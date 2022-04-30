-- See LICENSE for terms

local ToggleWorking = ChoGGi.ComFuncs.ToggleWorking
local mod_AutoPerformance

local has_colonists = {
	MetalsExtractor = true,
	PreciousMetalsExtractor = true,
}

local function StartupCode()

	-- make newly built buildings not need workers
	local bt = BuildingTemplates
	local ct = ClassTemplates.Building

	for id, item in pairs(bt) do
		if has_colonists[id] then
			item.max_workers = 0
			item.automation = 1
			item.auto_performance = mod_AutoPerformance
			local cls_temp = ct[id]
			cls_temp.max_workers = 0
			cls_temp.automation = 1
			cls_temp.auto_performance = mod_AutoPerformance
		end
	end

	-- update existing buildings
	local objs = UIColony:GetCityLabels("MetalsExtractor")
	-- no need to update again
	if objs[1].max_workers ~= 0 then
		table.iappend(objs, UIColony:GetCityLabels("PreciousMetalsExtractor"))
		for i = 1, #objs do
			local obj = objs[i]
			obj.max_workers = 0
			obj.automation = 1
			obj.auto_performance = mod_AutoPerformance
			ToggleWorking(obj)
		end
	end

end
OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_AutoPerformance = CurrentModOptions:GetProperty("AutoPerformance")

	-- Make sure we're in-game
	if not UIColony then
		return
	end

	StartupCode()

	-- update existing buildings auto_performance
	local objs = UIColony:GetCityLabels("MetalsExtractor")
	table.iappend(objs, UIColony:GetCityLabels("PreciousMetalsExtractor"))
	for i = 1, #objs do
		objs[i].auto_performance = mod_AutoPerformance
	end

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