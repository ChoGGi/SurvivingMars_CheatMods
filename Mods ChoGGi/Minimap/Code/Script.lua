-- See LICENSE for terms

local mod_id = "ChoGGi_Minimap"
local mod = Mods[mod_id]
local mod_UseScreenshots = mod.options and mod.options.UseScreenshots or true

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end

	mod_UseScreenshots = mod.options.UseScreenshots
	ChoGGi_Minimap_Options.UpdateTopoImage(mod_UseScreenshots)
end

-- for some reason mod options aren't retrieved before this script is loaded...
local function StartupCode()
	mod_UseScreenshots = mod.options.UseScreenshots
	ChoGGi_Minimap_Options.UpdateTopoImage(mod_UseScreenshots)
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

local IsValid = IsValid

local image_mod = Mods.ChoGGi_MapImagesPack

ChoGGi_Minimap_Options = {
	image_str = image_mod and image_mod.env.CurrentModPath .. "Maps/",
	UpdateTopoImage = function(value)
		-- find our map dlg
		local map_dlg = ChoGGi.ComFuncs.RetMapDlg_MiniMap()

		if not map_dlg then
			return
		end

		-- update minimap with image or topo image
		if value then
			map_dlg:UpdateMapImage(map_dlg.map_file)
		else
			local str = ChoGGi_Minimap_Options.image_str
			if not str then
				local image_mod = Mods.ChoGGi_MapImagesPack
				ChoGGi_Minimap_Options.image_str = image_mod and image_mod.env.CurrentModPath .. "Maps/"
				str = ChoGGi_Minimap_Options.image_str
			end
			if str then
				map_dlg:UpdateMapImage(str .. map_dlg.map_name .. ".png")
			else
				print([[ChoGGi Minimap needs: https://steamcommunity.com/sharedfiles/filedetails/?id=1571465108]])
			end
		end
	end
}

function OnMsg.ModsReloaded()
	local xt = ChoGGi.ComFuncs.RetHudButton("idRight")
	if not xt then
		return
	end

	ChoGGi.ComFuncs.RemoveXTemplateSections(xt, "ChoGGi_Template_Minimap")

	table.insert(xt, #xt,
		PlaceObj("XTemplateTemplate", {
			"ChoGGi_Template_Minimap", true,
			"__template", "HUDButtonTemplate",
			"RolloverText", [[Click to go places (updates minimap first click).]],
			"RolloverTitle", [[Minimap]],
			"Id", "idMinimap",
			"Image", CurrentModPath .. "UI/minimap.png",
			"FXPress", "MainMenuButtonClick",
			"OnPress", HUD.idMinimapOnPress,
		})
	)
end

-- map name for title/image
local current_map
local function MapName()
	if current_map then
		return current_map
	else
		current_map = GetMapName(GetMap())
		return current_map
	end
end

local screenshot_taken
function OnMsg.LoadGame()
	current_map = false
	screenshot_taken = false
end

function OnMsg.CityStart()
	current_map = false
end


local map_dlg = false
local dlg_x, dlg_y

function OnMsg.SaveGame()
	if map_dlg and IsValid(map_dlg.idMapControl.sphere) then
		map_dlg.idMapControl.sphere:delete()
	end
end

function HUD.idMinimapOnPress()
	if map_dlg then
		-- save dlg pos
		local box = map_dlg.idDialog.content_box
		dlg_x = box:minx()
		dlg_y = box:miny()
		-- bye bye
		map_dlg:Close()
		map_dlg = false
		Dialogs.HUD.idMinimapHighlight:SetVisible(false)
	else
		map_dlg = ChoGGi_MinimapDlg:new({}, terminal.desktop, {
			x = dlg_x,
			y = dlg_y,
		})
		local ChoGGi_Minimap_Options = ChoGGi_Minimap_Options

		-- auto-update image once per load
		if mod_UseScreenshots and not screenshot_taken then
			map_dlg:idUpdateMapOnPress()
			screenshot_taken = true
		end

		local map = MapName()
		-- use topo image instead of screenshot
		if mod_UseScreenshots then
			map_dlg:UpdateMapImage(map_dlg.map_file)
		else
			-- check for formatting string
			local str = ChoGGi_Minimap_Options.image_str
			if not str then
				local image_mod = Mods.ChoGGi_MapImagesPack
				ChoGGi_Minimap_Options.image_str = image_mod and image_mod.env.CurrentModPath .. "Maps/"
				str = ChoGGi_Minimap_Options.image_str
			end
			if str then
				map_dlg:UpdateMapImage(str .. map .. ".png")
			end
		end
		map_dlg.idCaption:SetText(map)
		map_dlg.map_name = map
		Dialogs.HUD.idMinimapHighlight:SetVisible(true)

	end

end

-- kill off on map change
function OnMsg.ChangeMapDone()
	local term = terminal.desktop
	for i = #term, 1, -1 do
		if term[i]:IsKindOf("ChoGGi_MinimapDlg") then
			term[i]:Close()
		end
	end
end
