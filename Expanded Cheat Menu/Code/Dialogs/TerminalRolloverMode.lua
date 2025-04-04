-- Ged\GedXWindowInspector.lua

-- this is used for select ui element on click

local ChoGGi_Funcs = ChoGGi_Funcs

local terminal_target
local terminal_dialog

DefineClass.ChoGGi_DlgRolloverModeTerminalTarget = {
	__parents = {
		"TerminalTarget"
	},
	terminal_target_priority = 20000000,
}

function ChoGGi_DlgRolloverModeTerminalTarget:MouseEvent(event, pt, button)
	if event == "OnMouseButtonDown" then
		if button == "L" then
			local term = terminal.desktop
			local target = term:GetMouseTarget(pt) or term

			OpenExamine(target, {
				has_params = true,
				parent = terminal_dialog,
				-- Ignore the Child checkbox in examine
				skip_child = true,
			})
		end
		-- right or middle so goodbye
		ChoGGi_Funcs.Common.TerminalRolloverMode(false)
		return "break"
	end
end

function ChoGGi_Funcs.Common.TerminalRolloverMode(enabled, dlg)
	if not terminal_target then
		terminal_target = ChoGGi_DlgRolloverModeTerminalTarget:new()
	end
	terminal_target.flash_ui = ChoGGi.UserSettings.FlashExamineObject

	if enabled then
		terminal_dialog = dlg
		terminal.AddTarget(terminal_target)
	else
		terminal.RemoveTarget(terminal_target)
	end
end
