-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 59
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error","RC Miner requires ChoGGi's Library (at least v" .. min_version .. [[).
Press OK to download it or check the Mod Manager to make sure it's enabled.]]) == "ok" then
				if p.steam then
					OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
				elseif p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/505/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/89?tab=files")
				end
			end
		end)
	end
end

PortableMinerSettings = {
	-- how much to mine each time
	mine_amount = 1 * const.ResourceScale,
	-- how much to store in res pile (10*10 = 100)
	max_res_amount_man = 90 * const.ResourceScale,
	-- how high we stack on the pile (10 per stack)
	max_z_stack_man = 9,
	-- amount in auto
	max_z_stack_auto = 250,
	max_res_amount_auto = 2500 * const.ResourceScale,
	-- ground paint
	visual_cues = true,

	mine_time_anim = {
		Concrete = 1000,
		Metals = 2000,
		PreciousMetals = 10000,
	},
	mine_time_idle = {
		Concrete = 1500,
		Metals = 3000,
		PreciousMetals = 15000,
	},
}

-- local some repeat funcs
local table = table

local IsValid = IsValid
local MovePointAway = MovePointAway
local MapFindNearest = MapFindNearest
local PlaceObj = PlaceObj
local Sleep = Sleep
local GetUIRollover = ResourceProducer.GetUISectionResourceProducerRollover

local name = [[RC Miner]]
local description = [[Will slowly (okay maybe a little quickly) mine Metal or Concrete into a resource pile.]]
local display_icon = CurrentModPath .. "UI/rover_combat.png"

-- if you want to change the entity, scale, animation
--~ entity = "Lama"
--~ entity = "Kosmonavt"
--~ custom_scale = 500 -- 100 is default size
--~ custom_anim = "playBasketball" -- object:GetStates()
--~ custom_anim = "playTaiChi" -- takes quite awhile, may want to increase mined amount or set limit on time
--~ custom_anim_idle = "layDying"

--~ g_NotWorkingBuildings

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
	display_name = name,
	description = description,
	display_icon = display_icon,

	entity = "CombatRover",
	default_anim = "attackIdle",
	default_anim_idle = "idle",
	entity_scale = false,

	-- how close to the resource icon do we need to be
	mine_dist = 1500,
	-- area around it to mine for concrete. this gets called everytime you mine, so we just get the default shape once and use that instead of this func
	mine_area = RegolithExtractor.GetExtractionShape(),
	-- what spot on the entity to use as placement for the stockpile
	pooper_shooter = "Droneentrance",

	-- we store each type of res in here, and just use lifetime_production as something to update from this. That way we can show each type in hint
	lifetime_table = {
		All = 0,
		Concrete = 0,
		Metals = 0,
		PreciousMetals = 0,
	},
	lifetime_production = 0,
	production_per_day = 0,

	has_auto_mode = true,

	malfunction_start_state = "malfunction",
	malfunction_idle_state = "malfunctionIdle",
	malfunction_end_state = "malfunctionEnd",

	-- stops error when adding signs (Missing spot 'Top'), it doesn't have a Top spot, but Rocket is slightly higher then Origin
	sign_spot = "Rocket",

	-- erm... something?
	last_serviced_time = 0,
	-- probably doesn't need a default res, but it may stop some error in the log?
	resource = "Metals",
	-- nearby_deposits name is needed for metal extractor func
	nearby_deposits = {},
	accumulate_dust = true,
	-- changed below
	notworking_sign = false,
	-- refund res
	on_demolish_resource_refund = { Metals = 20 * const.ResourceScale, MachineParts = 20 * const.ResourceScale , Electronics = 10 * const.ResourceScale },
}

DefineClass.PortableMinerBuilding = {
	__parents = {"BaseRoverBuilding"},
	rover_class = "PortableMiner",
}

DefineClass.PortableStockpile = {
	__parents = {"ResourceStockpile"},
}

function PortableMiner:GameInit()
--~ 	BaseRover.GameInit(self)

	-- select sounds
	self.fx_actor_class = "AttackRover"

	-- colour #, Color, Roughness, Metallic
	-- middle area
	self:SetColorizationMaterial(1, -10592674, -128, 120)
	-- body
	self:SetColorizationMaterial(2, -5987164, 120, 20)
	-- color of bands
	self:SetColorizationMaterial(3, -13031651, -128, 48)

  if self.entity_scale then
    self:SetScale(self.entity_scale)
  end

	-- show the pin info
	self.producers = {self}
	self.pin_rollover = T(0,"<ui_command>")
end

-- retrieves prod info
local function BuildProdInfo(self,info,res_name)
	if self.resource ~= res_name then
		info[#info+1] = T{476, "Lifetime production<right><resource(LifetimeProduction,resource)>",
			resource = res_name, LifetimeProduction = self.lifetime_table[res_name], self}
	end
