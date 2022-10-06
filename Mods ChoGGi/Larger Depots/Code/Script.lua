-- See LICENSE for terms

-- Update mod desc
local function UpdateTrans()
	local locale_path = CurrentModPath .. "Locales/"

  if GetLanguage() == "Schinese" then
		LoadTranslationTableFile(locale_path .. "Schinese.csv")
	else
		LoadTranslationTableFile(locale_path .. "English.csv")
	end

	CurrentModDef.description = _InternalTranslate(T(302535920012098))
end
OnMsg.TranslationChanged = UpdateTrans

local mod_EnableMod
local mod_DepotAmounts
local mod_UniversalDepotAmounts
local mod_ResourceDepotAmounts

local function UpdateTemplate(id, amount)
	BuildingTemplates[id].max_storage_per_resource = amount
	ClassTemplates.Building[id].max_storage_per_resource = amount
end

local res_depots = {
	"StorageConcrete",
	"StorageElectronics",
	"StorageFood",
	"StorageFuel",
	"StorageMachineParts",
	"StorageMetals",
	"StorageMysteryResource",
	"StoragePolymers",
	"StorageRareMetals",
	"StorageRareMinerals",
	"StorageSeeds",
}

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_UniversalDepotAmounts = CurrentModOptions:GetProperty("UniversalDepotAmounts") * const.ResourceScale
	mod_ResourceDepotAmounts = CurrentModOptions:GetProperty("ResourceDepotAmounts") * const.ResourceScale

	UpdateTemplate("UniversalStorageDepot", mod_UniversalDepotAmounts)
	for i = 1, #res_depots do
		UpdateTemplate(res_depots[i], mod_ResourceDepotAmounts)
	end

	UpdateTrans()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
