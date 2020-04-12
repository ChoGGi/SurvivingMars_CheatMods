-- See LICENSE for terms

-- add keybind for toggle
local Actions = ChoGGi.Temp.Actions
Actions[#Actions+1] = {ActionName = T(3973, "Salvage"),
	ActionId = "ChoGGi.AddSalvageHotkey.SalvageToggle",
	OnAction = function()
		local igi = GetInGameInterface()
		if igi then
			if igi.DemolishModeDialog then
				igi:SetMode("selection")
			else
				igi:SetMode("demolish")
			end
		end
	end,
	ActionShortcut = "Delete",
	replace_matching_id = true,
	ActionBindable = true,
}
