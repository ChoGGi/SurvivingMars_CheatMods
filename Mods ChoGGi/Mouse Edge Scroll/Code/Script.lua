-- See LICENSE for terms

local mod_EnableMod
local mod_ScrollBorderSize

local function SetScroll()
	-- make sure we're in-game
	if not UICity then
		return
	end

	if mod_EnableMod then
		cameraRTS.SetProperties(1, {ScrollBorder = mod_ScrollBorderSize})
	else
		cameraRTS.SetProperties(1, {ScrollBorder = const.DefaultCameraRTS.ScrollBorder})
	end
end
OnMsg.CityStart = SetScroll
OnMsg.LoadGame = SetScroll
OnMsg.ChangeMapDone = SetScroll

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_ScrollBorderSize = CurrentModOptions:GetProperty("ScrollBorderSize")

	SetScroll()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
