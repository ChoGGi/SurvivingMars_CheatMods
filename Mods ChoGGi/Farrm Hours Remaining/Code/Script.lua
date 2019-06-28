-- See LICENSE for terms

local orig_GetHarvestRemaining = Farm.GetHarvestRemaining
function Farm:GetHarvestRemaining(...)
	local sols = orig_GetHarvestRemaining(self, ...)
	local time = sols

	if sols < 2 then
		local grown, duration = self:GetGrowthTimes()

		if sols == 1 then
			sols = (((duration - grown) / const.HourDuration) - 24)
		else
			sols = ((duration - grown) / const.HourDuration)
		end

		time = sols .. " " .. T(3778, "Hours") .. " " .. time
	end

	return time
end
