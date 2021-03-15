-- See LICENSE for terms

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local orig_Building_CalcRefundAmount = Building.CalcRefundAmount
function Building:CalcRefundAmount(total_amount, ...)
	if mod_EnableMod then
		-- CalcRefundAmount does a /2, just we just do a *2 and call it a day
		total_amount = total_amount * 2
	end
	return orig_Building_CalcRefundAmount(self, total_amount, ...)
end

local on_demolish_resource_refund = {Metals = 20 * const.ResourceScale, Electronics = 10 * const.ResourceScale}
local orig_BaseRover_GetRefundResources = BaseRover.GetRefundResources
function BaseRover:GetRefundResources(...)
	if mod_EnableMod then
		if not self.on_demolish_resource_refund_ChoGGi then
			self.on_demolish_resource_refund_ChoGGi = self.on_demolish_resource_refund
			self.on_demolish_resource_refund = on_demolish_resource_refund
		end
	else
		if self.on_demolish_resource_refund_ChoGGi then
			self.on_demolish_resource_refund = self.on_demolish_resource_refund_ChoGGi
			self.on_demolish_resource_refund_ChoGGi = nil
		end
	end
	return orig_BaseRover_GetRefundResources(self, ...)
end
