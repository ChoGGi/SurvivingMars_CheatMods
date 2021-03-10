-- See LICENSE for terms

local def = CurrentModDef
-- we need to store the list of sponsor locked buildings
local sponsor_buildings = def.sponsor_buildings or {}

local mod_options = {}
local options

-- build options list
local BuildingTemplates = BuildingTemplates
for id, bld in pairs(BuildingTemplates) do
	for i = 1, 3 do
		if sponsor_buildings[id] or bld["sponsor_status" .. i] ~= false then
			mod_options["ChoGGi_" .. id] = false
			sponsor_buildings[id] = true
			break
		end
	end
end

-- fired when settings are changed/init
local function ModOptions()
	options = CurrentModOptions
	for id in pairs(mod_options) do
		mod_options[id] = options:GetProperty(id)
	end
--~ ex(mod_options)
	local BuildingTechRequirements = BuildingTechRequirements
	local table = table

	local BuildingTemplates = BuildingTemplates
	for id, bld in pairs(BuildingTemplates) do

		-- set each status to false if it isn't
		for i = 1, 3 do
			if sponsor_buildings[id] then
				local str = "sponsor_status" .. i
				if mod_options["ChoGGi_" .. id] then
					bld[str] = false
				elseif bld[str] ~= "" then
					bld[str] = "required"
				end
			end
		end

		-- and this bugger screws me over on GetBuildingTechsStatus when using RCs
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

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end
