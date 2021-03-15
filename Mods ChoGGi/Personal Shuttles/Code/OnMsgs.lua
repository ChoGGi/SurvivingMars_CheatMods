-- See LICENSE for terms

local IsKindOf = IsKindOf
local IsValid = IsValid

local function StartupCode()
	local UICity = UICity

	-- place to store per-game values
	if not UICity.PersonalShuttles then
		UICity.PersonalShuttles = {}
	end
	-- objects carried by shuttles
	if not UICity.PersonalShuttles.shuttle_carried then
		UICity.PersonalShuttles.shuttle_carried = {}
	end
	-- controllable shuttle handles launched (true = attacker, false = friend)
	if not UICity.PersonalShuttles.shuttle_threads then
		UICity.PersonalShuttles.shuttle_threads = {}
	end
	-- we just want one shuttle scanning per anomaly (list of anomaly handles that are being scanned)
	if not UICity.PersonalShuttles.shuttle_scanning_anomaly then
		UICity.PersonalShuttles.shuttle_scanning_anomaly = {}
	end

	-- clear out Temp settings
	PersonalShuttles.shuttle_rocket_DD = {}
	PersonalShuttles.unit_pathing_handles = {}
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

function OnMsg.NewDay() -- NewSol
	-- clean up old handles
	local HandleToObject = HandleToObject
	local threads = UICity.PersonalShuttles.shuttle_threads
	if next(threads) then
		for h, _ in pairs(threads) do
			if not IsValid(HandleToObject[h]) then
				threads[h] = nil
			end
		end
	end

end

-- which true=attack, false=friend
local function SpawnShuttle(hub, attacker)
	local PersonalShuttles = PersonalShuttles
	local UICity = UICity
	for i = 1, #hub.shuttle_infos do
		local s_i = hub.shuttle_infos[i]
		if s_i:CanLaunch() and s_i.hub.has_free_landing_slots then
			if #(UICity.labels.PersonalShuttle or "") >= (PersonalShuttles.max_shuttles or 50) then
				ChoGGi.ComFuncs.MsgPopup(
					T(302535920011133, [[Max of 50 (somewhere above 50 and below 100 it crashes).]]),
					T(745, "Shuttles")
				)
				return
			end

			-- ShuttleInfo:Launch(task)
			local hub = s_i.hub
			-- LRManagerInstance
			local shuttle = PersonalShuttle:new({
				hub = hub,
				transport_task = PersonalShuttles_ShuttleFollowTask:new({
					state = "ready_to_follow",
					dest_pos = GetTerrainCursor() or GetRandomPassable()
				}),
				info_obj = s_i
			})
			s_i.shuttle_obj = shuttle
			local slot = hub:ReserveLandingSpot(shuttle)
			shuttle:SetPos(slot.pos)
			-- CargoShuttle:Launch()
			shuttle:PushDestructor(function(s)
				hub:ShuttleLeadOut(s)
				hub:FreeLandingSpot(s)
			end)
			-- do we attack dustdevils?
			if attacker then
				UICity.PersonalShuttles.shuttle_threads[shuttle.handle] = true
				shuttle:SetColorizationMaterial(1, PersonalShuttles.attacker_color1 or -2031616, -100, 120)
				shuttle:SetColorizationMaterial(2, PersonalShuttles.attacker_color2 or -16777216, 120, 20)
				shuttle:SetColorizationMaterial(3, PersonalShuttles.attacker_color3 or -9043968, -128, 48)
			else
				UICity.PersonalShuttles.shuttle_threads[shuttle.handle] = false
				shuttle:SetColorizationMaterial(1, PersonalShuttles.friend_colour1 or -16711941, -100, 120)
				shuttle:SetColorizationMaterial(2, PersonalShuttles.friend_colour2 or -16760065, 120, 20)
				shuttle:SetColorizationMaterial(3, PersonalShuttles.friend_colour3 or -1, -128, 48)
			end
			-- follow that cursor little minion
			shuttle:SetCommand("FollowMouse")
			-- we only allow it to fly for a certain amount (about 4 sols)
			shuttle.time_now = GameTime()
			-- return it so we can do viewpos on it for menu item
			return shuttle
		end
	end