end
--~ function PortableMiner:GetCargoManifest()
function PortableMiner:Getui_command()
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
		local deposit_pos = GetPassablePointNearby(deposit:GetPos())
		if self:HasPath(deposit_pos, "Origin") then
			-- if leaving an empty site then this sign should be turned off
			self:ShowNotWorkingSign(false)
			self:SetCommand("Goto",deposit_pos)
		else
			unreachable_objects[deposit] = true
		end
	else
		-- turn off auto for all miners if no deposits
		local miners = UICity.labels.PortableMiner or ""
		for i = 1, #miners do
			miners[i].auto_mode_on = false
			miners[i]:ShowNotWorkingSign(true)
--~ 			miners[i]:SetCommand("Idle",10000)
			miners[i]:SetCommand("Idle")
		end
	end
	Sleep(2500)
end

-- if we're in auto-mode then make the stockpile take more
function PortableMiner:ToggleAutoMode(broadcast)
	local pms = PortableMinerSettings
	-- if it's on it's about to be turned off
	if IsValid(self.stockpile) then
		self.stockpile.max_z = self.auto_mode_on and pms.max_z_stack_man or pms.max_z_stack_auto
	end
	return BaseRover.ToggleAutoMode(self,broadcast)
end

function PortableMiner:Idle()
	local pms = PortableMinerSettings
	-- if there's one near then mine that bugger
  if self:DepositNearby() then
    self:ShowNotWorkingSign(false)
    --  get to work
    self:SetCommand("Load")
	-- we in auto-mode?
	elseif g_RoverAIResearched and self.auto_mode_on then
		self:ProcAutomation()
	-- check if stockpile is existing and full
  elseif not self.notworking_sign and IsValid(self.stockpile) and (self:GetDist2D(self.stockpile) >= 5000 or
						self.stockpile:GetStoredAmount() < (self.auto_mode_on and pms.max_res_amount_auto or pms.max_res_amount_man)) then
    self:ShowNotWorkingSign(false)
  end

--~ 	Sleep(type(delay) == "number" or 2500)

	self:Gossip("Idle")
	self:SetState("idle")
	-- kill off thread if we're in one
	Halt()
end

function PortableMiner:DepositNearby()
	local d = MapFindNearest(self, "map", "SubsurfaceDeposit", "TerrainDeposit", --[["SurfaceDeposit",--]] function(o)
		return self:GetDist2D(o) < self.mine_dist
	end)

		-- if it's concrete and there's a marker then we're good, if it's sub then check depth + tech researched
	if d and (d:IsKindOf("TerrainDepositConcrete") and d:GetDepositMarker() or
					(d:IsKindOfClasses("SubsurfaceDepositPreciousMetals","SubsurfaceDepositMetals") and
					(d.depth_layer < 2 or UICity:IsTechResearched("DeepMetalExtraction")))) then
		-- let miner know what kind we're mining
		self.resource = d.resource
		-- we need to store res as [1] to use the built-in metal extract func
		self.nearby_deposits[1] = d
		-- untouched concrete starts off with false for the amount...
		d.amount = d.amount or d.max_amount

		return true
	end

	-- nadda
	table.iclear(self.nearby_deposits)
	return false
end

function PortableMiner:ShowNotWorkingSign(bool)
  if bool then
    self.notworking_sign = true
    self:AttachSign(self.notworking_sign,"SignNotWorking")
  else
    self.notworking_sign = false
    self:AttachSign(self.notworking_sign,"SignNotWorking")
  end
end

-- get rid of it showing up in the buildings not working OnScreenNotificationPreset
function PortableMiner:SetWorking()
	work = not not work
	local old_working = self.working
	self.working = work
	if self.working == old_working then
		return
	end
	self:OnSetWorking(work)
end

