--pretty much a direct copynpaste from explorer (just removed stuff that's rover only)
function ChoGGiX.CodeFuncs.AnalyzeAnomaly(self,anomaly)
  if not IsValid(self) then
    return
  end
  self:SetState("idle")
  self:SetPos(self:GetVisualPos())
  self:Face(anomaly:GetPos(), 200)
  local layers = anomaly.depth_layer or 1
  self.scan_time = layers * g_Consts.RCRoverScanAnomalyTime
  local progress_time = MulDivRound(anomaly.scanning_progress, self.scan_time, 100)
  self.scanning_start = GameTime() - progress_time
  RebuildInfopanel(self)
  self:PushDestructor(function(self)
    if IsValid(anomaly) then
      anomaly.scanning_progress = ChoGGiX.CodeFuncs.GetScanAnomalyProgress(self)
      if anomaly.scanning_progress >= 100 then
        self:Gossip("ScanAnomaly", anomaly.class, anomaly.handle)
        anomaly:ScanCompleted(self)
        anomaly:delete()
      end
    end
    if IsValid(anomaly) and anomaly == SelectedObj then
      Msg("UIPropertyChanged", anomaly)
    end
    --self:StopFX()
    self.scanning = false
    self.scanning_start = false
  end)
  local time = self.scan_time - progress_time
  --self:StartFX("Scan", anomaly)
  self.scanning = true
  while time > 0 and IsValid(self) and IsValid(anomaly) do
    Sleep(1000)
    time = time - 1000
    anomaly.scanning_progress = ChoGGiX.CodeFuncs.GetScanAnomalyProgress(self)
    if anomaly == SelectedObj then
      Msg("UIPropertyChanged", anomaly)
    end
  end
  self:PopAndCallDestructor()
  ChoGGiX.Temp.CargoShuttleScanningAnomaly[anomaly.handle] = nil
end
function ChoGGiX.CodeFuncs.GetScanAnomalyProgress(self)
  return self.scanning_start and MulDivRound(GameTime() - self.scanning_start, 100, self.scan_time) or 0
end

function ChoGGiX.CodeFuncs.DefenceTick(self,AlreadyFired)
  local CreateGameTimeThread = CreateGameTimeThread
  local Sleep = Sleep
  local PlayFX = PlayFX

  if type(AlreadyFired) ~= "table" then
    print("Error: ShuttleRocketDD isn't a table")
  end
  --list of dustdevils on map
  local hostiles = g_DustDevils or empty_table
  if IsValidThread(self.track_thread) then
    return
  end
  for i = 1, #hostiles do
    local obj = hostiles[i]

    --get dist (added * 10 as it didn't see to target at the range of it's hex grid)
    --it could be from me increasing protection radius, or just how it targets meteors
    if IsValid(obj) and self:GetVisualDist2D(obj) <= self.shoot_range * 10 then
      --check if tower is working
      if not IsValid(self) or not self.working or self.destroyed then
        return
      end

      --follow = small ones attached to majors
      if not obj.follow and not AlreadyFired[obj.handle] then
      --if not AlreadyFired[obj.handle] then
        --aim the tower at the dustdevil
        if self.class == "DefenceTower" then
          self:OrientPlatform(obj:GetVisualPos(), 7200)
        end
        --fire in the hole
        local rocket = self:FireRocket(nil, obj)
        --store handle so we only launch one per devil
        AlreadyFired[obj.handle] = obj
        --seems like safe bets to set
        self.meteor = obj
        self.is_firing = true
        --sleep till rocket explodes
        CreateGameTimeThread(function()
          while rocket.move_thread do
            Sleep(500)
          end
          if obj:IsKindOf("BaseMeteor") then
            --make it pretty
            PlayFX("AirExplosion", "start", obj, nil, obj:GetPos())
            Msg("MeteorIntercepted", obj)
            obj:ExplodeInAir()
          else
            --make it pretty
            PlayFX("AirExplosion", "start", obj, obj:GetAttaches()[1], obj:GetPos())
            --kill the devil object
            obj:delete()
          end
          self.meteor = false
          self.is_firing = false
        end)
        --back to the usual stuff
        Sleep(self.reload_time)
        return true
      end
    end
  end
  --remove only remove devil handles if they're actually gone
  if #AlreadyFired > 0 then
    CreateGameTimeThread(function()
      --for i = 1, #AlreadyFired do
      for i = #AlreadyFired, 1, -1 do
        if not IsValid(AlreadyFired[i]) then
          AlreadyFired[i] = nil
        end
      end
    end)
  end
end

function ChoGGiX.CodeFuncs.RecallShuttlesHub(hub)
  for _, s_i in pairs(hub.shuttle_infos) do
    local shuttle = s_i.shuttle_obj
    if shuttle then

      if type(ChoGGiX.Temp.CargoShuttleThreads[shuttle.handle]) == "boolean" then
        ChoGGiX.Temp.CargoShuttleThreads[shuttle.handle] = nil
      end
      if shuttle.ChoGGiX_FollowMouseShuttle then
        shuttle.ChoGGiX_FollowMouseShuttle = nil
        shuttle:SetCommand("Idle")
      end

    end
  end
end
--which true=attack,false=friend
function ChoGGiX.CodeFuncs.SpawnShuttle(hub,which)
  local ChoGGiX = ChoGGiX
  for _, s_i in pairs(hub.shuttle_infos) do
    if s_i:CanLaunch() then
      --ShuttleInfo:Launch(task)
      local hub = s_i.hub
      if not hub or not hub.has_free_landing_slots then
        return false
      end
      --LRManagerInstance
      local shuttle = CargoShuttle:new({
        hub = hub,
        transport_task = ChoGGiX_ShuttleFollowTask:new({
          state = "ready_to_follow",
          dest_pos = GetTerrainCursor() or GetRandomPassable()
        }),
        info_obj = s_i
      })
      s_i.shuttle_obj = shuttle
      local slot = hub:ReserveLandingSpot(shuttle)
      shuttle:SetPos(slot.pos)
      --CargoShuttle:Launch()
      shuttle:PushDestructor(function(s)
        s.hub:ShuttleLeadOut(s)
        s.hub:FreeLandingSpot(s)
      end)
      local amount = 0
      for _ in pairs(ChoGGiX.Temp.CargoShuttleThreads) do
        amount = amount + 1
      end
      if amount <= 50 then
        --do we attack dustdevils?
        if which then
          ChoGGiX.Temp.CargoShuttleThreads[shuttle.handle] = true
          shuttle:SetColor1(-9624026)
          shuttle:SetColor2(1)
          shuttle:SetColor3(-13892861)
        else
          ChoGGiX.Temp.CargoShuttleThreads[shuttle.handle] = false
          shuttle:SetColor1(-16711941)
          shuttle:SetColor2(-16760065)
          shuttle:SetColor3(-1)
        end
        --easy way to get amount of shuttles about
        ChoGGiX.Temp.CargoShuttleThreads[#ChoGGiX.Temp.CargoShuttleThreads+1] = true
        shuttle.ChoGGiX_FollowMouseShuttle = true
        --follow that cursor little minion
        shuttle:SetCommand("ChoGGiX_FollowMouse")
        --we only allow it to fly for a certain amount (about 4 sols)
        shuttle.timenow = GameTime()
        --return it so we can do viewpos on it for menu item
        return shuttle
      else
      --or the crash is from all the dust i have going :)
        ChoGGiX.ComFuncs.MsgPopup(
          "Max of 50 (above 50 and below 100 it crashes).",
          "Shuttle"
        )
      end
      --since we found a shuttle break the loop
      break
    end
  end
end

--only add unique template names
function ChoGGiX.CodeFuncs.AddXTemplate(Name,Template,Table,XT,InnerTable)
  if not (Name or Template or Table) then
    return
  end
  XT = XT or XTemplates

  if not InnerTable then
    if not XT[Template][1][Name] then
      XT[Template][1][Name] = true

      XT[Template][1][#XT[Template][1]+1] = PlaceObj("XTemplateTemplate", {
        "__context_of_kind", Table.__context_of_kind or "Infopanel",
        "__template", Table.__template or "InfopanelSection",
        "Icon", Table.Icon or "UI/Icons/gpmc_system_shine.tga",
        "Title", Table.Title or "Placeholder",
        "RolloverText", Table.RolloverText or "Info",
        "RolloverTitle", Table.RolloverTitle or "Title",
        "RolloverHint", Table.RolloverHint or "Hint",
        "OnContextUpdate", Table.OnContextUpdate
      }, {
        PlaceObj("XTemplateFunc", {
        "name", "OnActivate(self, context)",
        "parent", function(parent, context)
            return parent.parent
          end,
        "func", Table.func or "function() return end"
        })
      })
    end
  else
    if not XT[Template][Name] then
      XT[Template][Name] = true

      XT[Template][#XT[Template]+1] = PlaceObj("XTemplateTemplate", {
        "__context_of_kind", Table.__context_of_kind or "Infopanel",
        "__template", Table.__template or "InfopanelSection",
        "Icon", Table.Icon or "UI/Icons/gpmc_system_shine.tga",
        "Title", Table.Title or "Placeholder",
        "RolloverText", Table.RolloverText or "Info",
        "RolloverTitle", Table.RolloverTitle or "Title",
        "RolloverHint", Table.RolloverHint or "Hint",
        "OnContextUpdate", Table.OnContextUpdate
      }, {
        PlaceObj("XTemplateFunc", {
        "name", "OnActivate(self, context)",
        "parent", function(parent, context)
            return parent.parent
          end,
        "func", Table.func or "function() return end"
        })
      })
    end
  end
end
