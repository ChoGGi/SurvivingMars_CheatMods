function ChoGGi.MsgFuncs.ShuttleControl_ClassesGenerate()
  --custom shuttletask
  DefineClass.ChoGGi_ShuttleFollowTask = {
    __parents = {"InitDone"},
    state = "new",
    shuttle = false,
    scanning = false, --from explorer code for AnalyzeAnomaly
    dest_pos = false, --there isn't one, but adding one prevents log spam
    reload_time = false,
    shoot_range = false,
    track_thread = false,
    defence_thread_DD = false,
  }
end

function ChoGGi.MsgFuncs.ShuttleControl_ClassesBuilt()

  --add infopanel button
  if table.find(XTemplates.ipRover[1], "UniqueId", "ChoGGi_ShuttleHub") then
      return
  end
--[[
  table.insert(XTemplates.ipRover[1],
      PlaceObj("XTemplateTemplate", {
          "__context_of_kind", "ShuttleHub",
          "__template", "InfopanelActiveSection",
          "Icon", "UI/Icons/Upgrades/factory_ai_02.tga",
          "Title", T{AutoGatherTransport.StringIdBase + 11, "Auto Gather"},
          "RolloverText", T{AutoGatherTransport.StringIdBase + 12, "Enable/Disable automatic gathering of surface deposits by this rover.<newline><newline>(AutoGatherTransport mod)"},
          "RolloverTitle", T{AutoGatherTransport.StringIdBase + 13, "Auto Gather"},
          "RolloverHint",  T{AutoGatherTransport.StringIdBase + 14, "<left_click> Toggle setting"},
          "OnContextUpdate",
              function(self, context)
                  if context.auto_gather then
                      self:SetTitle("Spawn Attacker"})
                      self:SetIcon("UI/Icons/Upgrades/factory_ai_02.tga")
                  else
                      self:SetTitle("Spawn Friend")
                      self:SetIcon("UI/Icons/Upgrades/factory_ai_01.tga")
                  end
              end,
              "UniqueId", "AutoGatherTransport-1"
      }, {
          PlaceObj("XTemplateFunc", {
              "name", "OnActivate(self, context)",
              "parent", function(parent, context)
                      return parent.parent
                  end,
              "func", function(self, context)
                      context.auto_gather = not context.auto_gather
                      ObjModified(context)
                  end
          })
      })
  )
--]]
  --
  function CargoShuttle:ChoGGi_DefenceTickD(ChoGGi)
    if self.ChoGGi_FollowMouseShuttle and ChoGGi.Temp.CargoShuttleThreads[self.handle] then
      return ChoGGi.CodeFuncs.DefenceTick(self,ChoGGi.Temp.ShuttleRocketDD)
    end
  end

--				Movable.Goto(drone, pt) -- Unit.Goto is a command, use this instead for direct control

  --get shuttle to follow mouse
  function CargoShuttle:GroundWait(Amount)
    Sleep(Amount or 500)
  end

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
    repeat
      --atttack dustdevils/meteors
      local sel = SelectedObj
      local pos = self:GetVisualPos()
      local dest = GetTerrainCursor()
      local x = pos:x()
      local y = pos:y()
      local z = pos:z()
      --if x ~= dest:x() or y ~= dest:y() then
        --don't try to fly if pos or dest aren't different (spams log)
        local path = self:CalcPath(pos, dest)
        local destp = path[#path][#path[#path]] or path[#path][#path][#path] or pos
        --check the last path point to see if it's far away (can't be bothered to make a new func that allows you to break off the path)
        --and if we move when we're too close it's jerky
        local dist = point(x,y):Dist(destp) < 50000 and point(x,y):Dist(destp) > 8000
        if newpos or dist or idle > 50 then
          self.hover_height = 0
          --rest on ground
          --if idle is ticking up
          if idle > 50 then
            if not self.ChoGGi_Landed then
              PlayFX("Dust", "start", self)
              --self:FollowPathCmd(self:CalcPath(pos, point(x+UICity:Random(-3500,3500),y+UICity:Random(-3500,3500))))
              self:FollowPathCmd(self:CalcPath(pos, point(x+UICity:Random(-1500,1500),y+UICity:Random(-1500,1500))))
              --self:FollowPathCmd(self:CalcPath(pos, point(x+1000,y+1000)))
              self.ChoGGi_Landed = self:GetPos()
               PlayFX("Dust", "end", self)
           elseif z ~= terrain.GetHeight(pos) then
              print("-------------z: " .. z .. " gt: " .. terrain.GetHeight(pos))
              --check if shuttle is resting above ground
              self:FollowPathCmd(self:CalcPath(pos, point(x+1000,y+1000)))
            end
            Sleep(750+idle)
            --print("GroundWait E")
          end
          --mouse moved far enough then wake up and fly
          if newpos or dist then
            --print("fly S")
            --reset idle count
            idle = 0
            --we don't want to skim the ground (default is 3, but this one likes living life on the edge)
            self.hover_height = 1000
            --from pinsdlg
            if newpos then
              --path = self:CalcPath(pos, newpos)
              --want to be kinda random (when there's lots of shuttles about)
              path = self:CalcPath(
                point(x+UICity:Random(-2500,2500),y+UICity:Random(-2500,2500),1000),
                point(newpos:x()+UICity:Random(-2500,2500),newpos:y()+UICity:Random(-2500,2500),1000)
              )
              newpos = nil
            end
            if self.ChoGGi_Landed then
              self.ChoGGi_Landed = nil
              PlayFX("DomeExplosion", "start", self)
            end
            self:FollowPathCmd(path)
          end
        end
        --scanning/resource
        if sel and sel ~= self then
          --Anomaly scanning
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
          --resource moving
          elseif type(ChoGGi.Temp.Testing) == "function" and sel:IsKindOfClasses("ResourceStockpile", "SurfaceDepositGroup", "ResourcePile") then
            --if carrying resource then drop it off when key is held
          --hold down key to pick obj or just select?
          --if self.ChoGGi_carriedobj then
          --:Attach() to shuttle then hold down key for drop off, or selected res and same type as carried then add it
          --probably should just drop it where mouse and when key is hold down, KISS

            if not _G then
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
          end
        --end
      end
      --so shuttle follows the mouse after awhile if shuttle is too far away
      idle = idle + 1
      Sleep(300 + idle)
    --about 4 sols then send it back home
    until GameTime() - timenow > 2000000
    print("TIMESUP")
    --so it can set the GoHome command (we block it)
    ChoGGi.Temp.CargoShuttleThreads[self.handle] = nil
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
