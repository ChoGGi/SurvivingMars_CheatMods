-- See LICENSE for terms

local tonumber = tonumber
local floatfloor = floatfloor
local GetDate = GetDate
local T = T
local clock = {302535920011360, "<hour>:<min>"}

local IsValidXWin = ChoGGi.ComFuncs.IsValidXWin
local Infobar

local mod_ShowClock
local mod_TimeFormat
local mod_TextStyle
local mod_Background
local mod_TextOpacity
--~ local mod_PosChoices = "Infobar"

local function SetClock()
	local strproc = GetDate():gmatch("%d+")
--~ 	print(strproc())
--~ 	print(strproc())
--~ 	print(strproc())

--~ 	local day = strproc()
	-- to the ether with you
	strproc()

	clock.hour = strproc()
	clock.min = strproc()
--~ 	local sec = strproc()

	if not mod_TimeFormat and tonumber(clock.hour) > 12 then
		-- why 13-12 somehow equals 1.0 I haven't a clue...
		clock.hour = floatfloor(clock.hour - 12)
	end

	if not IsValidXWin(Infobar) then
		Infobar = Dialogs.Infobar
	end

	if Infobar and Infobar.idRealTimeClockArea then
		Infobar.idRealTimeClock:SetText(T(clock))
	end
end


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
	"EncyclopediaArticleTitle",
}

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions
	mod_ShowClock = options:GetProperty("ShowClock")
	mod_TimeFormat = options:GetProperty("TimeFormat")
	mod_TextStyle = options:GetProperty("TextStyle")
	mod_Background = options:GetProperty("Background")
	mod_TextOpacity = options:GetProperty("TextOpacity")
--~ 	mod_PosChoices = options:GetProperty("PosChoices")

	if mod_ShowClock then
		if not IsValidXWin(Infobar) then
			Infobar = Dialogs.Infobar
		end
		if Infobar then
			-- add clock
			AddTime(Infobar)
			-- text colour
			Infobar.idRealTimeClock:SetTextStyle(style_lookup[mod_TextStyle])
			-- blue
			Infobar.idRealTimeClock:SetBackground(mod_Background and -1825019475 or 0)
			-- see through
			Infobar.idRealTimeClockArea:SetTransparency(mod_TextOpacity)

			SetClock()
		end
	else
		RemoveTime()
	end

end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

function OnMsg.NewHour()
	if not mod_ShowClock then
		return
	end

	SetClock()
end

AddTime = function(dlg)
--~ 	WaitMsg("OnRender")

	-- skip if already added
	if not dlg or dlg.idRealTimeClockArea then
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
	area:SetTransparency(mod_TextOpacity)

	-- attach to dialog
	area:SetParent(dlg)

	SetClock()
end

RemoveTime = function()
	if not IsValidXWin(Infobar) then
		Infobar = Dialogs.Infobar
	end

	if Infobar and Infobar.idRealTimeClockArea then
		Infobar.idRealTimeClockArea:Close()
	end
end

local ChoOrig_OpenDialog = OpenDialog
function OpenDialog(dlg_str, ...)
	local dlg = ChoOrig_OpenDialog(dlg_str, ...)
	if mod_ShowClock and dlg_str == "Infobar" then
		CreateRealTimeThread(AddTime, dlg)
	end
	return dlg
end
