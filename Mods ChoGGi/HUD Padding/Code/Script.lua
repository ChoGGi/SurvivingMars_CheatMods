-- See LICENSE for terms

local box = box
local tonumber = tonumber

-- input as text "0,0,0,0"
--~ local StrToBox = ChoGGi.ComFuncs.StrToBox
local function StrToBox(text)
	if not text then
		return box(0,0,0,0)
	end

	-- remove any spaces/newlines etc
	text = text:gsub("[%s%c]", "")
	-- grab the values
	local values = {}
	local c = 0

	-- loop through all the numbers
	for d in text:gmatch("%d+") do
		c = c + 1
		values[c] = tonumber(d)
	end

	return box(values[1], values[2], values[3], values[4])
end


local mod_EnableMod
local mod_Infobar
local mod_OnScreenNotificationsDlg
local mod_BottomBar

local function ChangePadding()
	local Dialogs = Dialogs
	if not mod_EnableMod or not Dialogs and Dialogs.HUD then
		return
	end

	-- slight delay
	CreateRealTimeThread(function()
		if Dialogs.Infobar then
			Dialogs.Infobar:SetPadding(mod_Infobar)
		end
		if Dialogs.OnScreenNotificationsDlg then
			Dialogs.OnScreenNotificationsDlg:SetPadding(mod_OnScreenNotificationsDlg)
		end

		-- bottom area
		local mod_BottomBar = box(0,0,0,50)
		if Dialogs.PinsDlg then
			Dialogs.PinsDlg:SetPadding(mod_BottomBar)
		end
		if Dialogs.HUD then
			Dialogs.HUD.idBottom:SetPadding(mod_BottomBar)
			if g_AccessibleDlc.picard then
				Dialogs.HUD.idMapSwitch:SetPadding(mod_BottomBar)
			end
		end
	end)
end
OnMsg.InGameInterfaceCreated = ChangePadding
OnMsg.UIModeChange = ChangePadding

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_Infobar = StrToBox(CurrentModOptions:GetProperty("Infobar"))
	mod_OnScreenNotificationsDlg = StrToBox(CurrentModOptions:GetProperty("OnScreenNotificationsDlg"))
	mod_BottomBar = StrToBox(CurrentModOptions:GetProperty("BottomBar"))

	-- Make sure we're in-game
	if not UIColony then
		return
	end

	ChangePadding()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
