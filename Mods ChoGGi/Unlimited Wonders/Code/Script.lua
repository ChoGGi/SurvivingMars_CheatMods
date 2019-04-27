-- See LICENSE for terms

-- we do this in ModsReloaded so any modded wonders get included
function OnMsg.ModsReloaded()
	local BuildingTemplates = BuildingTemplates
	for _,bld in pairs(BuildingTemplates) do
		bld.wonder = nil
	end
end
