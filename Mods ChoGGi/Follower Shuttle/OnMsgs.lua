local cCodeFuncs = ChoGGiX.CodeFuncs
local cComFuncs = ChoGGiX.ComFuncs
local cConsts = ChoGGiX.Consts
local cInfoFuncs = ChoGGiX.InfoFuncs
local cMsgFuncs = ChoGGiX.MsgFuncs
local cSettingFuncs = ChoGGiX.SettingFuncs
local cTables = ChoGGiX.Tables

local PlayFX = PlayFX
local NearestObject = NearestObject
local Sleep = Sleep
local GetTerrainCursor = GetTerrainCursor
local GameTime = GameTime
local GetObjects = GetObjects

function OnMsg.ClassesGenerate()

  cMsgFuncs.InfoPaneCheats_ClassesGenerate()
  cMsgFuncs.ReplacedFunctions_ClassesGenerate()
  --custom shuttletask
  DefineClass.ChoGGiX_ShuttleFollowTask = {
    __parents = {"InitDone"},
    state = "new",
    shuttle = false,
    dest_pos = false
  }

end

function OnMsg.ClassesPreprocess()

  local c = CargoShuttle
  c.__parents[#c.__parents] = "PinnableObject"
  c.ChoGGiX_DefenceTickD = false

end

function OnMsg.ClassesBuilt()

  cMsgFuncs.ReplacedFunctions_ClassesBuilt()

  function CargoShuttle:ChoGGiX_DefenceTickD(ChoGGiX)
    if self.ChoGGiX_FollowMouseShuttle then
      return cCodeFuncs.DefenceTick(self,ChoGGiX.Temp.ShuttleRocketDD,10000)
    end
  end

  --dust for the shuttle
  local function duston(shut)
    if not shut.ChoGGiX_Landed and not shut.ChoGGiX_DustOn then
      PlayFX("Dust", "start", shut)
      shut.ChoGGiX_DustOn = true
    end
  end
  --get shuttle to follow mouse
  function CargoShuttle:ChoGGiX_FollowMouse(newpos)
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
      if x ~= dest:x() or y ~= dest:y() then
        --don't try to fly if pos or dest aren't different (spams log)
        local path = self:CalcPath(pos, dest)
        local destp = path[#path][#path[#path]]
        --check the last path point to see if it's far away (can't be bothered to make a new func that allows you to break off the path)
        --and if we move when we're too close it's jerky
        local dist = point(x,y):Dist(destp) < 50000 and point(x,y):Dist(destp) > 2000
        if newpos or dist or idle > 50 then
          self.hover_height = 0
          --rest on ground
          if idle > 50 and pos:z() ~= terrain.GetHeight(pos) then
            self:FollowPathCmd(self:CalcPath(pos, point(x+1000,y+1000)))
            --this may not have been set so make sure we turn off dust
            self.ChoGGiX_Landed = true
            self.ChoGGiX_DustOn = nil
            PlayFX("Dust", "end", self)
          --goto cursor
          --elseif newpos or dist or idle > 150 then
          elseif newpos or dist then
            --reset idle count
            idle = 0
            --we don't want to skim the ground
            self.hover_height = 3000
            --from pinsdlg
            if newpos then
              path = self:CalcPath(pos, newpos)
              newpos = nil
            end
            if self.ChoGGiX_Landed then
              self.ChoGGiX_Landed = nil
              PlayFX("DomeExplosion", "start", self)
            end
            self:FollowPathCmd(path)
            --re-add the dust after a bit
            CreateRealTimeThread(function()
              Sleep(250)
              duston(self)
            end)
          end
        end
        if sel and sel ~= self then
          if IsKindOf(sel,"SubsurfaceAnomaly") then
            --scan nearby SubsurfaceAnomaly
            local anomaly = NearestObject(pos,GetObjects({class="SubsurfaceAnomaly"}),2000)
            if anomaly and sel == anomaly then
              --duston(self)
              PlayFX("ArtificialSunCharge", "start", anomaly)
              cCodeFuncs.AnalyzeAnomaly(self, anomaly)
              PlayFX("ArtificialSunCharge", "end", anomaly)
            end
          elseif type(cTesting) == "function" and sel:IsKindOfClasses("ResourceStockpile", "SurfaceDepositGroup", "ResourcePile") then
            --if carrying resource then drop it off
            local stockpile = NearestObject(pos,GetObjects({class=sel.class}),2000)
            if stockpile and sel == stockpile then
              local supply --userdata
              local demand --userdata
              local resource --string
              if IsKindOf(sel,"SurfaceDepositGroup") then
                supply = sel.group[1].task_requests[1]
                demand = sel.group[1].transport_request
                resource = sel.group[1].encyclopedia_id
              elseif IsKindOf(sel,"ResourceStockpile") then
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
      end
      --so shuttle follows the mouse after awhile if shuttle is too far away
      idle = idle + 1
      Sleep(300 + idle)
    --about 4 sols then send it back home
    until GameTime() - timenow > 2000000
  end
  function CargoShuttle:Analyze(anomaly)
    cCodeFuncs.AnalyzeAnomaly(self,anomaly)
  end
  function CargoShuttle:FireRocket(spot, target, rocket_class, luaobj)
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

end --OnMsg

function OnMsg.LoadingScreenPreClose()
  local UICity = UICity

  --for new games
  if not UICity then
    return
  end

  --show cheats pane so we can clicky
  config.BuildingInfopanelCheats = true
  ReopenSelectionXInfopanel()

end
