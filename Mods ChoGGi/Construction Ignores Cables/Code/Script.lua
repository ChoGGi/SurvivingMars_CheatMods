-- See LICENSE for terms

local table = table

function ConstructionController:IsObstructed()
	local obstructors = self.construction_obstructors or ""
	for i = #obstructors, 1, -1 do
		if obstructors[i]:IsKindOf("ElectricityGridElement") then
			table.remove(obstructors, i)
		end
	end
	-- orig func
	return #obstructors > 0
end
