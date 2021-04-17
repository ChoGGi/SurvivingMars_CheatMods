-- See LICENSE for terms

local mod_Range = ArtificialSun.effect_range or 8
local const_HexHeight = const.HexHeight

local TestSunPanelRange = TestSunPanelRange
local IsValid = IsValid
local table = table
local next = next

local function UpdateSolarPanel(panel, suns)
	local in_range, _ = table.ifilter(suns, function(_, sun)
		return TestSunPanelRange(sun, panel)
	end)
	-- filter will return indexed keys with their orig index
	_, in_range = next(in_range)

	-- if anything is close enough to count
	if in_range then
		-- update panel prod values
		panel:SetArtificialSun(in_range)
	else
		panel.artificial_sun = false
	end

	panel:UpdateProduction()
end

-- loop through all suns and update any panels in range
local function UpdateArtificialSunRange(obj)
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

	-- make sure we're in-game
	if not UICity then
		return
	end
	UpdateArtificialSunRange()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

OnMsg.CityStart = UpdateArtificialSunRange
OnMsg.LoadGame = UpdateArtificialSunRange

-- I;m lazy so copy and paste

local orig_SolarPanelBuilding_OnSetWorking = SolarPanelBuilding.OnSetWorking
function SolarPanelBuilding:OnSetWorking(...)
	UpdateArtificialSunRange(self)
	return orig_SolarPanelBuilding_OnSetWorking(self, ...)
end

local orig_SolarPanelBase_OnSetWorking = SolarPanelBase.OnSetWorking
function SolarPanelBase:OnSetWorking(...)
	UpdateArtificialSunRange(self)
	return orig_SolarPanelBase_OnSetWorking(self, ...)
end

local orig_SolarPanelBase_GameInit = SolarPanelBase.GameInit
function SolarPanelBase:GameInit(...)
	UpdateArtificialSunRange(self)
	return orig_SolarPanelBase_GameInit(self, ...)
end

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
