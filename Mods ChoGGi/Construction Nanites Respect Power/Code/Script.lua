-- See LICENSE for terms

local orig_ConstructionSite_BuildingUpdate = ConstructionSite.BuildingUpdate
function ConstructionSite:BuildingUpdate(...)
	if self.construction_started and g_ConstructionNanitesResearched and self.working then
		return orig_ConstructionSite_BuildingUpdate(self, ...)
	end
end
