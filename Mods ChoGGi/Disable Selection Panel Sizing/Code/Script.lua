-- See LICENSE for terms

local WaitMsg = WaitMsg
local GetSafeMargins = GetSafeMargins
local GetInGameInterface = GetInGameInterface
local box = box

local mod_Enabled
local mod_ScrollSelection

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_Enabled = CurrentModOptions:GetProperty("Enabled")
	mod_ScrollSelection = CurrentModOptions:GetProperty("ScrollSelection")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_XSizeConstrained_WindowUpdateMeasure = XSizeConstrainedWindow.UpdateMeasure
local ChoOrig_XWindow_UpdateMeasure = XWindow.UpdateMeasure

function XSizeConstrainedWindow:UpdateMeasure(...)
	if mod_Enabled then
		return ChoOrig_XWindow_UpdateMeasure(self, ...)
	else
		return ChoOrig_XSizeConstrained_WindowUpdateMeasure(self, ...)
	end
end


-- ClassesBuilt is so it overrides the func I added to ECM
function OnMsg.ClassesBuilt()
	local margin_offset = 0
	local margin_top = 32

	function InfopanelDlg:RecalculateMargins()
		local margins = GetSafeMargins()
		local bottom_margin = 0
		local pins = Dialogs.PinsDlg
		if pins then
			local igi = GetInGameInterface()
			bottom_margin = igi.box:maxy() - pins.box:miny() - margins:maxy()
		end
		-- I don't see the reason it needs to be 58
--~ 		margins = box(margins:minx(), margins:miny() + 58, margins:maxx(), margins:maxy() + bottom_margin)
		margins = box(margins:minx(), margins:miny() + margin_top, margins:maxx(), margins:maxy() + bottom_margin + margin_offset)
		self:SetMargins(margins)
	end

end

-- the below is for adding scrollbars to certain selection panels
local infopanel_list = {
	ipBuilding = true,
	ipColonist = true,
	ipDrone = true,
	ipRover = true,
}

local zerobox = box(0, 0, 0, 0)

local ChoOrig_Infopanel_DlgOpen = InfopanelDlg.Open
function InfopanelDlg:Open(...)
	CreateRealTimeThread(function()
		repeat
			WaitMsg("OnRender")
		until self.visible

		-- give me the scroll. goddamn it blinky
		if mod_ScrollSelection and infopanel_list[self.XTemplate] then
			self.idActionButtons.parent:SetZOrder(2)

			local g_Classes = g_Classes
			local dlg = self[1]

			-- attach our scroll area to the XSizeConstrainedWindow
			self.idChoGGi_ScrollArea = g_Classes.XWindow:new({
				Id = "idChoGGi_ScrollArea",
			}, dlg)

			self.idChoGGi_ScrollV = g_Classes.XSleekScroll:new({
				Id = "idChoGGi_ScrollV",
				Target = "idChoGGi_ScrollBox",
				Dock = "left",
				MinThumbSize = 30,
				Background = 0,
				AutoHide = true,
			}, self.idChoGGi_ScrollArea)

			self.idChoGGi_Scrollbar_thumb = self.idChoGGi_ScrollV.idThumb

			-- [LUA ERROR] attempt to index a boolean value (local 'desktop')
			self.idChoGGi_ScrollV.idThumb.desktop = terminal.desktop
			self.idChoGGi_ScrollV.idThumb:SetVisible(false)

			self.idChoGGi_ScrollBox = g_Classes.XScrollArea:new({
				Id = "idChoGGi_ScrollBox",
				VScroll = "idChoGGi_ScrollV",
				LayoutMethod = "VList",
			}, self.idChoGGi_ScrollArea)

			if self.idContent then
				-- move content list to scrollarea
				self.idContent:SetParent(self.idChoGGi_ScrollBox)
				-- add ref back
				self.idContent = self.idChoGGi_ScrollBox.idContent

				self:RecalculateMargins()

				-- add height limit for infopanel
				local height = terminal.desktop.box:sizey()
				local HUD = Dialogs.HUD
				local bb = HUD.idMapSwitch
				local offset = HUD.idRight.box:sizey() + (bb and bb.box:sizey() or 0)
				local added_margin = bb and 48 or 101
				self.idChoGGi_ScrollArea:SetMaxHeight(height - offset + added_margin)
				self:SetMargins(zerobox)
			end
		--~ ex(self)

		end
	end)

	return ChoOrig_Infopanel_DlgOpen(self, ...)
end
