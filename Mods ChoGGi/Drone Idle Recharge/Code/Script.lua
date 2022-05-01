-- See LICENSE for terms

local mod_RechargeLimit = 0

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_RechargeLimit = CurrentModOptions:GetProperty("RechargeLimit")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_Drone_Idle = Drone.Idle
function Drone:Idle(...)
	-- call orig first
	local ret = ChoOrig_Drone_Idle(self, ...)
	-- needs 0.0 or it'll always be 0
	local battery_percent = ((self.battery + 0.0) / (self.battery_max + 0.0)) * 100
	if (battery_percent or 0) <= (mod_RechargeLimit or 0) then
		-- same cmd as manually sending drone
		self:SetCommand("EmergencyPower")
	end
	-- there's no return, but a mod might want to add one
	return ret
end
