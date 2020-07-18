-- See LICENSE for terms

local table_find = table.find
local table_remove = table.remove
local table_rand = table.rand
local GameTime = GameTime
local Max = Max
local Sleep = Sleep
local AsyncRand = AsyncRand

local orig_WaitInOrbit = SupplyRocket.WaitInOrbit
function SupplyRocket:WaitInOrbit(arrive_time, ...)

	-- check for pass and abort if not
	local pass_table
	if self.cargo then
		pass_table = table_find(self.cargo, "class", "Passengers")
	end
	if not pass_table then
		return orig_WaitInOrbit(self, arrive_time, ...)
	end

	-- SupplyRocket:WaitInOrbit()
	self:OffPlanet()
	self.orbit_arrive_time = arrive_time

	-- no need to check
--~ 	self.cargo = self.cargo or {}
	local cargo = self.cargo

	-- skip the below, since we know it's a pass rocket
	self.orbit_arrive_time = self.orbit_arrive_time or GameTime()
--~ 	-- release probes immediately, mark orbit arrival time if carrying passengers
--~ 	for i = #cargo, 1, -1 do
--~ 		local item = cargo[i]
--~ 		if IsKindOf(g_Classes[item.class], "OrbitalProbe") then
--~ 			for j = 1, item.amount do
--~ 				PlaceObject(item.class, {city = self.city})
--~ 			end
--~ 			table.remove(cargo, i)
--~ 		elseif item.class == "Passengers" then
--~ 			self.orbit_arrive_time = self.orbit_arrive_time or GameTime()
--~ 		end
--~ 	end

	local landing_disabled = self.landing_disabled
	self:UpdateStatus(self:IsFlightPermitted() and (landing_disabled and "landing disabled" or "in orbit") or "suspended in orbit")

	if not self:IsLandAutomated() or not self:IsFlightPermitted() or landing_disabled then
--~ 		if self.orbit_arrive_time then
			-- wait the usual orbit time
			Sleep(Max(0, self.passenger_orbit_life + GameTime() - self.orbit_arrive_time))
--~ 			-- testing
--~ 			Sleep(const.HourDuration)

			-- instead of killing them all off, we remove the food and kill off one per sol
			table_remove(cargo, table_find(cargo, "class", "Food"))
			-- feeding schedule
			local hour = const.HourDuration
			local max = hour * 6
			local min = hour * 2
			local min1 = min + 1

			pass_table = cargo[pass_table]
			while pass_table.amount > 0 do
				-- between 2 and 6 hours per feed
				Sleep(Max(0, (AsyncRand(max - min1) + min) + GameTime() - self.orbit_arrive_time))
				-- who's it gonn' be?
				local _, idx = table_rand(pass_table.applicants_data)
				-- just in case
				if not idx then
					break
				end
				table_remove(pass_table.applicants_data, idx)
				pass_table.amount = pass_table.amount - 1
				self.ChoGGi_cann_a_snack = true
			end

			-- if we land before they're all dead the below won't fire

			-- kill the passengers, call GameOver if there are no colonists on Mars
			local count
			for i = #cargo, 1, -1 do
				if cargo[i].class == "Passengers" then
					count = cargo[i].amount
					table_remove(cargo, i)
				end
			end

			if (count or 0) > 0 then
				if #(self.city.labels.Colonist or "") == 0 then
					GameOver("last_colonist_died")
				else
					-- notification
					AddOnScreenNotification("DeadColonistsInSpace", nil, {count = count})
				end

				-- call if all die
				self:OnPassengersLost()

			end
			self.orbit_arrive_time = nil
			self:UpdateStatus(self.status) -- force update to get rid of the passenger-specific texts in rollover/summary
--~ 		end
		WaitWakeup()
	end
	self:SetCommand("LandOnMars", self.landing_site)
end

local orig_LandOnMars = SupplyRocket.LandOnMars
function SupplyRocket:LandOnMars(...)
	-- longpig lu'au?
	if self.ChoGGi_cann_a_snack then
		local cargo = self.cargo
		local pass_table
		if cargo then
			pass_table = table_find(cargo, "class", "Passengers")
		end
		-- just in case
		if not pass_table then
			return orig_LandOnMars(self, ...)
		end
		pass_table = cargo[pass_table]

		-- mark the leftovers
		for i = 1, #pass_table.applicants_data do
			pass_table.applicants_data[i].traits.ChoGGi_cannibal = true
		end
	end

	return orig_LandOnMars(self, ...)
end

function OnMsg.ClassesPostprocess()
	if TraitPresets.ChoGGi_cannibal then
		return
	end

	PlaceObj("TraitPreset", {
		daily_update_func = function (colonist, trait)
			colonist:ChangeSanity(-trait.param*const.Scale.Stat, trait.id)
		end,
		description = T(101452796812,"<DisplayName> loses Sanity")
			.. T(302535920011355, " from having eaten uncooked flesh (BBQ party next time)."),
		display_name = T(302535920011000, "Cannibal"),
		group = "Negative",
		id = "ChoGGi_cannibal",
		incompatible = {},
		param = 4,
	})

end
