-- Ged\GedXWindowInspector.lua

-- nope not hacky at all
local is_loaded
function OnMsg.ChoGGi_Library_Loaded(mod_id)
	if is_loaded or mod_id and mod_id ~= "ChoGGi_CheatMenu" then
		return
	end
	is_loaded = true

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
			ChoGGi_TerminalRolloverMode(false)
		end
		return "break"
	end

	function ChoGGi_TerminalRolloverMode(enabled,dialog)
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
