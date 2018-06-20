--See LICENSE for terms

local Concat = PersonalShuttles.ComFuncs.Concat

local Sleep = Sleep
local GameTime = GameTime
local DeleteThread = DeleteThread
local PlayFX = PlayFX
local Random = Random

function OnMsg.ClassesBuilt()

  if PersonalShuttles.UserSettings.ShowShuttleControls then
--pick/drop button for shuttle
    local Table = {
      __context_of_kind = "CargoShuttle",
      RolloverTitle = "Pickup/Drop Item",
      RolloverHint = "Change to Pickup and select resource pile you've previously marked for pickup.\nToggle it back to \"Drop Item\" and select an object: it'll drop it (somewhat) next to it.",
      OnContextUpdate = function(self, context)
        --only show when it's one of our shuttles
        if context.PersonalShuttles_FollowMouseShuttle then
          self:SetVisible(true)
          self:SetMaxHeight()
        else
          self:SetVisible(false)
          self:SetMaxHeight(0)
        end
        --set title and icon
        if context.PersonalShuttles_PickUp_Toggle then
          self:SetTitle("Pickup Item")
          self:SetIcon("UI/Icons/Sections/shuttle_2.tga")
        else
          self:SetTitle("Drop Item")
          self:SetIcon("UI/Icons/Sections/shuttle_3.tga")
        end
      end,
      func = function(self, context)
        if context.PersonalShuttles_FollowMouseShuttle then
          context.PersonalShuttles_PickUp_Toggle = not context.PersonalShuttles_PickUp_Toggle
          ObjModified(context)
        end
      end
    }
    PersonalShuttles.CodeFuncs.AddXTemplate("PersonalShuttles_CustomPane1","ipShuttle",Table)
--info showing carried item
    Table = {
      __context_of_kind = "CargoShuttle",
      --__template = "InfopanelSection",
      RolloverTitle = "Carried object",
      RolloverHint = "Shows name of carried object.",
      Icon = "UI/Icons/Sections/shuttle_4.tga",
      OnContextUpdate = function(self, context)
        local Obj = context.PersonalShuttles_carriedObj
        if Obj then
          self:SetVisible(true)
          self:SetMaxHeight()
          self:SetTitle(Concat("Carried: ",PersonalShuttles.CodeFuncs.Trans(Obj.display_name)))
        else
          self:SetVisible(false)
          self:SetMaxHeight(0)
        end
      end,
      func = function()end
      }
    PersonalShuttles.CodeFuncs.AddXTemplate("PersonalShuttles_CustomPane2","ipShuttle",Table)
