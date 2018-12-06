-- See LICENSE for terms

local spon_stat = "sponsor_status%s"
local spon_name = "sponsor_name%s"
local buildings = {}

-- build a list of locked buildings (we do it here for any changed by mods)
function OnMsg.ModsReloaded()
	local BuildingTechRequirements = BuildingTechRequirements

	local BuildingTemplates = BuildingTemplates
	for id,bld in pairs(BuildingTemplates) do
		for i = 1, 3 do
			local name = spon_name:format(i)
			if bld[name] ~= "" then
				-- add a table for each sponsor
				if not buildings[bld[name]] then
					buildings[bld[name]] = {}
				end
				-- and add the building id
				if not buildings[bld[name]][id] then
					local a,b,c = spon_stat:format(1),spon_stat:format(2),spon_stat:format(3)
					-- paradox spon disables regular shuttlehub
					buildings[bld[name]][id] = {
						bld[a] ~= "disabled" and bld[a] or false,
						bld[b] ~= "disabled" and bld[b] or false,
						bld[c] ~= "disabled" and bld[c] or false,
					}
				end
			end
		end

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

function OnMsg.NewDay()
--~ function OnMsg.NewHour()
	local BuildingTemplates = BuildingTemplates
	local RivalAIs = RivalAIs
	for id,rival in pairs(RivalAIs) do
		-- there's none locked to it, then nothing to do
		if buildings[id] then
			local standing = rival.resources.standing > 59
			for bld_id,list in pairs(buildings[id]) do
				-- not sure why they added three sponsors so we'll just be lazy
				for i = 1, 3 do
					if standing then
						BuildingTemplates[bld_id][spon_stat:format(i)] = false
					else
						BuildingTemplates[bld_id][spon_stat:format(i)] = list[i]
					end
				end
			end
		end
	end
end
