-- See LICENSE for terms

local table_remove = table.remove
local orig_UpdateConstructionObstructors = ConstructionController.UpdateConstructionObstructors
function ConstructionController:UpdateConstructionObstructors(...)
	local ret = orig_UpdateConstructionObstructors(self, ...)

	local objs = self.construction_obstructors or ""
	for i = #objs, 1, -1 do
		if objs[i]:IsKindOf("ElectricityGridElement") then
			table_remove(objs, i)
		end
	end

	return ret
end
