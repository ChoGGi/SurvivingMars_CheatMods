--  See LICENSE for terms

local TConcat = ChoGGi_Miner.ComFuncs.TableConcat
local Concat = ChoGGi_Miner.ComFuncs.Concat

local table,select,type,tostring = table,select,type,tostring

local DoneObject = DoneObject
local GetEntityCombinedShape = GetEntityCombinedShape
local GetObjects = GetObjects
local IsValid = IsValid
local MovePointAway = MovePointAway
local Msg = Msg
local NearestObject = NearestObject
local OnMsg = OnMsg
local PlaceObj = PlaceObj
local PlaceObject = PlaceObject
local Sleep = Sleep
local TerrainDeposit_Extract = TerrainDeposit_Extract
local XTemplates = XTemplates

do -- this do keeps these locals local to the do -> end scope
  local BuildingDepositExploiterComponent = BuildingDepositExploiterComponent
  local DefineClass = DefineClass
  local const = const
  DefineClass.PortableMiner = {
    __parents = {
      "AttackRover",
      "PinnableObject",
      "ComponentAttach",
      "Demolishable",
      "ResourceStockpileBase",
      "Constructable",
      -- mining
      "ResourceProducer",
      "BuildingDepositExploiterComponent",
      "TerrainDepositExtractor",
    },

    -- how much to mine
    mine_amount = 1 * const.ResourceScale,
--~     mine_amount = 100 * const.ResourceScale,
    -- how much to store in res pile
    max_res_amount = 100 * const.ResourceScale, -- visible is limited to 100
--~     max_res_amount = 10000 * const.ResourceScale,
    -- mine once an hour
    building_update_time = const.HourDuration,
    -- color of bands
    custom_color = -13031651,

    -- custom_entity = "Lama",
    -- custom_entity = "Kosmonavt",
    -- custom_scale = 500, -- 100 is default size
    -- custom_anim = "playBasketball", -- object:GetStates()
    -- custom_anim = "playTaiChi", -- takes quite awhile, may want to increase mined amount or set limit on time
    -- custom_anim_idle = "layDying",

    -- set to false to use length of animation (these are in game times, i think at normal speed 1 is 1 millisecond)
    -- anim_time = false,
    -- idle_time = false,
    anim_time = 1000,
    idle_time = 1500,

    -- how close to the resource icon do we need to be
    mine_dist = 1500,
    -- area around it to mine for concrete
    mine_area = "DomeMega",

    -- if you want the battery to drain
    battery_hourly_drain_rate = 0,
    -- stuff for mining
    UpdateUI = BuildingDepositExploiterComponent.UpdateUI,
    last_serviced_time = 0,
    resource = "Metals",
    nearby_deposits = false,
    accumulate_dust = true,
    notworking_sign = false,
    pooper_shooter = "Droneentrance",

    produced_total = 0,
    produced_last_deposit = 0,
  }

  DefineClass.PortableMinerBuilding = {
    __parents = {"BaseRoverBuilding"},
    rover_class = "PortableMiner",
  }

end

