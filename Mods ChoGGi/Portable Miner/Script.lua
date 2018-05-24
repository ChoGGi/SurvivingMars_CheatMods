function OnMsg.ClassesGenerate()
  DefineClass.PortableMiner = {
    __parents = {
      "AttackRover",
      "PinnableObject",
      "ComponentAttach",
      "Demolishable",

      "ResourceStockpileBase",
      "Constructable",
      --mining
      "ResourceProducer",
      "BuildingDepositExploiterComponent",
      "TerrainDepositExtractor",

    },
    UpdateUI = BuildingDepositExploiterComponent.UpdateUI,

    last_serviced_time = 0, --(TODO: is still needed?) moment the mine was last serviced by a working drone, or turned on
    building_update_time = const.HourDuration,
    resource = "Metals",
    mine_amount = 1000,
    max_res_amount = 100000,
    nearby_deposits = false,
    battery_hourly_drain_rate = 0,
    accumulate_dust = true,
    notworking_sign = false,
    pooper_shooter = "Droneentrance",
  }

  DefineClass.PortableMinerBuilding = {
    __parents = {
      "BaseRoverBuilding"
    },
    rover_class = "PortableMiner",
  }


  function PortableMiner:GameInit()
    --give it a groundy looking colour
    self:SetColor3(-13031651)
    --dunno it was in attackrover
    self.name = self.display_name

    self:SetCommand("Roam")
  end

  local OrigFunc_PortableMiner_Repair
  function PortableMiner:Repair()
    OrigFunc_PortableMiner_Repair(self)
    --orig func calls :DisconnectFromCommandCenters()
    self:ConnectToCommandCenters()
  end

  --needed someplace to override it, and roam only happens after it's done what it needs to do and we need a place to add a Sleep
  function PortableMiner:Roam()
    local city = self.city or UICity
    city:RemoveFromLabel("HostileAttackRovers", self)
    city:AddToLabel("Rover", self)
    self.reclaimed = true
    --self.affected_by_no_battery_tech = true
    --needs a very slight delay or something fucks up when you spawn it on a deposit...sigh
    Sleep(1)
    self:SetCommand("Idle")
  end

  function PortableMiner:DepositNearby()
    local res = NearestObject(self:GetVisualPos(),GetObjects({class="Deposit"}),1500)
    if not res or res and (res:IsKindOf("SubsurfaceAnomaly") or res:IsKindOf("SubsurfaceDepositWater")) then
      self.nearby_deposits = false
      return false
    end

    if res:IsKindOf("SubsurfaceDeposit") or res:IsKindOf("TerrainDepositConcrete") then
      self.resource = res.resource
      self.nearby_deposits = res
      return true
    elseif res and res[1] then
      if not res[1]:IsKindOf("SubsurfaceAnomaly") and not res[1]:IsKindOf("SubsurfaceDepositWater") then
        self.resource = res[1].resource
        self.nearby_deposits = res[1]
        return true
      end
    end
  end

  function PortableMiner:ShowNotWorkingSign(bool)
    if bool then
      self.notworking_sign = true
      self:AttachSign(true, "SignNotWorking")
      self:UpdateWorking(false)
    else
      self.notworking_sign = false
      self:DestroyAttaches("BuildingSign")
      self:UpdateWorking(true)
    end
  end

  function PortableMiner:IsReloading()
    if self.ui_working and self:DepositNearby() then
      --get to work
      self:SetCommand("Load")
      return true
    else
      --check if stockpile is existing and full
      if not self.ui_working and
          (self:GetDist2D(self.stockpile) >= 5000 or
          self.stockpile and self.stockpile:GetStoredAmount() < self.max_res_amount) then
        self.ui_working = true
      end
      self:ShowNotWorkingSign()
    end
  end

  --called it Load so it uses the load resource icon in pins
  function PortableMiner:Load()
    --stop wheels from turning, and little jerky movement
    self:SetState("idle")

    if self.nearby_deposits then
      --remove removed stockpile
      if not IsValid(self.stockpile) then
        self.stockpile = false
      end
      --add new stockpile if none
      if not self.stockpile or
          self:GetDist2D(self.stockpile) >= 5000 or
          self.stockpile and self.stockpile.resource ~= self.resource then
        local stockpile = NearestObject(self:GetPos(),GetObjects({class="ResourceStockpile"}),5000)

        if not stockpile or stockpile and stockpile.resource == self.resource then
          --plunk down a new res stockpile
          stockpile = PlaceObj("ResourceStockpile", {
            --time to get all humping robot on christmas
            "Pos", self:GetSpotLoc(self:GetSpotBeginIndex(self.pooper_shooter)),
            --find a way to get angle so we can move it back a bit
            "Angle", self:GetAngle(),
            "resource", self.resource,
            "destroy_when_empty", true
          })
        end
        --why doesn't this work in PlaceObj? needs happen after GameInit maybe?
        stockpile.max_z = 10
        self.stockpile = stockpile
      end
      --stops at 100 per stockpile
      if self.stockpile:GetStoredAmount() < self.max_res_amount then
        self.ui_working = true
        --remove the sign
        self:ShowNotWorkingSign()
        --up n down n up n down
        self:SetStateText("attackIdle")
        local mined
        --mine some shit
        if self.resource == "Concrete" then
          mined = s:DigErUpConcrete(s.mine_amount)
        elseif self.resource == "Metals" or self.resource == "PreciousMetals" then
          mined = self:DigErUpMetals(self.mine_amount)
        end
        if mined then
          --update stockpile
          self.stockpile:AddResourceAmount(mined)
        end
      else
        self.ui_working = false
        --no need to keep on re-showing sign (assuming there isn't a check for this, but an if bool is quicker then whatever it does)
        if not self.notworking_sign then
          self:ShowNotWorkingSign(true)
        end
      end
    end
    Sleep(1000)
    self:SetCommand("Idle")
  end

  function PortableMiner:DigErUpMetals(amount)
    if not IsValid(self.nearby_deposits) then
      self.nearby_deposits = false
      return
    end

    amount = self.nearby_deposits:TakeAmount(amount)
    Msg("ResourceExtracted", self.nearby_deposits.resource, amount)

    if self.nearby_deposits:IsDepleted() then
      self.nearby_deposits = false
      self:OnDepositDepleted(self.nearby_deposits)
    end
    return amount
  end

  function PortableMiner:DigErUpConcrete(amount)
    if not IsValid(self.nearby_deposits) then
      self.nearby_deposits = false
      return
    end

    local info = self:GetRessourceInfo()
    local shape = self:GetExtractionShape()
    if not info or not shape then
      return
    end

    local extracted, remaining = TerrainDeposit_Extract(shape, self, TerrainDepositGrid, info, amount)
    Msg("ResourceExtracted", self.resource, extracted)

    if remaining == 0 then
      self.nearby_deposits = false
      assert(not self:CheckDeposit())
      self.nearby_deposits = false
      self:OnDepositDepleted()
      local deposit = self:GetDeposit()
      if IsValid(deposit) and deposit:GetAmount() < 10 * const.ResourceScale then
        DoneObject(deposit)
      end
    end

    if extracted == 0 then
      return
    end

    return extracted
  end
  --needed for Concrete
  function PortableMiner:GetDepositResource()
    return self.resource
  end
  function PortableMiner:GetExtractionShape()
    return GetEntityCombinedShape("QuarryClosedShape")
  end

end --ClassesGenerate

function OnMsg.ClassesPostprocess()

  PlaceObj("BuildingTemplate",{
    "name","PortableMinerBuilding",
    "template_class","PortableMinerBuilding",
    "construction_cost_Metals",40000,
    "construction_cost_MachineParts",40000,
    "construction_cost_Electronics",20000,
    "dome_forbidden",true,
    "display_name","RC Portable Miner",
    "display_name_pl","RC Portable Miner",
    "description","Will slowly mine Metal or Concrete into a resource pile.",
    "build_category","Infrastructure",
    "display_icon","UI/Icons/Buildings/rover_combat.tga",
    "build_pos",2,
    --since attackrover doesn't have an entity use transport
    "entity","RoverTransportBuilding",
    "encyclopedia_exclude",true,
    "on_off_button",false,
    "prio_button",false,
    "palettes","AttackRoverBlue"
  })

end --ClassesPostprocess
