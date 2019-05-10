-- See LICENSE for terms

local table_find = table.find
local table_remove = table.remove
local type = type
local IsValid = IsValid
local pairs = pairs
local Msg = Msg
local GenerateColonistData = GenerateColonistData
local GetRandomPassablePoint = GetRandomPassablePoint
local GetPassablePointNearby = GetPassablePointNearby
local InvalidPos = InvalidPos()

local function RemoveInvalid(count,list)
	for i = #list, 1, -1 do
		if not IsValid(list[i]) then
			count = count + 1
			table_remove(list,i)
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

--~ local function RemoveOldMainTasks(s)
--~ 	for i = #r.task_requests, 1, -1 do
--~ 		local task = r.task_requests[i]
--~ 		if task:GetResource() == r.maintenance_requirements.resource and task:GetFillIndex() == 1000000 and task:GetFlags() == 1028 then
--~ 			table_remove(r.task_requests,i)
--~ 		end
--~ 	end
--~ end
local function AddStockPile(res,amount,pos)
	local stockpile = PlaceObj("ResourceStockpile", {
		"Pos", pos,
		"resource", res,
		"destroy_when_empty", true,
	})
	stockpile:AddResourceAmount(amount)
--~ 	return stockpile
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
					local pass = table_find(r.cargo,"class","Passengers")
					pass = r.cargo[pass]
					if type(pass) == "table" and pass.amount > 0 and #pass.applicants_data == 0 then
						r:SetCommand("Unload")
					end
				end

				if type(r.expedition) == "table" then
					local unload_it
					local crew = r.expedition.crew or ""
					for j = #crew, 1, -1 do
						local c = crew[j]
						if IsValid(c) then
							-- valid but stuck on WorkCycle cmd
							unload_it = true
							c:SetCommand("Idle")
							table_remove(crew,j)
							-- if we don't add the thread it spams log with [LUA ERROR] attempt to yield across a C-call boundary
							CreateGameTimeThread(function()
								c:ExitBuilding(r)
							end)
						else
							-- more invalid colonists...
							SpawnColonist_lib(c,r,nil,UICity)
							table_remove(crew,j)
						end
					end

					-- valid but stuck inside rocket
					local drones = r.expedition.drones or ""
					for j = #drones, 1, -1 do
						local d = drones[j]
						if IsValid(d) then
							if d:GetPos() == InvalidPos then
								CreateGameTimeThread(function()
									d:ExitBuilding(r)
									Sleep(10000)
									-- something screws them up, so take the easy way out
									if not d.command then
										d:delete()
										UICity.drone_prefabs = UICity.drone_prefabs + 1
									end
								end)
								table_remove(drones,j)
							end
						else
							UICity.drone_prefabs = UICity.drone_prefabs + 1
							table_remove(drones,j)
						end
					end

					if unload_it then
						r:SetCommand("Unload")
					end
				end

				-- invalid drones
				local invalid = RemoveInvalid(0,r.drones_exiting or "")
				invalid = RemoveInvalid(invalid,r.drones_entering or "")
				invalid = RemoveInvalid(invalid,r.drones_in_queue_to_charge or "")
				invalid = RemoveInvalid(invalid,r.drones or "")
				UICity.drone_prefabs = UICity.drone_prefabs + invalid

--~ 				if r.maintenance_request then
--~ 					local cmd = r.command
--~ 					RemoveOldMainTasks(r)
--~ 					table_clear(r.maintenance_requirements)
--~ 					r.maintenance_request = false
--~ 					r:SetCommand(cmd)
--~ 				end

				-- fix for my screwup with the main reqs
				if not r.expedition and #r.task_requests ~= 8 then
					local count = 0
					for j = 1, #r.task_requests do
						if r.task_requests[j]:GetResource() == "MachineParts" then
							count = count + 1
						end
					end
					-- one for loading, one for the main req
					if count ~= 2 then
						-- remove old reqs
						r.task_requests = {}
						-- re-do other ones
						r:CreateResourceRequests()
						if not r.allow_export then
							r:ToggleAllowExport()
						end
						local unit_count = r:GetRequestUnitCount(r.max_export_storage)
						r.export_requests = { r:AddDemandRequest("PreciousMetals", r.max_export_storage, 0, unit_count) }
						r:ToggleAllowExport()
						r:ToggleAllowExport()
					end
				end

			-- seems easiest to just ignore it
			elseif r.command == "WaitMaintenance" then
				-- drop res piles for any fuel/rare metals
				local spawned = 0
				local id_start, id_end = r:GetAllSpots(0)
				for j = id_start, id_end do
					if j % 2 == 0 and spawned ~= 2 and r:GetSpotName(j) == "Workrover" then
						local amount = r:GetStoredExportResourceAmount()
						if amount > 500 then
							AddStockPile("PreciousMetals",amount,r:GetSpotPos(j))
						end
						spawned = spawned + 1
					elseif j % 2 ~= 0 and spawned ~= 2 and r:GetSpotName(j) == "Workrover" then
						local extra = r.unload_fuel_request and r.unload_fuel_request:GetActualAmount() or 0
						local amount = r.launch_fuel - r.refuel_request:GetActualAmount() + extra
						if amount > 500 then
							AddStockPile("Fuel",amount,r:GetSpotPos(j))
						end
						spawned = spawned + 1
					end
				end
				r:SetCommand("Unload")

--~ 				RemoveOldMainTasks(r)
--~ 				r:SetCommand("WaitMaintenance",r.maintenance_requirements.resource, r.maintenance_request:GetTargetAmount())

--~ 			-- any of the above WaitMaintenance rockets
--~ 			elseif r.command == "Refuel" and r.maintenance_request then
--~ 				local cmd = r.command
--~ 				RemoveOldMainTasks(r)
--~ 				table_clear(r.maintenance_requirements)
--~ 				r.maintenance_request = false
--~ 				r:SetCommand(cmd)
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
