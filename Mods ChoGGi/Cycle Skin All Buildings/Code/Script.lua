-- See LICENSE for terms

local RetTemplateOrClass = ChoGGi.ComFuncs.RetTemplateOrClass
local ObjectColourRandom = ChoGGi.ComFuncs.ObjectColourRandom
local SetChoGGiPalette = ChoGGi.ComFuncs.SetChoGGiPalette

local IsKindOf = IsKindOf
local IsMassUIModifierPressed = IsMassUIModifierPressed

local function CycleAllSkins(obj)
	local skin, palette = obj:GetCurrentSkin()
	local objs = UICity.labels[RetTemplateOrClass(obj)] or ""
	local name = obj.template_name
	for i = 1, #objs do
		local all_obj = objs[i]
		if all_obj.template_name == name then
			all_obj:ChangeSkin(skin, palette)
		end
	end
end

local function RandomSkin(obj, all_skins)
	ObjectColourRandom(obj)

	if all_skins then
		local palette = obj.ChoGGi_origcolors
		local objs = UICity.labels[RetTemplateOrClass(obj)] or ""
		for i = 1, #objs do
			SetChoGGiPalette(objs[i], palette)
		end
	end

	-- we don't need to keep this around, since changing the skin will reset it
	obj.ChoGGi_origcolors = nil
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
		print("CANNOT FIND SKIN BUTTON: Cycle Skin All Buildings")
		return
	end

	xtemplate.ChoGGi_CycleSkinAllBuildings_Button = true

	button.OnPress = function(self, gamepad)
		local context = self.context

		-- objs with one skin so we can reset random colours
		local skins = context:GetSkins()
		if #skins == 1 then
			local skin, palette = context:GetCurrentSkin()
			context:ChangeSkin(skin, palette)
		else
			context:CycleSkin()
		end

		if (gamepad or IsMassUIModifierPressed()) then
			CycleAllSkins(context)
		end
	end

	-- add a right-click or button y action
	button.AltPress = true
	button.OnAltPress = function(self, gamepad)
		RandomSkin(self.context)
		if (gamepad or IsMassUIModifierPressed()) then
			RandomSkin(self.context, true)
		end
	end

	-- show button for stuff with at least one skin
	button.__condition = function(_, context)
		if not IsKindOf(context, "ConstructionSite") then
			return #(context:GetSkins() or "") > 0 or IsKindOf(context, "RocketBase")
		end
	end

	button.RolloverText = button.RolloverText .. T(302535920011495, "\n\nPress Ctrl to cycle all buildings, <right_click> to use a randomly coloured skin.")
end
