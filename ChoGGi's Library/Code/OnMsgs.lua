--~ ChoGGi.Temp.UIScale = (LocalStorage.Options.UIScale + 0.0) / 100 or 100
ChoGGi.Temp.UIScale = (LocalStorage.Options.UIScale + 0.0) / 100
-- used for resizing my dialogs to scale
function OnMsg.SystemSize()
	ChoGGi.Temp.UIScale = (LocalStorage.Options.UIScale + 0.0) / 100
end

-- we don't add shortcuts and ain't supposed to drink no booze
function OnMsg.ShortcutsReloaded()
	ChoGGi.ComFuncs.Rebuildshortcuts()
end

-- so we at least have keys when it happens
function OnMsg.ReloadLua()
	if type(XShortcutsTarget.UpdateToolbar) == "function" then
		ChoGGi.ComFuncs.Rebuildshortcuts()
	end
end
