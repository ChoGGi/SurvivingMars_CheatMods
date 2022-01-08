-- See LICENSE for terms

function OnMsg.ClassesPostprocess()
	local template = XTemplates.customDroneHub
	local idx = table.find(template, "Icon", "UI/Icons/Sections/drone.tga")
	if idx then
		template[idx].Title = T(0000, "Drones<right><drone(DronesCount,MaxDronesCount)>")
	end
end

-- got removed by AG, it's not as if anyone needs to see how many drones a drone hub can support
function DroneControl:GetMaxDronesCount()
	return g_Consts.CommandCenterMaxDrones
end
