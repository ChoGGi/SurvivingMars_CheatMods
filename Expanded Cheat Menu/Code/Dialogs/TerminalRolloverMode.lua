-- Ged\GedXWindowInspector.lua

-- this is used for select ui element on click

local terminal_target
local terminal_dialog

DefineClass.ChoGGi_RolloverModeTerminalTarget = {
	__parents = {
		"TerminalTarget"
	},
	terminal_target_priority = 20000000
}

function ChoGGi_RolloverModeTerminalTarget:MouseEvent(event, pt)
	if event == "OnMouseButtonDown" then
		local term = terminal.desktop
		local target = term:GetMouseTarget(pt) or term
		ChoGGi.ComFuncs.OpenInExamineDlg(target,terminal_dialog)
		ChoGGi.ComFuncs.TerminalRolloverMode(false)
	end
	return "break"
end

function OnMsg.ClassesGenerate()

	function ChoGGi.ComFuncs.TerminalRolloverMode(enabled,dialog)
		if not terminal_target then
			terminal_target = ChoGGi_RolloverModeTerminalTarget:new()
		end

		if enabled then
			terminal_dialog = dialog
			terminal.AddTarget(terminal_target)
		else
			terminal.RemoveTarget(terminal_target)
		end
	end

end
