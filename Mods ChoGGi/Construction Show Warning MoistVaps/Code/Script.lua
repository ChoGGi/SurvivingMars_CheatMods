-- See LICENSE for terms

local function IsMoistureVaporatorSite(obj)
	if obj.building_class_proto:IsKindOf("MoistureVaporator") then
		return true
	end
end

local orig_UpdateConstructionStatuses = ConstructionController.UpdateConstructionStatuses
function ConstructionController:UpdateConstructionStatuses(...)
	orig_UpdateConstructionStatuses(self, ...)

	if self.template_obj:IsKindOf("MoistureVaporator") then
		if MapCount(self.cursor_obj, "hex", const.MoistureVaporatorRange, "ConstructionSite", IsMoistureVaporatorSite) > 0 then
			local status = table.copy(ConstructionStatus.VaporatorInRange)
			status.text = T{status.text, {number = MulDivRound(self.template_obj.water_production, const.MoistureVaporatorPenaltyPercent, 100)}}
			self.construction_statuses[#self.construction_statuses + 1] = status
		end
	end
end