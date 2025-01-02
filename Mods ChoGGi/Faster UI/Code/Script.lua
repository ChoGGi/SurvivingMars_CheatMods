-- See LICENSE for terms

local mod_PinsShow
local mod_PinsHide
local mod_BuildMenu
local mod_OverviewMode
local mod_FadeToBlack
local mod_LongerDelay

-- Faster pins 1/2
local ChoOrig_PinsDlg_SetVisible = PinsDlg.SetVisible
function PinsDlg:SetVisible(visible, instant, ...)
	if mod_PinsShow then
		-- closing menu
		instant = true
	end
	return ChoOrig_PinsDlg_SetVisible(self, visible, instant, ...)
end

-- Open build menu
local ChoOrig_XBuildMenu_EaseInButton = XBuildMenu.EaseInButton
function XBuildMenu:EaseInButton(button, start_time, ...)
	if mod_BuildMenu then
		start_time = mod_LongerDelay
	end
	return ChoOrig_XBuildMenu_EaseInButton(self, button, start_time, ...)
end

-- Switch to map overview
local ChoOrig_OverviewModeDialog_GetCameraTransitionTime = OverviewModeDialog.GetCameraTransitionTime
function OverviewModeDialog.GetCameraTransitionTime(...)
	if UICity and mod_OverviewMode then
		-- 0 makes it bounce around
		return 1
	end
	return ChoOrig_OverviewModeDialog_GetCameraTransitionTime(...)
end

function OnMsg.ClassesPostprocess()
	-- Fade to black for map switch buttons
	local template = XTemplates.FadeToBlackDlg[1]
	template.FadeInTime = 1
	template.FadeOutTime = 1

	-- Faster pins 2/2
	local ChoOrig_XBlinkingButtonWithRMB_AddInterpolation = XBlinkingButtonWithRMB.AddInterpolation
	function XBlinkingButtonWithRMB:AddInterpolation(int, ...)
		if mod_PinsHide and int then
			-- see if + helps?
			int.start = mod_LongerDelay+1
			int.duration = mod_LongerDelay
			int.easing = mod_LongerDelay+2
		end

		return ChoOrig_XBlinkingButtonWithRMB_AddInterpolation(self, int, ...)
	end
end

-- Update fade time after game is loaded
local function UpdateFade()
	local time = 1
	if not mod_FadeToBlack then
		-- Default time
		-- last checked 1010999
		-- Source\Lua\XTemplates\FadeToBlackDlg.lua
		time = 450
	end
	--
	local template = XTemplates.FadeToBlackDlg[1]
	template.FadeInTime = time
	template.FadeOutTime = time

	-- Black bar fade (changes some shadow details? when fully transitioned)
	if mod_OverviewMode then
		OverviewMapCurtains.FadeInTime = 0
		OverviewMapCurtains.FadeOutTime = 0
	else
		OverviewMapCurtains.FadeInTime = const.InterfaceAnimDuration
		OverviewMapCurtains.FadeOutTime = const.InterfaceAnimDuration
	end

end

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_PinsShow = CurrentModOptions:GetProperty("Pins1")
	mod_PinsHide = CurrentModOptions:GetProperty("Pins2")
	mod_BuildMenu = CurrentModOptions:GetProperty("BuildMenu")
	mod_OverviewMode = CurrentModOptions:GetProperty("OverviewMode")
	mod_FadeToBlack = CurrentModOptions:GetProperty("FadeToBlack")
	mod_LongerDelay = CurrentModOptions:GetProperty("LongerDelay")

	UpdateFade()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
