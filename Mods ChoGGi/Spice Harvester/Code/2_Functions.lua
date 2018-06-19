local pairs = pairs
local GetRandomPassable = GetRandomPassable
local GetTerrainCursor = GetTerrainCursor

--which true=attack,false=friend
function SpiceHarvester.CodeFuncs.SpawnShuttle(hub)
--~   local hub_pos = hub:GetVisualPos()
  local SpiceHarvester = SpiceHarvester
  for _, s_i in pairs(hub.shuttle_infos) do
--~   print("s_i",s_i.hub.has_free_landing_slots)
    if s_i:CanLaunch() and s_i.hub and s_i.hub.has_free_landing_slots then
--~     if s_i:CanLaunch() and s_i.hub then
      --ShuttleInfo:Launch(task)
      local hub = s_i.hub
      --LRManagerInstance
      local shuttle = CargoShuttle:new({
        hub = hub,
        transport_task = SpiceHarvester_ShuttleFollowTask:new({
          state = "ready_to_follow",
          dest_pos = GetTerrainCursor() or GetRandomPassable()
        }),
        info_obj = s_i
      })
      s_i.shuttle_obj = shuttle
      local slot = hub:ReserveLandingSpot(shuttle)
      shuttle:SetPos(slot.pos)
--~       shuttle:SetPos(point(hub_pos:x(),hub_pos:y(),hub_pos:z()+500))
      --CargoShuttle:Launch()
      shuttle:PushDestructor(function(s)
        hub:ShuttleLeadOut(s)
        hub:FreeLandingSpot(s)
      end)
      local amount = 0
      for _ in pairs(UICity.SpiceHarvester.CargoShuttleThreads) do
        amount = amount + 1
      end
      if amount <= SpiceHarvester.UserSettings.Max_Shuttles or 50 then
        UICity.SpiceHarvester.CargoShuttleThreads[shuttle.handle] = true
        shuttle:SetColor1(SpiceHarvester.UserSettings.Color1 or -12247037)
        shuttle:SetColor2(SpiceHarvester.UserSettings.Color2 or -11196403)
        shuttle:SetColor3(SpiceHarvester.UserSettings.Color3 or -13297406)
        --easy way to get amount of shuttles about
        UICity.SpiceHarvester.CargoShuttleThreads[#UICity.SpiceHarvester.CargoShuttleThreads+1] = true
        shuttle.SpiceHarvester_FollowHarvesterShuttle = true
        shuttle.SpiceHarvester_Harvester = hub.ChoGGi_Parent
        --follow that cursor little minion
        shuttle:SetCommand("SpiceHarvester_FollowHarvester")
        --we only allow it to fly for a certain amount (about 4 sols)
--~         shuttle.timenow = GameTime()
        --nice n slow
        shuttle.max_speed = 1000

        --return it so we can do viewpos on it for menu item
        return shuttle
        --since we found a shuttle break the loop
--~         break
      end
    end
  end
end
