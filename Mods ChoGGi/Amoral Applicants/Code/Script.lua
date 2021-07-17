-- See LICENSE for terms

local table = table
local GameTime = GameTime
local Max = Max
local Sleep = Sleep
local AsyncRand = AsyncRand

local mod_DailySanityLoss
local mod_DailyColonistLoss
local mod_MaxFeedingTime
local mod_MinFeedingTime
local ChoGGi_lib

-- fired when settings are changed/init
local function ModOptions()
	local options = CurrentModOptions
	mod_DailySanityLoss = options:GetProperty("DailySanityLoss")
	mod_DailyColonistLoss = options:GetProperty("DailyColonistLoss")
	mod_MaxFeedingTime = options:GetProperty("MaxFeedingTime")
	mod_MinFeedingTime = options:GetProperty("MinFeedingTime")

	-- skip log nagging with rawget
	ChoGGi_lib = rawget(_G, "ChoGGi")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local orig_WaitInOrbit = RocketBase.WaitInOrbit
function RocketBase:WaitInOrbit(arrive_time, ...)

	-- check for passengers and abort if not
	local pass_table
	if self.cargo then
		pass_table = table.find(self.cargo, "class", "Passengers")
		if not pass_table then
			return orig_WaitInOrbit(self, arrive_time, ...)
		end
	end

	-- most of RocketBase:WaitInOrbit() follows
	self:OffPlanet()
	self.orbit_arrive_time = arrive_time

	-- no need to check
--~ 	self.cargo = self.cargo or {}
	local cargo = self.cargo

	-- skip most of this, since we know it's a pass rocket

	-- release probes immediately, mark orbit arrival time if carrying passengers
--~ 	for i = #cargo, 1, -1 do
--~ 		local item = cargo[i]
--~ 		if IsKindOf(g_Classes[item.class], "OrbitalProbe") then
--~ 			for j = 1, item.amount do
--~ 				PlaceObject(item.class, {city = self.city})
--~ 			end
--~ 			table.remove(cargo, i)
--~ 		elseif item.class == "Passengers" then
			self.orbit_arrive_time = self.orbit_arrive_time or GameTime()
--~ 		end
--~ 	end

	local landing_disabled = self.landing_disabled
	self:UpdateStatus(self:IsFlightPermitted() and (landing_disabled and "landing disabled" or "in orbit") or "suspended in orbit")

	if not self:IsLandAutomated() or not self:IsFlightPermitted() or landing_disabled then

		if ChoGGi_lib and ChoGGi.testing then
			-- testing
			Sleep(const.HourDuration)
		else
			-- wait the usual orbit time
			Sleep(Max(0, self.passenger_orbit_life + GameTime() - self.orbit_arrive_time))
		end

		-- Instead of killing them all off, we remove the food and kill off one per sol (probably a haffy would be better, or variable based on amount?)
		table.remove(cargo, table.find(cargo, "class", "Food"))

		-- feeding schedule
		local hour = const.HourDuration
		local max = hour * mod_MaxFeedingTime
		local min = hour * mod_MinFeedingTime
		local min1 = min + 1

		local route66 = 667 * hour

		-- make the rocket tooltip a bir more obvious
		self.passenger_orbit_life = route66
		self.orbit_arrive_time = GameTime()

		pass_table = cargo[pass_table]
		-- while longpig is left
		while pass_table.amount > 0 do
			Sleep(AsyncRand(max - min1) + min)
			-- just a reminder
			self.passenger_orbit_life = route66
			self.orbit_arrive_time = GameTime()

			for _ = 1, mod_DailyColonistLoss do
				-- who's it gonn' be?
				local _, idx = table.rand(pass_table.applicants_data)
				-- just in case
				if idx then
					table.remove(pass_table.applicants_data, idx)
					pass_table.amount = pass_table.amount - 1
				end
			end
			-- mark the rocket
			self.ChoGGi_cann_a_snack = true
		end

		-- If the rocket lands before they're all dead the below won't fire

		-- kill the passengers, call GameOver if there are no colonists on Mars
		local count
		for i = #cargo, 1, -1 do
			if cargo[i].class == "Passengers" then
				count = cargo[i].amount
				table.remove(cargo, i)
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

		WaitWakeup()
	end
	self:SetCommand("LandOnMars", self.landing_site)
end

local orig_LandOnMars = RocketBase.LandOnMars
function RocketBase:LandOnMars(...)
	-- longpig Lūʻau?
	if self.ChoGGi_cann_a_snack then
		-- whoopsie, should've checked for this...
		self.ChoGGi_cann_a_snack = nil

		local cargo = self.cargo
		local pass_table
		if cargo then
			pass_table = table.find(cargo, "class", "Passengers")
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

			colonist:ChangeSanity(-mod_DailySanityLoss*const.Scale.Stat, trait.id)
		end,
		description = T(101452796812,"<DisplayName> loses Sanity")
			.. T(302535920011355, " from having eaten uncooked flesh (BBQ party next time)."),
		display_name = T(302535920011000, "Cannibal"),
		group = "Negative",
		id = "ChoGGi_cannibal",
		incompatible = {},
	})

end
