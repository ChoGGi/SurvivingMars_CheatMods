-- See LICENSE for terms

local IsValid = IsValid
local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local RandomColourLimited = ChoGGi.ComFuncs.RandomColourLimited

local mod_RemoveOnSelect
local mod_RandomColours

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_RemoveOnSelect = CurrentModOptions:GetProperty("RemoveOnSelect")
	mod_RandomColours = CurrentModOptions:GetProperty("RandomColours")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local lines = {}
local lines_c = 0
local tunnels = {}
local OPolyline

local function CleanUp(skip)
	if lines_c == 0 then
		return
	end
	-- speed up when spawning/deleting objs
	if not skip then
		SuspendPassEdits("ChoGGi.ShowTunnelLines.Cleanup")
	end

	for i = 1, lines_c do
		local line = lines[i]
		if IsValid(line) then
			line:delete()
		end
	end
	if not skip then
		ResumePassEdits("ChoGGi.ShowTunnelLines.Cleanup")
	end
	table.iclear(lines)
	table.clear(tunnels)
	lines_c = 0
end

function OnMsg.SelectionAdded(obj)
	-- we only want tunnels
	if not obj:IsKindOf("Tunnel") then
		return
	end

	-- add a delay if unit thoughts is enabled (Pathing_StopAndRemoveAll() removes lines)
	CreateRealTimeThread(function()
		WaitMsg("OnRender")

		SuspendPassEdits("ChoGGi.ShowTunnelLines.SpawnTunnels")
		CleanUp(true)

		if not OPolyline then
			OPolyline = ChoGGi_OPolyline
		end

		local objs = UICity.labels.Tunnel or ""
		for i = 1, #objs do
			-- get tunnel n linked one so we only have one of each in table
			local t1 = objs[i]
			local t2 = t1.linked_obj
			-- see if we already added a table for paired tunnel
			if not (tunnels[t1] or tunnels[t2]) then
				-- no dupes
				tunnels[t1] = true
				tunnels[t2] = true
				-- spawn a line and draw it with a parabolic arc
				local line = OPolyline:new()
				line:SetParabola(t1:GetPos(), t2:GetPos())
				if mod_RandomColours then
					line:SetColors(RandomColourLimited())
				end
				-- store line obj for delete
				lines_c = lines_c + 1
				lines[lines_c] = line
			end
		end
--~ 		ex{tunnels,lines}

		ResumePassEdits("ChoGGi.ShowTunnelLines.SpawnTunnels")
	end)
end

OnMsg.SaveGame = CleanUp

-- when selection is removed (or changed) hide all the lines
function OnMsg.SelectionRemoved()
	if mod_RemoveOnSelect then
		CleanUp()
	end
end
