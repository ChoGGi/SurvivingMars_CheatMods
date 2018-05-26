function ChoGGiX.MsgFuncs.ShuttleControl_ClassesGenerate()
  --custom shuttletask
  DefineClass.ChoGGiX_ShuttleFollowTask = {
    __parents = {"InitDone"},
    state = "new",
    shuttle = false,
    scanning = false, --from explorer code for AnalyzeAnomaly
    dest_pos = false, --there isn't one, but adding one prevents log spam
  }
end

function ChoGGiX.MsgFuncs.ShuttleControl_ClassesPreprocess()
  local c = CargoShuttle
  c.ChoGGiX_DefenceTickD = false
  c.__parents[#c.__parents] = "PinnableObject"
end

function ChoGGiX.MsgFuncs.ShuttleControl_ClassesBuilt()

  if ChoGGiX.UserSettings.ShowShuttleControls then
    local XTemplates = XTemplates
--pick/drop button for shuttle
    local Table = {
      __context_of_kind = "CargoShuttle",
      Icon = "",
      Title = "",
      RolloverTitle = "Pickup/Drop Item",
      RolloverHint = "Change to Pickup and select resource pile you've previously marked for pickup.\nToggle it back to \"Drop Item\" and select an object: it'll drop it (somewhat) next to it.",
      OnContextUpdate = function(self, context)
        --only show when it's one of our shuttles
        if context.ChoGGiX_FollowMouseShuttle then
          self:SetVisible(true)
          self:SetMaxHeight()
        else
          self:SetVisible(false)
          self:SetMaxHeight(0)
        end
        --set title and icon
        if context.ChoGGiX_PickUp_Toggle then
          self:SetTitle("Pickup Item")
          self:SetIcon("UI/Icons/Sections/shuttle_2.tga")
        else
          self:SetTitle("Drop Item")
          self:SetIcon("UI/Icons/Sections/shuttle_3.tga")
        end
      end,
      func = function(self, context)
        if context.ChoGGiX_FollowMouseShuttle then
          context.ChoGGiX_PickUp_Toggle = not context.ChoGGiX_PickUp_Toggle
          ObjModified(context)
        end
      end
    }
    ChoGGiX.CodeFuncs.AddXTemplate("ChoGGiX_CustomPane1","ipShuttle",Table,XTemplates)
--spawn shuttle buttons for hub and return shuttle button
    Table = {
      __context_of_kind = "ShuttleHub",
      Icon = "UI/Icons/Sections/shuttle_3.tga",
      Title = "Spawn Attacker",
      RolloverTitle = "Spawn Attacker",
      RolloverHint = "Spawns a Shuttle that will follow your cursor, scan nearby selected anomalies for you, attack nearby dustdevils, and pick up resources you've selected and marked for pickup.\nPin it and right-click the pin to have it come to your position.",
      func = function(self, context)
        ChoGGiX.CodeFuncs.SpawnShuttle(context,true)
      end
    }
    ChoGGiX.CodeFuncs.AddXTemplate("ChoGGiX_CustomPane1","customShuttleHub",Table,XTemplates)
    --
    Table = {
      __context_of_kind = "ShuttleHub",
      Icon = "UI/Icons/Sections/shuttle_2.tga",
      Title = "Spawn Friend",
      RolloverTitle = "Spawn Friend",
      RolloverHint = "Spawns a Shuttle that will follow your cursor, scan nearby selected anomalies for you, and pick up resources you've selected and marked for pickup.\nPin it and right-click the pin to have it come to your position.",
      func = function(self, context)
        ChoGGiX.CodeFuncs.SpawnShuttle(context)
      end
    }
    ChoGGiX.CodeFuncs.AddXTemplate("ChoGGiX_CustomPane2","customShuttleHub",Table,XTemplates)
    --
    Table = {
      __context_of_kind = "ShuttleHub",
      Icon = "UI/Icons/Sections/shuttle_4.tga",
      Title = "Recall Shuttles",
      RolloverTitle = "Recall Shuttles",
      RolloverHint = "Recalls all shuttles you've spawned at this ShuttleHub.",
      func = function(self, context)
        ChoGGiX.CodeFuncs.RecallShuttlesHub(context)
      end
    }
    ChoGGiX.CodeFuncs.AddXTemplate("ChoGGiX_CustomPane3","customShuttleHub",Table,XTemplates)
--add mark for pickup buttons to certain resource piles
    local hint_mark = "Change this to Pickup, then select a spawned shuttle and have it come on by."
    local title1 = "Ignore Item"
    local title2 = "Pickup Item"
    local icon1 = "UI/Icons/Sections/shuttle_1.tga"
    local icon2 = "UI/Icons/Sections/shuttle_2.tga"
    local hint_marktitle1 = "Mark For Pickup"
    local hint_marktitle2 = "Marked For Pickup"
    Table = {
      __context_of_kind = "ResourceStockpile",
      RolloverTitle = "Mark For Pickup",
      RolloverHint = hint_mark,
      OnContextUpdate = function(self, context)
        if not context.ChoGGiX_PickUpItem then
          self:SetTitle(title1)
          self:SetRolloverTitle(hint_marktitle1)
          self:SetIcon(icon1)
        else
          self:SetTitle(title2)
          self:SetRolloverTitle(hint_marktitle2)
          self:SetIcon(icon2)
        end
      end,
      func = function(self, context)
        context.ChoGGiX_PickUpItem = not context.ChoGGiX_PickUpItem
        ObjModified(context)
      end
    }
    ChoGGiX.CodeFuncs.AddXTemplate("ChoGGiX_CustomPane1","ipResourcePile",Table,XTemplates)
    --
    Table = {
      __context_of_kind = "Drone",
      RolloverTitle = "Mark For Pickup",
      RolloverHint = hint_mark,
      OnContextUpdate = function(self, context)
        if not context.ChoGGiX_PickUpItem then
          self:SetTitle(title1)
          self:SetRolloverTitle(hint_marktitle1)
          self:SetIcon(icon1)
        else
          self:SetTitle(title2)
          self:SetRolloverTitle(hint_marktitle2)
          self:SetIcon(icon2)
        end
      end,
      func = function(self, context)
        context.ChoGGiX_PickUpItem = not context.ChoGGiX_PickUpItem
        ObjModified(context)
      end
    }
    ChoGGiX.CodeFuncs.AddXTemplate("ChoGGiX_CustomPane3","ipDrone",Table,XTemplates)
    --
    Table = {
      __context_of_kind = "BaseRover",
      RolloverTitle = "Mark For Pickup",
      RolloverHint = hint_mark,
      OnContextUpdate = function(self, context)
        if not context.ChoGGiX_PickUpItem then
          self:SetTitle(title1)
          self:SetRolloverTitle(hint_marktitle1)
          self:SetIcon(icon1)
        else
          self:SetTitle(title2)
          self:SetRolloverTitle(hint_marktitle2)
          self:SetIcon(icon2)
        end
      end,
      func = function(self, context)
        context.ChoGGiX_PickUpItem = not context.ChoGGiX_PickUpItem
        ObjModified(context)
      end
    }
    ChoGGiX.CodeFuncs.AddXTemplate("ChoGGiX_CustomPane3","ipRover",Table,XTemplates)
    --
    Table = {
      __context_of_kind = "UniversalStorageDepot",
      RolloverTitle = "",
      RolloverHint = hint_mark,
      OnContextUpdate = function(self, context)
        if not context.ChoGGiX_PickUpItem then
          self:SetTitle(title1)
          self:SetRolloverTitle(hint_marktitle1)
          self:SetIcon(icon1)
        else
          self:SetTitle(title2)
          self:SetRolloverTitle(hint_marktitle2)
          self:SetIcon(icon2)
        end
      end,
      func = function(self, context)
        context.ChoGGiX_PickUpItem = not context.ChoGGiX_PickUpItem
        ObjModified(context)
      end
    }
    ChoGGiX.CodeFuncs.AddXTemplate("ChoGGiX_CustomPane4","sectionStorage",Table,XTemplates)
  end

  --dustdevil thread for rockets
  function CargoShuttle:ChoGGiX_DefenceTickD(ChoGGiX)
    if self.ChoGGiX_FollowMouseShuttle and ChoGGiX.Temp.CargoShuttleThreads[self.handle] then
      return ChoGGiX.CodeFuncs.DefenceTick(self,ChoGGiX.Temp.ShuttleRocketDD)
    end
  end

  function CargoShuttle:ChoGGiX_IsFollower()
    if not self.ChoGGiX_FollowMouseShuttle then
      self:SetCommand("Idle")
    end
  end

  --get shuttle to follow mouse
  function CargoShuttle:ChoGGiX_FollowMouse(newpos)
    self:ChoGGiX_IsFollower()

    local ChoGGiX = ChoGGiX
    local PlayFX = PlayFX
    local Sleep = Sleep
    local GameTime = GameTime
    local terrain = terrain
    --when shuttle isn't moving it gets magical fuel from somewhere so we use a timer
    local idle = 0
    --always start it off as pickup
    self.ChoGGiX_PickUp_Toggle = true
    repeat
      local x,y,z = self:GetVisualPosXYZ()
      local dest = GetTerrainCursor()

      self:ChoGGiX_Goto(ChoGGiX,PlayFX,terrain,Sleep,point(x,y,z),x,y,z,dest,idle,newpos)
      --scanning/resource
      self:ChoGGiX_SelectedObject(ChoGGiX,PlayFX,SelectedObj,point(x,y,z),dest)
      --idle = idle + 1
      idle = idle + 10
      Sleep(250 + idle)
    --about 4 sols then send it back home (or if we recalled it)
    until (GameTime() - self.timenow > 2000000) or not self.ChoGGiX_FollowMouseShuttle
    --so it can set the GoHome command (we normally blocked it)
    self.ChoGGiX_FollowMouseShuttle = nil
    --buh-bye little flying companion
    self:SetCommand("GoHome")
  end

  function CargoShuttle:ChoGGiX_Goto(ChoGGiX,PlayFX,terrain,Sleep,pos,x,y,z,dest,idle,newpos)
    if not dest then
      return
    end
    --don't try to fly if pos or dest aren't different (spams log)
    local path = self:CalcPath(pos, dest)
    local destp = path[#path][#path[#path]] or path[#path][#path][#path] or pos
    --check the last path point to see if it's far away (can't be bothered to make a new func that allows you to break off the path)
    --and if we move when we're too close it's jerky
    local dist = point(x,y):Dist(destp) < 100000 and point(x,y):Dist(destp) > 6000
    if newpos or dist or idle > 250 then
      --rest on ground
      self.hover_height = 0

      --if idle is ticking up
      if idle > 250 then
        if not self.ChoGGiX_Landed then
          PlayFX("Dust", "start", self)
          self:FollowPathCmd(self:CalcPath(pos, point(x+UICity:Random(-1500,1500),y+UICity:Random(-1500,1500))))
          self.ChoGGiX_Landed = self:GetPos()
          Sleep(750)
          PlayFX("Dust", "end", self)
        --10000 = flat ground (shuttle h and ground h and different below, so ignore)
        elseif z >= 10000 and z ~= terrain.GetSurfaceHeight(pos) then
          --if shuttle is resting above ground
          PlayFX("Dust", "start", self)
          self:FollowPathCmd(self:CalcPath(pos, point(x+1000,y+1000,0)))
          Sleep(750)
          PlayFX("Dust", "end", self)
        end
        Sleep(500+idle)
      end
      --mouse moved far enough then wake up and fly
      if newpos or dist then
        --print("fly S")
        --reset idle count
        idle = 0
        --we don't want to skim the ground (default is 3, but this one likes living life on the edge)
        self.hover_height = 1500
        --from pinsdlg
        if newpos then
          --want to be kinda random (when there's lots of shuttles about)
          if #ChoGGiX.Temp.CargoShuttleThreads > 10 then
            path = self:CalcPath(
              pos,
              point(newpos:x()+UICity:Random(-2500,2500),newpos:y()+UICity:Random(-2500,2500),1500)
            )
          else
            path = self:CalcPath(pos, newpos)
          end
          newpos = nil
        end
        if self.ChoGGiX_Landed then
          self.ChoGGiX_Landed = nil
          PlayFX("DomeExplosion", "start", self)
        end
        self:FollowPathCmd(path)
      end
    end
  end

  function CargoShuttle:ChoGGiX_SelectedObject(ChoGGiX,PlayFX,sel,pos,dest)
    if sel and sel ~= self then
      --Anomaly scanning
      if sel:IsKindOf("SubsurfaceAnomaly") then
        --scan nearby SubsurfaceAnomaly
        local anomaly = NearestObject(pos,GetObjects({class="SubsurfaceAnomaly"}),2000)
        --make sure it's the right one, and not already being scanned by another
        if anomaly and sel == anomaly and not ChoGGiX.Temp.CargoShuttleScanningAnomaly[anomaly.handle] then
          PlayFX("ArtificialSunCharge", "start", anomaly)
          ChoGGiX.Temp.CargoShuttleScanningAnomaly[anomaly.handle] = true
          ChoGGiX.CodeFuncs.AnalyzeAnomaly(self, anomaly)
          PlayFX("ArtificialSunCharge", "end", anomaly)
        end
      --resource moving

      --are we carrying?
      elseif self.ChoGGiX_carriedObj and self.ChoGGiX_PickUp_Toggle == false then
        --we want to drop obj next to sel

        self.hover_height = 100
        local carried = self.ChoGGiX_carriedObj

        --local pass = GetPassablePointNearby(dest)
        self:FollowPathCmd(self:CalcPath(pos,dest))
        --move it

        --carried:SetPos(HexGetNearestCenter(dest))
        carried:Detach()

        --carried:SetPos(HexGetNearestCenter(pass))
        if type(carried.Idle) == "function" then
          carried:SetCommand("Idle")
        end

        self.ChoGGiX_carriedObj = nil
        --make it able to pick up again without having to press the button
        self.ChoGGiX_PickUp_Toggle = true
        self.hover_height = 1500

      --PICKUP
      else
        --if it's marked for pickup and shuttle is set to pickup and it isn't already carrying then grab it
        if sel.ChoGGiX_PickUpItem and self.ChoGGiX_PickUp_Toggle and not self.ChoGGiX_carriedObj then

          --goto item
          self.hover_height = 100
          self:FollowPathCmd(self:CalcPath(pos,sel:GetVisualPos()))

          --remove pickup mark from it
          sel.ChoGGiX_PickUpItem = nil
          --PlayFX of beaming, transport one i think
          Sleep(1000)

          --"pick it up" (move it below the ground so it isn't visible and save the object locally)
          --sel:SetPos(point(0,0,0))
          --actually picks it up woot!
          self:Attach(sel,self:GetSpotBeginIndex("Top"))

          --make sure we know we have cargo
          self.ChoGGiX_carriedObj = sel
          self.hover_height = 1500
        end
      end
    end --scanning/resource
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
