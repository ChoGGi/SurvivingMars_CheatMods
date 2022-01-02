-- See LICENSE for terms

local table, type, pairs = table, type, pairs
local IsValid = IsValid
local Msg = Msg
local GenerateColonistData = GenerateColonistData
local GetRandomPassablePoint = GetRandomPassablePoint
local GetPassablePointNearby = GetPassablePointNearby
local InvalidPos = InvalidPos()

local mod_EnableMod

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

local function RemoveInvalid(count, list)
	for i = #list, 1, -1 do
		if not IsValid(list[i]) then
			count = count + 1
			table.remove(list, i)
		end
	end
	return count
end

local function AddStockPile(res, amount, pos)
	local stockpile = PlaceObj("ResourceStockpile", {
		"Pos", pos,
		"resource", res,
		"destroy_when_empty", true,
	})
	stockpile:AddResourceAmount(amount)
end

-- we need to wait till mods are loaded to check for my mod
local SpawnColonist

function OnMsg.LoadGame()
	if not mod_EnableMod then
		return
	end
	local UICity = UICity

	-- If my lib mod is installed use my copy of this function
	if not SpawnColonist then
		if table.find(ModsLoaded, "id", "ChoGGi_Library") then
			SpawnColonist = ChoGGi.ComFuncs.SpawnColonist
		end
		SpawnColonist = type(SpawnColonist) == "function"
			and SpawnColonist or function(old_c, building, pos, city)
			if not city then
				city = UICity
			end

			local colonist
			if old_c then
				colonist = GenerateColonistData(city, old_c.age_trait, false, {
					gender = old_c.gender, entity_gender = old_c.entity_gender,
					no_traits = "no_traits", no_specialization = true,
				})
				-- we set all the set gen doesn't (it's more for random gen after all)
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

			colonist:SetPos(pos or building and GetPassablePointNearby(building:GetPos())
				or GetRandomPassablePoint())

			-- if spec is different then updates to new entity
			colonist:ChooseEntity()
			return colonist
		end
	end

	local rockets = UICity.labels.AllRockets or ""
	for i = 1, #rockets do
		local r = rockets[i]
		local r_pos = r:GetPos()

		-- skip any pods and ones not on the ground
		if not r:IsKindOf("SupplyPod") and r_pos ~= InvalidPos then
			if r.command == "Unload" then
				-- has expectation of passengers, but none are on the rocket
				if type(r.cargo) == "table" then
					local pass = table.find(r.cargo, "class", "Passengers")
					pass = r.cargo[pass]
					if type(pass) == "table" and pass.amount > 0
						and #pass.applicants_data == 0
					then
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
							table.remove(crew, j)
							-- If we don't add the thread it spams log with [LUA ERROR] attempt to yield across a C-call boundary
							CreateGameTimeThread(function()
								c:ExitBuilding(r)
							end)
						else
							-- more invalid colonists...
							SpawnColonist(c, r, nil, UICity)
							table.remove(crew, j)
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
								table.remove(drones, j)
							end
						else
							UICity.drone_prefabs = UICity.drone_prefabs + 1
							table.remove(drones, j)
						end
					end

					if unload_it then
						r:SetCommand("Unload")
					end
				end

				-- Invalid drones
				local invalid = RemoveInvalid(0, r.drones_exiting or "")
				invalid = RemoveInvalid(invalid, r.drones_entering or "")
				invalid = RemoveInvalid(invalid, r.drones_in_queue_to_charge or "")
				invalid = RemoveInvalid(invalid, r.drones or "")
				UICity.drone_prefabs = UICity.drone_prefabs + invalid

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
						r.export_requests = {
							r:AddDemandRequest("PreciousMetals", r.max_export_storage, 0,
							unit_count),
						}
						r:ToggleAllowExport()
						r:ToggleAllowExport()
					end
				end

			elseif r.command == "Countdown" or r.command == "Takeoff" then
				-- exited means exited (unless it's really really close, close enough)
				if type(r.drones_exiting) == "table" then
					for j = #r.drones_exiting, 1, -1 do
						local drone = r.drones_exiting[j]
						-- off map
						if r.command == "Takeoff" and drone:GetPos() == InvalidPos then
							table.remove(r.drones_exiting, j)
							drone:delete()
							UICity.drone_prefabs = UICity.drone_prefabs + 1
						-- not moving or outside the rocket
						elseif r.command == "Countdown" and (drone.moving == false
								or r_pos:Dist2D(drone:GetVisualPos()) > 1500) then
							table.remove(r.drones_exiting, j)
						end
					end
				end
				-- bugged rocket trying to do a trade (only has priority button)
				if r.command == "Takeoff" and r.expedition and r.expedition.route_id
					and r.refuel_request:GetActualAmount() == 0 and not r:IsRefueling()
				then
					r:CheatLaunch()
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
							AddStockPile("PreciousMetals", amount, r:GetSpotPos(j))
						end
						spawned = spawned + 1
					elseif j % 2 ~= 0 and spawned ~= 2
						and r:GetSpotName(j) == "Workrover"
					then
						local ruf_amount = r.unload_fuel_request
							and r.unload_fuel_request:GetActualAmount() or 0
						local rf_amount = r.refuel_request
							and r.refuel_request:GetActualAmount() or 0
						local amount = r.launch_fuel - rf_amount + ruf_amount
						if amount > 500 then
							AddStockPile("Fuel", amount, r:GetSpotPos(j))
						end
						spawned = spawned + 1
					end
				end
				r:SetCommand("Unload")

			-- foreign trade rocket stuck on pad with 0 res unloading
			elseif r.command == "ExchangeResources"
				and r:GetStateText() == "disembarkIdle"
				and r:IsKindOf("ForeignTradeRocket")
				and r:GetStoredAmount() == 0
			then
				r:SetCommand("ExchangeResources")

			-- returned expedition rocket giving msg it hasn't landed
			elseif r.command == "WaitingRefurbish"
				and r.class ~= "RocketExpedition"
				and (#r.drones_exiting > 0 or r:GetRefuelProgress() == r.launch_fuel)
			then
				local site = r.landing_site
				-- change command
				r:SetCommand("WaitLaunchOrder")
				-- remove drones exiting
				local drones = r.drones_exiting
				for j = #drones, 1, -1 do
					table.remove(drones, j)
				end

				CreateRealTimeThread(function()
					-- rocket was swapped to exped rocket
					while r.class ~= "RocketExpedition" do
						WaitMsg("OnRender")
						r = GetLandingRocket(site)
					end
					-- abort "new" expedition it's now on
					r.expedition.canceled = true
					ObjModified(r)
					if r.launch_valid_cmd[r.command] then
						r:SetCommand("Unload", "cancel")
					elseif r.command == "ExpeditionExecute" then
						Wakeup(r.command_thread)
					end
				end)

			-- canceled exped doesn't get canceled properly back
			elseif r.command == "ExpeditionPrepare"
				and r.class == "RocketExpedition"
				and r.expedition and r.expedition.canceled
			then
				r.expedition.canceled = false
				r:ExpeditionCancel()

			-- rocket ifs
			end

		end
	end

	-- expedition rocket never lands on pad
	local pads = UICity.labels.LandingPad or ""
	for i = 1, #pads do
		local pad = pads[i]
		local has, rocket = pad:HasRocket()
		-- InvalidPos means it's not on mars
		if has and rocket:GetPos() == InvalidPos and IsValid(rocket.landing_site) then
			rocket:SetCommand("LandOnMars", rocket.landing_site)
		end
	end

	-- could be me? but he said dust storms...
	pads = UICity.labels.TradePad or ""
	for i = 1, #pads do
		local pad = pads[i]
		if IsValid(pad.trade_rocket) and pad.trade_rocket.command == "OnEarth"
			and pad.trade_rocket.ChoGGi_RepositionRocket == -10000
		then
			pad.trade_rocket:SetCommand("LandOnMars", pad)
			pad.trade_rocket.ChoGGi_RepositionRocket = nil
		end
	end

end
