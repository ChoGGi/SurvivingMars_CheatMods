-- See LICENSE for terms

local pairs, type = pairs, type

local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local Translate = ChoGGi.ComFuncs.Translate
local Strings = ChoGGi.Strings

function ChoGGi.MenuFuncs.SetToxicPoolsMax()
	local title = Translate(12026--[[Toxic Pools]]) .. " " .. Strings[302535920000834--[[Max]]]
	local default_setting = ChoGGi.Consts.MaxToxicRainPools

	local item_list = {
		{text = Translate(1000121--[[Default]]) .. ": " .. default_setting, value = default_setting},
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
			ChoGGi.ComFuncs.SetSavedConstSetting("MaxToxicRainPools")

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.MaxToxicRainPools),
				title
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = title,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetAllTerraformingParams(action)
	if g_NoTerraforming then
		MsgPopup(
			Strings[302535920000562--[[Terraforming not enabled!]]],
			T(12476, "Terraforming")
		)
		return
	end

	for param in pairs(Terraforming) do
		SetTerraformParamPct(param, action.setting_value)
	end
end

function ChoGGi.MenuFuncs.OpenAirDomes_Toggle()
	SetOpenAirBuildings(not OpenAirBuildings)
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(OpenAirBuildings),
		Strings[302535920000559--[[Open Air Domes Toggle]]]
	)
end

function ChoGGi.MenuFuncs.RemoveLandScapingLimits_Toggle()
	ChoGGi.UserSettings.RemoveLandScapingLimits = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.RemoveLandScapingLimits)
	ChoGGi.ComFuncs.SetLandScapingLimits(ChoGGi.UserSettings.RemoveLandScapingLimits)

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.RemoveLandScapingLimits),
		Strings[302535920000560--[[Remove LandScaping Limits]]]
	)
end

function ChoGGi.MenuFuncs.PlantRandomLichen()
	if g_NoTerraforming then
		MsgPopup(
			Strings[302535920000562--[[Terraforming not enabled!]]],
			Strings[302535920000534--[[Plant Random Lichen]]]
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

			local PlaceObject = PlaceObject
			SuspendPassEdits("ChoGGi.MenuFuncs.PlantRandomLichen")
			PlaceObject("VegFocusTask", {
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
			ResumePassEdits("ChoGGi.MenuFuncs.PlantRandomLichen")

			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice.value),
				Strings[302535920000534--[[Plant Random Lichen]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000534--[[Plant Random Lichen]]],
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.PlantRandomVegetation()
	if g_NoTerraforming then
		MsgPopup(
			Strings[302535920000562--[[Terraforming not enabled!]]],
			Strings[302535920000529--[[Plant Random Vegetation]]]
		)
		return
	end

	local hint = Strings[302535920000758--[[Will take some time for 25K and up.]]]
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

			ChoGGi.ComFuncs.PlantRandomVegetation(choice.value)

			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice.value),
				Strings[302535920000529--[[Plant Random Vegetation]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000529--[[Plant Random Vegetation]]],
		hint = hint,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetSoilQuality()
	if g_NoTerraforming then
		MsgPopup(
			Strings[302535920000562--[[Terraforming not enabled!]]],
			T(776100024488, "Soil Quality")
		)
		return
	end

	local soil_quality = GetSoilQuality(WorldToHex(GetCursorWorldPos()))

	local item_list = {
		{text = Strings[302535920000106--[[Current]]], value = soil_quality},
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
				ChoGGi.ComFuncs.SettingState(choice.value),
				T(776100024488, "Soil Quality")
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Translate(776100024488--[[Soil Quality]]),
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetTerraformingParams(action)
	if g_NoTerraforming then
		MsgPopup(
			Strings[302535920000562--[[Terraforming not enabled!]]],
			action.ActionName
		)
		return
	end

	local setting_id = action.setting_id

	local item_list = {
		{text = Strings[302535920000106--[[Current]]], value = GetTerraformParamPct(setting_id)},
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
				ChoGGi.ComFuncs.SettingState(choice.value),
				T(12476, "Terraforming")
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = action.ActionName,
		skip_sort = true,
	}
end
