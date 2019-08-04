-- See LICENSE for terms

local options
local mod_Enabled
local mod_ScrollSelection

-- fired when settings are changed/init
local function ModOptions()
	mod_Enabled = options.Enabled
	mod_ScrollSelection = options.ScrollSelection
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_DisableSelectionPanelSizing" then
		return
	end

	ModOptions()
end

local XSizeConstrained_WindowUpdateMeasure = XSizeConstrainedWindow.UpdateMeasure
local XWindow_UpdateMeasure = XWindow.UpdateMeasure

function XSizeConstrainedWindow:UpdateMeasure(...)
	if mod_Enabled then
		return XWindow_UpdateMeasure(self, ...)
	else
		return XSizeConstrained_WindowUpdateMeasure(self, ...)
	end
end

local margin_offset = 0
local margin_top = 32

local GetSafeMargins = GetSafeMargins
local GetInGameInterface = GetInGameInterface
local box = box

-- the ClassesBuilt is so it overrides the one I added to ECM
function OnMsg.ClassesBuilt()
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

-- get around to finishing this (scrollable selection panel)
local function AddScrollDialogXTemplates(obj)
	local g_Classes = g_Classes

	local dlg = obj[1]

	-- attach our scroll area to the XSizeConstrainedWindow
	obj.idChoGGi_ScrollArea = g_Classes.XWindow:new({
		Id = "idChoGGi_ScrollArea",
	}, dlg)

	obj.idChoGGi_ScrollV = g_Classes.XSleekScroll:new({
		Id = "idChoGGi_ScrollV",
		Target = "idChoGGi_ScrollBox",
		Dock = "left",
		MinThumbSize = 30,
		AutoHide = true,
		Background = 0,
	}, obj.idChoGGi_ScrollArea)

	obj.idChoGGi_ScrollBox = g_Classes.XScrollArea:new({
		Id = "idChoGGi_ScrollBox",
		VScroll = "idChoGGi_ScrollV",
		LayoutMethod = "VList",
	}, obj.idChoGGi_ScrollArea)

	-- move content list to scrollarea
	obj.idContent:SetParent(obj.idChoGGi_ScrollBox)

	-- height of rightside hud button area
	local hud = Dialogs.HUD.idRight.box:sizey()

	-- offset from the top
	local y_offset = obj.Margins:miny()

	margin_offset = hud + y_offset + margin_top
	obj:RecalculateMargins()

--~ ex(obj)
end

local Sleep = Sleep
local Infopanel_DlgOpen = InfopanelDlg.Open
function InfopanelDlg:Open(...)
	CreateRealTimeThread(function()
		repeat
			Sleep(10)
		until self.visible

		-- give me the scroll. goddamn it blinky
		if mod_ScrollSelection and infopanel_list[self.XTemplate] then
			self.idActionButtons.parent:SetZOrder(2)
			AddScrollDialogXTemplates(self)
		end
	end)

	return Infopanel_DlgOpen(self, ...)
end
