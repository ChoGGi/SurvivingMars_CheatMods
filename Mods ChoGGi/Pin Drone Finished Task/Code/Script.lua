-- See LICENSE for terms

local mod_PinDrone
local mod_PauseGame
local mod_UnpinSelectedDrone
local mod_PinDroneIdle
local mod_PauseGameIdle
local options

-- fired when settings are changed/init
local function ModOptions()
	options = CurrentModOptions

	mod_PinDrone = options:GetProperty("PinDrone")
	mod_UnpinSelectedDrone = options:GetProperty("UnpinSelectedDrone")
	mod_PauseGame = options:GetProperty("PauseGame")
	mod_PauseGameIdle = options:GetProperty("PauseGameIdle")
	mod_PinDroneIdle = options:GetProperty("PinDroneIdle")
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

local table = table

local orig_Drone_GoHome = Drone.GoHome
function Drone:GoHome(...)
	if mod_PinDrone and not table.find(g_PinnedObjs, self) then
		self:TogglePin()
	end
	if mod_PauseGame then
		UICity:SetGameSpeed(0)
		UISpeedState = "pause"
	end

	return orig_Drone_GoHome(self, ...)
end

local orig_Drone_Idle = Drone.Idle
function Drone:Idle(...)
	if mod_PinDroneIdle and not table.find(g_PinnedObjs, self) then
		self:TogglePin()
	end
	if mod_PauseGameIdle then
		UICity:SetGameSpeed(0)
		UISpeedState = "pause"
	end

	return orig_Drone_Idle(self, ...)
end

local orig_Drone_OnSelected = Drone.OnSelected
function Drone:OnSelected(...)
	if mod_UnpinSelectedDrone and table.find(g_PinnedObjs, self) then
		self:TogglePin()
	end

	return orig_Drone_OnSelected(self, ...)
end
