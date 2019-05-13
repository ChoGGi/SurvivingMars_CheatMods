local function SetTableValue(tab, id, id_name, item, value)
	local idx = table.find(tab, id, id_name)
	if idx then
		tab[idx][item] = value
--~ 		return tab[idx]
	end
end

local XTemplates = XTemplates
XTemplates.NewOverlayDlg[1].Dock = "right"
XTemplates.SaveLoadContentWindow[1].Dock = "right"
SetTableValue(XTemplates.SaveLoadContentWindow[1], "Dock", "left", "Dock", "right")
XTemplates.PhotoMode[1].Dock = "right"
