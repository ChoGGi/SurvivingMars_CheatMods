-- See LICENSE for terms

function SupplyRocket:GetArrivalTimePercent()
	if not self.launch_time or (self.flight_time or 0) <= 0 then
		return "0 " .. T(3778, "Hours") .. " 100"
	end

	local start = GameTime() - self.launch_time
	local left = (self.flight_time - start) / const.HourDuration
	if left < 0 then
		left = 0
	end

	return left .. " " .. T(3778, "Hours") .. " "
		.. Min(100, MulDivRound(start, 100, self.flight_time))
end
