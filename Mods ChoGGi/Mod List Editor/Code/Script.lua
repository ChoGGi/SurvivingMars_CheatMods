-- See LICENSE for terms

local GetNextTable = ChoGGi_Funcs.Common.GetNextTable

local as, g_env
function OnMsg.ChoGGi_UpdateBlacklistFuncs(env)
	g_env = env
	as = env.AccountStorage
end

local mod_id = "ChoGGi_ModListEditor"

ChoGGi_ModListEditor_ModData = false

local function SaveModData(data)
	if not data then
		data = ChoGGi_ModListEditor_ModData or {}
	end

	LocalStorage.ModPersistentData[mod_id] = data
	-- update LocalSettings.lua
	SaveLocalStorage()
end

local function LoadModData()
	local data
	if LocalStorage.ModPersistentData[mod_id] then
		data = LocalStorage.ModPersistentData[mod_id]
	end

	-- no settings so use "defaults"
	if not data or not next(data) then
		-- build list of currently enabled mods and use that
		data = {
			-- these mods will be loaded next time
			_LoadMods = table.icopy(as.LoadMods),
			-- example using first two enabled mods
			templist = {as.LoadMods[1], as.LoadMods[2]},
			-- use currently enabled mods as exmaple list
			example_currently_enabled_mods = table.icopy(as.LoadMods),
		}
		data._LoadMods._HELPTEXT = "list of mods to be loaded next time game starts."
		data.templist._HELPTEXT = "Example list to keep around for easy copy/paste"
		data.example_currently_enabled_mods._HELPTEXT = "Example list to keep around for easy copy/paste"
	end

	ChoGGi_ModListEditor_ModData = data
	return data
end

local OnAction = function()
	-- Open list of mods in text editor
	ChoGGi_Funcs.Common.OpenInMultiLineTextDlg{
		text = TableToLuaCode(LoadModData()),
		title = T(0000, "Mod List Editor"),
		button_ok = TranslationTable[161964752558--[[Save]]],
		hint_ok = TranslationTable[302535920001244--[["Saves settings to file, and applies any changes."]]],
		hint_cancel = TranslationTable[302535920001245--[[Abort without touching anything.]]],
		code = true,
		custom_func = function(_, dialog)
			local text = dialog.idEdit:GetText()

			local err, data = LuaCodeToTuple(text)
			if err then
				return PrintError(err)
			end
			-- Make sure this mod is always enabled
			if not table.find(data._LoadMods, mod_id) then
				data._LoadMods[#data._LoadMods+1] = mod_id
			end

			as.LoadMods = data._LoadMods
			g_env.SaveAccountStorage()

			-- update saved setting file
			SaveModData(data)

--~ 			print("TEXT", text)
		end,

	}
end

function OnMsg.ClassesPostprocess()
	local id = "idModListEditorButton"
	local image = ChoGGi.library_path .. "UI/incal_egg.png"
	local name = T(0000, "Mod List Editor  <image " .. image .. " 500>")

	-- add button to in game menu
	local xtemplate = XTemplates.XIGMenu[1]
	if not xtemplate.ChoGGi_ModListEditorButton then
		xtemplate.ChoGGi_ModListEditorButton = true

		-- XTemplateWindow[3] ("Margins" = (60, 40)-(0, 0) *(HGE.Box)) >
		xtemplate = xtemplate[3]
		for i = 1, #xtemplate do
			if xtemplate[i].Id == "idList" then
				table.insert(xtemplate[i], 5, PlaceObj("XTemplateAction", {
					"ActionId", id,
					"ActionName", name,
					"OnAction", OnAction,
					"ActionToolbar", "mainmenu",
				}))
				local template = xtemplate[i][5]
				template:SetRolloverTemplate("Rollover")
				template:SetRolloverTitle(T(126095410863, "Info"))
				template:SetRolloverText(T(0000, "Open Mod List Editor"))


				break
			end
		end

	end

	-- add button to main menu
	xtemplate = XTemplates.PGMenuNew[1]
	if xtemplate[mod_id .. "AddedButton"] then
		return
	end
	-- well almost added
	xtemplate[mod_id .. "AddedButton"] = true

	xtemplate = GetNextTable(xtemplate, "__class", "XAspectWindow")
	if not xtemplate then
		return
	end
	xtemplate = GetNextTable(xtemplate, "Id", "idMenuBar")
	if not xtemplate then
		return
	end
	xtemplate = GetNextTable(xtemplate, "mode", "Main")
	if not xtemplate then
		return
	end

	xtemplate[#xtemplate+1] = PlaceObj("XTemplateAction", {
		"ActionId", id,
		"ActionName", name,
		"ActionToolbar", "bottommenu",
		"OnAction", OnAction,
	})
	local template = xtemplate[#xtemplate]
	template:SetRolloverTemplate("Rollover")
	template:SetRolloverTitle(T(126095410863, "Info"))
	template:SetRolloverText(T(0000, "Open Mod List Editor"))

end
