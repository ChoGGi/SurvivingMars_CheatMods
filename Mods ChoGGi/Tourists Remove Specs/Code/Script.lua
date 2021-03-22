-- See LICENSE for terms

local specs

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	specs = table.copy(const.ColonistSpecialization)
	specs.Tourist = nil
	specs.none = nil
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local pairs = pairs
local function UpdateColonist(obj)
	local traits = obj.traits
	if traits and traits.Tourist then
		for trait in pairs(traits) do
			if specs[trait] then
				-- tourist with a spec
				obj.city:RemoveFromLabel(trait, obj)
				obj:RemoveTrait(trait)
				-- I guess I could, I mean devs add it to ColonistSpecialization
				obj.specialist = "Tourist"
--~ 				obj.specialist = "none"
				obj:ChooseEntity()
			end
		end
	end
end

GlobalVar("g_ChoGGi_TouristsRemoveSpecs_StartupClean", false)
local function StartupCode()
	if not mod_EnableMod or g_ChoGGi_TouristsRemoveSpecs_StartupClean then
		return
	end

	local objs = UICity.labels.Colonist or ""
	for i = 1,# objs do
		UpdateColonist(objs[i])
	end

	g_ChoGGi_TouristsRemoveSpecs_StartupClean = true
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

-- update newly arrived
function OnMsg.ColonistArrived(obj)
	if mod_EnableMod then
		UpdateColonist(obj)
	end
end
