-- See LICENSE for terms

local mod_EnableMod
local mod_SkipGrids
local mod_SkipPassages
local mod_TurnOffBuildings

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_SkipGrids = CurrentModOptions:GetProperty("SkipGrids")
	mod_SkipPassages = CurrentModOptions:GetProperty("SkipPassages")
	mod_TurnOffBuildings = CurrentModOptions:GetProperty("TurnOffBuildings")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local skip_grid = {
	"CableConstructionSite",
	"GridSwitchConstructionSite",
	"PipeConstructionSite",
}
local skips = {
	"MirrorSphereBuilding",
	"BlackCubeMonolith",
	"CrystalsBuilding",
	"Sinkhole",
}

function OnMsg.ConstructionSitePlaced(site)
	if not mod_EnableMod then
		return
	end

	if site.building_class_proto:IsKindOfClasses(skips)
		or (mod_SkipPassages and site:IsKindOf("PassageConstructionSite"))
		or (mod_SkipGrids and site:IsKindOfClasses(skip_grid))
	then
		return
	end

	RebuildInfopanel(site)
	site:SetUIWorking(false)
end

-- Turn off new buildings (if they have on/off button)
function OnMsg.BuildingInit(bld)
	if not mod_EnableMod or not mod_TurnOffBuildings then
		return
	end

	local bt = BuildingTemplates[bld.template_name]
	if bt and bt.on_off_button then
		RebuildInfopanel(bld)
		bld:SetUIWorking(false)
	end
end

-- Only need to run once
GlobalVar("g_ChoGGi_ConstructionSitesStartOff_FixOffStuff", false)

function OnMsg.LoadGame()
	if not mod_EnableMod or g_ChoGGi_ConstructionSitesStartOff_FixOffStuff then
		return
	end

	local BuildingTemplates = BuildingTemplates
	local objs = UIColony:GetCityLabels("Building")
	for i = 1, #objs do
		local obj = objs[i]

		local bt = BuildingTemplates[obj.template_name]
		if bt and not bt.on_off_button then
			obj:SetUIWorking(true)
		end
	end

	g_ChoGGi_ConstructionSitesStartOff_FixOffStuff = true
end
