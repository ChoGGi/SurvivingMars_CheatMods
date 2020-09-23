-- See LICENSE for terms

local mod_RotateSpeed
local mod_UpDownSpeed
local mod_MaxZoom
local mod_ScrollBorder
local mod_MaxHeight
local mod_MoveSpeed

local function UpdateCamera()
	local params = cameraRTS.GetProperties(1)

	params.RotateSpeed = mod_RotateSpeed
	params.UpDownSpeed = mod_UpDownSpeed
	params.MaxZoom = mod_MaxZoom
	params.ScrollBorder = mod_ScrollBorder
	params.MaxHeight = mod_MaxHeight
	params.mod_MoveSpeedNormal = mod_MoveSpeed
	params.mod_MoveSpeedFast = mod_MoveSpeed * 2

	cameraRTS.SetProperties(1, params)
end

local options

-- fired when settings are changed/init
local function ModOptions()
	options = CurrentModOptions

	mod_RotateSpeed = options:GetProperty("RotateSpeed")
	mod_UpDownSpeed = options:GetProperty("UpDownSpeed")
	mod_MaxZoom = options:GetProperty("MaxZoom") * 1000
	mod_ScrollBorder = options:GetProperty("ScrollBorder")
	mod_MaxHeight = options:GetProperty("MaxHeight")
	mod_MoveSpeed = options:GetProperty("MoveSpeed")

	-- make sure we're ingame
	if not UICity then
		return
	end
	UpdateCamera()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

OnMsg.CityStart = UpdateCamera
OnMsg.LoadGame = UpdateCamera
