-- See LICENSE for terms

local mod_Range = ArtificialSun.effect_range or 8

-- loop through all suns and update any panels in range
local function UpdateArtificialSunRange()
	-- local some globals
	local GridSpacing = const.GridSpacing
	local MapGet = MapGet
	local TestSunPanelRange = TestSunPanelRange
	local table_sort = table.sort

	-- first update range for all art suns
	local suns = UICity.labels.ArtificialSun or ""
	for i = 1, #suns do
		suns[i].effect_range = mod_Range
--~ 		suns[i].UIWorkRadius = mod_Range
	end

	-- large radius extension so it can catch large panels (dev comment)
	local sun_radius = (mod_Range + 10) * GridSpacing

	-- now update all solar panels
	local panels = UICity.labels.SolarPanelBase or ""
	for i = 1, #panels do
		local panel = panels[i]

		-- get any suns in range of panel
		local suns = MapGet(panel, sun_radius, "ArtificialSun", function(sun)
			return TestSunPanelRange(sun, panel)
		end)

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
			panel:UpdateProduction()
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

--~ -- add ArtificialSun to ServiceArea section (without messing with other buildings/mods)
--~ function OnMsg.ClassesPostprocess()
--~ 	local xt = XTemplates.sectionServiceArea[1]
--~ 	local orig_con = xt.__condition
--~ 	xt.__condition = function(parent, context)
--~ 		return context:IsKindOf("ArtificialSun") or orig_con(parent, context)
--~ 	end
--~ end
