-- See LICENSE for terms

local mod_EnableLog
local mod_EnableConsole

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableLog = CurrentModOptions:GetProperty("EnableLog")
	mod_EnableConsole = CurrentModOptions:GetProperty("EnableConsole")

	ConsoleEnabled = mod_EnableConsole
	ShowConsoleLog(mod_EnableLog)
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function ShowConsole()
	if not mod_EnableConsole or table.find(ModsLoaded, "id", "ChoGGi_CheatMenu") then
		return
	end

	if not rawget(_G, "dlgConsole") then
		CreateConsole()
	end
	if rawget(_G, "dlgConsole") then
		dlgConsole:Show(true)
	end
end

function OnMsg.ClassesPostprocess()
	local CommonShortcuts = XTemplates.CommonShortcuts
	if table.find(CommonShortcuts, "ActionId", "ChoGGi_EnableConsole") then
		return
	end

	CommonShortcuts[#CommonShortcuts+1] = PlaceObj("XTemplateAction", {
		"ActionId", "ChoGGi_EnableConsole",
		"ActionTranslate", false,
		"ActionShortcut", "Enter",
		"ActionShortcut2", "~",
		"OnAction", ShowConsole,
		"replace_matching_id", true,
	})
end

function restart()
	quit("restart")
end
