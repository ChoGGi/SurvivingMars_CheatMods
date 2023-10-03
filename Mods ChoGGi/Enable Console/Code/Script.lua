-- See LICENSE for terms

local mod_EnableConsole
local mod_EnableLog

local function IsECM()
	if table.find(ModsLoaded, "id", "ChoGGi_CheatMenu") then
		return true
	end
end

local function ModOptions(id)
	if IsECM() then
		return
	end

	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableConsole = CurrentModOptions:GetProperty("EnableConsole")
	mod_EnableLog = CurrentModOptions:GetProperty("EnableLog")

	ConsoleEnabled = mod_EnableConsole
	ShowConsoleLog(mod_EnableLog)
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function ShowConsole()
	if not mod_EnableConsole or IsECM() then
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
	if IsECM() then
		return
	end

	local CommonShortcuts = XTemplates.CommonShortcuts

	if table.find(CommonShortcuts, "ActionId", "ChoGGi_EnableConsole") then
		return
	end

	CommonShortcuts[#CommonShortcuts+1] = PlaceObj("XTemplateAction", {
		"ActionId", "ChoGGi_EnableConsole",
		"ActionTranslate", false,
		"ActionShortcut", "Enter",
		"OnAction", ShowConsole,
		"replace_matching_id", true,

		-- for some reason works fine for ECM but not this mod...
		"ActionShortcut2", "~",
	})

	local template = CommonShortcuts[#CommonShortcuts]
	template:SetRolloverTemplate("Rollover")
	template:SetRolloverTitle(T(126095410863, "Info"))
	template:SetRolloverText(T(0000, "Press Enter or Tilde to show console."))

end

function restart()
	quit("restart")
end

function OnMsg.ChoGGi_UpdateBlacklistFuncs(env)
	if IsECM() then
		return
	end

	-- ReadHistory fires from :Show(), if it isn't loaded before you :Exec() then goodbye history
	local ChoOrig_Console_Exec = Console.Exec
	function Console:Exec(text, hide_text, ...)
		if not self.history_queue or #self.history_queue == 0 then
			self:ReadHistory()
		end
		if hide_text then
			-- same as Console:Exec(), but skips log text
			self:AddHistory(text)
			local err = env.ConsoleExec(text, ConsoleRules)
			if err then
				ConsolePrint(err)
			end
			return
		end
		return ChoOrig_Console_Exec(self, text, hide_text, ...)
	end
end
