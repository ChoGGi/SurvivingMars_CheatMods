-- See LICENSE for terms

local RotateBuilding = ChoGGi.ComFuncs.RotateBuilding

local mod_EnableMod

local function UpdateRotate()
	if not mod_EnableMod then
		return
	end

	local buildings = ClassTemplates.Building
	for _, bld in pairs(buildings) do
		bld.can_rotate_during_placement = true
	end
end

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	UpdateRotate()
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

function OnMsg.ClassesPostprocess()

	local xtemplate = XTemplates.ipBuilding[1]

	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_RotateAllBuildings_Rotate", true)

	xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
		"Id" , "ChoGGi_Template_RotateAllBuildings_Rotate",
		"ChoGGi_Template_RotateAllBuildings_Rotate", true,
		"__template", "InfopanelButton",
		"__context_of_kind", "UndergroundPassage",
		"__condition", function()
			return mod_EnableMod
		end,
		"Icon", "UI/Icons/IPButtons/automated_mode_on.tga",
		"RolloverTitle", T(1000077, "Rotate"),
		"RolloverText", T(7519, "<left_click>") .. " "
			.. T(312752058553, "Rotate Building Left").. "\n"
			.. T(7366, "<right_click>") .. " "
			.. T(306325555448, "Rotate Building Right"),
		"RolloverHint", "",
		"RolloverHintGamepad", T(7518, "ButtonA") .. " "
			.. T(312752058553, "Rotate Building Left") .. " "
			.. T(7618, "ButtonX") .. " " .. T(306325555448, "Rotate Building Right"),
		"OnPress", function (self, gamepad)
			local objs = MapGet(self.context:GetPos(), 1, 1)

			RotateBuilding(objs, not gamepad and IsMassUIModifierPressed(), true)
			ObjModified(self.context)
		end,
		"AltPress", true,
		"OnAltPress", function(self, gamepad)
			local objs = MapGet(self.context:GetPos(), 1, 1)

			if gamepad then
				RotateBuilding(objs, gamepad, true)
			else
				RotateBuilding(objs, not IsMassUIModifierPressed(), true)
			end
			ObjModified(self.context)
		end,
	})
end
