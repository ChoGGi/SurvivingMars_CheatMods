-- See LICENSE for terms

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
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

function OnMsg.LoadGame()
	if not mod_EnableMod then
		return
	end

	-- suspending speeds up deleting
	SuspendPassEdits("ChoGGi.RemoveBlueYellowGridMarks.LoadGame")

	-- blue/yellow markers
	local objs = MapGet(true, "GridTile", "GridTileWater", "RangeHexRadius", function(o)
		-- SkiRich's Toggle Work Zone
		if not o.ToggleWorkZone then
			return true
		end
	end)
	for i = #objs, 1, -1 do
		objs[i]:delete()
	end

	-- remove the rover outlines added from https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-persistent-transport-route-blueprint-on-map.1121333/
	local objs = MapGet(true, "WireFramedPrettification", function(o)
		if o:GetEntity() == "RoverTransport" then
			return true
		end
	end)
	for i = #objs, 1, -1 do
		objs[i]:delete()
	end

	ResumePassEdits("ChoGGi.RemoveBlueYellowGridMarks.LoadGame")
end