end

local icon_str = CurrentModPath .. "UI/shuttle_"
local carried_str = T(302535920011134, "Carried")

-- add all our buttons to the selection panel
function OnMsg.ClassesPostprocess()

	local AddXTemplate = ChoGGi.ComFuncs.AddXTemplate
	local RetName = ChoGGi.ComFuncs.RetName

	-- pick/drop button for shuttle
	AddXTemplate("PersonalShuttles_PickDrop", "ipShuttle", {
		__context_of_kind = "PersonalShuttle",
		RolloverTitle = T(302535920011135, [[Pickup/Drop Item]]),
		RolloverText = T(302535920011136, [[Pickup: Item with "Pickup" enabled will be picked up.
Drop: select something on the ground, and carried item will be dropped nearby.]]),
		OnContextUpdate = function(self, context)
			if context.pickup_toggle then
				self:SetTitle(T(302535920011137, [[Pickup Item]]))
				self:SetIcon(icon_str .. 2 .. ".png")
			else
				self:SetTitle(T(302535920011138, [[Drop Item]]))
				self:SetIcon(icon_str .. 3 .. ".png")
			end
		end,
		func = function(self, context)
			context.pickup_toggle = not context.pickup_toggle
			ObjModified(context)
		end,
	})

	-- Info showing carried item
	AddXTemplate("PersonalShuttles_CarriedItem", "ipShuttle", {
		__context_of_kind = "PersonalShuttle",
		RolloverTitle = T(302535920011139, [[Carried Object]]),
		RolloverText = T(302535920011140, [[Shows name of carried object.]]),
		Icon = icon_str .. 4 .. ".png",
		OnContextUpdate = function(self, context)
			local obj = context.carried_obj
			if obj then
				self:SetVisible(true)
				self:SetMaxHeight()
				self:SetTitle(carried_str .. ": " .. RetName(obj))
			else
				self:SetVisible(false)
				self:SetMaxHeight(0)
			end
		end,
	})
	AddXTemplate("PersonalShuttles_Recall", "ipShuttle", {
		__context_of_kind = "PersonalShuttle",
		Title = T(302535920011141, [[Recall Shuttle]]),
		RolloverTitle = T(302535920011141, [[Recall Shuttle]]),
		RolloverText = T(302535920011142, [[Send shuttle back to hub.]]),
		Icon = icon_str .. 3 .. ".png",
		func = function(_, context)
			if type(UICity.PersonalShuttles.shuttle_threads[context.handle]) == "boolean" then
				UICity.PersonalShuttles.shuttle_threads[context.handle] = nil
			end
			-- make sure to drop off any items before
			if context.carried_obj then
				CreateGameTimeThread(function()
					context:DropCargo()
					context.recall_shuttle = true
				end)
			else
				context.recall_shuttle = true
			end
		end,
	})

	-- spawn shuttle buttons for hub and return shuttle button
	AddXTemplate("PersonalShuttles_SpawnButtonA", "customShuttleHub", {
		__context_of_kind = "ShuttleHub",
		Icon = icon_str .. 3 .. ".png",
		Title = T(302535920011143, [[Spawn Attacker]]),
		RolloverTitle = T(302535920011143, [[Spawn Attacker]]),
		RolloverText = T(302535920011144, [[Spawns a Shuttle that will follow your cursor, scan nearby selected anomalies for you, attack nearby dustdevils, and pick up items (drones, rovers, res piles, and waste rock) you've selected and marked for pickup.]]),
		func = function(self, context)
			SpawnShuttle(context, true)
		end,
	})

	AddXTemplate("PersonalShuttles_SpawnButtonF", "customShuttleHub", {
		__context_of_kind = "ShuttleHub",
		Icon = icon_str .. 2 .. ".png",
		Title = T(302535920011145, [[Spawn Friend]]),
		RolloverTitle = T(302535920011145, [[Spawn Friend]]),
		RolloverText = T(302535920011146, [[Spawns a Shuttle that will follow your cursor, scan nearby selected anomalies for you, and pick up items (drones, rovers, res piles, and waste rock) you've selected and marked for pickup.]]),
		func = function(self, context)
			SpawnShuttle(context)
		end,
	})

	AddXTemplate("PersonalShuttles_RecallButton", "customShuttleHub", {
		__context_of_kind = "ShuttleHub",
		__condition = function(_, context)
			for i = 1, #context.shuttle_infos do
				local shuttle = context.shuttle_infos[i].shuttle_obj
				if shuttle and shuttle.class == "PersonalShuttle" then
					return true
				end
			end
		end,
		Icon = icon_str .. 4 .. ".png",
		Title = T(302535920011147, [[Recall Shuttles]]),
		RolloverTitle = T(302535920011147, [[Recall Shuttles]]),
		RolloverText = T(302535920011148, [[Recalls all personal shuttles you've spawned at this Shuttle Hub.]]),
		func = function(_, context)
			local UICity = UICity
			for i = 1, #context.shuttle_infos do
				local shuttle = context.shuttle_infos[i].shuttle_obj
				if shuttle and shuttle.class == "PersonalShuttle" then
					if type(UICity.PersonalShuttles.shuttle_threads[shuttle.handle]) == "boolean" then
						UICity.PersonalShuttles.shuttle_threads[shuttle.handle] = nil
					end
					-- make sure to drop off any items before
					if shuttle.carried_obj then
						CreateGameTimeThread(function()
							shuttle:DropCargo()
							shuttle.recall_shuttle = true
						end)
					else
						shuttle.recall_shuttle = true
					end
				end
			end
		end,
	})

	-- add mark for pickup buttons to certain resource piles
	local res_table = {
		__condition = function()
			if #(UICity.labels.PersonalShuttle or "") > 0 then
				return true
			end
		end,
		RolloverTitle = T(302535920011149, [[Mark For Pickup]]),
		RolloverText = T(302535920011150, [[Change this to Pickup, keep mouse pointer nearby, and wait for shuttle.]]),
		OnContextUpdate = function(self, context)
			if context.PersonalShuttles_PickUpItem then
				self:SetTitle(T(302535920011137, [[Pickup Item]]))
				self:SetRolloverTitle(T(302535920011151, [[Marked For Pickup]]))
				self:SetIcon(icon_str .. 2 .. ".png")
			else
				self:SetTitle(T(302535920011152, [[Ignore Item]]))
				self:SetRolloverTitle(T(302535920011153, [[Mark For Pickup]]))
				self:SetIcon(icon_str .. 1 .. ".png")
			end
		end,
		func = function(self, context)
			if context.PersonalShuttles_PickUpItem then
				context.PersonalShuttles_PickUpItem = nil
			else
				context.PersonalShuttles_PickUpItem = true
			end
			ObjModified(context)
		end,
	}

	AddXTemplate("PersonalShuttles_ResourceStockpile", "ipResourcePile", res_table)

	res_table.__context_of_kind = "Drone"
	AddXTemplate("PersonalShuttles_ResourceDrone", "ipDrone", res_table)

	res_table.__context_of_kind = "BaseRover"
	AddXTemplate("PersonalShuttles_ResourceRover", "ipRover", res_table)

	res_table.__context_of_kind = "UniversalStorageDepot"
	res_table.__condition = function(_, context)
		if #(UICity.labels.PersonalShuttle or "") > 0 then
			-- make sure we can only pickup actual depots, not rockets or elevators...
			return IsKindOf(context, "UniversalStorageDepot") and not context:IsKindOf("RocketBase") and not IsKindOf(context, "SpaceElevator")
		end
	end
	AddXTemplate("PersonalShuttles_UniversalStorageDepot", "ipBuilding", res_table)

end -- OnMsg
