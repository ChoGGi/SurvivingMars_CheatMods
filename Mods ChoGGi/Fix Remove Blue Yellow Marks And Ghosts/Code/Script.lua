-- See LICENSE for terms

local DoneObject = DoneObject

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local rover_ents = {
	RoverBlueSunHarvester = true,
	RoverIndiaConstructor = true,
	RoverTransport = true,
}

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
		DoneObject(objs[i])
	end

	-- remove the rover outlines added from https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-persistent-transport-route-blueprint-on-map.1121333/
	objs = MapGet(true, "WireFramedPrettification", function(rover)
		return rover_ents[rover.entity or ""]
	end)
	for i = #objs, 1, -1 do
		DoneObject(objs[i])
	end

	ResumePassEdits("ChoGGi.RemoveBlueYellowGridMarks.LoadGame")
end
