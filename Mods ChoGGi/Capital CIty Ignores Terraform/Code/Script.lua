-- See LICENSE for terms

local table = table
local TGetID = TGetID

-- build city when terraforming is disabled
function OnMsg.GetAdditionalBuildingLocks(template, locks)
	if template.id == "OpenCity" then
		locks.NoTerraforming = nil
	end
end

-- allow to build whenever
function OnMsg.GatherUIBuildingPrerequisites(building, reasons)
	if building.template_class == "OpenCity" then
		for i = 1, #reasons do
			if TGetID(reasons[i]) == 12340 then
				table.remove(reasons, i)
				break
			end
		end
	end
end

-- use regular dome func instead of OpenCity one (it checks for BreathableAtmosphere)
OpenCity.HasAir = Dome.HasAir
