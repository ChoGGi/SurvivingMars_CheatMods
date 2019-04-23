function OnMsg.ModsReloaded()
	local BuildingTechRequirements = BuildingTechRequirements
	local BuildingTemplates = BuildingTemplates

	for id,bld in pairs(BuildingTemplates) do

		-- set each status to false if it isn't
		for i = 1, 3 do
			local str = "sponsor_status" .. i
			if bld[str] ~= false then
				bld[str] = false
			end
		end

		-- and this bugger screws me over on GetBuildingTechsStatus
		local name = id
		if name:find("RC") and name:find("Building") then
			name = name:gsub("Building","")
		end
		local idx = table.find(BuildingTechRequirements[id],"check_supply",name)
		if idx then
			table.remove(BuildingTechRequirements[id],idx)
		end

	end
end
