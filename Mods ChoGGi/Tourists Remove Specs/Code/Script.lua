-- See LICENSE for terms

local pairs = pairs
local ColonistSpecializationList = ColonistSpecializationList

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

local function UpdateColonist(obj)
	local traits = obj.traits
	if traits and traits.Tourist then
		for trait in pairs(traits) do
			if ColonistSpecializationList[trait] then
				-- tourist with a spec
				obj.city:RemoveFromLabel(trait, obj)
				obj:RemoveTrait(trait)
				-- I guess I could, I mean devs added it to ColonistSpecialization
--~ 				obj.specialist = "Tourist"
				obj.specialist = "none"
				obj:ChooseEntity()
			elseif trait == "Tourist" then
				obj.specialist = "none"
--~ 				obj.specialist = "Tourist"
			end
		end
	end
end

GlobalVar("g_ChoGGi_TouristsRemoveSpecs_StartupClean", false)
local function StartupCode()
	if not mod_EnableMod or g_ChoGGi_TouristsRemoveSpecs_StartupClean or rawget(_G, "g_AT_Options") then
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
	if mod_EnableMod or not rawget(_G, "g_AT_Options") then
		UpdateColonist(obj)
	end
end
