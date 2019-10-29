-- See LICENSE for terms

local table = table

function OnMsg.ModsReloaded()
	local BuildingTechRequirements = BuildingTechRequirements
	local BuildingTemplates = BuildingTemplates

	for id, bld in pairs(BuildingTemplates) do

		-- set each status to false if it isn't
		for i = 1, 3 do
			local str = "sponsor_status" .. i
			if bld[str] ~= false then
				bld[str] = false
			end
		end

		-- and this bugger screws me over on GetBuildingTechsStatus
		local name = id
		if name:sub(1, 2) == "RC" and name:sub(-8) == "Building" then
			name = name:gsub("Building", "")
		end
		local reqs = BuildingTechRequirements[id]
		local idx = table.find(reqs, "check_supply", name)
		if idx then
			table.remove(reqs, idx)
		end

	end
end
