-- See LICENSE for terms

local Translate = ChoGGi.ComFuncs.Translate
local SettingState = ChoGGi.ComFuncs.SettingState
local TranslationTable = TranslationTable
local Actions = ChoGGi.Temp.Actions
local c = #Actions

-- menu
c = c + 1
Actions[c] = {ActionName = TranslationTable[302535920000158--[[Consts]]],
	ActionMenubar = "ECM.Cheats",
	ActionId = ".Consts",
	ActionIcon = "CommonAssets/UI/Menu/folder.tga",
	OnActionEffect = "popup",
	ActionSortKey = "1Consts",
	RolloverText = TranslationTable[302535920000526--[[Any cheats changed here will override ones from a non-Consts menu.

 <color ChoGGi_red>Warning</color>: Changing these settings may cause crashing!]]],
}

-- group name to icon
local icons = {
	Buildings = "CommonAssets/UI/Menu/Cube.tga",
	Camera = "CommonAssets/UI/Menu/NewCamera.tga",
	Colonist = "CommonAssets/UI/Menu/AlignSel.tga",
	Cost = "CommonAssets/UI/Menu/pirate.tga",
	Default = "CommonAssets/UI/Menu/default.tga",
	Drone = "CommonAssets/UI/Menu/ShowAll.tga",
	Gameplay = "CommonAssets/UI/Menu/clear_debug_texture.tga",
	Research = "CommonAssets/UI/Menu/SelectionToObjects.tga",
	Rover = "CommonAssets/UI/Menu/road_type.tga",
	Scale = "CommonAssets/UI/Menu/MeasureTool.tga",
	Stat = "CommonAssets/UI/Menu/AreaProperties.tga",
	StoryBits = "CommonAssets/UI/Menu/Voice.tga",
	Terraforming = "CommonAssets/UI/Menu/place_objects.tga",
	Traits = "CommonAssets/UI/Menu/make_path.tga",
	Workplace = "CommonAssets/UI/Menu/LightArea.tga",
}

local ConstDef = Presets.ConstDef
for i = 1, #ConstDef do
	local def = ConstDef[i]

	-- add menus
	local group_name = def[1].group
	-- dunno
	if not group_name then
		group_name = "Default"
	end
	local icon = icons[group_name]

	c = c + 1
	Actions[c] = {ActionName = group_name,
		ActionMenubar = "ECM.Cheats.Consts",
		ActionId = "." .. group_name,
		ActionIcon = "CommonAssets/UI/Menu/folder.tga",
		OnActionEffect = "popup",
		RolloverText = TranslationTable[302535920000526--[[Any cheats changed here will override ones from a non-Consts menu.

<color ChoGGi_red>Warning</color>: Changing these settings may cause crashing!]]],
	}

	for j = 1, #def do
		local const = def[j]
		local name = const.name
		name = name and name ~= "" and (const.id .. " " .. Translate(name)) or const.id
		local desc = const.help
		desc = desc and desc ~= "" and Translate(desc) or name

		c = c + 1
		Actions[c] = {ActionName = name,
			ActionMenubar = "ECM.Cheats.Consts." .. group_name,
			ActionId = "." .. name,
			ActionIcon = icon,
			RolloverText = function()
				return SettingState(ChoGGi.UserSettings.Consts[const.id], desc)
			end,
			OnAction = ChoGGi.MenuFuncs.SetConstMenu,
			setting_name = name,
			setting_desc = desc,
			setting_id = const.id,
			setting_value = const.value,
			setting_scale = const.scale,
		}

	end
end
