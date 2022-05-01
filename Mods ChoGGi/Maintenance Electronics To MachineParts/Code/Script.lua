-- See LICENSE for terms

local list = {}
local c = 0

-- override templates
function OnMsg.ClassesPostprocess()
	local BuildingTemplates = BuildingTemplates
	for id, template in pairs(BuildingTemplates) do
		if template.maintenance_resource_type == "Electronics" then
			template.maintenance_resource_type = "MachineParts"
			c = c + 1
			list[c] = id
		end
	end
end

-- update existing
function OnMsg.LoadGame()
	local labels = UICity.labels
	for i = 1, c do
		local label = labels[list[i]] or ""
		for j = 1, #label do
			label[j].maintenance_resource_type = "MachineParts"
		end
	end
end
