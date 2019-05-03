-- See LICENSE for terms

-- mess with entities

--~ local tostring,type = tostring,type
local point = point
local IsPoint = IsPoint
local IsValid = IsValid
local GetRollPitchYaw = GetRollPitchYaw
local SetRollPitchYaw = SetRollPitchYaw

local Strings = ChoGGi.Strings
local RetName = ChoGGi.ComFuncs.RetName
local Translate = ChoGGi.ComFuncs.Translate
local GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind

local function GetRootDialog(dlg)
	return GetParentOfKind(dlg,"ChoGGi_3DManipulatorDlg")
end
DefineClass.ChoGGi_3DManipulatorDlg = {
	__parents = {"ChoGGi_XWindow"},
	obj = false,
	obj_name = false,

	dialog_width = 750.0,
	dialog_height = 650.0,

	-- if it's an attach item then we use different funcs
	is_attach = false,
	parent = false,

	-- save pos button
	saved_pos = false,
	saved_rollpitchyaw = false,

	-- how much to move by
	default_amount = 1000,
	-- pos buttons
	pos_xyz_list = {
		"X+","Y+","Z+",
		"X-","Y-","Z-",
	},
	rpy_list = {
		"Roll+","Pitch+","Yaw+",
		"Roll-","Pitch-","Yaw-",
	},
}

function ChoGGi_3DManipulatorDlg:Init(parent, context)
	local g_Classes = g_Classes

	self.obj_name = RetName(context.obj)
	self.obj = context.obj

	self.parent = self.obj:GetParent()
	if IsValid(self.parent) then
		is_attach = true
	end

	self.title = Translate(327465361219--[[Edit--]]) .. " " .. Translate(298035641454--[[Object--]]) .. " " .. Strings[302535920001432--[[3D--]]] .. ": " .. self.obj_name

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	-- set pos ui?
--~ SetAttachOffset
--~ SetRollPitchYaw

	do -- idPosArea
		self.idPosArea = g_Classes.ChoGGi_XDialogSection:new({
			Id = "idPosArea",
			Dock = "top",
			Margins = box(2,2,2,2)
		}, self.idDialog)

		-- pos top
		self.idPosAreaTop = g_Classes.ChoGGi_XDialogSection:new({
			Id = "idPosAreaTop",
			Dock = "top",
		}, self.idPosArea)

		self.idPosSave = g_Classes.ChoGGi_XButton:new({
			Id = "idPosSave",
			Text = Translate(5467--[[SAVE--]]),
			RolloverText = Strings[302535920000396--[["Store the position, roll, pitch, and yaw."--]]],
			OnPress = self.idPosSave_OnPress,
			-- updaterollover when clicked?
			Dock = "left",
		}, self.idPosAreaTop)
		-- always save current
		self:idPosSave_OnPress()

		self.idPosRestore = g_Classes.ChoGGi_XButton:new({
			Id = "idPosRestore",
			Text = Translate(5469--[[RESET--]]),
			RolloverText = Strings[302535920000398--[["Restore the position, roll, pitch, and yaw."--]]],
			OnPress = self.idPosRestore_OnPress,
			Dock = "left",
		}, self.idPosAreaTop)

		self.idPosClear = g_Classes.ChoGGi_XButton:new({
			Id = "idPosClear",
			Text = Translate(5448--[[CLEAR--]]),
			RolloverText = Strings[302535920000404--[["Clear the position, roll, pitch, and yaw."--]]],
			OnPress = self.idPosClear_OnPress,
			Dock = "left",
		}, self.idPosAreaTop)

		self.idAmount = g_Classes.ChoGGi_XTextInput:new({
			Id = "idAmount",
			RolloverText = Strings[302535920000389--[[The amount used when a button is pressed (default: %s).--]]]:format(self.default_amount),
			Hint = Translate(1000100--[[Amount--]]),
			HAlign = "right",
			MinWidth = 250,
		}, self.idPosAreaTop)

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
			Translate(1000497--[[X--]]) .. Translate(1000541--[[+--]]),
			Translate(1000498--[[Y--]]) .. Translate(1000541--[[+--]]),
			Translate(1000499--[[Z--]]) .. Translate(1000541--[[+--]]),

			Translate(1000497--[[X--]]) .. Translate(1000540--[[---]]),
			Translate(1000498--[[Y--]]) .. Translate(1000540--[[---]]),
			Translate(1000499--[[Z--]]) .. Translate(1000540--[[---]]),
		}

		for i = 1, 3 do
			local name = pos_xyz_list[i]
			local id = "idPos_" .. name
			self[id] = g_Classes.ChoGGi_XButton:new({
				Id = id,
				Text = name,
				text_lookup = self.pos_xyz_list[i],
				Dock = "left",
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
			Strings[302535920000391--[[Roll--]]] .. Translate(1000541--[[+--]]),
			Strings[302535920000392--[[Pitch--]]] .. Translate(1000541--[[+--]]),
			Strings[302535920000395--[[Yaw--]]] .. Translate(1000541--[[+--]]),

			Strings[302535920000391--[[Roll--]]] .. Translate(1000540--[[---]]),
			Strings[302535920000392--[[Pitch--]]] .. Translate(1000540--[[---]]),
			Strings[302535920000395--[[Yaw--]]] .. Translate(1000540--[[---]]),
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

--~ 	do -- idAngleArea
--~ 		self.idAngleArea = g_Classes.ChoGGi_XDialogSection:new({
--~ 			Id = "idAngleArea",
--~ 			Dock = "top",
--~ 		}, self.idDialog)
--~ 	end -- do

--~ 	do -- idAxisArea
--~ 		self.idAxisArea = g_Classes.ChoGGi_XDialogSection:new({
--~ 			Id = "idAxisArea",
--~ 			Dock = "top",
--~ 		}, self.idDialog)
--~ 	end -- do

--~ 	do -- idOrientArea
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
--~ 		RolloverText = Strings[302535920000102--[[Use to change values of selected list item.--]]],
--~ 		Hint = Strings[302535920000103--[[Edit Value--]]],
--~ 		OnTextChanged = self.idEditValue_OnTextChanged,
--~ 	}, self.idEditArea)

	self:PostInit(context.parent)

