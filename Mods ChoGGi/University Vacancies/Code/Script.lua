-- See LICENSE for terms

local GetFreeWorkplaces = GetFreeWorkplaces

local mod_UseVacancies

local exclude_specs = {}
local ColonistSpecializationList = ColonistSpecializationList
for i = 1, #ColonistSpecializationList do
	exclude_specs[ColonistSpecializationList[i]] = false
end

local ChoOrig_GetMostNeededSpecialistAround = GetMostNeededSpecialistAround
function GetMostNeededSpecialistAround(dome, ...)
	if not mod_UseVacancies then
		return ChoOrig_GetMostNeededSpecialistAround(dome, ...)
	end

	local specs = ColonistSpecializationList

	local current_vacancies = 0
	local existing_specs = 0
	local highest_need = 0
	local highest_need_existing = 0
	local highest_need_spec

	local city = dome and dome.city or UICity

	for i = 1, #specs do
		local spec = specs[i]
		current_vacancies = GetFreeWorkplaces(city, spec)
		existing_specs = #(city.labels[spec] or "")

		if not exclude_specs[spec] then
			-- get highest need
			if current_vacancies > highest_need then
				highest_need = current_vacancies
				highest_need_existing = existing_specs

				highest_need_spec = spec

			-- needs are same as highest, but existing is less
			elseif current_vacancies == highest_need
				and existing_specs < highest_need_existing
			then
				highest_need = current_vacancies
				highest_need_existing = existing_specs

				highest_need_spec = spec
			end
		end
		--
	end

	-- no idea why someone would exclude all specs, but I wouldn't put it past someone.
	if not highest_need_spec then
		return ChoOrig_GetMostNeededSpecialistAround(dome, ...)
	end

--~ 	print(highest_need_spec, "highest_need_spec")
	return highest_need_spec
end

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions

	mod_UseVacancies = options:GetProperty("UseVacancies")

	for id in pairs(exclude_specs) do
		exclude_specs[id] = options:GetProperty(id)
	end

end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
