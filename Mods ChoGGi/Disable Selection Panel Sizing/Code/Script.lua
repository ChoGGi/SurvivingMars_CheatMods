XSizeConstrainedWindow.UpdateMeasure = XWindow.UpdateMeasure

-- I don't see the reason it needs to be 58
function InfopanelDlg:RecalculateMargins()
	local margins = GetSafeMargins()
	local bottom_margin = 0
	local pins = GetDialog("PinsDlg")
	if pins then
		local igi = GetInGameInterface()
		bottom_margin = igi.box:maxy() - pins.box:miny() - margins:maxy()
	end
--~ 	margins = box(margins:minx(), margins:miny() + 58, margins:maxx(), margins:maxy() + bottom_margin)
	margins = box(margins:minx(), margins:miny() + 32, margins:maxx(), margins:maxy() + bottom_margin)
	self:SetMargins(margins)
end
