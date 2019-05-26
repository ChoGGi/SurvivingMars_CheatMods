-- See LICENSE for terms

local IsValid = IsValid
function OnMsg.LoadGame()
	local pads = UICity.labels.LandingPad or ""
	for i = 1, #pads do
		local pad = pads[i]
		if pad.rocket_construction and not IsValid(rocket_construction) then
			pad.rocket_construction = false
		end
	end
end
