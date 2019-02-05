-- See LICENSE for terms

local IsKindOf = IsKindOf

local function SomeCode()
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

function OnMsg.CityStart()
  SomeCode()
end

function OnMsg.LoadGame()
  SomeCode()
end


function OnMsg.NewDay() -- newsol
  local UICity = UICity

  -- clean up old handles
	local IsValid = IsValid
	local HandleToObject = HandleToObject
  if next(UICity.PersonalShuttles.shuttle_threads) then
    for h,_ in pairs(UICity.PersonalShuttles.shuttle_threads) do
      if not IsValid(HandleToObject[h]) then
        UICity.PersonalShuttles.shuttle_threads[h] = nil
      end
    end
  end

end

-- which true=attack,false=friend
local function SpawnShuttle(hub,attacker)
	local PersonalShuttles = PersonalShuttles
	local UICity = UICity
	for i = 1, #hub.shuttle_infos do
		local s_i = hub.shuttle_infos[i]
		if s_i:CanLaunch() and s_i.hub.has_free_landing_slots then
			if #(UICity.labels.PersonalShuttle or "") >= (PersonalShuttles.max_shuttles or 50) then
				ChoGGi.ComFuncs.MsgPopup(
					[[Max of 50 (somewhere above 50 and below 100 it crashes).]],
					S[745--[[Shuttles--]]]
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
				shuttle:SetColor1(PersonalShuttles.attacker_color1 or -9624026)
				shuttle:SetColor2(PersonalShuttles.attacker_color2 or 0)
				shuttle:SetColor3(PersonalShuttles.attacker_color3 or -13892861)
			else
				UICity.PersonalShuttles.shuttle_threads[shuttle.handle] = false
				shuttle:SetColor1(PersonalShuttles.friend_colour1 or -16711941)
				shuttle:SetColor2(PersonalShuttles.friend_colour2 or -16760065)
				shuttle:SetColor3(PersonalShuttles.friend_colour3 or -1)
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

local icon_str = CurrentModPath .. "UI/shuttle_%s.png"
local carried_str = "Carried: %s"

-- add all our buttons to the selection panel
function OnMsg.ClassesBuilt()

	local AddXTemplate = ChoGGi.ComFuncs.AddXTemplate
	local RetName = ChoGGi.ComFuncs.RetName
--~ 	local S = ChoGGi.Strings

	-- pick/drop button for shuttle
	AddXTemplate("PersonalShuttles_PickDrop","ipShuttle",{
		__context_of_kind = "PersonalShuttle",
		RolloverTitle = [[Pickup/Drop Item]],
		RolloverText = [[Pickup: Item with "Pickup" enabled will be picked up.
Drop: select something on the ground, and carried item will be dropped nearby.]],
		OnContextUpdate = function(self, context)
			if context.pickup_toggle then
				self:SetTitle([[Pickup Item]])
				self:SetIcon(icon_str:format(2))
			else
				self:SetTitle([[Drop Item]])
				self:SetIcon(icon_str:format(3))
			end
		end,
		func = function(self, context)
			context.pickup_toggle = not context.pickup_toggle
			ObjModified(context)
		end,
	})

	-- info showing carried item
	AddXTemplate("PersonalShuttles_CarriedItem","ipShuttle",{
		__context_of_kind = "PersonalShuttle",
		RolloverTitle = [[Carried Object]],
		RolloverText = [[Shows name of carried object.]],
		Icon = icon_str:format(4),
		OnContextUpdate = function(self, context)
			local obj = context.carried_obj
			if obj then
				self:SetVisible(true)
				self:SetMaxHeight()
				self:SetTitle(carried_str:format(RetName(obj)))
			else
				self:SetVisible(false)
				self:SetMaxHeight(0)
			end
		end,
	})
	AddXTemplate("PersonalShuttles_Recall","ipShuttle",{
		__context_of_kind = "PersonalShuttle",
		Title = [[Recall Shuttle]],
		RolloverTitle = [[Recall Shuttle]],
		RolloverText = [[Send shuttle back to hub.]],
		Icon = icon_str:format(3),
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
	AddXTemplate("PersonalShuttles_SpawnButtonA","customShuttleHub",{
		__context_of_kind = "ShuttleHub",
		Icon = icon_str:format(3),
		Title = [[Spawn Attacker]],
		RolloverTitle = [[Spawn Attacker]],
		RolloverText = [[Spawns a Shuttle that will follow your cursor, scan nearby selected anomalies for you, attack nearby dustdevils, and pick up items (drones, rovers, res piles, and waste rock) you've selected and marked for pickup.]],
		func = function(self, context)
			SpawnShuttle(context,true)
		end,
	})

	AddXTemplate("PersonalShuttles_SpawnButtonF","customShuttleHub",{
		__context_of_kind = "ShuttleHub",
		Icon = icon_str:format(2),
		Title = [[Spawn Friend]],
		RolloverTitle = [[Spawn Friend]],
		RolloverText = [[Spawns a Shuttle that will follow your cursor, scan nearby selected anomalies for you, and pick up items (drones, rovers, res piles, and waste rock) you've selected and marked for pickup.]],
		func = function(self, context)
			SpawnShuttle(context)
		end,
	})

	AddXTemplate("PersonalShuttles_RecallButton","customShuttleHub",{
		__context_of_kind = "ShuttleHub",
		__condition = function(_, context)
			for i = 1, #context.shuttle_infos do
				local shuttle = context.shuttle_infos[i].shuttle_obj
				if shuttle and shuttle.class == "PersonalShuttle" then
					return true
				end
			end
		end,
		Icon = icon_str:format(4),
		Title = [[Recall Shuttles]],
		RolloverTitle = [[Recall Shuttles]],
		RolloverText = [[Recalls all personal shuttles you've spawned at this Shuttle Hub.]],
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
		RolloverTitle = [[Mark For Pickup]],
		RolloverText = [[Change this to Pickup, keep mouse pointer nearby, and wait for shuttle.]],
		OnContextUpdate = function(self, context)
			if context.PersonalShuttles_PickUpItem then
				self:SetTitle([[Pickup Item]])
				self:SetRolloverTitle([[Marked For Pickup]])
				self:SetIcon(icon_str:format(2))
			else
				self:SetTitle([[Ignore Item]])
				self:SetRolloverTitle([[Mark For Pickup]])
				self:SetIcon(icon_str:format(1))
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

	AddXTemplate("PersonalShuttles_ResourceStockpile","ipResourcePile",res_table)

	res_table.__context_of_kind = "Drone"
	AddXTemplate("PersonalShuttles_ResourceDrone","ipDrone",res_table)

	res_table.__context_of_kind = "BaseRover"
	AddXTemplate("PersonalShuttles_ResourceRover","ipRover",res_table)

	res_table.__context_of_kind = "UniversalStorageDepot"
	res_table.__condition = function(_, context)
		if #(UICity.labels.PersonalShuttle or "") > 0 then
			-- make sure we can only pickup actual depots, not rockets or elevators...
			return IsKindOf(context, "UniversalStorageDepot") and not context:IsKindOf("SupplyRocket") and not IsKindOf(context, "SpaceElevator")
		end
	end
	AddXTemplate("PersonalShuttles_UniversalStorageDepot","ipBuilding",res_table)

end -- OnMsg
