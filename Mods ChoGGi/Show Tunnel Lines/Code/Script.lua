-- See LICENSE for terms

local mod_RemoveOnSelect
local mod_RandomColours

-- fired when settings are changed/init
local function ModOptions()
	mod_RemoveOnSelect = CurrentModOptions:GetProperty("RemoveOnSelect")
	mod_RandomColours = CurrentModOptions:GetProperty("RandomColours")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

-- local some funcs
local IsValid = IsValid
local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local RandomColourLimited = ChoGGi.ComFuncs.RandomColourLimited

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
		SuspendPassEdits("ChoGGi_ShowTunnelLines_Cleanup")
	end

	for i = 1, lines_c do
		local line = lines[i]
		if IsValid(line) then
			line:delete()
		end
	end
	if not skip then
		ResumePassEdits("ChoGGi_ShowTunnelLines_Cleanup")
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
	SuspendPassEdits("ChoGGi_ShowTunnelLines_SpawnTunnels")
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
--~ 	ex{tunnels,lines}

	ResumePassEdits("ChoGGi_ShowTunnelLines_SpawnTunnels")
end

OnMsg.SaveGame = CleanUp

-- when selection is removed (or changed) hide all the lines
function OnMsg.SelectionRemoved()
	if mod_RemoveOnSelect then
		CleanUp()
	end
end
