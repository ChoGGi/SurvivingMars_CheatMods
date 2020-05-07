-- See LICENSE for terms

local mod_PinDrone
local mod_PauseGame
local mod_UnpinSelectedDrone
local options

-- fired when settings are changed/init
local function ModOptions()
	options = CurrentModOptions

	mod_PinDrone = options:GetProperty("PinDrone")
	mod_UnpinSelectedDrone = options:GetProperty("UnpinSelectedDrone")
	mod_PauseGame = options:GetProperty("PauseGame")
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

local table_find = table.find

local orig_Drone_GoHome = Drone.GoHome
function Drone:GoHome(...)
	if mod_PinDrone and not table_find(g_PinnedObjs, self) then
		self:TogglePin()
	end
	if mod_PauseGame then
		UICity:SetGameSpeed(0)
	end

	return orig_Drone_GoHome(self, ...)
end

local orig_Drone_OnSelected = Drone.OnSelected
function Drone:OnSelected(...)
	if mod_UnpinSelectedDrone and table_find(g_PinnedObjs, self) then
		self:TogglePin()
	end

	return orig_Drone_OnSelected(self, ...)
end
