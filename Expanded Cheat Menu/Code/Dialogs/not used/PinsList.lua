-- See LICENSE for terms

-- unfinished showing a list of objects

function OnMsg.ClassesGenerate()

	local RetName = PinExpander.ComFuncs.RetName

	DefineClass.PinExpander_PinsListDlg = {
		__parents = {"PinExpander_Window"},
		idPinsListDlg = true,
		obj = false,
		items = false,
		title = false,
		title_image = false,

		prefix = [[Pin Expander]],
		RolloverTemplate = "Rollover",
		dialog_width = 700.0,
		dialog_height = 240.0,
	}

	function PinExpander_PinsListDlg:Init(parent, context)
		self.obj = context.obj
		self.title = getmetatable(self.obj).display_name
		self.title_image = self.obj:GetPinIcon()

		self:AddElements(parent,context)
		self:AddScrollList()

		self.idList:SetLayoutMethod("Grid")

		-- get pos of pins and stick it above
		self.idDialog:SetBox(2880,540,self.dialog_width,self.dialog_height)

		self.items = ChoGGi.ComFuncs.RetAllOfClass(self.obj.class)
		self:BuildList()
	end

	function PinExpander_PinsListDlg:UpdateList(obj)
		self.obj = obj
		self.items = ChoGGi.ComFuncs.RetAllOfClass(obj.class)

		self.title = getmetatable(obj).display_name
		self.idCaption:SetTitle(self)

		self.title_image = obj:GetPinIcon()
		self.idCaptionImage:SetImage(self.title_image)

		self:BuildList()
	end

	function PinExpander_PinsListDlg:BuildList()
		local PinsDlg = Dialogs.PinsDlg
		self.idList:Clear()

		for i = 1, #self.items do
			local item = self.items[i]
			local name = RetName(item)

			local text = string.format("<image %s 2000> %s",PinsDlg:GetPinConditionImage(item),name)
			local listitem = self.idList:CreateTextItem(text)
			-- easier access
			listitem.item = item

			-- add rollover text
			local button = PinsDlg[table.find(PinsDlg,"context",item)]
			if button then
				listitem.RolloverTitle = button.RolloverTitle
				listitem.RolloverText = button.RolloverText
				listitem.RolloverHint = button.RolloverHint
				listitem.RolloverHintGamepad = button.RolloverHintGamepad
			else
				listitem.RolloverTitle = T(8108, "<Title>", item)
				listitem.RolloverText = self:GetPinObjText(item)
				listitem.RolloverHint = self:GetPinObjRollover(item, "pin_rollover_hint")
				listitem.RolloverHintGamepad = self:GetPinObjRollover(item, "pin_rollover_hint_xbox")
			end
		end
	end

	function PinExpander_PinsListDlg:GetPinObjText(obj)
		local text = ""
		local rollover = obj.pin_rollover
		if rollover == "" then
			text = (obj.description ~= "" and T(obj.description, obj)) or obj:GetProperty("description") or ""
		elseif IsT(rollover) or type(rollover) == "string" then
			text = T(rollover, obj)
		end
		return text
	end

	function PinExpander_PinsListDlg:GetPinObjRollover(obj, hint_property)
		local hint = obj:GetProperty(hint_property)
		if not hint then
			return PinnableObject[hint_property]
		elseif hint ~= "" then
			return T(hint, obj)
		else
			return hint
		end
	end

end
