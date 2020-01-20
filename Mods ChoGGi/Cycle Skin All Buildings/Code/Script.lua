-- See LICENSE for terms

--~ function ChoGGi.ComFuncs.RetTemplateOrClass(obj)
local function RetTemplateOrClass(obj)
	return obj.template_name ~= "" and obj.template_name or obj.class
end

local function CycleAllSkins(obj)
	local skin, palette = obj:GetCurrentSkin()
	local objs = UICity.labels[RetTemplateOrClass(obj)] or ""
	for i = 1, #objs do
		objs[i]:ChangeSkin(skin, palette)
	end
end

function OnMsg.ClassesPostprocess()
	-- [1]InfopanelDlg>[1]XSizeConstrainedWindow>[3]XContextWindow>[1]idActionButtons
	local xtemplate = XTemplates.Infopanel[1][1][3][1]

	-- we don't need extra text added
	if xtemplate.ChoGGi_CycleSkinAllBuildings_Button then
		return
	end

	local button
	for i = 1, #xtemplate do
		local action = xtemplate[i]
		if action.Icon == "UI/Infopanel/infopanel_skin.tga" then
			button = xtemplate[i]
			break
		end
	end
	if not button then
		print("CANNOT FIND BUTTON: Cycle Skin All Buildings")
		return
	end

	xtemplate.ChoGGi_CycleSkinAllBuildings_Button = true

	local IsMassUIModifierPressed = IsMassUIModifierPressed
	button.OnPress = function (self, gamepad)
		self.context:CycleSkin()
		if gamepad or IsMassUIModifierPressed() then
			CycleAllSkins(self.context)
		end
	end

	button.RolloverText = button.RolloverText .. T(302535920011495, "\n\nPress Ctrl to cycle all buildings.")
end
