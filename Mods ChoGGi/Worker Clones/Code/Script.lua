-- See LICENSE for terms

local mod_EnableMod

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function GetRandomWorker(building)
	-- Okay a bit overkill
	if not building then
		local vats = UIColony:GetCityLabels("CloningVats")
		building = table.rand(vats)
	end

	local workers = {}
	local c = 0
	for i = 1, #building.workers do
		local shift = building.workers[i]
		for j = 1, #shift do
			c = c + 1
			workers[c] = shift[j]
		end
	end
	local worker = table.rand(workers)
	return worker
end

local ColonistClasses = ColonistClasses
local ColonistAgeGroups = const.ColonistAgeGroups

local current_vat

local ChoOrig_GenerateColonistData = GenerateColonistData
local function ChoFake_GenerateColonistData(city, age_trait, martianborn, params, ...)

	local worker = GetRandomWorker(current_vat)

	if not params then
		params = {}
	end
	-- Skip what we can for
	params.no_traits = true
	params.gender = worker.gender
	params.entity_gender = worker.entity_gender

	local new_data = ChoOrig_GenerateColonistData(city, age_trait, martianborn, params, ...)
	-- add traits/etc from existing
	new_data.traits.Martianborn = nil
	new_data.race = worker.race
	new_data.birthplace = worker.birthplace
	new_data.name = _InternalTranslate(worker.name) .. " Jr."

	for id, value in pairs(worker.traits) do
		-- Can't have children with specs or they've invis
		if not ColonistClasses[id] and not ColonistAgeGroups[id] then
			new_data.traits[id] = value
		end
	end

	return new_data
end


local ChoOrig_CloningVats_BuildingUpdate = CloningVats.BuildingUpdate
function CloningVats:BuildingUpdate(...)
	if not mod_EnableMod then
		return ChoOrig_CloningVats_BuildingUpdate(self, ...)
	end

	current_vat = self

	GenerateColonistData = ChoFake_GenerateColonistData
	local _, ret_value = pcall(ChoOrig_CloningVats_BuildingUpdate, self, ...)
	GenerateColonistData = ChoOrig_GenerateColonistData

	current_vat = false
	-- There's no return value from it, but whatever
	return ret_value
end

--~ function OnMsg.ColonistBorn(colonist, etc)
--~ 	if etc == "cloned" then
--~ 		ex(colonist)
--~ 	end
--~ end
