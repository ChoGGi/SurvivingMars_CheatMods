-- See LICENSE for terms

local mod_ShowNotification

-- fired when settings are changed/init
local function ModOptions()
	mod_ShowNotification = CurrentModOptions:GetProperty("ShowNotification")
end

--~ -- load default/saved settings
--~ OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local buildings = {}
local standings_prev = {}

function OnMsg.ModsReloaded()
--~ ex(buildings)
--~ ex(standings_prev)

	ModOptions()

-- build a list of locked buildings (we do it in ModsReloaded for any changed by mods)
	local BuildingTechRequirements = BuildingTechRequirements
	local BuildingTemplates = BuildingTemplates

	for id, bld in pairs(BuildingTemplates) do
		for i = 1, 3 do
			local name = "sponsor_name" .. i
			local spons = bld[name]
			if spons ~= "" then
				-- add a table for each sponsor
				if not buildings[spons] then
					buildings[spons] = {}
				end
				-- and add the building id
				if not buildings[spons][id] then
					-- paradox spon disables regular shuttlehub
					buildings[spons][id] = {
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
		local reqs = BuildingTechRequirements[id]
		local idx = table.find(reqs, "check_supply", name)
		if idx then
			table.remove(reqs, idx)
		end

	end
end

-- Mr. Burns
local excel = 61

local function UpdateStanding()

	-- show standings msg
	local show_standings = false

	local RivalAIs = RivalAIs
	local BuildingTemplates = BuildingTemplates
	for id, rival in pairs(RivalAIs) do
		-- there's none locked to it, then nothing to do
		local rival_bld = buildings[id]
		if rival_bld then
			-- are we showing standing msg?
			local standing_curr = rival.resources.standing
			-- check if old and new standing are diff
			if mod_ShowNotification then
				local standing_prev = standings_prev[id]
				if standing_prev
					and (standing_prev >= excel and standing_curr < excel
					or standing_prev < excel and standing_curr >= excel)
				then
					show_standings = true
				end
				-- update old standing
				standings_prev[id] = standing_curr
			end

			--  61 for excellent
			local standing_excel = standing_curr > 60
			for bld_id, list in pairs(rival_bld) do
				-- not sure why they added three sponsors (when they only use one) so we'll just be lazy
				for i = 1, 3 do
					if standing_excel then
						BuildingTemplates[bld_id]["sponsor_status" .. i] = false
					else
						BuildingTemplates[bld_id]["sponsor_status" .. i] = list[i]
					end
				end
			end
		end
	end

	if not mod_ShowNotification or not show_standings then
		return
	end

	local GetStandingText = GetStandingText
	local Max = Max
	local T = T
	local standing_msg = {}
	local c = 0
	for _, rival in pairs(RivalAIs) do
		local standing = rival.resources.standing
		c = c + 1
		standing_msg[c] = T{302535920011562, "<name>: <stand_text><newline>",
			name = rival.display_name,
			stand_text = T{11538, "<standing> (<clamped_number>)",
				standing = GetStandingText(standing),
				clamped_number = Max(standing, -100),
			},
		}
	end

	-- sort by rival name
	local CmpLower = CmpLower
	local _InternalTranslate = _InternalTranslate
	table.sort(standing_msg, function(a, b)
		return CmpLower(_InternalTranslate(a.name), _InternalTranslate(b.name))
	end)

	ChoGGi.ComFuncs.MsgPopup(
		table.concat(standing_msg),
		T(302535920011561, "Colony Standing"),
		{size = true}
	)
end


OnMsg.CityStart = UpdateStanding
OnMsg.LoadGame = UpdateStanding
OnMsg.NewDay = UpdateStanding
