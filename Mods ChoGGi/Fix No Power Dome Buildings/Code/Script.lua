-- See LICENSE for terms

local IsValid = IsValid
local ElectricityGridObject_GameInit = ElectricityGridObject.GameInit

local mod_EnableMod

local function FixBuildings()
	if not mod_EnableMod then
		return
	end

	local GameMaps = GameMaps
	for _, map in pairs(GameMaps) do
		local objs = map.realm:MapGet("map", "ElectricityGridObject")
		for i = 1, #objs do
			local obj = objs[i]
			-- should be good enough to not get false positives?
			if obj.working == false and obj.signs.SignNoPower and IsValid(obj.parent_dome)
				and obj.electricity and not obj.electricity.parent_dome
			then
				obj:DeleteElectricity()
				ElectricityGridObject_GameInit(obj)
			end
		end
	end
end

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- make sure we're in-game
	if not UICity then
		return
	end

	FixBuildings()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

--~ OnMsg.CityStart = FixBuildings
OnMsg.LoadGame = FixBuildings
