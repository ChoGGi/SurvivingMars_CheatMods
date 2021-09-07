-- See LICENSE for terms

local IsValid = IsValid
local ElectricityGridObject_GameInit = ElectricityGridObject.GameInit

local mod_EnableMod

local function FixBuildings()
	if not mod_EnableMod then
		return
	end

	local objs = ActiveGameMap.realm:MapGet("map", "ElectricityGridObject")
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

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- make sure we're in-game
	if not UICity then
		return
	end
	FixBuildings()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	-- I'm sure it wouldn't be that hard to only call this msg for the mod being applied, but...
	if id == CurrentModId then
		ModOptions()
	end
end

--~ OnMsg.CityStart = FixBuildings
OnMsg.LoadGame = FixBuildings
