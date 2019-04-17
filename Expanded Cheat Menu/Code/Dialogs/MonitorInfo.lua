-- See LICENSE for terms

-- shows various information (with auto-refresh)

if not ChoGGi.testing then
	return
end

local TableConcat = ChoGGi.ComFuncs.TableConcat
local Translate = ChoGGi.ComFuncs.Translate
local Strings = ChoGGi.Strings

local pairs,type,tostring = pairs,type,tostring

-- 1 above console log, 1000 above examine
local zorder = 2001001

DefineClass.ChoGGi_MonitorInfoDlg = {
	__parents = {"FrameWindow"},
	ZOrder = zorder,
	--defaults
	refreshing = false,
	refreshing_thread = false,
	obj = false,
	values = false,
	tables = false,
	delay = 1000,
	MinSize = point(50, 50),
	translate = false,
}

function ChoGGi_MonitorInfoDlg:Init()



		dlg.idCaption:SetText(list.title or "")
		self.obj = context.obj
		self.values = context.values
		self.tables = context.tables




	local ChoGGi = ChoGGi
	local g_Classes = g_Classes
	local point = point

	--element pos is based on
	self:SetPos(point(0,0))

	local dialog_width = 400
	local dialog_height = 600
	self:SetSize(dialog_width, dialog_height)
	self:SetMovable(true)

	local border = 4
	local element_y
	local element_x
	dialog_width = dialog_width - border * 2
	local dialog_left = border

	ChoGGi.ComFuncs.DialogAddCloseX(self)
	ChoGGi.ComFuncs.DialogAddCaption(self,{
		prefix = string.format("%s : ",Strings[302535920000555--[[Monitor Info--]]]),
		pos = point(25, border),
		size = point(dialog_width-self.idCloseX:GetSize():x(), 22)
	})

	element_y = border / 2 + self.idCaption:GetPos():y() + self.idCaption:GetSize():y()

	local title = Strings[302535920000084--[[Auto-Refresh--]]]
	self.idAutoRefresh = g_Classes.CheckButton:new(self)
	self.idAutoRefresh:SetPos(point(dialog_left, element_y))
--~ 		self.idAutoRefresh:SetSize(title)
	self.idAutoRefresh:SetImage("CommonAssets/UI/Controls/Button/CheckButton.tga")
	self.idAutoRefresh:SetText(title)
	self.idAutoRefresh:SetHint(Strings[302535920000085--[["Auto-refresh list every ""Amount""."--]]])
	self.idAutoRefresh:SetButtonSize(point(16, 16))
	--add check for auto-refresh
	function self.idAutoRefresh.button.OnButtonPressed()
		local Sleep = Sleep
		self.refreshing = self.idAutoRefresh:GetState()
		self.refreshing_thread = CreateRealTimeThread(function()
			while self.refreshing do
				self:UpdateText()
				Sleep(self.delay)
				--check for missing table objects
				if self.obj.title:find("Grids") then
					self.tables = ChoGGi.ComFuncs.RemoveMissingTableObjects(self.tables,"elements")
					--break if there's none left
					if #self.tables == 0 then
						--fire once more to show the nothing here text
						self:UpdateText()
						break
					end
				end
			end
		end)
	end

	element_x = border * 2 + self.idAutoRefresh:GetPos():x() + self.idAutoRefresh:GetSize():x()

	title = Translate(1000220--[[Refresh--]])
	self.idRefresh = g_Classes.Button:new(self)
	self.idRefresh:SetPos(point(element_x, element_y))
	self.idRefresh:SetSize(ChoGGi.ComFuncs.RetButtonTextSize(title))
	self.idRefresh:SetText(title)
	self.idRefresh:SetHint(Strings[302535920000086--[[Manually refresh the list.--]]])
	function self.idRefresh.OnButtonPressed()
		if ChoGGi.testing then
			OpenExamine(self.obj)
		end
		self:UpdateText()
	end

	element_x = border * 2 + self.idRefresh:GetPos():x() + self.idRefresh:GetSize():x()

	self.idTimerAmount = g_Classes.SingleLineEdit:new(self)
	self.idTimerAmount:SetPos(point(element_x, element_y))
	self.idTimerAmount:SetSize(dialog_width - element_x, 24)
	self.idTimerAmount:SetHSizing("Resize")
	self.idTimerAmount:SetVSizing("AnchorToTop")
	self.idTimerAmount:SetFontStyle("Editor14Bold")
	self.idTimerAmount:SetText("1000")
	self.idTimerAmount:SetHint(Strings[302535920000087--[[Refresh delay in ms--]]])
	self.idTimerAmount:SetTextVAlign("center")
	self.idTimerAmount:SetMaxLen(-1)
	function self.idTimerAmount.OnValueChanged()
		local delay,delay_type = ChoGGi.ComFuncs.RetProperType(self.idTimerAmount:GetText())
		if delay_type == "number" and delay > 0 then
			self.delay = delay
		end
	end

	element_y = border + self.idRefresh:GetPos():y() + self.idRefresh:GetSize():y()

	self.idText = g_Classes.StaticText:new(self)
	self.idText:SetPos(point(dialog_left, element_y))
	self.idText:SetSize(dialog_width, dialog_height-element_y - border)
	self.idText:SetHSizing("Resize")
	self.idText:SetVSizing("Resize")
	self.idText:SetFontStyle("Editor12Bold")
	self.idText:SetHint(Strings[302535920000088--[[Double right-click to open list of objects.--]]])
	self.idText:SetBackgroundColor(RGBA(0, 0, 0, 16))
	self.idText:SetScrollBar(true)
	self.idText:SetScrollAutohide(true)
	function self.idText.OnRButtonDoubleClick()
		OpenExamine(self.tables,true)
	end

	--so elements move when dialog re-sizes
	self:InitChildrenSizing()

	self:SetPos(point(100, 100))
	self:SetSize(400, 600)
