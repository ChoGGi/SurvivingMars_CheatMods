-- See LICENSE for terms

function OnMsg.ModsReloaded()
	local buildings = ClassTemplates.Building
	for _, bld in pairs(buildings) do
		bld.can_rotate_during_placement = true
	end
end

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

--~ REMOVE 10.4
--~ local RotateBuilding = ChoGGi.ComFuncs.RotateBuilding
local function RotateBuilding(objs, toggle, multiple)
	if multiple then
		for i = 1, #objs do
			local obj = objs[i]
			obj:SetAngle((obj:GetAngle() or 0) + (toggle and 1 or -1)*60*60)
		end
		return
	end

	objs:SetAngle((objs:GetAngle() or 0) + (toggle and 1 or -1)*60*60)
end
--~ REMOVE 10.4

function OnMsg.ClassesPostprocess()

	local xtemplate = XTemplates.ipBuilding[1]

	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_RotateAllBuildings_Rotate", true)

	xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
		"Id" , "ChoGGi_Template_RotateAllBuildings_Rotate",
		"ChoGGi_Template_RotateAllBuildings_Rotate", true,
		"__template", "InfopanelButton",
		"__context_of_kind", "UndergroundPassage",
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
