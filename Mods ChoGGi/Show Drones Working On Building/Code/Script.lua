-- See LICENSE for terms

local IsValid = IsValid
local SelectionArrowAdd = SelectionArrowAdd
local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits

function OnMsg.SelectionAdded(obj)
	local drones = {}
	local c = 0
	local cc = obj.command_centers or ""
	for i = 1, #cc do
		local hub_drones = cc[i].drones or ""
		for j = 1, #hub_drones do
			local drone = hub_drones[j]
			if IsValid(drone.target) then
				if drone.target.handle == obj.handle then
					c = c + 1
					drones[c] = drone
				else
					local parent = drone.target:GetParent()
					if IsValid(parent) and parent.handle == obj.handle then
						c = c + 1
						drones[c] = drone
					end
				end
			end
		end
	end

	SuspendPassEdits("ChoGGi.ShowDronesConstructionSite.OnSelected")
	SelectionArrowClearAll()
	SelectionArrowAdd(drones)
	ResumePassEdits("ChoGGi.ShowDronesConstructionSite.OnSelected")
end
