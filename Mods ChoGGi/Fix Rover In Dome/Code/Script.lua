-- See LICENSE for terms

local mod_EnableMod

local GetRandomPassableAround = GetRandomPassableAround
local IsUnitInDome = IsUnitInDome
local box = box

-- end to end for the diamond dome (plus some extra)
local largest = 30000

local function MoveRovers()
	-- no point in checking if domes have been opened
	if not MainCity or not mod_EnableMod or GetOpenAirBuildings(MainCity.map_id) then
		return
	end

	local rovers = MapGet("map", "BaseRover")
	for i = 1, #rovers do
		local rover = rovers[i]
		local dome = IsUnitInDome(rover)
		if dome and not dome.open_air then
			local x, y = (dome:GetObjectBBox() or box(0, 0, largest, largest)):sizexyz()
			-- whichever is larger (the radius starts from the centre, so we only need half-size)
			local radius = (x >= y and x or y) / 2
			rover:SetPos(GetRandomPassableAround(dome, radius + 650, radius + 150))
		end
	end

end
OnMsg.CityStart = MoveRovers
OnMsg.LoadGame = MoveRovers
-- Switch between different maps (can happen before UICity)
OnMsg.ChangeMapDone = MoveRovers

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	MoveRovers()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
