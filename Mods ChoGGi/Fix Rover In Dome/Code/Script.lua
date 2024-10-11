-- See LICENSE for terms

local mod_EnableMod

local GetRandomPassableAround = GetRandomPassableAround
local IsUnitInDome = IsUnitInDome
local box = box
local WorldToHex = WorldToHex
local GetObjectHexGrid = GetObjectHexGrid

local function GetPastureAtHex(obj)
	local q, r = WorldToHex(obj)
	local object_hex_grid = GetObjectHexGrid(obj)

	return object_hex_grid:GetObject(q, r, "Pasture")
end

-- end to end for the diamond dome (plus some extra)
local dome_size = 32000
local ranch_size = 4000

local function MoveUnits()
	if not UICity or not mod_EnableMod then
		return
	end

	local main_realm = GetRealmByID(MainMapID)

	-- no point in checking if domes have been opened
	if not GetOpenAirBuildings(MainCity.map_id) then
		local rovers = main_realm:MapGet("map", "BaseRover")
		for i = 1, #rovers do
			local rover = rovers[i]
			local dome = IsUnitInDome(rover)
			-- I've got a mod that lets you open domes individually
			if dome and not dome.open_air then
				local x, y = (dome:GetObjectBBox() or box(0, 0, dome_size, dome_size)):sizexyz()
				-- whichever is larger (the radius starts from the centre, so we only need half-size)
				local radius = (x >= y and x or y) / 2
				rover:SetPos(GetRandomPassableAround(dome, radius + 650, radius + 150))
			end
		end
	end

	-- drones stuck in pastures
	local drones = main_realm:MapGet("map", "Drone")
	for i = 1, #drones do
		local drone = drones[i]
		local ranch = GetPastureAtHex(drone)
		if ranch then
			local x, y = (ranch:GetObjectBBox() or box(0, 0, ranch_size, ranch_size)):sizexyz()
			-- whichever is larger (the radius starts from the centre, so we only need half-size)
			local radius = (x >= y and x or y) / 2
			drone:SetPos(GetRandomPassableAround(ranch, radius + 650, radius + 150))
		end
	end

end

OnMsg.CityStart = MoveUnits
OnMsg.LoadGame = MoveUnits
-- Switch between different maps (can happen before UICity)
OnMsg.ChangeMapDone = MoveUnits

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	MoveUnits()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