function PortableMiner:GameInit()
  -- give it a groundy looking colour
  self:SetColor3(self.custom_color)
  if self.custom_entity then
    self:ChangeEntity(self.custom_entity)
  end
  if self.custom_scale then
    self:SetScale(self.custom_scale)
  end
  if self.custom_anim then
    self.default_anim = self.custom_anim
  else
    self.default_anim = "attackIdle"
  end
  if self.custom_anim_idle then
    self.default_anim_idle = self.custom_anim_idle
  else
    self.default_anim_idle = 0
  end

  -- dunno it was in attackrover (maybe for some fx stuff with rockets or the mystery it's from?)
  self.name = self.display_name

  self:SetCommand("Roam")
end

--~   local OrigFunc_PortableMiner_Repair
function PortableMiner:Repair()
  AttackRover.Repair(self)
--~     OrigFunc_PortableMiner_Repair(self)
  -- orig func calls :DisconnectFromCommandCenters()
  self:ConnectToCommandCenters()
end

-- needed someplace to override it, and roam only happens after it's done what it needs to do and we need a place to add a Sleep
function PortableMiner:Roam()
  local city = self.city or UICity
  city:RemoveFromLabel("HostileAttackRovers", self)
  city:AddToLabel("Rover", self)
  self.reclaimed = true
  -- self.affected_by_no_battery_tech = true
  -- needs a very slight delay or something fucks up when you spawn it on a deposit...sigh
  Sleep(1)
  self:SetCommand("Idle")
end

-- added by SkyRich, see if this fixes it.
--~ function PortableMiner:Idle()
--~ 	self:SetState("idle")
--~ 	Sleep(1000)
--~ end

function PortableMiner:IsReloading()
  if self.ui_working and self:DepositNearby() then
    --  get to work
    self:SetCommand("Load")
    return true
  elseif not self.ui_working and
    -- check if stockpile is existing and full
      (self:GetDist2D(self.stockpile) >= 5000 or
      self.stockpile and self.stockpile:GetStoredAmount() < self.max_res_amount) then
    self.ui_working = true
    self:ShowNotWorkingSign(false)
  end
end

function PortableMiner:DepositNearby()
  local res = NearestObject(self:GetVisualPos(),GetObjects({class="Deposit"}),self.mine_dist)
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
--~     self:Attach(PlaceObject("SignNotWorking", nil, const.cfComponentAttach), self:GetSpotBeginIndex("Origin"))
    self:AttachSign(self.notworking_sign,"SignNotWorking")
    self:UpdateWorking(false)
  else
    self.notworking_sign = false
    self:AttachSign(self.notworking_sign,"SignNotWorking")
    self:UpdateWorking(true)
  end
end

-- called it Load so it uses the load resource icon in pins
function PortableMiner:Load()

  if self.nearby_deposits then
    -- remove removed stockpile
    if not IsValid(self.stockpile) then
      self.stockpile = false
    end
    -- add new stockpile if none
    if not self.stockpile or
        self:GetDist2D(self.stockpile) >= 5000 or
        self.stockpile and (self.stockpile.resource ~= self.resource or self.stockpile.Miner_Handle ~= self.handle) then
      local stockpile = NearestObject(self:GetPos(),GetObjects({class="ResourceStockpile"}),5000)

      if not stockpile or stockpile and (stockpile.resource ~= self.resource or stockpile.Miner_Handle ~= self.handle) then
        -- plunk down a new res stockpile
        stockpile = PlaceObj("ResourceStockpile", {

          -- time to get all humping robot on christmas
          "Pos", MovePointAway(self:GetDestination(), self:GetSpotLoc(self:GetSpotBeginIndex(self.pooper_shooter)), -800),
          -- "Pos", ScalePoint(pt, scalex, scaley, scalez)(self:GetSpotLoc(self:GetSpotBeginIndex(self.pooper_shooter)),1000,1000),
          -- find a way to get angle so we can move it back a bit
          "Angle", self:GetAngle(),
          "resource", self.resource,
          "destroy_when_empty", true
        })
      end
      -- why doesn't this work in PlaceObj? needs happen after GameInit maybe?
      stockpile.max_z = 10
      stockpile.Miner_Handle = self.handle
      self.stockpile = stockpile
    end
    --  stops at 100 per stockpile
    if self.stockpile:GetStoredAmount() < self.max_res_amount then
      self.ui_working = true
      -- remove the sign
      self:ShowNotWorkingSign(false)
      -- up n down n up n down
      self:SetStateText(self.default_anim)
      Sleep(self.anim_time or self:TimeToAnimEnd())

      local mined
      -- mine some shit
      if self.resource == "Concrete" then
        mined = self:DigErUpConcrete(self.mine_amount)
      elseif self.resource == "Metals" or self.resource == "PreciousMetals" then
        mined = self:DigErUpMetals(self.mine_amount)
      end
      if mined then
        -- update stockpile
        self.stockpile:AddResourceAmount(mined)
        local infoamount = ResourceOverviewObj.data[self.resource]
        infoamount = infoamount + 1
        self.produced_total = self.produced_total + mined
        self.produced_last_deposit = self.produced_last_deposit + mined
      end
    else
      self.ui_working = false
      -- no need to keep on re-showing sign (assuming there isn't a check for this, but an if bool is quicker then whatever it does)
      if not self.notworking_sign then
        self:ShowNotWorkingSign(true)
      end
    end
  end

  -- if not idle state then make idle state
  if self:GetState() ~= 0 then
    self:SetState(self.default_anim_idle)
  end
  Sleep(self.idle_time or self:TimeToAnimEnd())
  -- self:SetCommand("Idle")
end

function PortableMiner:SetCommand(command,...)
  if command ~= "Load" then
    self.produced_last_deposit = 0
  end
  CommandObject.SetCommand(self,command, ...)
end

-- shoehorn in a way to update global production values
function PortableMiner:GetResourceProduced()
  return self.produced_last_deposit
end

function PortableMiner:DigErUpMetals(amount)
  if not IsValid(self.nearby_deposits) then
    self.nearby_deposits = false
    return
  end

  amount = self.nearby_deposits:TakeAmount(amount)
  Msg("ResourceExtracted", self.nearby_deposits.resource, amount)

  if self.nearby_deposits:IsDepleted() then
    -- omg it's isn't doing anythings @!@!#!?
		table.insert_unique(g_IdleExtractors, self)
    self:ShowNotWorkingSign(true)
    self.produced_last_deposit = 0

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
  -- local shape = self:GetExtractionShape()
  -- there's QuarryExcavator,QuarryClosedShape, and Quarry. but those won't get the whole thing from the center
  local shape = GetEntityCombinedShape(self.mine_area)
  if not info or not shape then
    return
  end

  local extracted, remaining = TerrainDeposit_Extract(shape, self, TerrainDepositGrid, info, amount)
  Msg("ResourceExtracted", self.resource, extracted)

  if remaining == 0 then
    -- omg it's isn't doing anythings @!@!#!?
		table.insert_unique(g_IdleExtractors, self)
    -- delete that shit
    local deposit = self.nearby_deposits
    self.produced_last_deposit = 0
    if IsValid(deposit) and deposit:GetAmount() < 10 * const.ResourceScale then
--~     if IsValid(deposit) then
      deposit.depleted = true
      DoneObject(deposit)
      self.nearby_deposits = false
    end
  end

  if extracted == 0 then
    return
  end

  return extracted
end

function PortableMiner:CanExploit(deposit)
	deposit = deposit or self.nearby_deposits
	return IsValid(deposit)
end

function PortableMiner:OnSelected()
	self:AttachSign(false,"SignNotWorking")
  table.remove_entry(g_IdleExtractors, self)
end

-- needed for Concrete
function PortableMiner:GetDepositResource()
  return self.resource
end
-- function PortableMiner:GetExtractionShape()
--   return GetEntityCombinedShape("DomeMega")
-- end

--~ function PortableMiner:GetUISectionMineRollover()
--~ 	local lines = {
--~ 		T{466, "Production per Sol (predicted)<right><resource(PredictedDailyProduction, GetResourceProduced)>", self},
--~ 		T{468, "Lifetime production<right><resource(LifetimeProduction,exploitation_resource)>", self},
--~ 	}
--~ 	AvailableDeposits(self, lines)

--~ 	return TConcat(lines, "<newline><left>")
--~ end

--~ function PortableMiner:GetDepositResource()
--~ 	return self.resource
--~ end

--~ function PortableMiner:GetResourceProducedIcon()
--~ 	return Concat("UI/Icons/Sections/",self.resource,"_2.tga")
--~ end

function OnMsg.ClassesPostprocess()

  PlaceObj("BuildingTemplate",{
    "Id","PortableMinerBuilding",
    "template_class","PortableMinerBuilding",
    -- pricey
    "construction_cost_Metals",40000,
    "construction_cost_MachineParts",40000,
    "construction_cost_Electronics",20000,

    "dome_forbidden",true,
    "display_name",[[RC Miner]],
    "display_name_pl",[[RC Miner]],
    "description",[[Will slowly mine Metal or Concrete into a resource pile.]],
    "build_category","Infrastructure",
    "Group", "Infrastructure",
    "display_icon", Concat(ChoGGi_Miner.ModPath,"/rover_combat.tga"),
    "encyclopedia_exclude",true,
    "on_off_button",false,
    "prio_button",false,
    "entity","CombatRover",
    "palettes","AttackRoverBlue"
  })

end -- ClassesPostprocess

--~ function OnMsg.ClassesBuilt()

--~   if not XTemplates.ipAttackRover.ChoGGi_PortableMiner then
--~     XTemplates.ipAttackRover.ChoGGi_PortableMiner = true

--~     XTemplates.ipAttackRover[1][#XTemplates.ipAttackRover[1]+1] = PlaceObj("XTemplate", {
--~       ChoGGi_PortableMiner, true,
--~       group = "Infopanel Sections",
--~       id = "sectionMine",
--~       PlaceObj("XTemplateTemplate", {
--~         "__context_of_kind", "PortableMiner",
--~         "__template", "InfopanelSection",
--~         "RolloverText", T{604012311372, -- [[XTemplate sectionMine RolloverText]] "<UISectionMineRollover>"},
--~         "Title", T{80, -- [[XTemplate sectionMine Title]] "Production"},
--~         "Icon", "UI/Icons/Sections/facility.tga",
--~       }, {
--~         PlaceObj("XTemplateCode", {
--~           "run", function (self, parent, context)
--~             parent.parent:SetIcon(context:GetResourceProducedIcon())
--~           end,
--~         }),
--~         PlaceObj("XTemplateTemplate", {
--~           "__template", "InfopanelText",
--~           "Text", T{472, -- [[XTemplate sectionMine Text]] "Production per Sol<right><resource(PredictedDailyProduction, GetResourceProduced)>"},
--~         }),
--~       }),
--~     })


--~   end -- XTemplates

--~ end -- ClassesBuilt
