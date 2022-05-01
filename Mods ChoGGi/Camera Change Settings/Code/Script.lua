-- See LICENSE for terms

local mod_RotateSpeed
local mod_UpDownSpeed
local mod_MaxZoom
local mod_ScrollBorder
local mod_MaxHeight
local mod_MoveSpeed

local function UpdateCamera()
	-- make sure we're in-game
	if not UICity then
		return
	end

	local properties = cameraRTS.GetProperties(1)

	properties.RotateSpeed = mod_RotateSpeed
	properties.UpDownSpeed = mod_UpDownSpeed
	properties.MaxZoom = mod_MaxZoom
	properties.ScrollBorder = mod_ScrollBorder
	properties.MaxHeight = mod_MaxHeight
	properties.MoveSpeedNormal = mod_MoveSpeed
	properties.MoveSpeedFast = mod_MoveSpeed * 2

	cameraRTS.SetProperties(1, properties)
end
OnMsg.CityStart = UpdateCamera
OnMsg.LoadGame = UpdateCamera
OnMsg.ChangeMapDone = UpdateCamera

-- fired when settings are changed/init
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions

	mod_RotateSpeed = options:GetProperty("RotateSpeed")
	mod_UpDownSpeed = options:GetProperty("UpDownSpeed")
	mod_MaxZoom = options:GetProperty("MaxZoom") * 1000
	mod_ScrollBorder = options:GetProperty("ScrollBorder")
	mod_MaxHeight = options:GetProperty("MaxHeight")
	mod_MoveSpeed = options:GetProperty("MoveSpeed")

	UpdateCamera()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
