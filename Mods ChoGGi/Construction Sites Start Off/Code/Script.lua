-- See LICENSE for terms

local mod_TurnOff
local mod_SkipGrids
local mod_SkipPassages

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_TurnOff = CurrentModOptions:GetProperty("TurnOff")
	mod_SkipGrids = CurrentModOptions:GetProperty("SkipGrids")
	mod_SkipPassages = CurrentModOptions:GetProperty("SkipPassages")
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
	if not mod_TurnOff then
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
