-- See LICENSE for terms

function OnMsg.ConstructionComplete(building)
	if building.class == "School" then
		building.maintenance_resource_amount = 1000
	elseif building.class == "MartianUniversity" then
		building.maintenance_resource_amount = 1500
	end
end
