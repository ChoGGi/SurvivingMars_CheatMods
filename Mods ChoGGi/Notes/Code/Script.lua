-- See LICENSE for terms

MachineNames.ChoGGi_NotePadBuilding = {}
MachineNames.ChoGGi_NotePadBuilding.default = T(0000, "Notepad")
MachineNames.ChoGGi_NotePadBuildingBig = {}
MachineNames.ChoGGi_NotePadBuildingBig.default = T(0000, "NotepadBig")

local RetName = ChoGGi.ComFuncs.RetName
local IsValidXWin = ChoGGi.ComFuncs.IsValidXWin

local mod_NotepadWidth
local mod_NotepadHeight

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_NotepadWidth = CurrentModOptions:GetProperty("NotepadWidth")
	mod_NotepadHeight = CurrentModOptions:GetProperty("NotepadHeight")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

DefineClass.ChoGGi_NotePadBuilding = {
	__parents = {
		"Building",
	},

	notepad_dlg = false,
	notepad_text = false,
	always_show_notepad = false,
}

function ChoGGi_NotePadBuilding:GameInit()
	-- shows in examine without "all"
	self.notepad_text = ""
	self.always_show_notepad = true

	if self.entity:sub(-3)== "Big" then
		self.name = GenerateMachineName(self.class .. "Big")
	else
		self.name = GenerateMachineName(self.class)
	end
end

function ChoGGi_NotePadBuilding:OnSelected()
	if not self.always_show_notepad then
		return
	end

	-- if it's open then focus inputbox
	if IsValidXWin(self.notepad_dlg) then
		self.notepad_dlg.idEdit:SetFocus()
		return
	end

	self.notepad_dlg = ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
		width = mod_NotepadWidth,
		height = mod_NotepadHeight,
		title = T(0000, "Text: ") .. RetName(self),
		text = self.notepad_text,
		hint_ok = T(0000, "Save text to notepad"),
		hint_cancel = T(0000, "Abort without saving text!"),
		custom_func = function(answer, _, obj)
			if answer then
				self.notepad_text = obj.idEdit:GetText()
			end
		end,
	}

end

function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.ChoGGi_NotePadBuilding then
		PlaceObj("BuildingTemplate", {
			"Id", "ChoGGi_NotePadBuilding",
			"template_class", "ChoGGi_NotePadBuilding",
			"palette_color1", "outside_base",
			"palette_color2", "inside_base",
			"palette_color3", "rover_base",
			"disabled_in_environment1", "",
			"disabled_in_environment2", "",
			"disabled_in_environment3", "",
			"disabled_in_environment4", "",

			"display_name", T(0000, "Notepad"),
			"display_name_pl", T(0000, "Notepads"),
			"description", T(0000, "Clicking this building will open it's notepad."),
			"display_icon", "UI/Icons/Buildings/placeholder.tga",
			"entity", "WayPoint",
			"build_category", "ChoGGi",
			"Group", "ChoGGi",
			"encyclopedia_exclude", true,
			"on_off_button", false,
			"prio_button", false,
			"auto_clear", true,
			"instant_build", true,
		})

		PlaceObj("BuildingTemplate", {
			"Id", "ChoGGi_NotePadBuildingBig",
			"template_class", "ChoGGi_NotePadBuilding",
			"palette_color1", "outside_base",
			"palette_color2", "inside_base",
			"palette_color3", "rover_base",
			"disabled_in_environment1", "",
			"disabled_in_environment2", "",
			"disabled_in_environment3", "",
			"disabled_in_environment4", "",

			"display_name", T(0000, "Notepad Big"),
			"display_name_pl", T(0000, "Big Notepads"),
			"description", T(0000, "Clicking this building will open it's notepad."),
			"display_icon", "UI/Icons/Buildings/placeholder.tga",
			"entity", "WayPointBig",
			"build_category", "ChoGGi",
			"Group", "ChoGGi",
			"encyclopedia_exclude", true,
			"on_off_button", false,
			"prio_button", false,
			"auto_clear", true,
			"instant_build", true,
		})
	end


	local xtemplate = XTemplates.ipBuilding[1]

	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_NotePadBuilding_ToggleShow", true)

	table.insert(xtemplate, 1,
		PlaceObj("XTemplateTemplate", {
			"Id" , "ChoGGi_Template_NotePadBuilding_ToggleShow",
			"ChoGGi_Template_NotePadBuilding_ToggleShow", true,
			"comment", "toggle opening the notepad when selected",
			"__context_of_kind", "ChoGGi_NotePadBuilding",
			"__template", "InfopanelButton",
			"OnContextUpdate", function(self, context)
				local name = RetName(context)
				if context.always_show_notepad then
					self:SetIcon("UI/Icons/traits_approve.tga")
				else
					self:SetIcon("UI/Icons/traits_disapprove.tga")
				end
			end,

			"Title", T(0000, "Always Open"),
			"RolloverTitle", T(0000, "Always Open"),
			"RolloverText", T(0000, "Toggle always showing this notepad."),
			"Icon", "UI/Icons/IPButtons/traits_approve.tga",

			"OnPress", function(self)
				-- left click action
				self.context.always_show_notepad = not self.context.always_show_notepad
				ObjModified(self.context)
			end,
		})
	)

end
