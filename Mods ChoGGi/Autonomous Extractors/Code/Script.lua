-- See LICENSE for terms

local ToggleWorking = ChoGGi_Funcs.Common.ToggleWorking

local mod_AutoPerformance
local mod_EnableMod

local has_colonists = {
	MetalsExtractor = true,
	PreciousMetalsExtractor = true,
}

local function UpdateBuildings()

	-- make newly built buildings not need workers
	local bt = BuildingTemplates
	local ct = ClassTemplates.Building

	for id, item in pairs(bt) do
		if has_colonists[id] then
			if mod_EnableMod then
				item.max_workers = 0
				item.automation = 1
				item.auto_performance = mod_AutoPerformance
				local cls_temp = ct[id]
				cls_temp.max_workers = 0
				cls_temp.automation = 1
				cls_temp.auto_performance = mod_AutoPerformance
			else
				item.max_workers = nil
				item.automation = nil
				item.auto_performance = nil
				local cls_temp = ct[id]
				cls_temp.max_workers = nil
				cls_temp.automation = nil
				cls_temp.auto_performance = nil
			end
		end
	end

	-- update existing buildings
	local objs = ChoGGi_Funcs.Common.GetCityLabels("MetalsExtractor")
	table.iappend(objs, ChoGGi_Funcs.Common.GetCityLabels("PreciousMetalsExtractor"))

	for i = 1, #objs do
		local obj = objs[i]

		if mod_EnableMod then
			obj.max_workers = 0
			obj.automation = 1
			obj.auto_performance = mod_AutoPerformance
		else
			obj.max_workers = nil
			obj.automation = nil
			obj.auto_performance = nil
		end

		ToggleWorking(obj)
	end
end
OnMsg.CityStart = UpdateBuildings
OnMsg.LoadGame = UpdateBuildings

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_AutoPerformance = CurrentModOptions:GetProperty("AutoPerformance")

	-- Make sure we're in-game
	if not UIColony then
		return
	end

	UpdateBuildings()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local space_race = g_AvailableDlc.gagarin
local skin  = "AutomaticMetalsExtractor"
local palette

local function GetSkins(self, func, ...)
	if not space_race then
		return func(self, ...)
	end

	if not palette then
		local bt = BuildingTemplates.AutomaticMetalsExtractor
		palette = { bt.palette_color1, bt.palette_color2, bt.palette_color3, bt.palette_color4 }
	end

	local skins, palettes = func(self, ...)
	skins[#skins+1] = skin
	palettes[#palettes+1] = palette
	return skins, palettes
end


function OnMsg.ClassesPostprocess()
	local ChoOrig_MetalsExtractor_GetSkins = MetalsExtractor.GetSkins
	function MetalsExtractor:GetSkins(...)
		return GetSkins(self, ChoOrig_MetalsExtractor_GetSkins, ...)
	end
	local ChoOrig_PreciousMetalsExtractor_GetSkins = PreciousMetalsExtractor.GetSkins
	function PreciousMetalsExtractor:GetSkins(...)
		return GetSkins(self, ChoOrig_PreciousMetalsExtractor_GetSkins, ...)
	end
end