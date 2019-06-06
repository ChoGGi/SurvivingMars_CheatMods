-- See LICENSE for terms

local buildings = {}

-- build a list of locked buildings (we do it here for any changed by mods)
function OnMsg.ModsReloaded()
	local BuildingTechRequirements = BuildingTechRequirements

	local BuildingTemplates = BuildingTemplates
	for id, bld in pairs(BuildingTemplates) do
		for i = 1, 3 do
			local name = "sponsor_name" .. i
			if bld[name] ~= "" then
				-- add a table for each sponsor
				if not buildings[bld[name]] then
					buildings[bld[name]] = {}
				end
				-- and add the building id
				if not buildings[bld[name]][id] then
					-- paradox spon disables regular shuttlehub
					buildings[bld[name]][id] = {
						bld.sponsor_status1 ~= "disabled" and bld.sponsor_status1 or false,
						bld.sponsor_status2 ~= "disabled" and bld.sponsor_status2 or false,
						bld.sponsor_status3 ~= "disabled" and bld.sponsor_status3 or false,
					}
				end
			end
		end

		local name = id
		if name:find("RC") and name:find("Building") then
			name = name:gsub("Building", "")
		end
		local idx = table.find(BuildingTechRequirements[id], "check_supply", name)
		if idx then
			table.remove(BuildingTechRequirements[id], idx)
		end

	end
end

local function UpdateStanding()
	local BuildingTemplates = BuildingTemplates
	local RivalAIs = RivalAIs
	for id, rival in pairs(RivalAIs) do
		-- there's none locked to it, then nothing to do
		local rival_bld = buildings[id]
		if rival_bld then
			local standing = rival.resources.standing > 59
			for bld_id, list in pairs(rival_bld) do
				-- not sure why they added three sponsors so we'll just be lazy
				for i = 1, 3 do
					if standing then
						BuildingTemplates[bld_id]["sponsor_status" .. i] = false
					else
						BuildingTemplates[bld_id]["sponsor_status" .. i] = list[i]
					end
				end
			end
		end
	end
end

OnMsg.CityStart = UpdateStanding
OnMsg.LoadGame = UpdateStanding
--~ function OnMsg.NewHour()
OnMsg.NewDay = UpdateStanding
