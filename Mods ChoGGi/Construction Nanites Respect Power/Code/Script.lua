-- See LICENSE for terms

local ChoOrig_ConstructionSite_BuildingUpdate = ConstructionSite.BuildingUpdate
function ConstructionSite:BuildingUpdate(...)
	if self.construction_started and g_ConstructionNanitesResearched and self.working then
		return ChoOrig_ConstructionSite_BuildingUpdate(self, ...)
	end
end
