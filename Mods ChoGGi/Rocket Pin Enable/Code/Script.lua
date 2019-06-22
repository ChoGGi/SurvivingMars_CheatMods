-- See LICENSE for terms

function SupplyRocket.CanBeUnpinned()
	return true
end

SupplyRocket.show_pin_toggle = true


local function StartupCode()
	local rockets = UICity.labels.AllRockets or ""
	for i = 1, #rockets do
		local r = rockets[i]
		r.show_pin_toggle = true
	end
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
