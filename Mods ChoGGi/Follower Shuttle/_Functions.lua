local cCodeFuncs = ChoGGiX.CodeFuncs

--pretty much a direct copynpaste from explorer (just removed stuff that's rover only)
function cCodeFuncs.AnalyzeAnomaly(self,anomaly)
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
      anomaly.scanning_progress = cCodeFuncs.GetScanAnomalyProgress(self)
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
    anomaly.scanning_progress = cCodeFuncs.GetScanAnomalyProgress(self)
    if anomaly == SelectedObj then
      Msg("UIPropertyChanged", anomaly)
    end
  end
  self:PopAndCallDestructor()
end
function cCodeFuncs.GetScanAnomalyProgress(self)
  return self.scanning_start and MulDivRound(GameTime() - self.scanning_start, 100, self.scan_time) or 0
end

function cCodeFuncs.DefenceTick(self,AlreadyFired)
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
        CreateRealTimeThread(function()
          while rocket.move_thread do
            Sleep(500)
          end
          if IsKindOf(obj,"BaseMeteor") then
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
    CreateRealTimeThread(function()
      --for i = 1, #AlreadyFired do
      for i = #AlreadyFired, 1, -1 do
        if not IsValid(AlreadyFired[i]) then
          AlreadyFired[i] = nil
        end
      end
    end)
  end
end
