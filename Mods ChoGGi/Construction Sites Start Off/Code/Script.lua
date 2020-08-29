-- See LICENSE for terms

local mod_TurnOff
local mod_SkipGrids
local mod_SkipPassages

-- fired when settings are changed/init
local function ModOptions()
	mod_TurnOff = CurrentModOptions:GetProperty("TurnOff")
	mod_SkipGrids = CurrentModOptions:GetProperty("SkipGrids")
	mod_SkipPassages = CurrentModOptions:GetProperty("SkipPassages")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

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

GlobalVar("ChoGGi_ConstructionSitesStartOff_cleanup", false)

-- remove after a few months (aug 2020)
function OnMsg.LoadGame()
	if ChoGGi_ConstructionSitesStartOff_cleanup then
		return
	end

	local objs = MapGet("map", "ConstructionSite")
	for i = 1, #objs do
		local obj = objs[i]
		if obj.building_class_proto:IsKindOfClasses(skips) then
			obj:SetUIWorking(true)
		end
	end

	ChoGGi_ConstructionSitesStartOff_cleanup = true
end
