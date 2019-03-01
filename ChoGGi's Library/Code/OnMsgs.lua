-- See LICENSE for terms

local OnMsg = OnMsg

-- we don't add shortcuts and ain't supposed to drink no booze
OnMsg.ShortcutsReloaded = ChoGGi.ComFuncs.Rebuildshortcuts
-- so we at least have keys when it happens (what is "it"?)
OnMsg.ReloadLua = ChoGGi.ComFuncs.Rebuildshortcuts

-- use this message to perform post-built actions on the final classes
function OnMsg.ClassesBuilt()
	-- add build cat for my items
	local bc = BuildCategories
	if not table.find(bc,"id","ChoGGi") then
		bc[#bc+1] = {
			id = "ChoGGi",
			name = ChoGGi.Strings[302535920001400--[[ChoGGi--]]],
			image = ChoGGi.library_path .. "UI/bmc_incal_resources.png",
			highlight = ChoGGi.library_path .. "UI/bmc_incal_resources_shine.png",
		}
	end
end

-- this is when RocketPayload_Init is called (CityStart is too soon)
OnMsg.NewMapLoaded = ChoGGi.ComFuncs.UpdateDataTablesCargo
-- needed for UICity and some others that aren't created till around then
OnMsg.CityStart = ChoGGi.ComFuncs.RetName_Update
OnMsg.CityStart = ChoGGi.ComFuncs.UpdateStringsList
OnMsg.LoadGame = ChoGGi.ComFuncs.RetName_Update
OnMsg.LoadGame = ChoGGi.ComFuncs.UpdateStringsList
OnMsg.LoadGame = ChoGGi.ComFuncs.UpdateDataTablesCargo

-- now i should probably go around and change all my localed strings...
OnMsg.TranslationChanged = ChoGGi.ComFuncs.UpdateStringsList
OnMsg.TranslationChanged = ChoGGi.ComFuncs.UpdateDataTablesCargo
OnMsg.TranslationChanged = ChoGGi.ComFuncs.UpdateDataTables

OnMsg.ModsReloaded = ChoGGi.ComFuncs.UpdateDataTables

ChoGGi.Temp.UIScale = (LocalStorage.Options.UIScale + 0.0) / 100

-- This updates my dlgs when the ui scale is changed
local point = point
local pairs = pairs
local GetSafeAreaBox = GetSafeAreaBox
-- I guess I need a replacefuncs for lib as well...
local orig_SetUserUIScale = SetUserUIScale
function SetUserUIScale(val,...)
	orig_SetUserUIScale(val,...)

	local UIScale = (val + 0.0) / 100
	-- update existing dialogs
	local g_ChoGGiDlgs = g_ChoGGiDlgs
	for dlg in pairs(g_ChoGGiDlgs) do
		dlg.dialog_width_scaled = dlg.dialog_width * UIScale
		dlg.dialog_height_scaled = dlg.dialog_height * UIScale
		dlg.header_scaled = dlg.header * UIScale

		-- make sure the size i use is below the res w/h
		local _,_,x,y = GetSafeAreaBox():xyxy()
		if dlg.dialog_width_scaled > x then
			dlg.dialog_width_scaled = x - 50
		end
		if dlg.dialog_height_scaled > y then
			dlg.dialog_height_scaled = y - 50
		end

		dlg:SetSize(dlg.dialog_width_scaled, dlg.dialog_height_scaled)
	end
	-- might as well update this now (used to be in an OnMsg)
	ChoGGi.Temp.UIScale = UIScale
end
