-- See LICENSE for terms

if ChoGGi.what_game ~= "Mars" then
	return
end

local ChoGGi_Funcs = ChoGGi_Funcs
local pairs, type = pairs, type
local T = T
local Translate = ChoGGi_Funcs.Common.Translate
local MsgPopup = ChoGGi_Funcs.Common.MsgPopup

function ChoGGi_Funcs.Menus.SetToxicPoolsMax()
	local title = T(12026--[[Toxic Pools]]) .. " " .. T(302535920000834--[[Max]])
	local default_setting = ChoGGi.Consts.MaxToxicRainPools

	local item_list = {
		{text = T(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
		{text = 0, value = 0},
		{text = 10, value = 10},
		{text = 20, value = 20},
		{text = 40, value = 40},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 125, value = 125},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
	}
	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		if type(value) == "number" then

			const.MaxToxicRainPools = value
			ChoGGi_Funcs.Common.SetSavedConstSetting("MaxToxicRainPools")

			ChoGGi_Funcs.Settings.WriteSettings()
			MsgPopup(
				ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.MaxToxicRainPools),
				title
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = title,
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.SetAllTerraformingParams(action)
	if g_NoTerraforming then
		MsgPopup(
			T(302535920000562--[[Terraforming not enabled!]]),
			T(12476--[[Terraforming]])
		)
		return
	end

	for param in pairs(Terraforming) do
		SetTerraformParamPct(param, action.setting_value)
	end
end

function ChoGGi_Funcs.Menus.OpenAirDomes_Toggle()
	SetOpenAirBuildings(not GetOpenAirBuildings(ActiveMapID))
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(GetOpenAirBuildings(ActiveMapID)),
		T(302535920000559--[[Open Air Domes Toggle]])
	)
end

function ChoGGi_Funcs.Menus.RemoveLandScapingLimits_Toggle()
	ChoGGi.UserSettings.RemoveLandScapingLimits = ChoGGi_Funcs.Common.ToggleValue(ChoGGi.UserSettings.RemoveLandScapingLimits)
	ChoGGi_Funcs.Common.SetLandScapingLimits(ChoGGi.UserSettings.RemoveLandScapingLimits)

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.RemoveLandScapingLimits),
		T(302535920000560--[[Remove LandScaping Limits]])
	)
end

function ChoGGi_Funcs.Menus.PlantRandomLichen()
	if g_NoTerraforming then
		MsgPopup(
			T(302535920000562--[[Terraforming not enabled!]]),
			T(302535920000534--[[Plant Random Lichen]])
		)
		return
	end

	local item_list = {
		{text = 1, value = 1},
		{text = 5, value = 5},
		{text = 10, value = 10},
		{text = 15, value = 15},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 100, value = 100},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		if type(choice.value) == "number" then

			SuspendPassEdits("ChoGGi_Funcs.Menus.PlantRandomLichen")
			PlaceObjectIn("VegFocusTask", MainMapID, {
				min_foci = 10,
				max_foci = 20,
				max_sq = 100 * const.SoilGridScale,
				min_to_spawn = 2500,
				max_to_spawn = 5000,
				veg_types = {
					"Lichen",
					"Lichen",
					"Lichen",
					"Lichen",
					"Lichen"
				},
			})
			ResumePassEdits("ChoGGi_Funcs.Menus.PlantRandomLichen")

			MsgPopup(
				ChoGGi_Funcs.Common.SettingState(choice.value),
				T(302535920000534--[[Plant Random Lichen]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000534--[[Plant Random Lichen]]),
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.PlantRandomVegetation()
	if g_NoTerraforming then
		MsgPopup(
			T(302535920000562--[[Terraforming not enabled!]]),
			T(302535920000529--[[Plant Random Vegetation]])
		)
		return
	end

	local hint = T(302535920000758--[[Will take some time for 25K and up.]])
	local item_list = {
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
		{text = 5000, value = 5000},
		{text = 10000, value = 10000},
		{text = 25000, value = 25000, hint = hint},
		{text = 50000, value = 50000, hint = hint},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		if type(choice.value) == "number" then

			ChoGGi_Funcs.Common.PlantRandomVegetation(choice.value)

			MsgPopup(
				ChoGGi_Funcs.Common.SettingState(choice.value),
				T(302535920000529--[[Plant Random Vegetation]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(302535920000529--[[Plant Random Vegetation]]),
		hint = hint,
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.SetSoilQuality()
	if g_NoTerraforming then
		MsgPopup(
			T(302535920000562--[[Terraforming not enabled!]]),
			T(776100024488--[[Soil Quality]])
		)
		return
	end

	local soil_quality = GetSoilQuality(WorldToHex(GetCursorWorldPos()))

	local item_list = {
		{text = T(302535920000106--[[Current]]), value = soil_quality},
		{text = -100, value = -100},
		{text = -75, value = -75},
		{text = -50, value = -50},
		{text = -25, value = -25},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		if type(choice.value) == "number" then

			-- copy pasta dbg_ChangeSoilQuality(change)
			Soil_AddAmbient(SoilGrid, choice.value * const.SoilGridScale, -1000)
			OnSoilGridChanged()

			MsgPopup(
				ChoGGi_Funcs.Common.SettingState(choice.value),
				T(776100024488--[[Soil Quality]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = T(776100024488--[[Soil Quality]]),
		skip_sort = true,
	}
end

function ChoGGi_Funcs.Menus.SetTerraformingParams(action)
	if g_NoTerraforming then
		MsgPopup(
			T(302535920000562--[[Terraforming not enabled!]]),
			action.ActionName
		)
		return
	end

	local setting_id = action.setting_id

	local item_list = {
		{text = T(302535920000106--[[Current]]), value = GetTerraformParamPct(setting_id)},
		{text = 0, value = 0},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 100, value = 100},
	}

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		if type(choice.value) == "number" then

			SetTerraformParamPct(setting_id, choice.value)

			MsgPopup(
				ChoGGi_Funcs.Common.SettingState(choice.value),
				T(12476--[[Terraforming]])
			)
		end
	end

	ChoGGi_Funcs.Common.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = action.ActionName,
		skip_sort = true,
	}
end
