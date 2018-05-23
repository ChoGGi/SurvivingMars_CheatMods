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
  c.__parents[#c.__parents] = "PinnableObject"
  c.ChoGGiX_DefenceTickD = false
end

function ChoGGiX.MsgFuncs.ShuttleControl_ClassesBuilt()

  if ChoGGiX.UserSettings.ShowShuttleControls then
    --pick/drop button for shuttle
    if not table.find(XTemplates.ipShuttle[1], "ChoGGiX_ipShuttle", "ChoGGiX_ShuttleResButtons") then
      table.insert(XTemplates.ipShuttle[1],
        PlaceObj("XTemplateTemplate", {
          "__context_of_kind", "CargoShuttle",
          "__template", "InfopanelActiveSection",
          "Icon", "UI/Icons/Sections/shuttle_1.tga",
          "Title", "Pickup/Drop Item",
          "RolloverText", "Info",
          "RolloverTitle", "Pickup/Drop Item",
          "RolloverHint", "Follower Shuttles: Change to Pickup and select resource pile you've previously marked for pickup.\nToggle it back to \"Drop Item\" and select an object: it'll drop it (hopefully) next to it.",
          "OnContextUpdate",
            function(self, context)
              if not context.ChoGGiX_PickUp_Toggle then
                --carrying res
                self:SetTitle("Drop Item")
                self:SetIcon("UI/Icons/Sections/shuttle_3.tga")
              else
                --empty res we can pick up
                self:SetTitle("Pickup Item")
                self:SetIcon("UI/Icons/Sections/shuttle_2.tga")
              end
            end,
            "ChoGGiX_ipShuttle", "ChoGGiX_ShuttleResButtons"
      }, {
          PlaceObj("XTemplateFunc", {
            "name", "OnActivate(self, context)",
            "parent", function(parent, context)
                return parent.parent
              end,
            "func", function(self, context)
                -- ignore self, as it's always going to be selected
                if context.ChoGGiX_FollowMouseShuttle then
                  context.ChoGGiX_PickUp_Toggle = not context.ChoGGiX_PickUp_Toggle
                  ObjModified(context)
                end
              end
          })
        })
      )
    end
    --spawn shuttle buttons for hub and return shuttle button
    if not table.find(XTemplates.customShuttleHub[1], "ChoGGiX_ShuttleHubAttacker", "ChoGGiX_ShuttleHubSpawnButtons") then
      table.insert(XTemplates.customShuttleHub[1],
        PlaceObj("XTemplateTemplate", {
          "__context_of_kind", "ShuttleHub",
          "__template", "InfopanelActiveSection",
          "Icon", "UI/Icons/Sections/shuttle_3.tga",
          "Title", "SpawnAttacker",
          "RolloverText", "Info",
          "RolloverTitle", "Spawn Attacker",
          "RolloverHint", "Spawns a Shuttle that will follow your cursor, scan nearby selected anomalies for you, attack nearby dustdevils, and pick up resources you've selected and marked for pickup.\nPin it and right-click the pin to have it come to your position.",
          "OnContextUpdate",
            function(self, context)
              --carrying res
              self:SetTitle("Spawn Attacker")
              self:SetIcon("UI/Icons/Sections/shuttle_3.tga")
            end,
            "ChoGGiX_ShuttleHubAttacker", "ChoGGiX_ShuttleHubSpawnButtons"
      }, {
          PlaceObj("XTemplateFunc", {
            "name", "OnActivate(self, context)",
            "parent", function(parent, context)
                return parent.parent
              end,
            "func", function(self, context)
                ChoGGiX.CodeFuncs.SpawnShuttle(context,true)
              end
          })
        })
      )
    end
    if not table.find(XTemplates.customShuttleHub[1], "ChoGGiX_ShuttleHubFriend", "ChoGGiX_ShuttleHubSpawnButtons") then
      table.insert(XTemplates.customShuttleHub[1],
        PlaceObj("XTemplateTemplate", {
          "__context_of_kind", "ShuttleHub",
          "__template", "InfopanelActiveSection",
          "Icon", "UI/Icons/Sections/shuttle_2.tga",
          "Title", "SpawnFriend",
          "RolloverText", "Info",
          "RolloverTitle", "Spawn Friend",
          "RolloverHint", "Spawns a Shuttle that will follow your cursor, scan nearby selected anomalies for you, and pick up resources you've selected and marked for pickup.\nPin it and right-click the pin to have it come to your position.",
          "OnContextUpdate",
            function(self, context)
              --carrying res
              self:SetTitle("Spawn Friend")
              self:SetIcon("UI/Icons/Sections/shuttle_2.tga")
            end,
            "ChoGGiX_ShuttleHubFriend", "ChoGGiX_ShuttleHubSpawnButtons"
      }, {
          PlaceObj("XTemplateFunc", {
            "name", "OnActivate(self, context)",
            "parent", function(parent, context)
                return parent.parent
              end,
            "func", function(self, context)
                ChoGGiX.CodeFuncs.SpawnShuttle(context)
              end
          })
        })
      )
    end
    if not table.find(XTemplates.customShuttleHub[1], "ChoGGiX_ShuttleHubRecall", "ChoGGiX_ShuttleHubSpawnButtons") then
      table.insert(XTemplates.customShuttleHub[1],
        PlaceObj("XTemplateTemplate", {
          "__context_of_kind", "ShuttleHub",
          "__template", "InfopanelActiveSection",
          "Icon", "UI/Icons/Sections/shuttle_4.tga",
          "Title", "RecallShuttles",
          "RolloverText", "Info",
          "RolloverTitle", "Recall Shuttles",
          "RolloverHint", "Recalls all shuttles you've spawned at this ShuttleHub.",
          "OnContextUpdate",
            function(self, context)
              --carrying res
              self:SetTitle("Recall Shuttles")
              self:SetIcon("UI/Icons/Sections/shuttle_4.tga")
            end,
            "ChoGGiX_ShuttleHubRecall", "ChoGGiX_ShuttleHubSpawnButtons"
      }, {
          PlaceObj("XTemplateFunc", {
            "name", "OnActivate(self, context)",
            "parent", function(parent, context)
                return parent.parent
              end,
            "func", function(self, context)
                ChoGGiX.CodeFuncs.RecallShuttlesHub(context)
              end
          })
        })
      )
    end
    --add mark for pickup buttons to certain resource piles
    local hint_mark = "Change this to Pickup, then select a spawned shuttle and have it come on by."
    if not table.find(XTemplates.ipResourcePile[1], "ChoGGiX_MarkForPickup1", "ChoGGiX_MarkForPickupButtons") then
      table.insert(XTemplates.ipResourcePile[1],
        PlaceObj("XTemplateTemplate", {
          "__context_of_kind", "ResourceStockpile",
          "__template", "InfopanelActiveSection",
          "Icon", "UI/Icons/Sections/shuttle_1.tga",
          "Title", "MarkForPickup",
          "RolloverText", "Info",
          "RolloverTitle", "Mark For Pickup",
          "RolloverHint", hint_mark,
          "OnContextUpdate",
            function(self, context)
              if not context.ChoGGiX_PickUpItem then
                self:SetTitle("Ignore Item")
                self:SetIcon("UI/Icons/Sections/shuttle_1.tga")
              else
                --empty res we can pick up
                self:SetTitle("Pickup Item")
                self:SetIcon("UI/Icons/Sections/shuttle_2.tga")
              end
            end,
            "ChoGGiX_MarkForPickup1", "ChoGGiX_MarkForPickupButtons"
      }, {
          PlaceObj("XTemplateFunc", {
            "name", "OnActivate(self, context)",
            "parent", function(parent, context)
                return parent.parent
              end,
            "func", function(self, context)
                context.ChoGGiX_PickUpItem = not context.ChoGGiX_PickUpItem
                ObjModified(context)
              end
          })
        })
      )
    end

    if not table.find(XTemplates.ipRover[1], "ChoGGiX_MarkForPickup3", "ChoGGiX_MarkForPickupButtons") then
      table.insert(XTemplates.ipRover[1],
        PlaceObj("XTemplateTemplate", {
          "__context_of_kind", "InfopanelObj",
          "__template", "InfopanelActiveSection",
          "Icon", "UI/Icons/Sections/shuttle_1.tga",
          "Title", "MarkForPickup",
          "RolloverText", "Info",
          "RolloverTitle", "Mark For Pickup",
          "RolloverHint", hint_mark,
          "OnContextUpdate",
            function(self, context)
              if not context.ChoGGiX_PickUpItem then
                --carrying res
                self:SetTitle("Ignore Item")
                self:SetIcon("UI/Icons/Sections/shuttle_1.tga")
              else
                --empty res we can pick up
                self:SetTitle("Pickup Item")
                self:SetIcon("UI/Icons/Sections/shuttle_2.tga")
              end
            end,
            "ChoGGiX_MarkForPickup3", "ChoGGiX_MarkForPickupButtons"
      }, {
          PlaceObj("XTemplateFunc", {
            "name", "OnActivate(self, context)",
            "parent", function(parent, context)
                return parent.parent
              end,
            "func", function(self, context)
                context.ChoGGiX_PickUpItem = not context.ChoGGiX_PickUpItem
                ObjModified(context)
              end
          })
        })
      )
    end
    if not table.find(XTemplates.ipDrone[1], "ChoGGiX_MarkForPickup4", "ChoGGiX_MarkForPickupButtons") then
      table.insert(XTemplates.ipDrone[1],
        PlaceObj("XTemplateTemplate", {
          "__context_of_kind", "InfopanelObj",
          "__template", "InfopanelActiveSection",
          "Icon", "UI/Icons/Sections/shuttle_1.tga",
          "Title", "MarkForPickup",
          "RolloverText", "Info",
          "RolloverTitle", "Mark For Pickup",
          "RolloverHint", "Change this to Pick, then select a spawned shuttle and have it come on by.",
          "OnContextUpdate",
            function(self, context)
              if not context.ChoGGiX_PickUpItem then
                --carrying res
                self:SetTitle("Ignore Item")
                self:SetIcon("UI/Icons/Sections/shuttle_1.tga")
              else
                --empty res we can pick up
                self:SetTitle("Pickup Item")
                self:SetIcon("UI/Icons/Sections/shuttle_2.tga")
              end
            end,
            "ChoGGiX_MarkForPickup4", "ChoGGiX_MarkForPickupButtons"
      }, {
          PlaceObj("XTemplateFunc", {
            "name", "OnActivate(self, context)",
            "parent", function(parent, context)
                return parent.parent
              end,
            "func", function(self, context)
                context.ChoGGiX_PickUpItem = not context.ChoGGiX_PickUpItem
                ObjModified(context)
              end
          })
        })
      )
    end
  if not table.find(XTemplates.sectionStorage[1], "ChoGGiX_MarkForPickup5", "ChoGGiX_MarkForPickupButtons") then
    table.insert(XTemplates.sectionStorage[1],
      PlaceObj("XTemplateTemplate", {
        "__context_of_kind", "InfopanelObj",
        "__template", "InfopanelActiveSection",
        "Icon", "UI/Icons/Sections/shuttle_1.tga",
        "Title", "MarkForPickup",
        "RolloverText", "Info",
        "RolloverTitle", "Mark For Pickup",
        "RolloverHint", "Change this to Pick, then select a spawned shuttle and have it come on by.",
        "OnContextUpdate",
          function(self, context)
            if not context.ChoGGiX_PickUpItem then
              --carrying res
              self:SetTitle("Ignore Item")
              self:SetIcon("UI/Icons/Sections/shuttle_1.tga")
            else
              --empty res we can pick up
              self:SetTitle("Pickup Item")
              self:SetIcon("UI/Icons/Sections/shuttle_2.tga")
            end
          end,
          "ChoGGiX_MarkForPickup5", "ChoGGiX_MarkForPickupButtons"
    }, {
        PlaceObj("XTemplateFunc", {
          "name", "OnActivate(self, context)",
          "parent", function(parent, context)
              return parent.parent
            end,
          "func", function(self, context)
              context.ChoGGiX_PickUpItem = not context.ChoGGiX_PickUpItem
              ObjModified(context)
            end
        })
      })
    )
  end
  --adds to the bottom of every selection :) :(
  --[[
  if not table.find(XTemplates.Infopanel[1], "ChoGGiX_MarkForPickupX", "ChoGGiX_MarkForPickupButtons") then
    table.insert(XTemplates.Infopanel[1],
      PlaceObj("XTemplateTemplate", {
        "__context_of_kind", "InfopanelObj",
        "__template", "InfopanelActiveSection",
        "Icon", "UI/Icons/Sections/shuttle_1.tga",
        "Title", "MarkForPickup",
        "RolloverText", "Info",
        "RolloverTitle", "Mark For Pickup",
        "RolloverHint", "Toggle this, then select a spawned shuttle and have it come on by.",
        "OnContextUpdate",
          function(self, context)
            if not context.ChoGGiX_PickUpItem then
              --carrying res
              self:SetTitle("Drop")
              self:SetIcon("UI/Icons/Sections/shuttle_3.tga")
            else
              --empty res we can pick up
              self:SetTitle("Pickup")
              self:SetIcon("UI/Icons/Sections/shuttle_2.tga")
            end
          end,
          "ChoGGiX_MarkForPickupX", "ChoGGiX_MarkForPickupButtons"
    }, {
        PlaceObj("XTemplateFunc", {
          "name", "OnActivate(self, context)",
          "parent", function(parent, context)
              return parent.parent
            end,
          "func", function(self, context)
              context.ChoGGiX_PickUpItem = not context.ChoGGiX_PickUpItem
              ObjModified(context)
            end
        })
      })
    )
  end

   --figure out how to move groups of res
    if not table.find(XTemplates.ipSurfaceDeposit[1], "ChoGGiX_MarkForPickup2", "ChoGGiX_MarkForPickupButtons") then
      table.insert(XTemplates.ipSurfaceDeposit[1],
        PlaceObj("XTemplateTemplate", {
          "__context_of_kind", "SurfaceDepositGroup",
          "__template", "InfopanelActiveSection",
          "Icon", "UI/Icons/Sections/shuttle_1.tga",
          "Title", "MarkForPickup",
          "RolloverText", "Info",
          "RolloverTitle", "Mark For Pickup",
          "RolloverHint", hint_mark,
          "OnContextUpdate",
            function(self, context)
              if not context.ChoGGiX_PickUpItem then
                --carrying res
                self:SetTitle("Drop Res")
                self:SetIcon("UI/Icons/Sections/shuttle_3.tga")
              else
                --empty res we can pick up
                self:SetTitle("Pickup Res")
                self:SetIcon("UI/Icons/Sections/shuttle_2.tga")
              end
            end,
            "ChoGGiX_MarkForPickup2", "ChoGGiX_MarkForPickupButtons"
      }, {
          PlaceObj("XTemplateFunc", {
            "name", "OnActivate(self, context)",
            "parent", function(parent, context)
                return parent.parent
              end,
            "func", function(self, context)
                context.ChoGGiX_PickUpItem = not context.ChoGGiX_PickUpItem
                ObjModified(context)
              end
          })
        })
      )
    end
--]]

end

  --dustdevil thread for rockets
  function CargoShuttle:ChoGGiX_DefenceTickD(ChoGGiX)
    if self.ChoGGiX_FollowMouseShuttle and ChoGGiX.Temp.CargoShuttleThreads[self.handle] then
      return ChoGGiX.CodeFuncs.DefenceTick(self,ChoGGiX.Temp.ShuttleRocketDD)
    end
  end

--				Movable.Goto(drone, pt) -- Unit.Goto is a command, use this instead for direct control

  --get shuttle to follow mouse
  function CargoShuttle:ChoGGiX_FollowMouse(newpos)
    if not type(ChoGGiX.Temp.CargoShuttleThreads[self.handle]) == "boolean" then
      return
    end
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
    --always start it off as pickup
    self.ChoGGiX_PickUp_Toggle = true
    repeat
      local sel = SelectedObj
      local pos = self:GetVisualPos()
      local dest = GetTerrainCursor()
      local x = pos:x()
      local y = pos:y()
      local z = pos:z()
      --don't try to fly if pos or dest aren't different (spams log)
      local path = self:CalcPath(pos, dest)
      local destp = path[#path][#path[#path]] or path[#path][#path][#path] or pos
      --check the last path point to see if it's far away (can't be bothered to make a new func that allows you to break off the path)
      --and if we move when we're too close it's jerky
      local dist = point(x,y):Dist(destp) < 100000 and point(x,y):Dist(destp) > 6000
      if newpos or dist or idle > 250 then
        self.hover_height = 0
        --rest on ground
        --if idle is ticking up
        if idle > 250 then
          if not self.ChoGGiX_Landed then
            PlayFX("Land", "start", self)
            PlayFX("Dust", "start", self)

            --self:FollowPathCmd(self:CalcPath(pos, point(x+UICity:Random(-3500,3500),y+UICity:Random(-3500,3500))))
            self:FollowPathCmd(self:CalcPath(pos, point(x+UICity:Random(-1500,1500),y+UICity:Random(-1500,1500))))
            --self:FollowPathCmd(self:CalcPath(pos, point(x+1000,y+1000)))
            self.ChoGGiX_Landed = self:GetPos()
            PlayFX("Dust", "end", self)
            PlayFX("Land", "end", self)
         elseif z ~= terrain.GetHeight(pos) then
            --print("-------------z: " .. z .. " gt: " .. terrain.GetHeight(pos))
            --check if shuttle is resting above ground
            self:FollowPathCmd(self:CalcPath(pos, point(x+1000,y+1000)))
          end
          Sleep(500+idle)
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
            path = self:CalcPath(pos, newpos)
            --want to be kinda random (when there's lots of shuttles about)
            --path = self:CalcPath(
            --  point(x+UICity:Random(-2500,2500),y+UICity:Random(-2500,2500),1000),
            --  point(newpos:x()+UICity:Random(-2500,2500),newpos:y()+UICity:Random(-2500,2500),1000)
            --)
            newpos = nil
          end
          if self.ChoGGiX_Landed then
            self.ChoGGiX_Landed = nil
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

          carried:SetPos(HexGetNearestCenter(dest))
          carried:SetCommand("Idle")

          self.ChoGGiX_carriedObj = nil
          self.hover_height = 1000

        --PICKUP
        --elseif sel:IsKindOfClasses("ResourceStockpile", "SurfaceDepositGroup", "ResourcePile", "Unit") then
        elseif sel:IsKindOfClasses("ResourceStockpile", "ResourcePile", "Unit", "StorageDepot") then
          --if not and it's marked for pickup and shuttle is set to pickup then grab it
          if sel.ChoGGiX_PickUpItem and self.ChoGGiX_PickUp_Toggle then

            --goto item
            self.hover_height = 100
            self:FollowPathCmd(self:CalcPath(pos,sel:GetVisualPos()))

            --remove pickup mark from it
            sel.ChoGGiX_PickUpItem = nil
            --PlayFX of beaming, transport one i think
            Sleep(1000)

            --"pick it up" (move it below the ground so it isn't visible and save the object locally)
            sel:SetPos(point(0,0,0))
            --make sure we know we have cargo
            self.ChoGGiX_carriedObj = sel
            self.hover_height = 1000
          end
        end
      end --scanning/resource

      --idle = idle + 1
      idle = idle + 10
      Sleep(250 + idle)
    --about 4 sols then send it back home (or if we recalled it)
    until (GameTime() - timenow > 2000000) or type(ChoGGiX.Temp.CargoShuttleThreads[self.handle]) ~= "boolean"
    --so it can set the GoHome command (we block it)
    ChoGGiX.Temp.CargoShuttleThreads[self.handle] = nil

    self:SetCommand("GoHome")
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
