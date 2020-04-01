-- See LICENSE for terms

local mod_Range = ArtificialSun.effect_range or 8
local MapFilter = MapFilter
local TestSunPanelRange = TestSunPanelRange
local table_sort = table.sort
local GridSpacing = const.GridSpacing

local function UpdateSolarPanel(panel, suns)
	-- large radius extension so it can catch large panels (dev comment)
	local sun_radius = (mod_Range + 10) * GridSpacing

	-- get any suns in range of panel
	suns = MapFilter(suns, sun_radius, function(sun)
		return TestSunPanelRange(sun, panel)
	end)
	-- no suns means nothing close enough
	if #suns > 0 then
		-- sort dist by nearest
		local obj_pos = panel:GetPos()
		table_sort(suns, function(a, b)
			return a:GetDist2D(obj_pos) < b:GetDist2D(obj_pos)
		end)
		-- update panel prod values
		panel:SetArtificialSun(suns[1])
	else
		panel.artificial_sun = false
	end

	panel:UpdateProduction()
end

-- loop through all suns and update any panels in range
local function UpdateArtificialSunRange(obj)
	-- local some globals
	local is_valid = IsValid(obj)

	local suns = UICity.labels.ArtificialSun or empty_table
	-- first update range for all art suns
	if is_valid and obj:IsKindOf("ArtificialSun") then
			obj.effect_range = mod_Range
	else
		for i = 1, #suns do
			suns[i].effect_range = mod_Range
--~ 			suns[i].UIWorkRadius = mod_Range
		end
	end

	-- now update all solar panels
	if is_valid and obj:IsKindOf("SolarPanelBase") then
		UpdateSolarPanel(obj, suns)
	else
		local panels = UICity.labels.SolarPanelBase or ""
		for i = 1, #panels do
			UpdateSolarPanel(panels[i], suns)
		end
	end
end

-- fired when settings are changed/init
local function ModOptions()
	mod_Range = CurrentModOptions:GetProperty("Range")
	-- make sure we're not in menus
	if not GameState.gameplay then
		return
	end
	UpdateArtificialSunRange()
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

OnMsg.CityStart = UpdateArtificialSunRange
OnMsg.LoadGame = UpdateArtificialSunRange

-- fix for solar panels only expecting one sun
SolarPanelBase.GameInit = UpdateArtificialSunRange

local orig_ArtificialSun_GameInit = ArtificialSun.GameInit
function ArtificialSun:GameInit(...)
	UpdateArtificialSunRange(self)
	return orig_ArtificialSun_GameInit(self, ...)
end

--~ -- add ArtificialSun to ServiceArea section (without messing with other buildings/mods)
--~ function OnMsg.ClassesPostprocess()
--~ 	local xt = XTemplates.sectionServiceArea[1]
--~ 	local orig_con = xt.__condition
--~ 	xt.__condition = function(parent, context)
--~ 		return context:IsKindOf("ArtificialSun") or orig_con(parent, context)
--~ 	end
--~ end
