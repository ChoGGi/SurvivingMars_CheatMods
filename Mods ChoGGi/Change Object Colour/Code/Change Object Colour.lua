local Actions = {
	-- goes to placement mode with last built object
	{
		ActionId = "Change Object Colour.Change Colour",
		OnAction = function()
			ChoGGi.CodeFuncs.CreateObjectListAndAttaches()
		end,
		ActionShortcut = "F6",
		replace_matching_id = true,
	},
	{
		ActionId = "Change Object Colour.ChoGGi_ObjectColourRandom",
		OnAction = function()
			ChoGGi.CodeFuncs.ObjectColourRandom(ChoGGi.ComFuncs.SelObject())
		end,
		ActionShortcut = "Shift-F6",
	},
	{
		ActionId = "Change Object Colour.ChoGGi_ObjectColourDefault",
		OnAction = function()
			ChoGGi.CodeFuncs.ObjectColourDefault(ChoGGi.ComFuncs.SelObject())
		end,
		ActionShortcut = "Ctrl-F6",
	},
}

function OnMsg.ShortcutsReloaded()
	ChoGGi.ComFuncs.Rebuildshortcuts(Actions)
end
