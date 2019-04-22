-- See LICENSE for terms

local IsValid = IsValid

function OnMsg.LoadGame()
	local objs = UICity.labels.RCRover or ""
	for i = 1, #objs do
		local attached_drones = objs[i].attached_drones
		for j = #attached_drones, 1, -1 do
			local drone = attached_drones[j]
			if not IsValid(drone) then
				table.remove(attached_drones,j)
			end
		end
	end
end
