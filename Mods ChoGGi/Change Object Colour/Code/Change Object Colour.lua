local Actions = {
	-- goes to placement mode with last built object
	{
		ActionId = "Game.Color Modifier",
		OnAction = function()
			ChoGGi.CodeFuncs.CreateObjectListAndAttaches()
		end,
		ActionShortcut = "F6",
		replace_matching_id = true,
		ActionBindable = true,
		ActionName = S[174--[[Color Modifier--]]],
	},
	{
		ActionId = "ChoGGi_ObjectColourRandom",
		OnAction = function()
			ChoGGi.CodeFuncs.ObjectColourRandom(ChoGGi.ComFuncs.SelObject())
		end,
		ActionShortcut = "Shift-F6",
		ActionBindable = true,
		ActionName = string.format("%s %s",S[298035641454--[[Object--]]],S[302535920001346--[[Random Colour--]]]),
	},
	{
		ActionId = "ChoGGi_ObjectColourDefault",
		OnAction = function()
			ChoGGi.CodeFuncs.ObjectColourDefault(ChoGGi.ComFuncs.SelObject())
		end,
		ActionShortcut = "Ctrl-F6",
		ActionBindable = true,
		ActionName = string.format("%s %s",S[298035641454--[[Object--]]],S[302535920000025--[[Default Colour--]]]),
	},
}

function OnMsg.ShortcutsReloaded()
	ChoGGi.ComFuncs.Rebuildshortcuts(Actions)
end
