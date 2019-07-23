-- See LICENSE for terms

local options
local mod_ShowClock
local mod_TimeFormat
local mod_TextStyle
local mod_Background
--~ local mod_PosChoices = "Infobar"

local AddTime
local RemoveTime

local style_lookup = {
	"LandingPosNameAlt",
	"BugReportScreenshot",
	"CategoryTitle",
	"ConsoleLog",
	"DomeName",
	"GizmoText",
	"InfopanelResourceNoAccept",
	"ListItem1",
	"ModsUIItemStatusWarningBrawseConsole",
	"LandingPosNameAlt",
}

-- fired when settings are changed/init
local function ModOptions()
	mod_ShowClock = options.ShowClock
	mod_TimeFormat = options.TimeFormat
	mod_TextStyle = options.TextStyle
	mod_Background = options.Background
--~ 	mod_PosChoices = options.PosChoices

	local info = Dialogs.Infobar
	if mod_ShowClock then
		-- add clock
		AddTime(info)
		-- text colour
		info.idRealTimeClock:SetTextStyle(style_lookup[mod_TextStyle])
		-- blue
		info.idRealTimeClock:SetBackground(mod_Background and -1825019475 or 0)
	else
		RemoveTime()
	end
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_RealTimeClock" then
		return
	end

	ModOptions()
end

AddTime = function(dlg)
	if CurrentThread() then
		WaitMsg("OnRender")
	end

	-- skip if already added
	if dlg.idRealTimeClockArea then
		return
	end

	local area = XWindow:new({
		Id = "idRealTimeClockArea",
		Margins = box(0, 4, 8, 0),
		VAlign = "top",
		Dock = "right",
	}, dlg)

	XText:new({
		Id = "idRealTimeClock",
		RolloverTemplate = "Rollover",
		RolloverTitle = T(3452, "Time of day"),
		RolloverText = T(302535920011358, "Real Time Clock"),
		TextStyle = style_lookup[mod_TextStyle],
		Background = mod_Background and -1825019475 or 0,
	}, area)

	-- attach to dialog
	area:SetParent(dlg)
end

local floatfloor = floatfloor
local GetDate = GetDate
local dlgs
local clock = {302535920011360, "<hour>:<min>"}
function OnMsg.NewHour()
	if not mod_ShowClock then
		return
	end

	if not dlgs then
		dlgs = Dialogs
	end

	local strproc = GetDate():gmatch("%d+")

--~ 	local day = strproc()
	strproc()

	clock.hour = strproc()
	clock.min = strproc()

	if not mod_TimeFormat then
		-- why 13-12 somehow equals 1.0 I haven't a clue...
		clock.hour = floatfloor(clock.hour - 12)
	end

	dlgs.Infobar.idRealTimeClock:SetText(T(clock))
end

RemoveTime = function()
	if not dlgs then
		dlgs = Dialogs
	end

	if dlgs.Infobar.idRealTimeClockArea then
		dlgs.Infobar.idRealTimeClockArea:Close()
	end
end

local orig_OpenDialog = OpenDialog
function OpenDialog(dlg_str, ...)
	local dlg = orig_OpenDialog(dlg_str, ...)
	if mod_ShowClock then
--~ 		if dlg_str == "OnScreenNotificationsDlg" and mod_PosChoices == "Notifications"
--~ 			or dlg_str == "Infobar" and mod_PosChoices == "Infobar"
		if dlg_str == "Infobar" then
			CreateRealTimeThread(AddTime, dlg)
		end
	end
	return dlg
end
