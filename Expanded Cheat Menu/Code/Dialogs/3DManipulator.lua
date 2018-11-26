-- See LICENSE for terms

-- mess with entities

local S
local RetName
local Trans
local GetParentOfKind

local tostring,type,table = tostring,type,table
local StringFormat = string.format

function OnMsg.ClassesGenerate()
	S = ChoGGi.Strings
	RetName = ChoGGi.ComFuncs.RetName
	Trans = ChoGGi.ComFuncs.Translate
	GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
end

local GetRootDialog = function(obj)
	return GetParentOfKind(obj,"ChoGGi_3DManipulatorDlg")
end
DefineClass.ChoGGi_3DManipulatorDlg = {
	__parents = {"ChoGGi_Window"},
	obj = false,
	obj_name = false,

	dialog_width = 750.0,
	dialog_height = 650.0,
}

function ChoGGi_3DManipulatorDlg:Init(parent, context)
	local g_Classes = g_Classes

	self.obj_name = RetName(context.obj)
	self.obj = context.obj
	self.title = StringFormat("%s: %s",S[302535920001432--[[%s %s 3D--]]]:format(S[327465361219--[[Edit--]]],S[298035641454--[[Object--]]]),self.obj_name)

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	-- set pos ui?
--~ SetAttachOffset
--~ SetRollPitchYaw

	do -- idPos_Area
		self.idPos_Area = g_Classes.ChoGGi_DialogSection:new({
			Id = "idPos_Area",
			Dock = "top",
			Margins = box(2,2,2,2)
		}, self.idDialog)

		-- top
		self.idPos_AreaTop = g_Classes.ChoGGi_DialogSection:new({
			Id = "idPos_AreaTop",
			Dock = "top",
		}, self.idPos_Area)

		self.idPos_Save = g_Classes.ChoGGi_Button:new({
			Id = "idPos_Save",
			Text = "save",
			Dock = "left",
			--updaterollover when clicked?
		}, self.idPos_AreaTop)

		self.idPos_Restore = g_Classes.ChoGGi_Button:new({
			Id = "idPos_Restore",
			Text = "restore",
			Dock = "left",
		}, self.idPos_AreaTop)

		self.idPos_Amount = g_Classes.ChoGGi_TextInput:new({
			Id = "idPos_Amount",
			RolloverText = "how much to %s by",
			Hint = S[302535920000103--[[Edit Value--]]],
			HAlign = "left",
			MinWidth = 250,
		}, self.idPos_AreaTop)


		-- bottom
		self.idPos_AreaBot = g_Classes.ChoGGi_DialogSection:new({
			Id = "idPos_AreaBot",
			Dock = "bottom",
		}, self.idPos_Area)

		local id_str = "isPos_%s"
		local xyz_list = {
			"XPlus","YPlus","ZPlus",
			"XMinus","YMinus","ZMinus",
		}

		self.idPos_AreaBotPlus = g_Classes.ChoGGi_DialogSection:new({
			Id = "idPos_AreaBotPlus",
			Dock = "top",
		}, self.idPos_AreaBot)

		for i = 1, 3 do
			local id = id_str:format(xyz_list[i])
			self[id] = g_Classes.ChoGGi_Button:new({
				Id = id,
				Text = id,
				Dock = "left",
			}, self.idPos_AreaBotPlus)
		end

		self.idPos_AreaBotMinus = g_Classes.ChoGGi_DialogSection:new({
			Id = "idPos_AreaBotMinus",
			Dock = "bottom",
		}, self.idPos_AreaBot)

		for i = 4, 6 do
			local id = id_str:format(xyz_list[i])
			self[id] = g_Classes.ChoGGi_Button:new({
				Id = id,
				Text = id,
				Dock = "left",
			}, self.idPos_AreaBotMinus)
		end

	end -- do

	do -- idAngle_Area
		self.idAngle_Area = g_Classes.ChoGGi_DialogSection:new({
			Id = "idAngle_Area",
			Dock = "top",
		}, self.idDialog)
	end -- do

	do -- idAxis_Area
		self.idAxis_Area = g_Classes.ChoGGi_DialogSection:new({
			Id = "idAxis_Area",
			Dock = "top",
		}, self.idDialog)
	end -- do

	do -- idOrient_Area
		self.idOrient_Area = g_Classes.ChoGGi_DialogSection:new({
			Id = "idOrient_Area",
			Dock = "top",
		}, self.idDialog)
	end -- do


	self.idEditArea = g_Classes.ChoGGi_DialogSection:new({
		Id = "idEditArea",
		Dock = "bottom",
	}, self.idDialog)

	self.idEditValue = g_Classes.ChoGGi_TextInput:new({
		Id = "idEditValue",
		RolloverText = S[302535920000102--[[Use to change values of selected list item.--]]],
		Hint = S[302535920000103--[[Edit Value--]]],
		OnTextChanged = self.idEditValueOnTextChanged,
		RolloverAnchor = "bottom",
	}, self.idEditArea)

	self:SetInitPos(context.parent)

end

function ChoGGi_3DManipulatorDlg:XXXXXXXXXX()
	self = GetRootDialog(self)
end
