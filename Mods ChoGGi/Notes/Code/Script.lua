-- See LICENSE for terms

-- For assigning auto names to notes (like drones/etc)
MachineNames.ChoGGi_NotePadBuilding = {}
MachineNames.ChoGGi_NotePadBuilding.default = T(0000, "Notepad")
MachineNames.ChoGGi_NotePadBuildingBig = {}
MachineNames.ChoGGi_NotePadBuildingBig.default = T(0000, "NotepadBig")

local RetName = ChoGGi.ComFuncs.RetName
local IsValidXWin = ChoGGi.ComFuncs.IsValidXWin

local mod_NotepadWidth
local mod_NotepadHeight
local mod_AutoOpenNote

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_NotepadWidth = CurrentModOptions:GetProperty("NotepadWidth")
	mod_NotepadHeight = CurrentModOptions:GetProperty("NotepadHeight")
	mod_AutoOpenNote = CurrentModOptions:GetProperty("AutoOpenNote")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

DefineClass.ChoGGi_NotePadBuilding = {
	__parents = {
		"Building",
	},

	notepad_dlg = false,
	notepad_text = false,
}

function ChoGGi_NotePadBuilding:GameInit()
	-- shows in examine without "all"
	-- ...?
	self.notepad_text = ""

	if self.entity:sub(-3)== "Big" then
		self.name = GenerateMachineName(self.class .. "Big")
	else
		self.name = GenerateMachineName(self.class)
	end
end

local function OpenNote(obj)
	-- if it's open then focus inputbox
	if IsValidXWin(obj.notepad_dlg) then
		obj.notepad_dlg.idEdit:SetFocus()
		return
	end

	obj.notepad_dlg = ChoGGi.ComFuncs.OpenInMultiLineTextDlg{
		width = mod_NotepadWidth,
		height = mod_NotepadHeight,
		title = T(0000, "Text: ") .. RetName(obj),
		text = obj.notepad_text,
		hint_ok = T(0000, "Save text to notepad"),
		hint_cancel = T(0000, "Abort without saving text!"),
		custom_func = function(_, dlg_obj)
			obj.notepad_text = dlg_obj.idEdit:GetText()
		end,
	}
end

function ChoGGi_NotePadBuilding:OnSelected()
	if not mod_AutoOpenNote then
		return
	end

	OpenNote(self)
end

local function OpenNotesList()

	local item_list = {}
	local c = 0

	local objs = MapGet("map", "ChoGGi_NotePadBuilding")
	for i = 1, #objs do
		local obj = objs[i]
		c = c + 1
		item_list[c] = {
			text = obj.name,
			value = obj.name,
			hint = obj.notepad_text,
			obj = obj,
		}
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = empty_func,
		items = item_list,
		title = T(0000, "Show All Notes"),
		hint = T(0000, "<left_click> to select note"),
		custom_type = 9,
		custom_func = function(value)
			if IsValid(value[1].obj) then
				ViewAndSelectObject(value[1].obj)
			end
		end,
	}
end

local function AddTemplate(params)
	PlaceObj("BuildingTemplate", {
		"Id", params.Id,
		"display_name", params.display_name,
		"display_name_pl", params.display_name_pl,
		"entity", params.entity,


		"template_class", "ChoGGi_NotePadBuilding",
		"palette_color1", "outside_base",
		"palette_color2", "inside_base",
		"palette_color3", "rover_base",
		"disabled_in_environment1", "",
		"disabled_in_environment2", "",
		"disabled_in_environment3", "",
		"disabled_in_environment4", "",
		"description", T(0000, "Clicking this building will open it's notepad."),
		"display_icon", "UI/Icons/Buildings/placeholder.tga",
		"build_category", "ChoGGi",
		"Group", "ChoGGi",
		"encyclopedia_exclude", true,
		"on_off_button", false,
		"prio_button", false,
		"auto_clear", true,
		"instant_build", true,
		"can_refab", false,
	})

end

function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.ChoGGi_NotePadBuilding then
		AddTemplate{
			Id = "ChoGGi_NotePadBuilding",
			display_name = T(0000, "Notepad"),
			display_name_pl = T(0000, "Notepads"),
			entity = "WayPoint",
		}
		AddTemplate{
			Id = "ChoGGi_NotePadBuildingBig",
			display_name = T(0000, "Notepad Big"),
			display_name_pl = T(0000, "Big Notepads"),
			entity = "WayPointBig",
		}
	end

	local xtemplate = XTemplates.ipBuilding[1]

	-- Made it a mod option
	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_NotePadBuilding_ToggleShow", true)

	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_NotePadBuilding_ShowAllNotes", true)
	table.insert(xtemplate, 1,
		PlaceObj("XTemplateTemplate", {
			"Id" , "ChoGGi_Template_NotePadBuilding_ShowAllNotes",
			"ChoGGi_Template_NotePadBuilding_ShowAllNotes", true,
			"__context_of_kind", "ChoGGi_NotePadBuilding",
			"__template", "InfopanelButton",

			"Title", T(0000, "Show All Notes"),
			"RolloverTitle", T(0000, "Show All Notes"),
			"RolloverText", T(0000, "Show a list of all notes (on active map)."),
			"Icon", "UI/Icons/IPButtons/resources_section.tga",

			"OnPress", function(self)
				OpenNotesList()
			end,
		})
	)

	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_NotePadBuilding_OpenNote", true)
	table.insert(xtemplate, 1,
		PlaceObj("XTemplateTemplate", {
			"Id" , "ChoGGi_Template_NotePadBuilding_OpenNote",
			"ChoGGi_Template_NotePadBuilding_OpenNote", true,
			"__context_of_kind", "ChoGGi_NotePadBuilding",
			"__template", "InfopanelButton",

			"Title", T(0000, "Open Note"),
			"RolloverTitle", T(0000, "Open Note"),
			"RolloverText", T(0000, "Open this note."),
			"Icon", "UI/Icons/IPButtons/assign_workplace.tga",

			"OnPress", function(self)
				OpenNote(self.context)
			end,
		})
	)

end
