--See LICENSE for terms

function ChoGGi.MsgFuncs.ShuttleControl_ClassesGenerate()
  --custom shuttletask
  DefineClass.ChoGGi_ShuttleFollowTask = {
    __parents = {"InitDone"},
    state = "new",
    shuttle = false,
    scanning = false, --from explorer code for AnalyzeAnomaly
    dest_pos = false, --there isn't one, but adding one prevents log spam
  }
end

function ChoGGi.MsgFuncs.ShuttleControl_ClassesPreprocess()
  local c = CargoShuttle
  c.ChoGGi_DefenceTickD = false

  c.__parents[#c.__parents] = "PinnableObject"
  --c.__parents[#c.__parents] = "Vehicle"
  --c.__parents[#c.__parents] = "CityObject"
  --c.__parents[#c.__parents] = "NightLightObject"

end

function ChoGGi.MsgFuncs.ShuttleControl_ClassesBuilt()

  if ChoGGi.UserSettings.ShowShuttleControls then
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
        if context.ChoGGi_FollowMouseShuttle then
          self:SetVisible(true)
          self:SetMaxHeight()
        else
          self:SetVisible(false)
          self:SetMaxHeight(0)
        end
        --set title and icon
        if context.ChoGGi_PickUp_Toggle then
          self:SetTitle("Pickup Item")
          self:SetIcon("UI/Icons/Sections/shuttle_2.tga")
        else
          self:SetTitle("Drop Item")
          self:SetIcon("UI/Icons/Sections/shuttle_3.tga")
        end
      end,
      func = function(self, context)
        if context.ChoGGi_FollowMouseShuttle then
          context.ChoGGi_PickUp_Toggle = not context.ChoGGi_PickUp_Toggle
          ObjModified(context)
        end
      end
    }
    ChoGGi.CodeFuncs.AddXTemplate("ChoGGi_CustomPane1","ipShuttle",Table,XTemplates)
--spawn shuttle buttons for hub and return shuttle button
    Table = {
      __context_of_kind = "ShuttleHub",
      Icon = "UI/Icons/Sections/shuttle_3.tga",
      Title = "Spawn Attacker",
      RolloverTitle = "Spawn Attacker",
      RolloverHint = "Spawns a Shuttle that will follow your cursor, scan nearby selected anomalies for you, attack nearby dustdevils, and pick up resources you've selected and marked for pickup.\nPin it and right-click the pin to have it come to your position.",
      func = function(self, context)
        ChoGGi.CodeFuncs.SpawnShuttle(context,true)
      end
    }
    ChoGGi.CodeFuncs.AddXTemplate("ChoGGi_CustomPane1","customShuttleHub",Table,XTemplates)
    --
    Table = {
      __context_of_kind = "ShuttleHub",
      Icon = "UI/Icons/Sections/shuttle_2.tga",
      Title = "Spawn Friend",
      RolloverTitle = "Spawn Friend",
      RolloverHint = "Spawns a Shuttle that will follow your cursor, scan nearby selected anomalies for you, and pick up resources you've selected and marked for pickup.\nPin it and right-click the pin to have it come to your position.",
      func = function(self, context)
        ChoGGi.CodeFuncs.SpawnShuttle(context)
      end
    }
    ChoGGi.CodeFuncs.AddXTemplate("ChoGGi_CustomPane2","customShuttleHub",Table,XTemplates)
    --
    Table = {
      __context_of_kind = "ShuttleHub",
      Icon = "UI/Icons/Sections/shuttle_4.tga",
      Title = "Recall Shuttles",
      RolloverTitle = "Recall Shuttles",
      RolloverHint = "Recalls all shuttles you've spawned at this ShuttleHub.",
      func = function(self, context)
        ChoGGi.CodeFuncs.RecallShuttlesHub(context)
      end
    }
    ChoGGi.CodeFuncs.AddXTemplate("ChoGGi_CustomPane3","customShuttleHub",Table,XTemplates)
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
        if not context.ChoGGi_PickUpItem then
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
        context.ChoGGi_PickUpItem = not context.ChoGGi_PickUpItem
        ObjModified(context)
      end
    }
    ChoGGi.CodeFuncs.AddXTemplate("ChoGGi_CustomPane1","ipResourcePile",Table,XTemplates)
    --
    Table = {
      __context_of_kind = "Drone",
      RolloverTitle = "Mark For Pickup",
      RolloverHint = hint_mark,
      OnContextUpdate = function(self, context)
        if not context.ChoGGi_PickUpItem then
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
        context.ChoGGi_PickUpItem = not context.ChoGGi_PickUpItem
        ObjModified(context)
      end
    }
    ChoGGi.CodeFuncs.AddXTemplate("ChoGGi_CustomPane3","ipDrone",Table,XTemplates)
    --
    Table = {
      __context_of_kind = "BaseRover",
      RolloverTitle = "Mark For Pickup",
      RolloverHint = hint_mark,
      OnContextUpdate = function(self, context)
        if not context.ChoGGi_PickUpItem then
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
        context.ChoGGi_PickUpItem = not context.ChoGGi_PickUpItem
        ObjModified(context)
      end
    }
    ChoGGi.CodeFuncs.AddXTemplate("ChoGGi_CustomPane3","ipRover",Table,XTemplates)
    --
    Table = {
      __context_of_kind = "UniversalStorageDepot",
      RolloverTitle = "",
      RolloverHint = hint_mark,
      OnContextUpdate = function(self, context)
        if not context.ChoGGi_PickUpItem then
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
        context.ChoGGi_PickUpItem = not context.ChoGGi_PickUpItem
        ObjModified(context)
      end
    }
    ChoGGi.CodeFuncs.AddXTemplate("ChoGGi_CustomPane4","sectionStorage",Table,XTemplates)
  --[[
  --adds to the bottom of every selection :) :(
  Infopanel

   --figure out how to move groups of res
  ipSurfaceDeposit
--]]
  end --if

  --dustdevil thread for rockets
  function CargoShuttle:ChoGGi_DefenceTickD(ChoGGi)
    if self.ChoGGi_FollowMouseShuttle and ChoGGi.Temp.CargoShuttleThreads[self.handle] then
      return ChoGGi.CodeFuncs.DefenceTick(self,ChoGGi.Temp.ShuttleRocketDD)
    end
  end

  function CargoShuttle:ChoGGi_IsFollower()
    if not self.ChoGGi_FollowMouseShuttle then
      self:SetCommand("Idle")
    end
  end

  --set control to follow mouse click
  if type(ChoGGi.Temp.Testing) == "function" then
    function CargoShuttle:OnSelected()
      ChoGGi.Temp.ShuttleClickerControl = true
      self:SetCommand("ChoGGi_FollowMouseClick")
    end

    function CargoShuttle:ChoGGi_FollowMouseClick()
      --not one of mine
      self:ChoGGi_IsFollower()
    print("ChoGGi_FollowMouseClick")

      local PlayFX = PlayFX
      local Sleep = Sleep
      local ChoGGi = ChoGGi
      local terrain = terrain
      repeat
        local x,y,z = self:GetVisualPosXYZ()
        local dest = GetTerrainCursor()

        self:ChoGGi_Goto(ChoGGi,PlayFX,terrain,Sleep,pos,x,y,z,dest,idle,newpos)
        Sleep(1000)
      until (GameTime() - self.timenow > 2000000) or not self.ChoGGi_FollowMouseShuttle
    end
  end

--	Movable.Goto(object, pt) -- Unit.Goto is a command, use this instead for direct control

  --get shuttle to follow mouse
  function CargoShuttle:ChoGGi_FollowMouse(newpos)
    self:ChoGGi_IsFollower()

    local ChoGGi = ChoGGi
    local PlayFX = PlayFX
    local Sleep = Sleep
    local GameTime = GameTime
    local terrain = terrain
    local DeleteThread = DeleteThread
    --when shuttle isn't moving it gets magical fuel from somewhere so we use a timer
    local idle = 0
    --always start it off as pickup
    self.ChoGGi_PickUp_Toggle = true
    local dest_orig = false
    local dest_orig_temp = false
    local flightthread = false
    repeat

      local x,y,z = self:GetVisualPosXYZ()
      local dest = GetTerrainCursor()

      idle,dest_orig_temp = self:ChoGGi_Goto(ChoGGi,PlayFX,terrain,Sleep,DeleteThread,flightthread,point(x,y,z),x,y,z,dest,dest_orig,idle,newpos)
      if dest_orig_temp then
        dest_orig = dest_orig_temp
      end

      --scanning/resource
      self:ChoGGi_SelectedObject(ChoGGi,PlayFX,SelectedObj,point(x,y,z),dest)
      --idle = idle + 1
      idle = idle + 10
      Sleep(250 + idle)
    --about 4 sols then send it back home (or if we recalled it)
    until (GameTime() - self.timenow > 2000000) or not self.ChoGGi_FollowMouseShuttle
    --so it can set the GoHome command (we normally blocked it)
    self.ChoGGi_FollowMouseShuttle = nil
    --buh-bye little flying companion
    self:SetCommand("GoHome")
  end

  function CargoShuttle:ChoGGi_Goto(ChoGGi,PlayFX,terrain,Sleep,DeleteThread,flightthread,pos,x,y,z,dest,dest_orig,idle,newpos)
    if not dest then
      return idle
    end
    --too quick and it's jerky *or* mouse making small movements
    if self.ChoGGi_InFlight then
      if idle < 100 or point(dest_orig:x(),dest_orig:y()):Dist2D(point(dest:x(),dest:y())) < 1000 then
        return idle
      elseif idle > 100 then
      end
    end

    --don't try to fly if pos or dest aren't different (spams log)
    local path = self:CalcPath(pos, dest)
    --check the last path point to see if it's far away (can't be bothered to make a new func that allows you to break off the path)
    --and if we move when we're too close it's jerky
    --local dist = point(x,y):Dist(destp) < 100000 and point(x,y):Dist(destp) > 6000
    local dist = point(x,y):Dist2D(point(dest:x(),dest:y())) > 5000
    if newpos or dist or idle > 250 then
      --rest on ground
      self.hover_height = 0

      --if idle is ticking up
      if idle > 250 then
        if not self.ChoGGi_Landed then
          PlayFX("Dust", "start", self)
          self:FollowPathCmd(self:CalcPath(pos, point(x+UICity:Random(-1500,1500),y+UICity:Random(-1500,1500))))
          self.ChoGGi_Landed = self:GetPos()
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
        --reset idle count
        idle = 0
        --we don't want to skim the ground (default is 3, but this one likes living life on the edge)
        self.hover_height = 1500

        --from pinsdlg
        if newpos then
          --want to be kinda random (when there's lots of shuttles about)
          if #ChoGGi.Temp.CargoShuttleThreads > 10 then
            path = self:CalcPath(
              pos,
              point(newpos:x()+UICity:Random(-2500,2500),newpos:y()+UICity:Random(-2500,2500),1500)
            )
          else
            path = self:CalcPath(pos, newpos)
          end
          newpos = nil
        end

        if self.ChoGGi_Landed then
          self.ChoGGi_Landed = nil
          PlayFX("DomeExplosion", "start", self)
        end
        --abort previous flight if dest is different
        if self.ChoGGi_InFlight and dest ~= dest_orig then
          dest_orig = dest
          self.ChoGGi_InFlight = nil
          DeleteThread(flightthread)
          DeleteThread(FlyingObjs[self])
        --we don't want to start a new flight if we're flying and the dest isn't different
        elseif not self.ChoGGi_InFlight then
          --the actual flight
          flightthread = CreateGameTimeThread(function()
            self.ChoGGi_InFlight = true
            self:FollowPathCmd(path)
            self.ChoGGi_InFlight = nil
          end)
        end
      end
    end
    return idle,dest
  end

  function CargoShuttle:ChoGGi_OnGround(pos)
    local z = pos:z()
    if z < 10000 or (z >= 10000 and z == terrain.GetSurfaceHeight(pos)) then
      return true
    end
  end

  function CargoShuttle:ChoGGi_SelectedObject(ChoGGi,PlayFX,sel,pos,dest)
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

      --are we carrying?
      elseif self.ChoGGi_carriedObj and self.ChoGGi_PickUp_Toggle == false then
        --we want to drop obj next to sel

        self.hover_height = 100
        local carried = self.ChoGGi_carriedObj

        --local pass = GetPassablePointNearby(dest)
        self:FollowPathCmd(self:CalcPath(pos,dest))
        --move it

        --carried:SetPos(HexGetNearestCenter(dest))
        carried:Detach()

        --carried:SetPos(HexGetNearestCenter(pass))
        if type(carried.Idle) == "function" then
          carried:SetCommand("Idle")
        end

        self.ChoGGi_carriedObj = nil
        --make it able to pick up again without having to press the button
        self.ChoGGi_PickUp_Toggle = true
        self.hover_height = 1500

      --PICKUP
      else
        --if it's marked for pickup and shuttle is set to pickup and it isn't already carrying then grab it
        if sel.ChoGGi_PickUpItem and self.ChoGGi_PickUp_Toggle and not self.ChoGGi_carriedObj then

          --goto item
          self.hover_height = 100
          self:FollowPathCmd(self:CalcPath(pos,sel:GetVisualPos()))

          --remove pickup mark from it
          sel.ChoGGi_PickUpItem = nil
          --PlayFX of beaming, transport one i think
          Sleep(1000)

          --"pick it up" (move it below the ground so it isn't visible and save the object locally)
          --sel:SetPos(point(0,0,0))
          --actually picks it up woot!
          self:Attach(sel,self:GetSpotBeginIndex("Top"))

          --make sure we know we have cargo
          self.ChoGGi_carriedObj = sel
          self.hover_height = 1500
        end
      end
    end --scanning/resource
  end

  --no ChoGGi_ prefix as defencetower also fires a rocket and uses this function name
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
