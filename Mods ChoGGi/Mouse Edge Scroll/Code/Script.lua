-- See LICENSE for terms

local mod_EnableMod
local mod_ScrollBorderSize

local default_CameraScrollBorder = const.DefaultCameraRTS.ScrollBorder
local border_table = {}

local function SetScroll()
	if mod_EnableMod then
		border_table.ScrollBorder = mod_ScrollBorderSize
	else
		border_table.ScrollBorder = default_CameraScrollBorder
	end

	cameraRTS.SetProperties(1, border_table)
end

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_ScrollBorderSize = CurrentModOptions:GetProperty("ScrollBorderSize")

	-- make sure we're in-game
	if not UICity then
		return
	end
	SetScroll()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	-- I'm sure it wouldn't be that hard to only call this msg for the mod being applied, but...
	if id == CurrentModId then
		ModOptions()
	end
end

OnMsg.CityStart = SetScroll
OnMsg.LoadGame = SetScroll
