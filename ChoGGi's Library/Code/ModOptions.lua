-- See LICENSE for terms

local table = table
local type = type

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

local function ChangeBoolColour(xtemplate, id, colour)
	local idx = table.find(xtemplate, "Id", id)
	if not idx then
		return
	end

	local template = xtemplate[idx]
	template.Text = table.concat(T("<" .. colour .. ">") .. template.Text .. "</color>")
end

function OnMsg.ClassesPostprocess()

	-- Mod Options Expanded
	local xtemplate = XTemplates.PropBool[1]
	if not xtemplate.ChoGGi_ModOptionsExpanded then
		xtemplate.ChoGGi_ModOptionsExpanded = true

		-- Change On/Off text to green/red/duct tape
		ChangeBoolColour(xtemplate, "idOn", "green")
		ChangeBoolColour(xtemplate, "idOff", "red")

		UpdateProp(xtemplate)
		UpdateProp(XTemplates.PropChoiceOptions[1])

		xtemplate = XTemplates.PropNumber[1]
		UpdateProp(xtemplate)
		-- add buttons to number
		AddSliderButtons(xtemplate)

--~ 		-- hmm
--~ 		UpdateProp(XTemplates.PropKeybinding[1])
	end

	-- Mod Options Button
	local xtemplate = XTemplates.XIGMenu[1]
	if not xtemplate.ChoGGi_ModOptionsButton then
		xtemplate.ChoGGi_ModOptionsButton = true

		-- XTemplateWindow[3] ("Margins" = (60, 40)-(0, 0) *(HGE.Box)) >
		xtemplate = xtemplate[3]
		for i = 1, #xtemplate do
			if xtemplate[i].Id == "idList" then
				xtemplate = xtemplate[i]
				break
			end
		end

		if xtemplate.Id == "idList" then
			table.insert(xtemplate, 5, PlaceObj("XTemplateAction", {
				"ActionId", "idModOptions",
				"ActionName", T(1000867, "Mod Options"),
				"ActionToolbar", "mainmenu",
				"__condition", function()
					return CurrentModOptions:GetProperty("ModOptionsButton") and HasModsWithOptions()
				end,
				"OnAction", function(_, host, _)
					-- change to options dialog
					host:SetMode("Options")

					-- then change to mod options
					-- [2]XContentTemplate>
					local list = host[2].idOverlayDlg.idList
					for i = 1, #list do
						local button = list[i]
						if type(button.context) == "table" and button.context.id == "ModOptions" then
							SetDialogMode(button, "mod_choice", button.context)
							break
						end
					end
				end,
			}))
		end

	end

	-- Add input text box

	--

end