--spawn shuttle buttons for hub and return shuttle button
    Table = {
      __context_of_kind = "ShuttleHub",
      Icon = "UI/Icons/Sections/shuttle_3.tga",
      Title = "Spawn Attacker",
      RolloverTitle = "Spawn Attacker",
      RolloverHint = "Spawns a Shuttle that will follow your cursor, scan nearby selected anomalies for you, attack nearby dustdevils, and pick up resources you've selected and marked for pickup.",
      func = function(self, context)
        PersonalShuttles.CodeFuncs.SpawnShuttle(context,true)
      end
    }
    PersonalShuttles.CodeFuncs.AddXTemplate("PersonalShuttles_CustomPane1","customShuttleHub",Table)
    --
    Table = {
      __context_of_kind = "ShuttleHub",
      Icon = "UI/Icons/Sections/shuttle_2.tga",
      Title = "Spawn Friend",
      RolloverTitle = "Spawn Friend",
      RolloverHint = "Spawns a Shuttle that will follow your cursor, scan nearby selected anomalies for you, and pick up resources you've selected and marked for pickup.",
      func = function(self, context)
        PersonalShuttles.CodeFuncs.SpawnShuttle(context)
      end
    }
    PersonalShuttles.CodeFuncs.AddXTemplate("PersonalShuttles_CustomPane2","customShuttleHub",Table)
    --
    Table = {
      __context_of_kind = "ShuttleHub",
      Icon = "UI/Icons/Sections/shuttle_4.tga",
      Title = "Recall Shuttles",
      RolloverTitle = "Recall Shuttles",
      RolloverHint = "Recalls all shuttles you've spawned at this ShuttleHub.",
      func = function(self, context)
        PersonalShuttles.CodeFuncs.RecallShuttlesHub(context)
      end
    }
    PersonalShuttles.CodeFuncs.AddXTemplate("PersonalShuttles_CustomPane3","customShuttleHub",Table)
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
        if not context.PersonalShuttles_PickUpItem then
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
        context.PersonalShuttles_PickUpItem = not context.PersonalShuttles_PickUpItem
        ObjModified(context)
      end
    }
    PersonalShuttles.CodeFuncs.AddXTemplate("PersonalShuttles_CustomPane1","ipResourcePile",Table)
    --
    Table = {
      __context_of_kind = "Drone",
      RolloverTitle = "Mark For Pickup",
      RolloverHint = hint_mark,
      OnContextUpdate = function(self, context)
        if not context.PersonalShuttles_PickUpItem then
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
        context.PersonalShuttles_PickUpItem = not context.PersonalShuttles_PickUpItem
        ObjModified(context)
      end
    }
    PersonalShuttles.CodeFuncs.AddXTemplate("PersonalShuttles_CustomPane3","ipDrone",Table)
    --
    Table = {
      __context_of_kind = "BaseRover",
      RolloverTitle = "Mark For Pickup",
      RolloverHint = hint_mark,
      OnContextUpdate = function(self, context)
        if not context.PersonalShuttles_PickUpItem then
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
        context.PersonalShuttles_PickUpItem = not context.PersonalShuttles_PickUpItem
        ObjModified(context)
      end
    }
    PersonalShuttles.CodeFuncs.AddXTemplate("PersonalShuttles_CustomPane3","ipRover",Table)
    --
    Table = {
      __context_of_kind = "UniversalStorageDepot",
      RolloverTitle = "",
      RolloverHint = hint_mark,
      OnContextUpdate = function(self, context)
        if not context.PersonalShuttles_PickUpItem then
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
        context.PersonalShuttles_PickUpItem = not context.PersonalShuttles_PickUpItem
        ObjModified(context)
      end
    }
    PersonalShuttles.CodeFuncs.AddXTemplate("PersonalShuttles_CustomPane4","sectionStorage",Table)
  --[[
  --adds to the bottom of every selection :) :(
  Infopanel

   --figure out how to move groups of res
  ipSurfaceDeposit
--]]
  end --if

  --dustdevil thread for rockets
  function CargoShuttle:PersonalShuttles_DefenceTickD(PersonalShuttles)
    if self.PersonalShuttles_FollowMouseShuttle and UICity.PersonalShuttles.CargoShuttleThreads[self.handle] then
      return PersonalShuttles.CodeFuncs.DefenceTick(self,PersonalShuttles.Temp.ShuttleRocketDD)
    end
  end

  function CargoShuttle:PersonalShuttles_IsFollower()
    if not self.PersonalShuttles_FollowMouseShuttle then
      self:SetCommand("Idle")
    end
  end

  --set control to follow mouse click
  if type(PersonalShuttles.Temp.Testing) == "function" then
    function CargoShuttle:OnSelected()
      PersonalShuttles.Temp.ShuttleClickerControl = true
      self:SetCommand("PersonalShuttles_FollowMouseClick")
    end

    function CargoShuttle:PersonalShuttles_FollowMouseClick()
      --not one of mine
      self:PersonalShuttles_IsFollower()
    print("PersonalShuttles_FollowMouseClick")

      local PersonalShuttles = PersonalShuttles
      local terrain = terrain
      repeat
        local x,y,z = self:GetVisualPosXYZ()
        local dest = GetTerrainCursor()

        self:PersonalShuttles_Goto(PersonalShuttles,terrain,pos,x,y,z,dest,idle)
        Sleep(1000)
      until (GameTime() - self.timenow > 2000000) or not self.PersonalShuttles_FollowMouseShuttle
    end
  end

