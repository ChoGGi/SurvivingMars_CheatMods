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
	SuspendPassEdits("RemoveBlueYellowGridMarks")

	-- blue/yellow markers
	MapDelete(true, "GridTile", "GridTileWater", "RangeHexRadius", function(o)
		-- SkiRich's Toggle Hub Zone
		if not o.ToggleWorkZone then
			return true
		end
	end)

	-- remove the rover outlines added from https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-persistent-transport-route-blueprint-on-map.1121333/
	MapDelete(true, "WireFramedPrettification", function(o)
		if o:GetEntity() == "RoverTransport" then
			return true
		end
	end)

	ResumePassEdits("RemoveBlueYellowGridMarks")
end
