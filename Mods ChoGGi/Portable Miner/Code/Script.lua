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

-- local some repeat funcs
local table = table
local StringFormat = string.format
local IsValid = IsValid
local MovePointAway = MovePointAway
local NearestObject = NearestObject
local PlaceObj = PlaceObj
local Sleep = Sleep
local GetUIRollover = ResourceProducer.GetUISectionResourceProducerRollover

local name = [[RC Miner]]
local description = [[Will slowly (okay maybe a little quickly) mine Metal or Concrete into a resource pile.]]
local display_icon = StringFormat("%srover_combat.png",CurrentModPath)

-- how much to mine each time
local mine_amount = 1 * const.ResourceScale
-- how high we stack on the pile (10 per stack)
local max_z_stack = 10
-- how much to store in res pile (10*10 = 100)
local max_res_amount = 100 * const.ResourceScale
-- amount in auto
local max_res_amount_auto = 2500 * const.ResourceScale
local max_z_stack_auto = 250

--[[testing
local mine_amount = 100 * const.ResourceScale
local max_res_amount = 10000 * const.ResourceScale
local max_z_stack = 1000
-- careful about stacking too high, SM has a world height limit of 65536 (if you save with an object's origin? above that goodbye save)

local mine_amount = 1 * const.ResourceScale
local max_res_amount = 10 * const.ResourceScale
local max_z_stack = 1
--]]

-- how close to the resource icon do we need to be
local mine_dist = 1500
-- area around it to mine for concrete. this gets called everytime you mine, so we just get the default shape once and use that instead of this func
local mine_area = RegolithExtractor.GetExtractionShape()

-- set to false to use length of animation (these are in game times, i think at normal speed 1 is 1 millisecond)
local anim_time = 1000
local idle_time = 1500
--~ local anim_time = false
--~ local idle_time = false

-- what spot on the entity to use as placement for the stockpile
local pooper_shooter = "Droneentrance"

local entity = "CombatRover"
local custom_scale
local custom_anim
local custom_anim_idle
-- if you want to change the entity, scale, animation
--~ local entity = "Lama"
--~ local entity = "Kosmonavt"
--~ local custom_scale = 500 -- 100 is default size
--~ local custom_anim = "playBasketball" -- object:GetStates()
--~ local custom_anim = "playTaiChi" -- takes quite awhile, may want to increase mined amount or set limit on time
--~ local custom_anim_idle = "layDying"

DefineClass.PortableMiner = {
	__parents = {
		"BaseRover",
		"ComponentAttach",
		-- needed for concrete
		"TerrainDepositExtractor",
		-- not needed for metals, but to show prod info...
		"BuildingDepositExploiterComponent",
	},
	-- these are all set above
  name = name,
	description = description,
	display_icon = display_icon,
	mine_amount = mine_amount,
	max_res_amount = max_res_amount,
	max_z_stack = max_z_stack,
	anim_time = anim_time,
	idle_time = idle_time,
	entity = entity,
	custom_scale = custom_scale,
	custom_anim = custom_anim,
	custom_anim_idle = custom_anim_idle,
	mine_dist = mine_dist,
	mine_area = mine_area,
	pooper_shooter = pooper_shooter,

	-- erm... something?
	last_serviced_time = 0,
	-- probably doesn't need a default res, but it may stop some error in the log?
	resource = "Metals",
	-- used for building prod info
	resource_fake = false,
	-- nearby_deposits name is needed for metal extractor func
	nearby_deposits = {},
	accumulate_dust = true,
	notworking_sign = false,

	-- we store each type of res in here, and just use lifetime_production as something to update from this. That way we can show each type in hint
	lifetime_table = {
		Metals = 0,
		PreciousMetals = 0,
		Concrete = 0,
		All = 0,
	},
	lifetime_production = 0,
	production_per_day = 0,

	-- be nice to get this working as well
	has_auto_mode = true,

	malfunction_start_state = "malfunction",
	malfunction_idle_state = "malfunctionIdle",
	malfunction_end_state = "malfunctionEnd",

	-- stop error when adding signs (Missing spot 'Top'), it doesn't get a Top spot, but Rocket is slightly higher then Origin
	sign_spot = "Rocket",
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
    self.default_anim_idle = "idle"
  end

	-- show the pin info
	self.producers = {self}
	self.pin_rollover = T{0,"<CargoManifest>"}
end

-- retrieves prod info
local function BuildProdInfo(self,info,res_name)
	if self.resource ~= res_name then
		info[#info+1] = T{476, "Lifetime production<right><resource(LifetimeProduction,resource)>",
			resource = res_name, LifetimeProduction = self.lifetime_table[res_name], self}
	end
end
function PortableMiner:GetCargoManifest()
	local info = {}
	-- add life time info from the not selected reses
	BuildProdInfo(self,info,"Metals")
	BuildProdInfo(self,info,"PreciousMetals")
	BuildProdInfo(self,info,"Concrete")
	-- change lifetime to lifetime of that res
	self.lifetime_production = self.lifetime_table[self.resource]
	info[#info+1] = GetUIRollover(self)
	self.lifetime_production = self.lifetime_table.All
	return table.concat(info, "<newline><left>")
end
-- fake it till you make it (needed by GetUISectionResourceProducerRollover)
function PortableMiner:GetAmountStored()
	return self.stockpile and self.stockpile:GetStoredAmount() or 0
end
function PortableMiner:GetResourceProduced()
  return self.resource
end
function PortableMiner:GetPredictedDailyProduction()
	return self.production_per_day
end


-- needs this for the auto button to show up
PortableMiner.ToggleAutoMode_Update = RCTransport.ToggleAutoMode_Update

-- for auto mode
function PortableMiner:ProcAutomation()
	local unreachable_objects = self:GetUnreachableObjectsTable()
	local deposit = MapFindNearest(self, "map", "TerrainDepositConcrete", "SubsurfaceDepositPreciousMetals", "SubsurfaceDepositMetals",function(d)
		if d:IsKindOf("TerrainDepositConcrete") and d:GetDepositMarker() or
				(d:IsKindOfClasses("SubsurfaceDepositPreciousMetals","SubsurfaceDepositMetals") and
				(d.depth_layer < 2 or UICity:IsTechResearched("DeepMetalExtraction"))) then
			return not unreachable_objects[d]
		end
	end)

	if deposit then
		local deposit_pos = deposit:GetPos()
		if pf.HasPath(self:GetPos(), self.pfclass, deposit_pos) then
			self:SetCommand("Goto",deposit_pos)
		else
			unreachable_objects[deposit] = true
		end
	else
		-- turn off auto for all miners if no deposits
		local miners = UICity.labels.PortableMiner or ""
		for i = 1, #miners do
			miners[i].auto_mode_on = false
			miners[i]:SetCommand("Idle")
		end
	end
end

-- if we're in auto-mode then make the stockpile take more
function PortableMiner:ToggleAutoMode(broadcast)
	-- if it's on it's about to be turned off
	if auto_mode_on then
		self.max_res_amount = max_res_amount
		self.max_z_stack = max_z_stack
	else
		self.max_res_amount = max_res_amount_auto
		self.max_z_stack = max_z_stack_auto
	end
	return BaseRover.ToggleAutoMode(self,broadcast)
end

function PortableMiner:Idle()

	-- if there's one near then mine that shit
  if self:DepositNearby() then
    self:ShowNotWorkingSign(false)
    --  get to work
    self:SetCommand("Load")
	-- we in auto-mode?
	elseif g_RoverAIResearched and self.auto_mode_on then
		self:ProcAutomation()
		-- probably not needed anymore
		Sleep(1000)
	-- check if stockpile is existing and full
  elseif not self.notworking_sign and self.stockpile and (self:GetDist2D(self.stockpile) >= 5000 or
						self.stockpile:GetStoredAmount() < self.max_res_amount) then
    self:ShowNotWorkingSign(false)
  end

	self:Gossip("Idle")
	self:SetStateText(self.default_anim_idle)
	-- kill off thread if we're in one
	Halt()
end

function PortableMiner:DepositNearby()
  local d = NearestObject(self:GetLogicalPos(),UICity.labels.SubsurfaceDeposit,self.mine_dist)
	if not d then
		d = NearestObject(self:GetLogicalPos(),UICity.labels.TerrainDeposit,self.mine_dist)
	end
--~ 	if not d then
--~ 		d = NearestObject(self:GetLogicalPos(),UICity.labels.SurfaceDeposit,self.mine_dist)
--~ 	end

	if d then
		-- if it's concrete and there's a marker then we're good, if it's sub then check depth + tech researched
		if d:IsKindOf("TerrainDepositConcrete") and d:GetDepositMarker() or
				(d:IsKindOfClasses("SubsurfaceDepositPreciousMetals","SubsurfaceDepositMetals") and
				(d.depth_layer < 2 or UICity:IsTechResearched("DeepMetalExtraction"))) then
			self.resource = d.resource
			-- we need to store res as [1] to use the built-in metal extract func
			self.nearby_deposits = {d}
				-- untouched concrete starts off with false for the amount...
			d.amount = d.amount or d.max_amount
			return true
		end
	end
	-- nadda
	table.iclear(self.nearby_deposits)
	return false
end

function PortableMiner:ShowNotWorkingSign(bool)
  if bool then
    self.notworking_sign = true
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

	local skip_end
  if #self.nearby_deposits > 0 then
    -- remove removed stockpile
    if not IsValid(self.stockpile) then
      self.stockpile = false
    end
    -- add new stockpile if none
    if not self.stockpile or self:GetDist2D(self.stockpile) >= 5000 or
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
      stockpile.Miner_Handle = self.handle
      -- why doesn't this work in PlaceObj? needs happen after GameInit maybe?
      stockpile.max_z = self.max_z_stack
			-- assign it to the miner
      self.stockpile = stockpile
    end
    --  stop at max_res_amount per stockpile
    if self.stockpile:GetStoredAmount() < self.max_res_amount then
      -- remove the sign
      self:ShowNotWorkingSign(false)
      -- up n down n up n down
      self:SetStateText(self.default_anim)
      Sleep(self.anim_time or self:TimeToAnimEnd())

      -- mine some shit
      local mined
      if self.resource == "Concrete" then
        mined = self:DigErUp(self.mine_amount,true)
      elseif self.resource == "Metals" or self.resource == "PreciousMetals" then
        mined = self:DigErUp(self.mine_amount)
      end
      if mined then
				-- if it gets deleted by somebody mid mine :)
				if IsValid(self.stockpile) then
					-- update stockpile
					self.stockpile:AddResourceAmount(mined)
				else
					skip_end = true
					self.stockpile = false
				end
				local infoamount = ResourceOverviewObj.data[self.resource]
				infoamount = infoamount + 1
				-- per res
				self.lifetime_table[self.resource] = self.lifetime_table[self.resource] + mined
				-- combined
				self.lifetime_table.All = self.lifetime_table.All + mined
				-- probably need to do this for infobar?
				self.lifetime_production = self.lifetime_table.All
				-- daily reset
				self.production_per_day = self.production_per_day + mined
      end
    else
      -- no need to keep on re-showing sign (assuming there isn't a check for this, but an if bool is quicker then whatever it does)
      if not self.notworking_sign then
        self:ShowNotWorkingSign(true)
      end
    end
  end

	if not skip_end then
		-- if not idle state then make idle state (the raise up motion of the mining)
		if self:GetState() ~= 0 then
			self:SetStateText(self.default_anim_idle)
		end
		Sleep(self.idle_time or self:TimeToAnimEnd())
	end
end

function PortableMiner:SetCommand(command,...)
  if command ~= "Load" then
    self.production_per_day = 0
  end
  CommandObject.SetCommand(self,command, ...)
end

-- called when the mine is gone/empty (returns nil to skip the add res amount stuff)
local function MineIsEmpty(miner)
	-- it's done so remove our ref to it
	table.iclear(miner.nearby_deposits)
	-- if there's a mine nearby then off we go
  if miner:DepositNearby() then
    miner:SetCommand("Load")
		return
	end
	-- omg it's isn't doing anythings @!@!#!?
	table.insert_unique(g_IdleExtractors, miner)
	-- hey look at me!
	miner:ShowNotWorkingSign(true)
end

function OnMsg.NewDay() -- NewSol...
	-- reset the prod count (for overview or something)
	local miners = UICity.labels.PortableMiner or ""
	for i = 1, #miners do
		miners[i].production_per_day = 0
	end
end

function PortableMiner:DigErUp(amount,res_type)
	local d = self.nearby_deposits[1]

  if not IsValid(d) then
    return MineIsEmpty(self)
  end

--[[
	-- stupid surface deposits
	if self.nearby_deposits[1]:IsKindOfClasses("SurfaceDepositGroup","SurfaceDepositMetals","SurfaceDepositConcrete","SurfaceDepositPolymers") then
		local res = self.nearby_deposits[1]
		res = res.group and res.group[1] or res
		-- get one with amounts
		while true do
			if res.transport_request:GetActualAmount() == 0 then
				table.remove(self.nearby_deposits[1].group,1)
				res = self.nearby_deposits[1]
				res = res.group and res.group[1] or res
			else
				break
			end
		end
		-- remove what we need
		if res.transport_request:GetActualAmount() >= amount then
			res.transport_request:SetAmount(amount * -1)
		end
	else
		amount = self.nearby_deposits[1]:TakeAmount(amount)
	end
--]]

	-- if there isn't much left get what's left
	if amount > d.amount then
		amount = d.amount
	end

	-- save a ref to marker incase extract removes deposit
	local marker = d:GetDepositMarker()

	local extracted
	if res_type then
		extracted = TerrainDepositExtractor.ExtractResource(self,amount)
	else
		extracted = BuildingDepositExploiterComponent.ExtractResource(self,amount)
	end

	-- if it's empty ExtractResource will delete it
  if extracted == 0 or not IsValid(d) then
		-- remove the marker as well
		if IsValid(marker) then
			DoneObject(marker)
		end
    return MineIsEmpty(self)
  end

  return extracted
end

function PortableMiner:CanExploit()
	-- I don't need to check for tech here, since we check before we add it
	return IsValid(self.nearby_deposits[1])
end

function PortableMiner:OnSelected()
	self:AttachSign(false,"SignNotWorking")
  table.remove_entry(g_IdleExtractors, self)
end

-- needed for Concrete
function PortableMiner:GetExtractionShape()
  return self.mine_area
end

function OnMsg.ClassesPostprocess()

  PlaceObj("BuildingTemplate",{
    "Id","PortableMinerBuilding",
    "template_class","PortableMinerBuilding",
    -- pricey?
    "construction_cost_Metals",40000,
    "construction_cost_MachineParts",40000,
    "construction_cost_Electronics",20000,

    "dome_forbidden",true,
    "display_name",name,
    "display_name_pl",name,
    "description",description,
    "build_category","Infrastructure",
    "Group", "Infrastructure",
    "display_icon", display_icon,
    "encyclopedia_exclude",true,
    "on_off_button",false,
    "entity","CombatRover",
    "palettes","AttackRoverBlue"
  })

end

function OnMsg.ClassesBuilt()
	-- add some prod info to selection panel
	local rover = XTemplates.ipRover[1]
	-- check for and remove existing template
	local idx = table.find(rover, "ChoGGi_Template_PortableMiner_Prod", true)
	if idx then
		table.remove(rover,idx)
	end
	-- insert below status
	local status = table.find(rover, "Icon", "UI/Icons/Sections/sensor.tga")
	if status then
		status = status + 1
	else
		status = #rover
	end

	local prod_text
	table.insert(
		rover,
		status,
		PlaceObj('XTemplateTemplate', {
			"ChoGGi_Template_PortableMiner_Prod", true,
			"__context_of_kind", "PortableMiner",
			"__template", "InfopanelSection",
			"Title", T{80, "Production"},
			"Icon", "UI/Icons/Sections/storage.tga",
		}, {
			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelText",
				"Text",  T{0,"<CargoManifest>"},
			}),
		})
	)
--~
end
