-- See LICENSE for terms

-- mess with entities

-- SetScale

--~ local tostring, type = tostring, type
local tonumber = tonumber
local point = point
local IsPoint = IsPoint
local IsValid = IsValid

local TranslationTable = TranslationTable
local RetName = ChoGGi.ComFuncs.RetName
local Translate = ChoGGi.ComFuncs.Translate
local IsShiftPressed = ChoGGi.ComFuncs.IsShiftPressed

local GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
local function GetRootDialog(dlg)
	return dlg.parent_dialog or GetParentOfKind(dlg, "ChoGGi_Dlg3DManipulator")
end
DefineClass.ChoGGi_Dlg3DManipulator = {
	__parents = {"ChoGGi_XWindow"},
	obj = false,
	obj_name = false,

	dialog_width = 750.0,
	dialog_height = 650.0,

	-- If it's an attach item then we use different funcs
	is_attach = false,

	-- obj funcs (if there's attaches)
	func_pos_get = false,
--~ 	func_angle_get = false,
--~ 	func_axis_get = false,
	func_pos_set = false,
--~ 	func_angle_set = false,
--~ 	func_axis_set = false,

	parent_obj = false,

	-- save pos button
	saved_pos = false,
	saved_angle = false,
	saved_axis = false,

	degrees = 60*360,

	-- how much to move by
	default_amount = 1000,
	-- pos buttons
	pos_xyz_list = {
		"X+", "Y+", "Z+",
		"X-", "Y-", "Z-",
	},
	rpy_list = {
		"Roll+", "Pitch+", "Yaw+",
		"Roll-", "Pitch-", "Yaw-",
	},
}

function ChoGGi_Dlg3DManipulator:Init(parent, context)
	local g_Classes = g_Classes

	self.obj_name = RetName(context.obj)
	self.obj = context.obj
	local obj = context.obj

	self.parent_obj = obj:GetParent()
	if IsValid(self.parent_obj) then
		self.is_attach = true
		self.func_pos_get = obj.GetAttachOffset
		self.func_pos_set = obj.SetAttachOffset
--~ 		self.func_angle_get = obj.GetAttachAngle
--~ 		self.func_angle_set = obj.SetAttachAngle
--~ 		self.func_axis_get = obj.GetAttachAxis
--~ 		self.func_axis_set = obj.SetAttachAxis
	else
		self.func_pos_get = obj.GetPos
		self.func_pos_set = obj.SetPos
--~ 		self.func_angle_get = obj.GetAngle
--~ 		self.func_angle_set = obj.SetAngle
--~ 		self.func_axis_get = obj.GetAxis
--~ 		self.func_axis_set = obj.SetAxis
	end

	self.title = TranslationTable[327465361219--[[Edit]]] .. " " .. TranslationTable[298035641454--[[Object]]] .. " " .. TranslationTable[302535920001432--[[3D]]] .. ": " .. self.obj_name

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	do -- IdPosArea
		self.idPosArea = g_Classes.ChoGGi_XDialogSection:new({
			Id = "idPosArea",
			Dock = "top",
			Margins = box(2, 2, 2, 2)
		}, self.idDialog)

		-- pos top
		self.idPosAreaTop = g_Classes.ChoGGi_XDialogSection:new({
			Id = "idPosAreaTop",
			Dock = "top",
		}, self.idPosArea)

		self.idPosSave = g_Classes.ChoGGi_XButton:new({
			Id = "idPosSave",
			Text = TranslationTable[5467--[[SAVE]]],
			RolloverText = TranslationTable[302535920000396--[["Store the position, roll, pitch, and yaw."]]],
			OnPress = self.idPosSave_OnPress,
			-- updaterollover when clicked?
			Dock = "left",
		}, self.idPosAreaTop)
		-- always save current
		self:idPosSave_OnPress()

		self.idPosRestore = g_Classes.ChoGGi_XButton:new({
			Id = "idPosRestore",
			Text = TranslationTable[5469--[[RESET]]],
			RolloverText = TranslationTable[302535920000398--[["Restore the position, roll, pitch, and yaw (hold Shift to restore the original instead of saved)."]]],
			OnPress = self.idPosRestore_OnPress,
			Dock = "left",
		}, self.idPosAreaTop)

		self.idPosClear = g_Classes.ChoGGi_XButton:new({
			Id = "idPosClear",
			Text = TranslationTable[5448--[[CLEAR]]],
			RolloverText = TranslationTable[302535920000404--[["Clear the position, roll, pitch, and yaw (hold Shift to also clear the originals, also cleared when you close the dialog)."]]],
			OnPress = self.idPosClear_OnPress,
			Dock = "left",
		}, self.idPosAreaTop)

		if not self.is_attach then
			self.idMousePos = g_Classes.ChoGGi_XButton:new({
				Id = "idMousePos",
				Text = "",
				RolloverText = TranslationTable[302535920000908--[[Move obj to mouse pos.]]],
				OnPress = self.idMousePos_OnPress,
				Dock = "left",
			}, self.idPosAreaTop)
			self.idMousePos:SetImage("UI/Infopanel/middle_click.tga")
		end

		self.idAmount = g_Classes.ChoGGi_XTextInput:new({
			Id = "idAmount",
			RolloverText = TranslationTable[302535920000389--[[The amount used when a button is pressed (default: %s).]]]:format(self.default_amount),
			Hint = TranslationTable[1000100--[[Amount]]],
			HAlign = "right",
			MinWidth = 200,
			Margins = box(0, 0, 4, 0),
		}, self.idPosAreaTop)
		self.idAmount:SetText(tostring(self.default_amount))

		-- pos bottom
		self.idPosAreaBot = g_Classes.ChoGGi_XDialogSection:new({
			Id = "idPosAreaBot",
			Dock = "bottom",
		}, self.idPosArea)

		self.idPosAreaBotPlus = g_Classes.ChoGGi_XDialogSection:new({
			Id = "idPosAreaBotPlus",
			Dock = "top",
		}, self.idPosAreaBot)

		local pos_xyz_list = {
			TranslationTable[1000497--[[X]]] .. TranslationTable[1000541--[[+]]],
			TranslationTable[1000498--[[Y]]] .. TranslationTable[1000541--[[+]]],
			TranslationTable[1000499--[[Z]]] .. TranslationTable[1000541--[[+]]],

			TranslationTable[1000497--[[X]]] .. TranslationTable[1000540--[[-]]],
			TranslationTable[1000498--[[Y]]] .. TranslationTable[1000540--[[-]]],
			TranslationTable[1000499--[[Z]]] .. TranslationTable[1000540--[[-]]],
		}

		for i = 1, 3 do
			local name = pos_xyz_list[i]
			local id = "idPos_" .. name
			self[id] = g_Classes.ChoGGi_XButton:new({
				Id = id,
				Text = name,
				text_lookup = self.pos_xyz_list[i],
				Dock = "left",
				ChoGGi_RolloverText = TranslationTable[302535920000528--[[Move %s by %s.]]],
				GetRolloverText = self.GetCtrlRolloverText,
				OnPress = self.idPosButtons_OnPress,
			}, self.idPosAreaBotPlus)
		end

		self.idPosAreaBotMinus = g_Classes.ChoGGi_XDialogSection:new({
			Id = "idPosAreaBotMinus",
			Dock = "bottom",
		}, self.idPosAreaBot)

		for i = 4, 6 do
			local name = pos_xyz_list[i]
			local id = "idPos_" .. name
			self[id] = g_Classes.ChoGGi_XButton:new({
				Id = id,
				Text = name,
				text_lookup = self.pos_xyz_list[i],
				Dock = "left",
				ChoGGi_RolloverText = TranslationTable[302535920000528--[[Move %s by %s.]]],
				GetRolloverText = self.GetCtrlRolloverText,
				OnPress = self.idPosButtons_OnPress,
			}, self.idPosAreaBotMinus)
		end

	end -- do

	do -- roll pitchy aw area
		self.idRollPitchYawArea = g_Classes.ChoGGi_XDialogSection:new({
			Id = "idRollPitchYawArea",
			Dock = "top",
		}, self.idDialog)

		self.idRollPitchYawAreaBotPlus = g_Classes.ChoGGi_XDialogSection:new({
			Id = "idRollPitchYawAreaBotPlus",
			Dock = "top",
		}, self.idRollPitchYawArea)

		local rpy_list = {
			TranslationTable[302535920000391--[[Roll]]] .. TranslationTable[1000541--[[+]]],
			TranslationTable[302535920000392--[[Pitch]]] .. TranslationTable[1000541--[[+]]],
			TranslationTable[302535920000395--[[Yaw]]] .. TranslationTable[1000541--[[+]]],

			TranslationTable[302535920000391--[[Roll]]] .. TranslationTable[1000540--[[-]]],
			TranslationTable[302535920000392--[[Pitch]]] .. TranslationTable[1000540--[[-]]],
			TranslationTable[302535920000395--[[Yaw]]] .. TranslationTable[1000540--[[-]]],
		}

		for i = 1, 3 do
			local name = rpy_list[i]
			local id = "idRPY_" .. name
			self[id] = g_Classes.ChoGGi_XButton:new({
				Id = id,
				Text = name,
				text_lookup = self.rpy_list[i],
				Dock = "left",
				OnPress = self.idRollPitchYawButtons_OnPress,
			}, self.idRollPitchYawAreaBotPlus)
		end

		self.idRollPitchYawAreaBotMinus = g_Classes.ChoGGi_XDialogSection:new({
			Id = "idRollPitchYawAreaBotMinus",
			Dock = "bottom",
		}, self.idRollPitchYawArea)

		for i = 4, 6 do
			local name = rpy_list[i]
			local id = "idRPY_" .. name
			self[id] = g_Classes.ChoGGi_XButton:new({
				Id = id,
				Text = name,
				text_lookup = self.rpy_list[i],
				Dock = "left",
				OnPress = self.idRollPitchYawButtons_OnPress,
			}, self.idRollPitchYawAreaBotMinus)
		end

	end -- do

--~ 	do -- IdScaleArea
--~ 		self.idScaleArea = g_Classes.ChoGGi_XDialogSection:new({
--~ 			Id = "idScaleArea",
--~ 			Dock = "top",
--~ 		}, self.idDialog)
--~ 	end -- do

--~ 	do -- IdAngleArea
--~ 		self.idAngleArea = g_Classes.ChoGGi_XDialogSection:new({
--~ 			Id = "idAngleArea",
--~ 			Dock = "top",
--~ 		}, self.idDialog)
--~ 	end -- do

--~ 	do -- IdAxisArea
--~ 		self.idAxisArea = g_Classes.ChoGGi_XDialogSection:new({
--~ 			Id = "idAxisArea",
--~ 			Dock = "top",
--~ 		}, self.idDialog)
--~ 	end -- do

--~ 	do -- IdOrientArea
--~ 		self.idOrientArea = g_Classes.ChoGGi_XDialogSection:new({
--~ 			Id = "idOrientArea",
--~ 			Dock = "top",
--~ 		}, self.idDialog)
--~ 	end -- do

--~ 	self.idEditArea = g_Classes.ChoGGi_XDialogSection:new({
--~ 		Id = "idEditArea",
--~ 		Dock = "bottom",
--~ 	}, self.idDialog)

--~ 	self.idEditValue = g_Classes.ChoGGi_XTextInput:new({
--~ 		Id = "idEditValue",
--~ 		RolloverText = TranslationTable[302535920000102--[[Use to change values of selected list item.]]],
--~ 		Hint = TranslationTable[302535920000103--[[Edit Value]]],
--~ 		OnTextChanged = self.idEditValue_OnTextChanged,
--~ 	}, self.idEditArea)

	self:PostInit(context.parent)

end

function ChoGGi_Dlg3DManipulator:GetCtrlRolloverText()
	return self.ChoGGi_RolloverText:format(
		self.text_lookup,
		GetRootDialog(self):GetAdjustAmount()
	)
end

function ChoGGi_Dlg3DManipulator:GetAdjustAmount()
	-- make sure it returns a number
	return tonumber(self.idAmount:GetText()) or self.default_amount
end

function ChoGGi_Dlg3DManipulator:LimitDegree(num)
--~ 	if num > self.degrees then
--~ 		num = num - self.degrees
--~ 	end
--~ 	if num < 0 and num < -self.degrees then
--~ 		num = num + self.degrees
--~ 	end
	return num
end

function ChoGGi_Dlg3DManipulator:CorrectNumber(num, negative)
	local amount = self:GetAdjustAmount()

	if negative then
		amount = -amount
	end

	if num > -1 then
		num = num + amount
	else
		num = num - amount
	end

	return num
end

function ChoGGi_Dlg3DManipulator:idRollPitchYawButtons2_OnPress(delta)
	self = GetRootDialog(self)
	local obj = self.obj

	self.func_pos_set(obj,
		(obj:GetAngle() or 0) + (delta or 1)
--~ 		(self.func_angle_get(obj) or 0) + (delta or 1)
		*60*60
	)
end

function ChoGGi_Dlg3DManipulator:idRollPitchYawButtons_OnPress()
	local text = self.text_lookup
	self = GetRootDialog(self)
	local obj = self.obj

	local roll, pitch, yaw = GetRollPitchYaw(obj)

--~ print("A", roll, pitch, yaw)
	if text == "Roll+" then
		roll = self:CorrectNumber(roll)
		roll = self:LimitDegree(roll)
	elseif text == "Pitch+" then
		pitch = self:CorrectNumber(pitch)
		pitch = self:LimitDegree(pitch)
	elseif text == "Yaw+" then
		yaw = self:CorrectNumber(yaw)
		yaw = self:LimitDegree(yaw)

	elseif text == "Roll-" then
		roll = self:CorrectNumber(roll, true)
		roll = self:LimitDegree(roll)
	elseif text == "Pitch-" then
		pitch = self:CorrectNumber(pitch, true)
		pitch = self:LimitDegree(pitch)
	elseif text == "Yaw-" then
		yaw = self:CorrectNumber(yaw, true)
		yaw = self:LimitDegree(yaw)
	end

--~ print("B", roll, pitch, yaw)
	SetRollPitchYaw(obj, roll, pitch, yaw)
end

function ChoGGi_Dlg3DManipulator:idPosButtons_OnPress()
	local text = self.text_lookup
	self = GetRootDialog(self)
	local obj = self.obj

	local amount = self:GetAdjustAmount()

	local x, y, z = 0, 0, 0

	if text == "X+" then
		x = amount
	elseif text == "Y+" then
		y = amount
	elseif text == "Z+" then
		z = amount
	elseif text == "X-" then
		x = -amount
	elseif text == "Y-" then
		y = -amount
	elseif text == "Z-" then
		z = -amount
	end

	self.func_pos_set(obj,
		self.func_pos_get(obj)+point(x, y, z)
	)
end

function ChoGGi_Dlg3DManipulator:idMousePos_OnPress()
	GetRootDialog(self).obj:SetPos(GetCursorWorldPos())
end

function ChoGGi_Dlg3DManipulator:idPosClear_OnPress()
	self = GetRootDialog(self)
	self.saved_angle = false
	self.saved_axis = false
	self.saved_pos = false
	if IsShiftPressed() then
		obj.ChoGGi_3DManipulator_SavedData = nil
	end
end

function ChoGGi_Dlg3DManipulator:idPosRestore_OnPress()
	self = GetRootDialog(self)
	local obj = self.obj

	local pos, angle, axis
	if IsShiftPressed() then
		local orig = obj.ChoGGi_3DManipulator_SavedData
		if orig then
			pos = orig.saved_pos
			angle = tonumber(orig.saved_angle)
			axis = orig.saved_axis
		end
	else
		pos = self.saved_pos
		angle = tonumber(self.saved_angle)
		axis = self.saved_axis
	end

	if IsPoint(pos) then
		self.func_pos_set(obj, pos)
	end
	if angle then
--~ 		self.func_angle_set(obj, angle)
		obj:SetAngle(angle)
	end
	if IsPoint(axis) then
--~ 		self.func_axis_set(obj, axis)
		obj:SetAxis(axis)
	end
end

function ChoGGi_Dlg3DManipulator:idPosSave_OnPress()
	self = GetRootDialog(self)
	local obj = self.obj

	-- If opening an xwindow object skip this (testing the 3dman dialog from main menu)
	if not obj:IsKindOf("CObject") then
		return
	end

	self.saved_pos = self.func_pos_get(obj)
--~ 	self.saved_axis = self.func_angle_get(obj)
	self.saved_angle = obj:GetAngle()
--~ 	self.saved_axis = self.func_axis_get(obj)
	self.saved_axis = obj:GetAxis()

	-- make sure obj stores the orig
	if not obj.ChoGGi_3DManipulator_SavedData then
		obj.ChoGGi_3DManipulator_SavedData = {
			saved_pos = self.saved_pos,
			saved_angle = self.saved_angle,
			saved_axis = self.saved_axis,
		}
	end

end

--~ GedPropEditors.lua
--~ ModItemAttachment.lua
function ChoGGi_Dlg3DManipulator:SliderInit(id, parent, target, min, max)
	XEdit:new({
		Id = "idEdit_" .. id,
		Dock = "left",
		MinWidth = 50,
	}, parent)
	local max_rot = 180*60
	XSleekScroll:new({
		Id = "idScroll_" .. id,
		Dock = "box",
		Margins = box(2, 2, 2, 2),
		Min = min or -max_rot,
		Max = max + 1 or max_rot + 1,
		Horizontal = true,
		Target = target or "node",
	}, parent)
--~ 	self.idScroll:SetEnabled(not prop_meta.read_only)
--~   self.idEdit:SetEnabled(not prop_meta.read_only)
end

-- remove original pos key
function ChoGGi_Dlg3DManipulator:Done()
	obj.ChoGGi_3DManipulator_SavedData = nil
end
