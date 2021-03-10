-- See LICENSE for terms

local mod_RechargeLimit = 0

-- fired when settings are changed/init
local function ModOptions()
	mod_RechargeLimit = CurrentModOptions:GetProperty("RechargeLimit")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local orig_Drone_Idle = Drone.Idle
function Drone:Idle(...)
	-- call orig first
	local ret = orig_Drone_Idle(self, ...)
	-- needs 0.0 or it'll always be 0
	local battery_percent = ((self.battery + 0.0) / (self.battery_max + 0.0)) * 100
	if (battery_percent or 0) <= (mod_RechargeLimit or 0) then
		-- same cmd as manually sending drone
		self:SetCommand("EmergencyPower")
	end
	-- there's no return, but a mod might want to add one
	return ret
end
