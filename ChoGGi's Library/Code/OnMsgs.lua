-- See LICENSE for terms

local StringFormat = string.format
local S = ChoGGi.Strings

local OnMsg = OnMsg

-- we don't add shortcuts and ain't supposed to drink no booze
function OnMsg.ShortcutsReloaded()
	ChoGGi.ComFuncs.Rebuildshortcuts()
end

-- so we at least have keys when it happens
function OnMsg.ReloadLua()
	if type(XShortcutsTarget.UpdateToolbar) == "function" then
		ChoGGi.ComFuncs.Rebuildshortcuts()
	end
end

-- use this message to perform post-built actions on the final classes
function OnMsg.ClassesBuilt()
	-- add cat for my items
	local bc = BuildCategories
	if not table.find(bc,"id","ChoGGi") then
		bc[#bc+1] = {
			id = "ChoGGi",
			name = S[302535920001400--[[ChoGGi--]]],
			image = StringFormat("%sUI/bmc_incal_resources.png",ChoGGi.LibraryPath),
			highlight = StringFormat("%sUI/bmc_incal_resources_shine.png",ChoGGi.LibraryPath),
		}
	end
end

-- needed for UICity and some others that aren't created till around then
function OnMsg.LoadGame()
	ChoGGi.ComFuncs.RetName_Update()
end
function OnMsg.CityStart()
	ChoGGi.ComFuncs.RetName_Update()
end

ChoGGi.Temp.UIScale = (LocalStorage.Options.UIScale + 0.0) / 100
--~ function OnMsg.SystemSize()
--~ 	ChoGGi.Temp.UIScale = (LocalStorage.Options.UIScale + 0.0) / 100
--~ end

-- I guess I need a replacefuncs for lib as well
local point = point
local pairs = pairs
local orig_SetUserUIScale = SetUserUIScale
function SetUserUIScale(val,...)
	orig_SetUserUIScale(val,...)

	local UIScale = (val + 0.0) / 100
	-- update existing dialogs
	local obj = ChoGGi.Temp.Dialogs
	for dlg in pairs(obj) do
		dlg.dialog_width_scaled = dlg.dialog_width * UIScale
		dlg.dialog_height_scaled = dlg.dialog_height * UIScale
		dlg.header_scaled = dlg.header * UIScale
		dlg:SetSize(point(dlg.dialog_width_scaled, dlg.dialog_height_scaled))
	end
	-- might as well do it here
	ChoGGi.Temp.UIScale = UIScale
end
