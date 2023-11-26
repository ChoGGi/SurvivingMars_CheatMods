-- See LICENSE for terms

function OnMsg.SelectionAdded(obj)
	if IsKindOf(obj, "DroneControl") then
		return
	end

	local IsValid = IsValid

	local drones = {}
	local c = 0
	local cc = obj.command_centers or ""
	for i = 1, #cc do
		local hub_drones = cc[i].drones or ""
		for j = 1, #hub_drones do
			local drone = hub_drones[j]
			if drone.target and IsValid(drone.target) then
				if drone.target.handle == obj.handle then
					c = c + 1
					drones[c] = drone
				else
					local parent = drone.target:GetParent()
					if parent and IsValid(parent)
						and parent.handle == obj.handle
					then
						c = c + 1
						drones[c] = drone
					end
				end
			end
		end
	end

		SuspendPassEdits("ChoGGi.ShowDronesConstructionSite.OnSelected")
		-- If no drones then skip this to not hide colonist arrows, if drones then probably not going to be any colonists...
		if #drones > 0 then
			SelectionArrowClearAll()
		end
		SelectionArrowAdd(drones)
		ResumePassEdits("ChoGGi.ShowDronesConstructionSite.OnSelected")
end
