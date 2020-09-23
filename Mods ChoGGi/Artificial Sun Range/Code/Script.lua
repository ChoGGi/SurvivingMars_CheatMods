-- See LICENSE for terms

local mod_Range = ArtificialSun.effect_range or 8
local TestSunPanelRange = TestSunPanelRange
local IsValid = IsValid
--~ local GridSpacing = const.GridSpacing

local function UpdateSolarPanel(panel, suns)
	-- large radius extension so it can catch large panels (dev comment)
--~ local sun_radius = (mod_Range + 10) * GridSpacing

	local panel_pos = panel:GetPos()
	local length = max_int
	local nearest = suns[1]
	local new_length, found
	-- get any suns in range of panel
	for i = #suns, 1, -1 do
		local sun = suns[i]
		if TestSunPanelRange(sun, panel) then
			-- sorted by nearest
			new_length = sun:GetPos():Dist2D(panel_pos)
			if new_length < length then
				length = new_length
				nearest = sun
			end
			-- update if there's a sun in range
			found = true
		end
	end

	-- if anything is close enough to count
	if found then
		-- update panel prod values
		panel:SetArtificialSun(nearest)
	else
		panel.artificial_sun = false
	end

	panel:UpdateProduction()
end

-- loop through all suns and update any panels in range
local function UpdateArtificialSunRange(obj)
	-- local some globals
	local is_valid = IsValid(obj)

	local suns = UICity.labels.ArtificialSun or ""
	-- first update range for all art suns
	if is_valid and obj:IsKindOf("ArtificialSun") then
			obj.effect_range = mod_Range
	else
		for i = 1, #suns do
			suns[i].effect_range = mod_Range
		end
	end

	if #suns == 0 then
		return
	end

	-- now update all solar panels
	if is_valid and obj:IsKindOf("SolarPanelBase") then
		UpdateSolarPanel(obj, suns)
	else
		local panels = UICity.labels.SolarPanelBase or ""
		for i = 1, #panels do
			local panel = panels[i]
			if IsValid(panel) then
				UpdateSolarPanel(panel, suns)
			end
		end
	end
end

-- fired when settings are changed/init
local function ModOptions()
	mod_Range = CurrentModOptions:GetProperty("Range")

	-- make sure we're ingame
	if not UICity then
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