--	Movable.Goto(object, pt) -- Unit.Goto is a command, use this instead for direct control

  --get shuttle to follow mouse
  function CargoShuttle:PersonalShuttles_FollowMouse()
    self:PersonalShuttles_IsFollower()

    local PersonalShuttles = PersonalShuttles
    local terrain = terrain
    --when shuttle isn't moving it gets magical fuel from somewhere so we use a timer
    local idle = 0
    --always start it off as pickup
    self.PersonalShuttles_PickUp_Toggle = true
    self.PersonalShuttles_IdleTime = 0

    self.PersonalShuttles_OldDest = false
    local dest_orig_temp = false
    self.PersonalShuttles_flightthread = false
    self.PersonalShuttles_FirstIdle = 0
    repeat

      local x,y,z = self:GetVisualPosXYZ()
      local dest = GetTerrainCursor()

      self:PersonalShuttles_Goto(PersonalShuttles,terrain,point(x,y,z),x,y,z,dest)

      --scanning/resource
      self:PersonalShuttles_SelectedObject(PersonalShuttles,SelectedObj,point(x,y,z),dest)
      self.PersonalShuttles_IdleTime = self.PersonalShuttles_IdleTime + 10
      Sleep(250 + self.PersonalShuttles_IdleTime)
    --about 4 sols then send it back home (or if we recalled it)
    until (GameTime() - self.timenow > PersonalShuttles.UserSettings.TimeLimit or 2000000) or not self.PersonalShuttles_FollowMouseShuttle
    --so it can set the GoHome command (we normally blocked it)
    self.PersonalShuttles_FollowMouseShuttle = nil
    --buh-bye little flying companion
    self:SetCommand("GoHome")
  end

  function CargoShuttle:PersonalShuttles_Goto(PersonalShuttles,terrain,pos,x,y,z,dest)
    if not dest then
      return
    end
    --too quick and it's jerky *or* mouse making small movements
    if self.PersonalShuttles_InFlight then
      if self.PersonalShuttles_IdleTime < 100 then
        return
      elseif self.PersonalShuttles_IdleTime > 100 and self.PersonalShuttles_OldPos == pos then
      --
      else
        if self.PersonalShuttles_OldDest and point(self.PersonalShuttles_OldDest:x(),self.PersonalShuttles_OldDest:y()):Dist2D(point(dest:x(),dest:y())) < 1000 then
          if self.PersonalShuttles_FirstIdle < 25 then
            self.PersonalShuttles_FirstIdle = self.PersonalShuttles_FirstIdle + 1
            return self.PersonalShuttles_IdleTime
          end
        end
      end
    end
    self.PersonalShuttles_FirstIdle = 0

    --don't try to fly if pos or dest aren't different (spams log)
    local path = self:CalcPath(pos, dest)
    --check the last path point to see if it's far away (can't be bothered to make a new func that allows you to break off the path)
    --and if we move when we're too close it's jerky
    --local dist = point(x,y):Dist(destp) < 100000 and point(x,y):Dist(destp) > 6000
    local dist = point(x,y):Dist2D(point(dest:x(),dest:y())) > 5000
    if dist or self.PersonalShuttles_IdleTime > 250 then
      --rest on ground
      self.hover_height = 0

      --if idle is ticking up
      if self.PersonalShuttles_IdleTime > 250 then
        if not self.PersonalShuttles_Landed then
          self:SetState("fly")
          Sleep(250)
          --self:PersonalShuttles_LandIt(UICity,Sleep,terrain,x,y,pos)
          self:PlayFX("Dust", "start")
          self:PlayFX("Waiting", "start")
          local land = point(x+Random(-2500,2500),y+Random(-2500,2500)):SetZ(terrain.GetSurfaceHeight(pos))
          self:FlyingFace(land, 2500)
          self:SetPos(land, 4000)
          Sleep(750)
          self.PersonalShuttles_Landed = self:GetPos()
          self:PlayFX("Dust", "end")
          self:PlayFX("Waiting", "end")
          self:SetState("idle")

        --10000 = flat ground (shuttle h and ground h and different below, so ignore)
        --elseif z ~= terrain.GetSurfaceHeight(pos) then
        --  print("never?")
        --  self:PersonalShuttles_LandIt(UICity,Sleep,terrain,x,y,pos)
        end
        Sleep(500+self.PersonalShuttles_IdleTime)
      end

      --mouse moved far enough then wake up and fly
      if dist then
        --reset idle count
        self.PersonalShuttles_IdleTime = 0
        --we don't want to skim the ground (default is 3, but this one likes living life on the edge)
        self.hover_height = 1500

        --want to be kinda random (when there's lots of shuttles about)
        if #UICity.PersonalShuttles.CargoShuttleThreads > 10 then
          path = self:CalcPath(
            pos,
            point(dest:x()+Random(-2500,2500),dest:y()+Random(-2500,2500),1500)
          )
        else
          path = self:CalcPath(pos, dest)
        end

        if self.PersonalShuttles_Landed then
          self.PersonalShuttles_Landed = nil
          self:PlayFX("DomeExplosion", "start")
          --self:PersonalShuttles_TakeOff()
        end
        --abort previous flight if dest is different
        if self.PersonalShuttles_InFlight and dest ~= self.PersonalShuttles_OldDest then
          self.PersonalShuttles_OldDest = dest
          self.PersonalShuttles_InFlight = nil
          DeleteThread(self.PersonalShuttles_flightthread)
          DeleteThread(FlyingObjs[self])
        --we don't want to start a new flight if we're flying and the dest isn't different
        elseif not self.PersonalShuttles_InFlight then
          --the actual flight
          self.PersonalShuttles_flightthread = CreateGameTimeThread(function()
            self.PersonalShuttles_InFlight = true
            self:FollowPathCmd(path)
            self.PersonalShuttles_InFlight = nil
          end)
        end
      end
          self:SetState("idle")

    end
    self.PersonalShuttles_OldPos = pos
    self.PersonalShuttles_OldDest = dest
  end

  function CargoShuttle:PersonalShuttles_SelectedObject(PersonalShuttles,sel,pos,dest)
    if sel and sel ~= self then
      --Anomaly scanning
      if sel:IsKindOf("SubsurfaceAnomaly") then
        --scan nearby SubsurfaceAnomaly
        local anomaly = NearestObject(pos,GetObjects({class="SubsurfaceAnomaly"}),2000)
        --make sure it's the right one, and not already being scanned by another
        if anomaly and sel == anomaly and not UICity.PersonalShuttles.CargoShuttleScanningAnomaly[anomaly.handle] then
          PlayFX("ArtificialSunCharge", "start",anomaly)
          UICity.PersonalShuttles.CargoShuttleScanningAnomaly[anomaly.handle] = true
          PersonalShuttles.CodeFuncs.AnalyzeAnomaly(self, anomaly)
          PlayFX("ArtificialSunCharge", "end",anomaly)
        end
      --resource moving

      --are we carrying?
      elseif self.PersonalShuttles_carriedObj and self.PersonalShuttles_PickUp_Toggle == false then
        --we want to drop obj next to sel

        self.hover_height = 100
        local carried = self.PersonalShuttles_carriedObj

        --local pass = GetPassablePointNearby(dest)
        self:FollowPathCmd(self:CalcPath(pos,dest))
        --move it

        --carried:SetPos(HexGetNearestCenter(dest))
        self:PlayFX("ShuttleUnload", "start", self)
        Sleep(1000)
        self:PlayFX("ShuttleUnload", "end", self)
        carried:Detach()

        --carried:SetPos(HexGetNearestCenter(pass))
        if type(carried.Idle) == "function" then
          carried:SetCommand("Idle")
        end

        self.PersonalShuttles_carriedObj = nil
        --make it able to pick up again without having to press the button
        self.PersonalShuttles_PickUp_Toggle = true

        UICity.PersonalShuttles.CargoShuttleCarried[carried.handle] = nil

        self.hover_height = 1500

      --PICKUP
      else
        --if it's marked for pickup and shuttle is set to pickup and it isn't already carrying then grab it
        if sel.PersonalShuttles_PickUpItem and self.PersonalShuttles_PickUp_Toggle and not self.PersonalShuttles_carriedObj then

          --goto item
          self.hover_height = 100
          self:FollowPathCmd(self:CalcPath(pos,sel:GetVisualPos()))

          --remove pickup mark from it
          sel.PersonalShuttles_PickUpItem = nil
          --PlayFX of beaming, transport one i think
          self:PlayFX("ShuttleLoad", "start", self)
          Sleep(1000)
          self:PlayFX("ShuttleLoad", "end", self)

          if not UICity.PersonalShuttles.CargoShuttleCarried[sel.handle] then
            UICity.PersonalShuttles.CargoShuttleCarried[sel.handle] = true
            --pick it up
            self:Attach(sel,self:GetSpotBeginIndex("Top"))
            --and remember not to pick up more than one
            self.PersonalShuttles_carriedObj = sel
          end

          self.hover_height = 1500
        end
      end
    end --scanning/resource
  end

  --no PersonalShuttles_ prefix as defencetower also fires a rocket and uses this function name
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
