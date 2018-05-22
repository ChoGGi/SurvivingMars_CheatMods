function ChoGGi.MsgFuncs.ShuttleControl_ClassesGenerate()
  --custom shuttletask
  DefineClass.ChoGGi_ShuttleFollowTask = {
    __parents = {"InitDone"},
    state = "new",
    shuttle = false,
    scanning = false, --from explorer code for AnalyzeAnomaly
    dest_pos = false --there isn't one, but adding one prevents log spam
  }
end

function ChoGGi.MsgFuncs.ShuttleControl_ClassesBuilt()
  --
  function CargoShuttle:ChoGGi_DefenceTickD(ChoGGi)
    if self.ChoGGi_FollowMouseShuttle and ChoGGi.Temp.CargoShuttleThreads[self.handle] then
      return ChoGGi.CodeFuncs.DefenceTick(self,ChoGGi.Temp.ShuttleRocketDD)
    end
  end

  --dust for the shuttle
  local function duston(shut)
    if not shut.ChoGGi_Landed and not shut.ChoGGi_DustOn then
      PlayFX("Dust", "start", shut)
      shut.ChoGGi_DustOn = true
    end
  end

--				Movable.Goto(drone, pt) -- Unit.Goto is a command, use this instead for direct control

  --get shuttle to follow mouse
  function CargoShuttle:ChoGGi_FollowMouse(newpos)
    local point = point
    local PlayFX = PlayFX
    local terrain = terrain
    local Sleep = Sleep
    local GetObjects = GetObjects
    local NearestObject = NearestObject
    local GameTime = GameTime
    --when shuttle isn't moving it gets magical fuel from somewhere so we use a timer
    local timenow = GameTime()
    local idle = 0
    duston(self)
    repeat
      --atttack dustdevils/meteors
      local sel = SelectedObj
      local pos = self:GetVisualPos()
      local dest = GetTerrainCursor()
      local x = pos:x()
      local y = pos:y()
      --if x ~= dest:x() or y ~= dest:y() then
        --don't try to fly if pos or dest aren't different (spams log)
        local path = self:CalcPath(pos, dest)
        local destp = path[#path][#path[#path]] or path[#path][#path][#path] or pos
        --check the last path point to see if it's far away (can't be bothered to make a new func that allows you to break off the path)
        --and if we move when we're too close it's jerky
        local dist = point(x,y):Dist(destp) < 50000 and point(x,y):Dist(destp) > 2000
        if newpos or dist or idle > 50 then
          self.hover_height = 0
          --rest on ground
          if idle > 50 and pos:z() ~= terrain.GetHeight(pos) then
            --self:FollowPathCmd(self:CalcPath(pos, point(x+UICity:Random(-5000,5000),y+UICity:Random(-5000,5000))))
            self:FollowPathCmd(self:CalcPath(pos, point(x+500,y+500)))
            --this may not have been set so make sure we turn off dust
            self.ChoGGi_Landed = true
            self.ChoGGi_DustOn = nil
            PlayFX("Dust", "end", self)
          --goto cursor
          --elseif newpos or dist or idle > 150 then
          elseif newpos or dist then
            --reset idle count
            idle = 0
            --we don't want to skim the ground (default is 3, but this one likes living life on the edge)
            self.hover_height = 1000
            --from pinsdlg
            if newpos then
              path = self:CalcPath(pos, newpos)
              newpos = nil
            end
            if self.ChoGGi_Landed then
              self.ChoGGi_Landed = nil
              PlayFX("DomeExplosion", "start", self)
            end
            self:FollowPathCmd(path)
            --re-add the dust after a bit
            Sleep(250)
            duston(self)
          end
        end
        if sel and sel ~= self then
          if sel:IsKindOf("SubsurfaceAnomaly") then
            --scan nearby SubsurfaceAnomaly
            local anomaly = NearestObject(pos,GetObjects({class="SubsurfaceAnomaly"}),2000)
            --make sure it's the right one, and not already being scanned by another
            if anomaly and sel == anomaly and not ChoGGi.Temp.CargoShuttleScanningAnomaly[anomaly.handle] then
              PlayFX("ArtificialSunCharge", "start", anomaly)
              ChoGGi.Temp.CargoShuttleScanningAnomaly[anomaly.handle] = true
              ChoGGi.CodeFuncs.AnalyzeAnomaly(self, anomaly)
              PlayFX("ArtificialSunCharge", "end", anomaly)
            end
          elseif type(ChoGGi.Temp.Testing) == "function" and sel:IsKindOfClasses("ResourceStockpile", "SurfaceDepositGroup", "ResourcePile") then
            --if carrying resource then drop it off
            local stockpile = NearestObject(pos,GetObjects({class=sel.class}),2000)
            if stockpile and sel == stockpile then
              local supply --userdata
              local demand --userdata
              local resource --string
              if sel:IsKindOf("SurfaceDepositGroup") then
                supply = sel.group[1].task_requests[1]
                demand = sel.group[1].transport_request
                resource = sel.group[1].encyclopedia_id
              elseif sel:IsKindOf("ResourceStockpile") then
                supply = sel.supply_request
                demand = sel.task_requests[1]
                resource = sel.resource
              end
              self.transport_task[2] = supply
              self.transport_task[3] = demand
              self.transport_task[4] = resource
              print("pickup")
              self:PickUp()
            end
          end
        --end
      end
      --so shuttle follows the mouse after awhile if shuttle is too far away
      idle = idle + 1
      Sleep(300 + idle)
    --about 4 sols then send it back home
    until GameTime() - timenow > 2000000
  end
  function CargoShuttle:FireRocket(_, target, rocket_class, luaobj)
    local pos = self:GetSpotPos(1)
    local angle, axis = self:GetSpotRotation(1)
    rocket_class = rocket_class or "RocketProjectile"
    luaobj = luaobj or {}
    luaobj.shooter = luaobj.shooter or self
    luaobj.target = luaobj.target or target
    local rocket = PlaceObject(rocket_class, luaobj)
    rocket:Place(pos, axis, angle)
    rocket:StartMoving()
    PlayFX("MissileFired", "start", self, nil, pos, rocket.move_dir)
    return rocket
  end

end