end

local texttable
local text
local monitort
local name
function ChoGGi_MonitorInfoDlg:UpdateText()
	--check for scroll pos
	local scrollpos = self.idText.scroll:GetPosition()
	--create prop list for list
	texttable = {[1]=""}
	if #self.tables > 0 then
		for i = 1, #self.tables do
			monitort = self.tables[i]
			texttable[#texttable+1] = "----- "
			texttable[#texttable+1] = i
			texttable[#texttable+1] = ". "
			texttable[#texttable+1] = monitort.class
			texttable[#texttable+1] = ":\n"
			if self.obj.listtype == "all" then
				print("all")
				ex(self.tables[i])
				ex(self.values)
				for SecName,SecValue in pairs(self.tables[i]) do
				--goes through all tables

					--goes through each table
					texttable[#texttable+1] = SecName
					texttable[#texttable+1] = "\n"
					for Key,Value in pairs(SecValue) do

						if self.values[Key] then
							for j = 1, #self.values do
								local v = self.values[j]
								--name = monitort[SecName.name]
								texttable[#texttable+1] = "\t"
								texttable[#texttable+1] = v.name
								self:BuildValue(Value,0)
							end
						elseif Key == "field" then
							texttable[#texttable+1] = "\t"
							texttable[#texttable+1] = Value
							texttable[#texttable+1] = ": "
						end

					end

				end
			else
				for _,Value in pairs(self.values) do
					name = monitort[Value.name]
					if name or type(name) == "boolean" then
						texttable[#texttable+1] = Value.name
						self:BuildValue(name,Value.kind)
					end
				end
			end --for
		end --if
	else
		texttable[#texttable+1] = Strings[302535920000089--[[Nothing left--]]]
	end --if #self.tables > 0

	texttable[#texttable+1] = "\n"

	text = TableConcat(texttable)

	if text == "" then
		self.idText:SetText(Strings[302535920000090--[[Error opening: %s--]]]:format(RetName(self.obj)))
		return
	end
	--populate it
	self.idText:SetText(text)
	--and scroll to saved pos
	self.idText.scroll:SetPosition(scrollpos)
end

function ChoGGi_MonitorInfoDlg:BuildValue(name,kind)
	--0 = value
	if kind == 0 then
		texttable[#texttable+1] = ": "
		texttable[#texttable+1] = tostring(name)
		texttable[#texttable+1] = "\n"
	--1=table
	elseif kind == 1 then
		texttable[#texttable+1] = ": "
		texttable[#texttable+1] = #name
		texttable[#texttable+1] = "\n"
	--2=list table values
	elseif kind == 2 then
		texttable[#texttable+1] = ":\n"
		for t_name,t_value in pairs(name) do
			texttable[#texttable+1] = "\t"
			texttable[#texttable+1] = t_name
			texttable[#texttable+1] = ": "
			texttable[#texttable+1] = tostring(t_value)
			texttable[#texttable+1] = "\n"
		end
		texttable[#texttable+1] = "\n"
	end
	--just the three for now
end


--esc closes
function ChoGGi_MonitorInfoDlg:OnKbdKeyDown(_, vk)
	if vk == const.vkEsc then
		self.idCloseX:Press()
		return "break"
	end
	return "continue"
end

function ChoGGi_MonitorInfoDlg:Done()
	DeleteThread(self.refreshing_thread)
end
