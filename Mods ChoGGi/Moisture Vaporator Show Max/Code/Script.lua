-- See LICENSE for terms

local r = const.ResourceScale
local function UpdateMax(self)
	local prod = self.modifications and self.modifications.water_production
	if prod then
		local percent = 100.0
		-- if something uses amounts (mod maybe?)
		local amount = 0
		for i = 1, #prod do
			local mod = prod[i]
			if mod.percent and mod.percent > 0 then
				percent = percent + mod.percent
			elseif mod.amount and mod.amount > 0 then
				amount = amount + mod.amount
			end
		end
		self.ChoGGi_max_vap_prod = ((percent / 100) * r) + amount
	else
		self.ChoGGi_max_vap_prod = self.base_water_production
	end
end

local orig_GetWaterProductionText = WaterProducer.GetWaterProductionText
function WaterProducer:GetWaterProductionText(...)
	local ret = orig_GetWaterProductionText(self, ...)

	if not self:IsKindOf("MoistureVaporator") then
		return ret
	end

	if self.nearby_vaporators > 0 then
		if not self.ChoGGi_max_vap_prod then
			UpdateMax(self)
		end
		ret = ret .. T("<newline><left>") .. T{330,
			"Max production<right><water(production)>",
			production = self.ChoGGi_max_vap_prod
		}
	end

	return ret

end

local orig_UpdateNearbyVaporatorsCount = MoistureVaporator.UpdateNearbyVaporatorsCount
function MoistureVaporator:UpdateNearbyVaporatorsCount(...)
	UpdateMax(self)
	return orig_UpdateNearbyVaporatorsCount(self, ...)
end
