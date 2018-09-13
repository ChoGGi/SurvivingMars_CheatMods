--~ ChoGGi.Temp.UIScale = (LocalStorage.Options.UIScale + 0.0) / 100 or 100
ChoGGi.Temp.UIScale = (LocalStorage.Options.UIScale + 0.0) / 100
-- used for resizing my dialogs to scale
function OnMsg.SystemSize()
	ChoGGi.Temp.UIScale = (LocalStorage.Options.UIScale + 0.0) / 100
end
