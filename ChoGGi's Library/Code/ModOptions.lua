-- See LICENSE for terms

--local ChoGGi_Funcs = ChoGGi_Funcs
local what_game = ChoGGi.what_game

local table = table
local type = type
local HasModsWithOptions = HasModsWithOptions
local T = T
--~ local Translate = ChoGGi_Funcs.Common.Translate

local mod_DisableDialogEscape

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_DisableDialogEscape = CurrentModOptions:GetProperty("DisableDialogEscape")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

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
				"Text", T(0000, "[-]"),
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
				"Text", T(0000, "[+]"),
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

	-- Disable Esc on dialogs
	local function RemoveKey(key, params)
		local idx = table.find(params.actions, key, "Escape")
		if idx then
			params.actions[idx][key] = ""
		end
	end
	-- ClassDescendants sends class name as first param
	local function AdjustEsc(_, classdef)
		local ChoOrig_new = classdef.new
		function classdef:new(params, ...)
			if not mod_DisableDialogEscape then
				return ChoOrig_new(self, params, ...)
			end

			RemoveKey("ActionShortcut", params)
			RemoveKey("ActionShortcut2", params)

			return ChoOrig_new(self, params, ...)
		end
	end

	local object, cls_name
	if what_game == "Mars" then
		object = XMarsMessageBox
		cls_name = "XMarsMessageBox"
	elseif what_game == "JA3" then
		object = ZuluMessageDialog
		cls_name = "ZuluMessageDialog"
	end -- what_game
	if object then
		-- Main class
		AdjustEsc(nil, object)
		-- PopupNotification (and anything else that comes along)
		ClassDescendants(cls_name, AdjustEsc)
		--
	end


	-- Single click to change toggle options
	local template = XTemplates.PropBool[1]
	local idx = table.find(template, "name", "OnMouseButtonDown(self, pos, button)")
	if idx then
		template = template[idx]
		if not template.ChoGGi_SingleClick then

			local RealTime = RealTime
			local ticks = 0

			local ChoGGiOrig_func = template.func
			-- for some reason this func fires twice when you press it?
			template.func = function(self, pos, button, ...)
				XPropControl.OnMouseButtonDown(self, pos, button, ...)
				if button == "L" then
					-- good thing people can't click too fast
					local rt = RealTime()
					if ticks == rt then
						return
					end
					ticks = rt
					-- off we go then
					return ChoGGiOrig_func(self, pos, button, ...)
				end
			end

		end
	end

	-- Ignore persist errors
	-- This is in pp so it overrides ECM overriding the func
	local ChoOrig_ReportPersistErrors = ReportPersistErrors
	function ReportPersistErrors(...)
		-- be useful for restarting threads, see if devs will add it (edit: I don't see devs doing anything anymore)
		Msg("PostSaveGame")

		if CurrentModOptions:GetProperty("IgnorePersistErrors") then
			return 0, 0
		end

		return ChoOrig_ReportPersistErrors(...)
	end

	-- Mod Options Expanded
	local xtemplate = XTemplates.PropBool[1]
	if not xtemplate.ChoGGi_ModOptionsExpanded then
		xtemplate.ChoGGi_ModOptionsExpanded = true

		-- Change On/Off text to red/green/duct tape
		ChangeBoolColour(xtemplate, "idOn", "green")
		ChangeBoolColour(xtemplate, "idOff", "red")

		UpdateProp(xtemplate)


		if what_game == "Mars" then
			UpdateProp(XTemplates.PropChoiceOptions[1])
		elseif what_game == "JA3" then
			UpdateProp(XTemplates.PropChoice[1])
		end -- what_game

		xtemplate = XTemplates.PropNumber[1]
		UpdateProp(xtemplate)
		-- Add buttons to number
		AddSliderButtons(xtemplate)
	end

	if what_game == "Mars" then
		-- Mod Options Button in Main menu instead of Options menu
		xtemplate = XTemplates.XIGMenu[1]
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
					"ActionName", T(1000867--[[Mod Options]]),
					"ActionToolbar", "mainmenu",
					"__condition", function()
						if CurrentModOptions.GetProperty then
							return CurrentModOptions:GetProperty("ModOptionsButton") and HasModsWithOptions()
						end
						return HasModsWithOptions()
					end,
					"OnAction", function(_, host)
						-- change to options dialog
						host:SetMode("Options")

						-- then change to mod options
						-- [2]XContentTemplate.idOverlayDlg.idList
						local list = host[2].idOverlayDlg.idList
						for i = 1, #list do
							local context = list[i].context
							if type(context) == "table" and context.id == "ModOptions" then
								SetDialogMode(list[i], "mod_choice", context)
								break
							end
						end
					end,
				}))

				local template = xtemplate[5]
				template:SetRolloverTemplate("Rollover")
				template:SetRolloverTitle(T(126095410863, "Info"))
				template:SetRolloverText(T(302535920001673, "Shortcut to Options>Mod Options"))

			end

		end
	end -- what_game

	-- Add check for mod options with: "Header", true, and remove On/Off text from it
	-- or add a "header" prop / make use of existing
end

-- sort list of mods for mod options

local CmpLower = CmpLower
local function sort_mods(a, b)
	return CmpLower(a.title, b.title)
end

local ChoOrig_XTemplateForEach_map = XTemplateForEach.map
function XTemplateForEach.map(parent, context, array, i)
	if array == ModsLoaded then
		array = table.icopy(array)
		table.sort(array, sort_mods)
	end
	return ChoOrig_XTemplateForEach_map(parent, context, array, i)
end
