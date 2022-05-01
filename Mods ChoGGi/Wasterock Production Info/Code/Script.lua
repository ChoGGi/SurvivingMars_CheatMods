-- See LICENSE for terms

local IsValid = IsValid
local next = next
local CalcWasteRockAmount = CalcWasteRockAmount
local MulDivTrunc = MulDivTrunc

function OnMsg.ClassesPostprocess()
	local xtemplate = XTemplates.sectionResourceProducer[1]
	if xtemplate.ChoGGi_AddedWasteRockProdInfo then
		return
	end
	xtemplate.ChoGGi_AddedWasteRockProdInfo = true

	local prod_info = PlaceObj("XTemplateTemplate", {
		"__condition", function(_, context)
			return IsValid(context.wasterock_producer)
		end,
		"__template", "InfopanelText",
		"Text", T(6732, "Production per Sol")
			.. T("<right><resource(ChoGGi_GetPredictedDailyProduction_WasteRock, 'WasteRock')>"),
	})

	table.insert(xtemplate, #xtemplate, prod_info)

	xtemplate = XTemplates.sectionMine[1]
	table.insert(xtemplate, #xtemplate, prod_info)

	xtemplate = XTemplates.sectionWaterProduction[1]
	table.insert(xtemplate, #xtemplate, prod_info)

	-- consumption
	xtemplate = XTemplates.sectionConsumption[1]
	xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
		"__template", "InfopanelText",
		"Id", "idWasteRock",
	})
end

function ResourceProducer:ChoGGi_GetPredictedDailyProduction_WasteRock()
	local waste_count = 0

	local deposit
	if IsValid(self.found_deposit) then
		deposit = self.found_deposit
	elseif self.nearby_deposits and next(self.nearby_deposits) then
		deposit = self.nearby_deposits[1]
	end

	local is_deposit = IsValid(deposit)

	if is_deposit and self:IsKindOf("WaterProducer") then
		waste_count = CalcWasteRockAmount(
			self.water:GetProductionEstimate(),
			self.exploitation_resource,
			deposit.grade
		)
	else
		-- not all buildings need a deposit
		local grade = is_deposit and deposit.grade
			or self.GetDepositGrade and self:GetDepositGrade()

		for i = 1, #self.producers do
			waste_count = waste_count + CalcWasteRockAmount(
				self.producers[i]:GetPredictedDailyProduction(),
				self.exploitation_resource,
				grade
			)
		end
	end

	return waste_count
end

function Building:ChoGGi_GetPredictedDailyConsumption_WasteRock()
	local consumption_amount = self.consumption_amount or 0
	local consumption_daily = 0

	-- they don't produce resources
	if self:IsKindOf("TerraformingBuildingBase") then
		local boost = self:GetTerraformingBoost(self.building_update_time)
		if boost == 0 or g_NoTerraforming then
			consumption_daily = consumption_amount
		else
			consumption_daily = MulDivTrunc(boost, consumption_amount, const.TerraformingScale) * 24
		end
	elseif self.GetPredictedDailyProduction then
		consumption_daily = self:GetPredictedDailyProduction() * (consumption_amount / const.ResourceScale)
	end

	return consumption_daily
end

local ChoOrig_UpdateUISectionConsumption = Building.UpdateUISectionConsumption
function Building:UpdateUISectionConsumption(win, ...)
	win.idWasteRock:SetText("")
	if self.consumption_resource_type == "WasteRock"
		and self:IsKindOf("HasConsumption") and self:DoesHaveConsumption()
		and self.consumption_stored_resources
	then
		win.idWasteRock:SetText(T(347, "Consumption")
			.. T("<right><resource(ChoGGi_GetPredictedDailyConsumption_WasteRock, 'WasteRock')>")
		)
	end

	return ChoOrig_UpdateUISectionConsumption(self, win, ...)
end

local grade_str = {787, "Grade<right><grade_name>"}
local ChoOrig_AvailableDeposits = AvailableDeposits
function AvailableDeposits(bld, items, ...)
	local ret = ChoOrig_AvailableDeposits(bld, items, ...)
	if items then
		local count = #items
		-- append grade of deposit to rollover text
		if type(items[count]) == "table" and items[count][1] == 298 then
			grade_str.grade_name = DepositGradeToDisplayName[bld:GetDepositGrade()]
			items[count+1] = T(grade_str)
		end
	end
	return ret
end