end

function ChoGGi_3DManipulatorDlg:RetAmount()
	local num = tonumber(self.idAmount:GetText())
	if type(num) == "number" then
		return num
	end
	return self.default_amount
end

function ChoGGi_3DManipulatorDlg:idRollPitchYawButtons_OnPress()
	local text = self.text_lookup
	self = GetRootDialog(self)
	local amount = self:RetAmount()

	local roll,pitch,yaw = GetRollPitchYaw(self.obj)

	if text == "Roll+" then
		roll = roll + amount
	elseif text == "Pitch+" then
		pitch = pitch + amount
	elseif text == "Yaw+" then
		yaw = yaw + amount
	elseif text == "Roll-" then
		roll = roll + (amount * -1)
	elseif text == "Pitch-" then
		pitch = pitch + (amount * -1)
	elseif text == "Yaw-" then
		yaw = yaw + (amount * -1)
	end

	SetRollPitchYaw(self.obj,roll,pitch,yaw)
end

function ChoGGi_3DManipulatorDlg:idPosButtons_OnPress()
	local text = self.text_lookup
	self = GetRootDialog(self)
	local amount = self:RetAmount()

	local x,y,z = 0,0,0

	if text == "X+" then
		x = amount
	elseif text == "Y+" then
		y = amount
	elseif text == "Z+" then
		z = amount
	elseif text == "X-" then
		x = amount * -1
	elseif text == "Y-" then
		y = amount * -1
	elseif text == "Z-" then
		z = amount * -1
	end

	self.obj:SetPos(self.obj:GetPos()+point(x,y,z))
end

function ChoGGi_3DManipulatorDlg:idPosClear_OnPress()
	self = GetRootDialog(self)
	self.saved_rollpitchyaw = false
	self.saved_pos = false
end

function ChoGGi_3DManipulatorDlg:idPosRestore_OnPress()
	self = GetRootDialog(self)
	if IsPoint(self.saved_pos) then
		self.obj:SetPos(self.saved_pos)
	end
	if self.saved_rollpitchyaw then
		local rpw = self.saved_rollpitchyaw
		SetRollPitchYaw(self.obj,rpw[1],rpw[2],rpw[3])
	end
end
function ChoGGi_3DManipulatorDlg:idPosSave_OnPress()
	self = GetRootDialog(self)
	self.saved_pos = self.obj:GetPos()
	self.saved_rollpitchyaw = {GetRollPitchYaw(self.obj)}
end
