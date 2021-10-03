-- See LICENSE for terms

-- 0.0 so we don't round up
local resource_scale = const.Scale.Resources + 0.0
local function GetConsumption(self, prod)
	local cons = self.consumption_amount
	return prod / resource_scale * cons
end

local T = T
local table = table

local function AddStrings(self, str, idx1, idx2)
	table.insert(str.table, idx1, T{302535920011732, "Daily consumption (predicted)<right><resource(consumption,resource)>",
		consumption = GetConsumption(self, self:GetPredictedDailyProduction()),
		resource = self.consumption_resource_type,
	})
	table.insert(str.table, idx2, T{302535920011733, "Lifetime consumption<right><resource(consumption,resource)>",
		consumption = GetConsumption(self, self:SumOfAllProducers("lifetime_production")),
		resource = self.consumption_resource_type,
	})
end

local ChoOrig_GetUISectionResourceProducerRollover = ResourceProducer.GetUISectionResourceProducerRollover
function ResourceProducer:GetUISectionResourceProducerRollover(...)
	local ret = ChoOrig_GetUISectionResourceProducerRollover(self, ...)

	-- no icon for them
	if self.consumption_resource_type == "no_consumption" then
		return ret
	end

	if not self.consumption_amount or not self.SumOfAllProducers then
		return ret
	end

	local str = ret[1]

	-- try to stick it under daily prod
	local idx1 = 3
	local idx2 = 5
	if str.j ~= 5 then
		-- or at the end if it isn't 5 (modded?)
		idx1 = str.j-1
		idx2 = str.j
	end
	str.j = str.j + 2

	AddStrings(self, str, idx1, idx2)
	return ret
end

local ChoOrig_GetUISectionConsumptionRollover = Building.GetUISectionConsumptionRollover
function Building:GetUISectionConsumptionRollover(...)
	local ret = ChoOrig_GetUISectionConsumptionRollover(self, ...)

	if not self.consumption_amount or not self.SumOfAllProducers then
		return ret
	end

	local res_prod = self:IsKindOf("ResourceProducer")
	if not res_prod or res_prod and not self:DoesHaveConsumption() then
		return ret
	end

	-- just stick it at the end
	local str = ret[1]
	str.j = str.j + 3
	local c = #str.table + 1

	-- add a header for this one
	str.table[c] = T("<center><em>") .. T(692, "Resources") .. T("</em>")

	AddStrings(self, str, c+1, c+2)
	return ret
end
