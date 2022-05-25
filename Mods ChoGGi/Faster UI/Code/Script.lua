-- See LICENSE for terms

local pcall = pcall

local mod_EnableMod

-- Fake funcs
local ChoOrig_GetPreciseTicks = GetPreciseTicks
local function ChoFake_GetPreciseTicks()
	return 0
end
-- Faster pins
local ChoOrig_PinsDlg_SetVisible = PinsDlg.SetVisible
function PinsDlg:SetVisible(visible, instant, ...)
	if mod_EnableMod then
		-- opening menu
		GetPreciseTicks = ChoFake_GetPreciseTicks
		-- closing menu
		instant = true
	end
	pcall(ChoOrig_PinsDlg_SetVisible, self, visible, instant, ...)
	GetPreciseTicks = ChoOrig_GetPreciseTicks
end
-- Open build menu
local ChoOrig_XBuildMenu_EaseInButton = XBuildMenu.EaseInButton
function XBuildMenu:EaseInButton(button, start_time, ...)
	if mod_EnableMod then
		start_time = 0
	end
	return ChoOrig_XBuildMenu_EaseInButton(self, button, start_time, ...)
end
-- Switch to map overview
local ChoOrig_OverviewModeDialog_GetCameraTransitionTime = OverviewModeDialog.GetCameraTransitionTime
function OverviewModeDialog.GetCameraTransitionTime(...)
	if mod_EnableMod then
		return 0
	end
	return ChoOrig_OverviewModeDialog_GetCameraTransitionTime(...)
end

-- Fade to black for map switch buttons

-- pp is too soon for mod options, so we default to "enabled" for it
function OnMsg.ClassesPostprocess()
	local template = XTemplates.FadeToBlackDlg[1]
	template.FadeInTime = 0
	template.FadeOutTime = 0
end

local function UpdateFade(time)
	if mod_EnableMod then
		time = 0
	else
		-- default time (last checked picard rev 1010999)
		time = 450
	end
	--
	local template = XTemplates.FadeToBlackDlg[1]
	template.FadeInTime = time
	template.FadeOutTime = time
end

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	UpdateFade()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
