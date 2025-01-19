-- See LICENSE for terms

local mod_EnableConsole
local mod_EnableLog

local found_ecm
local function IsECM()
	if found_ecm or table.find(ModsLoaded, "id", "ChoGGi_CheatMenu") then
		found_ecm = true
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

	-- build console buttons
	if IsECM() then
		return
	end

	local dlgConsole = dlgConsole
	if dlgConsole and not dlgConsole.ChoGGi_MenuAdded then
		local edit = dlgConsole.idEdit

		-- removes comments from code, and adds a space to each newline, so pasting multi line works
		local XEditEditOperation = XEdit.EditOperation

		-- I don't want to make the mod require my lib mod
		local StripComments
		if rawget(_G, "ChoGGi_Funcs") then
			StripComments = ChoGGi_Funcs.Common.StripComments
		else
			StripComments = function(...)
				return ...
			end
		end

		function edit:EditOperation(insert_text, is_undo_redo, cursor_to_text_start, ...)
			if type(insert_text) == "string" then
				insert_text = StripComments(insert_text)
				insert_text = insert_text:gsub("\n", " \n")
			end
			return XEditEditOperation(self, insert_text, is_undo_redo, cursor_to_text_start, ...)
		end

		dlgConsole.ChoGGi_MenuAdded = true
	end

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

-- kind of an ugly way of making sure console doesn't include ` when using tilde to open console
-- I could do a thread and wait till the key isn't pressed, but it's slower
-- this does block user from typing in `, but eh
local ChoOrig_Console_TextChanged = Console.TextChanged
function Console:TextChanged(...)
	ChoOrig_Console_TextChanged(self, ...)
	local text = self.idEdit:GetText()

	if text:sub(-1) == "`" then
		self.idEdit:SetText(text:sub(1, -2))
		self.idEdit:SetCursor(1, #text-1)
	end
end
