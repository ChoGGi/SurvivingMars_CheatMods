-- See LICENSE for terms

local function UpdateProp(xtemplate)
	local idx = table.find(xtemplate, "MaxWidth", 400)
	if idx then
		xtemplate[idx].MaxWidth = 1000000
	end
end

local function AdjustNumber(self, direction)
	local slider = self.parent.idSlider
	if direction then
		slider:ScrollTo(slider.Scroll + slider.StepSize)
	else
		slider:ScrollTo(slider.Scroll - slider.StepSize)
	end
end

local function AddSliderButtons(xtemplate)
	local idx = table.find(xtemplate, "Id", "idSlider")
	if idx then
		local template_left = PlaceObj("XTemplateWindow", {
				"Id", "idButtonLower_ChoGGi",
				"__class", "XTextButton",
				"Text", T("[-]"),
				"FXMouseIn", "ActionButtonHover",
				"FXPress", "ActionButtonClick",
				"FXPressDisabled", "UIDisabledButtonPressed",
				"HAlign", "center",
				"RolloverZoom", 1100,
				"Background", 0,
				"FocusedBackground", 0,
				"RolloverBackground", 0,
				"PressedBackground", 0,
				"TextStyle", "MessageTitle",
				"MouseCursor", "UI/Cursors/Rollover.tga",
				"OnPress", function(self)
					AdjustNumber(self, false)
				end,
				"RolloverTemplate", "Rollover",
			})
		local template_right = PlaceObj("XTemplateWindow", {
				"__template", "PropName",
				"__class", "XTextButton",
				"Id", "idButtonHigher_ChoGGi",
				"Text", T("[+]"),
				"FXMouseIn", "ActionButtonHover",
				"FXPress", "ActionButtonClick",
				"FXPressDisabled", "UIDisabledButtonPressed",
				"HAlign", "center",
				"RolloverZoom", 1100,
				"Background", 0,
				"FocusedBackground", 0,
				"RolloverBackground", 0,
				"PressedBackground", 0,
				"TextStyle", "MessageTitle",
				"MouseCursor", "UI/Cursors/Rollover.tga",
				"OnPress", function(self)
					AdjustNumber(self, true)
				end,
				"RolloverTemplate", "Rollover",
			})
		table.insert(xtemplate, idx, template_left)
		table.insert(xtemplate, idx+2, template_right)
	end
end

function OnMsg.ClassesPostprocess()
	local xtemplate = XTemplates.PropBool[1]
	if xtemplate.ChoGGi_ModOptionsExpanded then
		return
	end
	xtemplate.ChoGGi_ModOptionsExpanded = true


	UpdateProp(xtemplate)
	UpdateProp(XTemplates.PropChoiceOptions[1])
	xtemplate = XTemplates.PropNumber[1]
	UpdateProp(xtemplate)
	-- add buttons to number
	AddSliderButtons(xtemplate)

--~ 	-- hmm
--~ 	UpdateProp(XTemplates.PropKeybinding[1])
end
