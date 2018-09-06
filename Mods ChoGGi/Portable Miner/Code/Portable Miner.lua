-- See LICENSE for terms

local LICENSE = [[Any code from https://github.com/HaemimontGames/SurvivingMars is copyright by their LICENSE

All of my code is licensed under the MIT License as follows:

MIT License

Copyright (c) [2018] [ChoGGi]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.]]

-- if we use global func more then once: make them local for that small bit o' speed
local select,tostring,type,pcall,table = select,tostring,type,pcall,table

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

DefineClass.PortableMiner = {
	__parents = {
		"BaseRover",
		"ComponentAttach",
		-- mining
		"ResourceProducer",
		"TerrainDepositExtractor",
		-- battery
		"BuildingDepositExploiterComponent",
	},

	-- how much to mine
	mine_amount = 1 * const.ResourceScale,
--~     mine_amount = 100 * const.ResourceScale,
	-- how much to store in res pile
	max_res_amount = 100 * const.ResourceScale, -- visible is limited to 100
--~     max_res_amount = 10000 * const.ResourceScale,
	-- mine once an hour
	building_update_time = const.HourDuration,

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
--~ 	battery_hourly_drain_rate = 0,
	-- stuff for mining

	last_serviced_time = 0,
	resource = "Metals",
	nearby_deposits = false,
	accumulate_dust = true,
	notworking_sign = false,
	pooper_shooter = "Droneentrance",

	produced_total = 0,
	produced_last_deposit = 0,

	entity = "CombatRover",

  name = [[RC Miner]],
	description = [[Will slowly mine Metal or Concrete into a resource pile.]],
	display_icon = string.format("%srover_combat.tga",CurrentModPath),
}

DefineClass.PortableMinerBuilding = {
	__parents = {"BaseRoverBuilding"},
	rover_class = "PortableMiner",
}

function PortableMiner:GameInit()
	-- colour #, Color, Roughness, Metallic
	-- middle area
	self:SetColorizationMaterial(1, -10592674, -128, 120)
	-- body
	self:SetColorizationMaterial(2, -9013642, 120, 20)
	-- color of bands
	self:SetColorizationMaterial(3, -13031651, -128, 48)

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

end

function PortableMiner:Idle()
  if self.ui_working and self:DepositNearby() then
    --  get to work
    self:SetCommand("Load")
  elseif not self.ui_working and
    -- check if stockpile is existing and full
      (self:GetDist2D(self.stockpile) >= 5000 or
      self.stockpile and self.stockpile:GetStoredAmount() < self.max_res_amount) then
    self.ui_working = true
    self:ShowNotWorkingSign(false)
  end

	self:Gossip("Idle")
	self:SetState("idle")
	Halt()
end

function PortableMiner:DepositNearby()
  local res = NearestObject(self:GetLogicalPos(),UICity.labels.SubsurfaceDeposit,self.mine_dist)
	if not res then
		res = NearestObject(self:GetLogicalPos(),UICity.labels.TerrainDeposit,self.mine_dist)
	end
--~ 	if not res then
--~ 		res = NearestObject(self:GetLogicalPos(),UICity.labels.SurfaceDeposit,self.mine_dist)
--~ 	end

	if res then
		-- if it's surface then we're good, if it's sub then check depth + tech researched
--~ 		if res:IsKindOfClasses("SurfaceDepositMetals","TerrainDepositConcrete") or
		if res:IsKindOf("TerrainDepositConcrete") or
				(res:IsKindOfClasses("SubsurfaceDepositPreciousMetals","SubsurfaceDepositMetals") and
				(res.depth_layer < 2 or UICity:IsTechResearched("DeepMetalExtraction"))) then
			self.resource = res.resource
			self.nearby_deposits = res
			return true
		end
	end
	-- nadda
	self.nearby_deposits = false
	return false
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
      local stockpile = NearestObject(self:GetLogicalPos(),UICity.labels.ResourceStockpile,5000)

      if not stockpile or stockpile and (stockpile.resource ~= self.resource or stockpile.Miner_Handle ~= self.handle) then
        -- plunk down a new res stockpile
        stockpile = PlaceObj("ResourceStockpile", {
          -- time to get all humping robot on christmas
          "Pos", MovePointAway(self:GetDestination(), self:GetSpotLoc(self:GetSpotBeginIndex(self.pooper_shooter)), -800),
          "Angle", self:GetAngle(),
          "resource", self.resource,
          "destroy_when_empty", true
        })
      end
      -- why doesn't this work in PlaceObj? needs happen after GameInit maybe?
      stockpile.max_z = 10
      stockpile.Miner_Handle = self.handle
			--
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

	-- stupid surface deposits
--~ 	if self.nearby_deposits:IsKindOfClasses("SurfaceDepositGroup","SurfaceDepositMetals","SurfaceDepositConcrete","SurfaceDepositPolymers") then
--~ 		local res = self.nearby_deposits
--~ 		res = res.group and res.group[1] or res
--~ 		-- get one with amounts
--~ 		while true do
--~ 			if res.transport_request:GetActualAmount() == 0 then
--~ 				table.remove(self.nearby_deposits.group,1)
--~ 				res = self.nearby_deposits
--~ 				res = res.group and res.group[1] or res
--~ 			else
--~ 				break
--~ 			end
--~ 		end
--~ 		-- remove what we need
--~ 		if res.transport_request:GetActualAmount() >= amount then
--~ 			res.transport_request:SetAmount(amount * -1)
--~ 		end
--~ 	else
--~ 		amount = self.nearby_deposits:TakeAmount(amount)
--~ 	end
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

--~ 	return table.concat(lines, "<newline><left>")
--~ end

--~ function PortableMiner:GetDepositResource()
--~ 	return self.resource
--~ end

--~ function PortableMiner:GetResourceProducedIcon()
--~ 	return string.format("UI/Icons/Sections/%s_2.tga",self.resource)
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
--~     "display_name_pl",[[RC Miner]],
    "description",[[Will slowly mine Metal or Concrete into a resource pile.]],
    "build_category","Infrastructure",
    "Group", "Infrastructure",
    "display_icon", string.format("%srover_combat.tga",CurrentModPath),
    "encyclopedia_exclude",true,
    "on_off_button",false,
--~     "prio_button",false,
    "entity","CombatRover",
    "palettes","AttackRoverBlue"
  })

end -- ClassesPostprocess
