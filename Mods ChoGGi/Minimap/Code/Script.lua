-- See LICENSE for terms

local IsValid = IsValid
local image_str

do -- Map Images Pack (it doesn't need to be loaded just installed)
	local min_version = 1
	local mod = Mods.ChoGGi_MapImagesPack

	if not mod or mod and not Platform.steam and min_version > mod.version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[Minimap requires Map Images Pack (at least v%s).
Press Ok to download it.]],min_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1571465108")
			end
		end)
	else
		image_str = string.format("%sMaps/%s.png",Mods.ChoGGi_MapImagesPack.env.CurrentModPath,"%s")
	end
end -- do

-- tell people how to get my library mod (if needs be)
local fire_once
function OnMsg.ModsReloaded()
	if fire_once then
		return
	end
	fire_once = true

	-- version to version check with
	local min_version = 37
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	-- if we can't find mod or mod is less then min_version (we skip steam since it updates automatically)
	if not idx or idx and not Platform.steam and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[Minimap requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end

	local xt = XTemplates
	local idx = table.find(xt.HUD[1],"Id","idBottom")
	if not idx then
		print("ChoGGi: Minimap missing HUD idBottom")
		return
	end
	xt = xt.HUD[1][idx]
	idx = table.find(xt,"Id","idRight")
	if not idx then
		print("ChoGGi: Minimap missing HUD idRight")
		return
	end
	xt = xt[idx][1]

	ChoGGi.ComFuncs.RemoveXTemplateSections(xt,"ChoGGi_Template_Minimap")

	table.insert(xt,#xt,PlaceObj("XTemplateTemplate", {
		"ChoGGi_Template_Minimap", true,
		"__template", "HUDButtonTemplate",
		"RolloverText", [[Click to go places.]],
		"RolloverTitle", [[Minimap]],
		"Id", "idMinimap",
		"Image", string.format("%sUI/minimap.png",CurrentModPath),
		"ImageShine", string.format("%sUI/minimap_shine.png",CurrentModPath),
		"FXPress", "MainMenuButtonClick",
		"OnPress", function()
			HUD.idMinimapOnPress()
		end,
	})
	)
end

local current_map
local function MapName()
	if current_map then
		return current_map
	else
		current_map = GetMapName(GetMap())
		return current_map
	end
end
function OnMsg.LoadGame()
	current_map = false
end
function OnMsg.CityStart()
	current_map = false
end

local map_dlg = false

function OnMsg.SaveGame()
	if IsValid(map_dlg.idMapControl.sphere) then
		map_dlg.idMapControl.sphere:delete()
	end
end

local dlg_x,dlg_y
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
		local minimap = ChoGGi_MinimapDlg:new({}, terminal.desktop,{
			x = dlg_x,
			y = dlg_y,
		})
		local map = MapName()
		minimap.idMapImage:SetImage(image_str:format(map))
		minimap.idCaption:SetText(map)
		Dialogs.HUD.idMinimapHighlight:SetVisible(true)
		map_dlg = minimap
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
