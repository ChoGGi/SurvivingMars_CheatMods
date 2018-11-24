local TableFind = table.find
local TableRemove = table.remove
local type = type
local IsValid = IsValid
local InvalidPos = InvalidPos()
local pairs = pairs
local Msg = Msg
local GenerateColonistData = GenerateColonistData
local GetRandomPassablePoint = GetRandomPassablePoint
local GetPassablePointNearby = GetPassablePointNearby

local function RemoveInvalid(count,list)
	for i = #list, 1, -1 do
		if not IsValid(list[i]) then
			count = count + 1
			TableRemove(list,i)
		end
	end
	return count
end

local function SpawnColonist(old_c,building,pos,city)
	city = city or UICity

	local colonist
	if old_c then
		colonist = GenerateColonistData(city, old_c.age_trait, false, {gender=old_c.gender,entity_gender=old_c.entity_gender,no_traits = "no_traits",no_specialization=true})
		--we set all the set gen doesn't (it's more for random gen after all
		colonist.birthplace = old_c.birthplace
		colonist.death_age = old_c.death_age
		colonist.name = old_c.name
		colonist.race = old_c.race
		colonist.specialist = old_c.specialist
		for trait_id, _ in pairs(old_c.traits) do
			if trait_id and trait_id ~= "" then
				colonist.traits[trait_id] = true
			end
		end
	else
		colonist = GenerateColonistData(city)
	end

	Colonist:new(colonist)
	Msg("ColonistBorn", colonist)

	colonist:SetPos(pos or building and GetPassablePointNearby(building:GetPos()) or GetRandomPassablePoint())

	--if spec is different then updates to new entity
	colonist:ChooseEntity()
	return colonist
end

function OnMsg.LoadGame()
	-- if my lib mod is installed use my copy of this function
	local SpawnColonist_lib
	if ModsLoaded.ChoGGi_Library then
		SpawnColonist_lib = ChoGGi.ComFuncs.SpawnColonist
	end
	SpawnColonist_lib = type(SpawnColonist_lib) == "function" and SpawnColonist_lib or SpawnColonist

	local UICity = UICity
	local rockets = UICity.labels.AllRockets or ""
	for i = 1, #rockets do
		local r = rockets[i]

		-- skip any pods and ones not on the ground
		if not r:IsKindOf("SupplyPod") and r:GetPos() ~= InvalidPos then
			if r.command == "Unload" then

				-- has expectation of passengers, but none are on the rocket
				if type(r.cargo) == "table" then
					local pass = TableFind(r.cargo,"class","Passengers")
					pass = r.cargo[pass]
					if type(pass) == "table" and pass.amount > 0 and #pass.applicants_data == 0 then
						r:SetCommand("Unload")
					end
				end

				-- more invalid colonists...
				if type(r.expedition) == "table" then
					local crew = r.expedition.crew or ""
					for i = #crew, 1, -1 do
						if not IsValid(crew[i]) then
							SpawnColonist_lib(crew[i],r,nil,UICity)
							TableRemove(crew,i)
						end
					end
				end

				-- invalid drones
				local invalid = RemoveInvalid(0,r.drones_exiting or "")
				invalid = RemoveInvalid(invalid,r.drones_entering or "")
				invalid = RemoveInvalid(invalid,r.drones_in_queue_to_charge or "")
				invalid = RemoveInvalid(invalid,r.drones or "")
				UICity.drone_prefabs = UICity.drone_prefabs + invalid

			-- resends main com with whatever res is needed
			elseif r.command == "WaitMaintenance" then
				r:SetCommand("WaitMaintenance",r.maintenance_requirements.resource, r.maintenance_request:GetTargetAmount())

			end

		end
	end

	-- expedition rocket never lands on pad
	local pads = UICity.labels.LandingPad or ""
	for i = 1, #pads do
		local p = pads[i]
		local has,rocket = p:HasRocket()
		-- InvalidPos means it's not on mars
		if has and rocket:GetPos() == InvalidPos and IsValid(rocket.landing_site) then
			rocket:SetCommand("LandOnMars",rocket.landing_site)
		end
	end

end