-- called it Load so it uses the load resource icon in pins
function PortableMiner:Load()
	local pms = PortableMinerSettings

	local skip_end
  if #self.nearby_deposits > 0 then
    -- remove removed stockpile
    if not IsValid(self.stockpile) then
      self.stockpile = false
    end
		-- check if a stockpile is in dist, and if it's the correct res, and not another miner's pile
    if not self.stockpile or self:GetDist2D(self.stockpile) > 5000 or
					self.stockpile and (self.stockpile.resource ~= self.resource or self.stockpile.miner_handle ~= self.handle) then
			-- try to get one close by
			local stockpile = MapFindNearest(self, "map", "PortableStockpile", function(o)
				return self:GetDist2D(o) < 5000
			end)

    -- add new stockpile if none
      if not stockpile or stockpile and (stockpile.resource ~= self.resource or stockpile.miner_handle ~= self.handle) then
        -- plunk down a new res stockpile
        stockpile = PlaceObj("PortableStockpile", {
          -- time to get all humping robot on christmas
          "Pos", MovePointAway(self:GetDestination(), self:GetSpotLoc(self:GetSpotBeginIndex(self.pooper_shooter)), -800),
          "Angle", self:GetAngle(),
          "resource", self.resource,
          "destroy_when_empty", true
        })
      end
      stockpile.miner_handle = self.handle
      -- why doesn't this work in PlaceObj? needs happen after GameInit maybe?
      stockpile.max_z = self.auto_mode_on and pms.max_z_stack_auto or pms.max_z_stack_man
			-- assign it to the miner
      self.stockpile = stockpile
    end
    --  stop at max_res_amount per stockpile
    if self.stockpile:GetStoredAmount() < (self.auto_mode_on and pms.max_res_amount_auto or pms.max_res_amount_man) then
      -- remove the sign
      self:ShowNotWorkingSign(false)
      -- up n down n up n down
      self:SetStateText(self.default_anim)
      Sleep(pms.mine_time_anim[self.resource] or self:TimeToAnimEnd())

      -- mine some loot
      local mined = self:DigErUp(pms)
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
		Sleep(pms.mine_time_idle[self.resource] or self:TimeToAnimEnd())
	end
end

function OnMsg.NewDay() -- NewSol...
	-- reset the prod count (for overview or something)
	local miners = UICity.labels.PortableMiner or ""
	for i = 1, #miners do
		miners[i].production_per_day = 0
	end
end

-- called when the mine is gone/empty (returns nil to skip the add res amount stuff)
local function MineIsEmpty(miner)
	-- it's done so remove our ref to it
	table.iclear(miner.nearby_deposits)
	-- needed to mine other concrete
	miner.found_deposit = false
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

-- for painting the ground
local concrete_paint = table.find(TerrainTextures, "name", "Dig")
local metal_paint = table.find(TerrainTextures, "name", "SandFrozen")
local SetTypeCircle = terrain.SetTypeCircle
local function Random(m, n)
	return AsyncRand(n - m + 1) + m
end

function PortableMiner:DigErUp(pms)
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

	local amount = pms.mine_amount
	-- if there isn't much left get what's left
	if amount > d.amount then
		amount = d.amount
	end

	local extracted,paint
	if self.resource == "Concrete" then
		extracted = TerrainDepositExtractor.ExtractResource(self,amount)
		paint = concrete_paint
	elseif self.resource == "Metals" or self.resource == "PreciousMetals" then
		extracted = BuildingDepositExploiterComponent.ExtractResource(self,amount)
		paint = metal_paint
	end

	-- if it's empty ExtractResource will delete it
  if extracted == 0 or not IsValid(d) then
    return MineIsEmpty(self)
  end

	-- visual cues
	if pms.visual_cues then
		local pt = self:GetLogicalPos()
		pt = point(pt:x()+Random(-5000, 5000),pt:y()+Random(-5000, 5000))
		SetTypeCircle(pt, 250, paint)
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
	if not BuildingTemplates.PortableMinerBuilding then
		PlaceObj("BuildingTemplate",{
			"Id","PortableMinerBuilding",
			"template_class","PortableMinerBuilding",
			-- pricey?
			"construction_cost_Metals",40000,
			"construction_cost_MachineParts",40000,
			"construction_cost_Electronics",20000,
			-- add a bit of pallor to the skeleton
			"palette_color1", "rover_base",

			"dome_forbidden",true,
			"display_name",name,
			"display_name_pl",name,
			"description",description,
			"build_category","ChoGGi",
			"Group", "ChoGGi",
			"display_icon", display_icon,
			"encyclopedia_exclude",true,
			"count_as_building",false,
			"prio_button",false,
			"on_off_button",false,
			"entity","CombatRover",
		})
	end
end

--~ -- add some prod info to selection panel
--~ function OnMsg.ClassesBuilt()
--~ 	local rover = XTemplates.ipRover[1]

--~ 	-- check for and remove existing template
--~ 	ChoGGi.ComFuncs.RemoveXTemplateSections(rover,"ChoGGi_Template_PortableMiner_Prod",true)

--~ 	table.insert(
--~ 		rover,
--~ 		#rover,
--~ 		PlaceObj('XTemplateTemplate', {
--~ 			"ChoGGi_Template_PortableMiner_Prod", true,
--~ 			"__context_of_kind", "PortableMiner",
--~ 			"__template", "InfopanelSection",
--~ 			"Title", T(80, "Production"),
--~ 			"Icon", "UI/Icons/Sections/storage.tga",
--~ 		}, {
--~ 			PlaceObj("XTemplateTemplate", {
--~ 				"__template", "InfopanelText",
--~ 				"Text",  T(0,"<CargoManifest>"),
--~ 			}),
--~ 		})
--~ 	)
--~ end
