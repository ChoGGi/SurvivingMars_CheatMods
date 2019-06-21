-- See LICENSE for terms

local r = const.ResourceScale
local pms = {
	-- how much to mine each time
	mine_amount = 1 * r,
	-- how much to store in res pile (10*10 = 100)
	max_res_amount_man = 90 * r,
	-- how high we stack on the pile (10 per stack)
	max_z_stack_man = 9,
	-- amount in auto
	max_z_stack_auto = 250,
	max_res_amount_auto = 2500 * r,
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

local options
local mod_ShowRocket

-- fired when settings are changed
local function ModOptions()
	pms.mine_amount = options.mine_amount * r
	pms.max_res_amount_man = options.max_res_amount_man * r
	pms.max_z_stack_man = options.max_res_amount_man / 10
	pms.max_res_amount_auto = options.max_res_amount_auto * r
	pms.max_z_stack_auto = options.max_res_amount_auto / 10

	pms.mine_time_anim.Concrete = options.mine_time_animConcrete
	pms.mine_time_idle.Concrete = options.mine_time_idleConcrete
	pms.mine_time_anim.Metals = options.mine_time_animMetals
	pms.mine_time_idle.Metals = options.mine_time_idleMetals
	pms.mine_time_anim.PreciousMetals = options.mine_time_animPreciousMetals
	pms.mine_time_idle.PreciousMetals = options.mine_time_idlePreciousMetals
	pms.visual_cues = options.visual_cues
	mod_ShowRocket = options.ShowRocket
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_PortableMiner" then
		return
	end

	ModOptions()
end

local function StartupCode()
	-- reset the prod count (for overview or something)
	local miners = UICity.labels.PortableMiner or ""
	for i = 1, #miners do
		local miner = miners[i]
		miner.city = UICity
		miner:SpawnThumper()
		if miner.lifetime_table then
			break
		end
		miner.lifetime_table = {
			All = 0,
			Concrete = 0,
			Metals = 0,
			PreciousMetals = 0,
			-- lukes
			Radioactive = 0,
			Hydrocarbon = 0,
			Crystals = 0,
		}
	end
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

-- for painting the ground
local concrete_paint = table.find(TerrainTextures, "name", "Dig")
local metal_paint = table.find(TerrainTextures, "name", "SandFrozen")

local name = T(302535920011207, [[RC Miner]])
local name_pl = T(302535920011208, [[RC Miners]])
local description = T(302535920011209, [[Will slowly (okay maybe a little quickly) mine Metal or Concrete into a resource pile.]])
local display_icon = CurrentModPath .. "UI/rover_combat.png"
local entity = "CombatRover"

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
	entity = entity,

	default_anim = "attackIdle",
	default_anim_idle = "idle",

	-- how close to the resource icon do we need to be
	mine_dist = 1500,
	-- area around it to mine for concrete. this gets called everytime you mine, so we just get the default shape once and use that instead of this func
	mine_area = RegolithExtractor.GetExtractionShape(),
	-- what spot on the entity to use as placement for the stockpile
	pooper_shooter = "Droneentrance",

	-- we store each type of res in here, and just use lifetime_production as something to update from this. That way we can show each type in hint
	lifetime_table = false,
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
	nearby_deposits = false,
	accumulate_dust = true,
	-- changed below
	notworking_sign = false,
	-- refund res
	on_demolish_resource_refund = { Metals = 20 * const.ResourceScale, MachineParts = 20 * const.ResourceScale , Electronics = 10 * const.ResourceScale },

	mineable = {
		"TerrainDepositConcrete",
		-- metals
		"SubsurfaceDepositPreciousMetals", "SubsurfaceDepositMetals",
		-- LukeH's Resources
		"SubsurfaceDepositCrystals", "SubsurfaceDepositRadioactive", --[["SubsurfaceDepositHydrocarbon",]]
	},

	-- living just enough for the city
	city = false,

	-- show the pin info
	pin_rollover = T(51, "<ui_command>"),

	-- add a missile to "grows" while mining
	thumper = false,
}

DefineClass.PortableMinerBuilding = {
	__parents = {"BaseRoverBuilding"},
	rover_class = "PortableMiner",
}

DefineClass.PortableStockpile = {
	__parents = {"ResourceStockpile"},
}

function PortableMiner:GameInit()

	self.city = UICity
	self.nearby_deposits = {}

	self.lifetime_table = {
		All = 0,
		Concrete = 0,
		Metals = 0,
		PreciousMetals = 0,
		-- lukes
		Radioactive = 0,
		Hydrocarbon = 0,
		Crystals = 0,
	}

	-- select sounds
	self.fx_actor_class = "AttackRover"

	-- Colour #, Colour, Roughness, Metallic (r/m go from -128 to 127)
	-- middle area
	self:SetColorizationMaterial(1, -10592674, -128, 120)
	-- body
	self:SetColorizationMaterial(2, -5987164, 120, 20)
	-- color of bands
	self:SetColorizationMaterial(3, -13031651, -128, 48)

	-- show the pin info
	self.producers = {self}

	self:SpawnThumper()
end

-- retrieves prod info
function PortableMiner:BuildProdInfo(info, res_name)
	if self.resource ~= res_name then
		info[#info+1] = T{476, "Lifetime production<right><resource(LifetimeProduction, resource)>",
			resource = res_name, LifetimeProduction = self.lifetime_table[res_name], self}
	end
end

function PortableMiner:Getui_command()
	local info = {}
	-- add life time info from the not selected reses
	self:BuildProdInfo(info, "Metals")
	self:BuildProdInfo(info, "PreciousMetals")
	self:BuildProdInfo(info, "Concrete")
	-- change lifetime to lifetime of that res
	self.lifetime_production = self.lifetime_table[self.resource]
	info[#info+1] = ResourceProducer.GetUISectionResourceProducerRollover(self)
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

function PortableMiner:Done()
	if IsValid(self.thumper) then
		DoneObject(self.thumper)
	end
end

function PortableMiner:SpawnThumper()
	if IsValid(self.thumper) then
		return
	end

	local thumper = MeteorInterceptParabolicRocket:new()
--~ 	local spot = self:GetSpotBeginIndex("Rocket")
--~ 	self:Attach(thumper, spot)

--~ 	local pos = self:GetSpotLoc(spot)
--~ 	thumper:SetPos(pos)
	thumper:SetScale(150)
	thumper:SetVisible(false)

	thumper:SetColorModifier(-16777216)

	self.thumper = thumper
end

function PortableMiner:Goto(...)
	self.thumper:SetVisible(false)
	return Unit.Goto(self, ...)
end

-- for auto mode
function PortableMiner:ProcAutomation()
	local unreachable_objects = self:GetUnreachableObjectsTable()
	local deposit = MapFindNearest(self, "map", "SubsurfaceDeposit", "TerrainDeposit", --[["SurfaceDeposit", ]] function(d)
		if d:IsKindOf("TerrainDepositConcrete") and d:GetDepositMarker() or
				(d:IsKindOfClasses(self.mineable) and
				(d.depth_layer < 2 or self.city:IsTechResearched("DeepMetalExtraction"))) then
			return not unreachable_objects[d]
		end
	end)

	if deposit then
		local deposit_pos = GetPassablePointNearby(deposit:GetPos())
		if self:HasPath(deposit_pos, "Origin") then
			-- if leaving an empty site then this sign should be turned off
			self:ShowNotWorkingSign(false)
			self:SetCommand("Goto", deposit_pos)
		else
			unreachable_objects[deposit] = true
		end
	else
		-- turn off auto for all miners if no deposits
		local miners = self.city.labels.PortableMiner or ""
		for i = 1, #miners do
			local miner = miners[i]
			miner.auto_mode_on = false
			miner:ShowNotWorkingSign(true)
			miner:SetCommand("Idle")
		end
	end
	Sleep(2500)
end

-- if we're in auto-mode then make the stockpile take more
function PortableMiner:ToggleAutoMode(broadcast)
	-- if it's on it's about to be turned off
	if IsValid(self.stockpile) then
		self.stockpile.max_z = self.auto_mode_on and pms.max_z_stack_man or pms.max_z_stack_auto
	end
	return BaseRover.ToggleAutoMode(self, broadcast)
end

function PortableMiner:Idle()
	-- if there's one near then mine that bugger
	if self:DepositNearby() then
		self:ShowNotWorkingSign(false)
		--	get to work
		self:SetCommand("Load")
	-- we in auto-mode?
	elseif g_RoverAIResearched and self.auto_mode_on then
		self:ProcAutomation()
	-- check if stockpile is existing and full
	elseif not self.notworking_sign and IsValid(self.stockpile)
			and (self:GetVisualDist(self.stockpile) >= 5000 or
			self.stockpile:GetStoredAmount() < (self.auto_mode_on
			and pms.max_res_amount_auto or pms.max_res_amount_man)) then
		self:ShowNotWorkingSign(false)
	end

--~ 	Sleep(type(delay) == "number" or 2500)

	self:Gossip("Idle")
	self:SetState("idle")
	-- kill off thread if we're in one
	Halt()
end

function PortableMiner:DepositNearby()
	local d = MapFindNearest(self, "map", "SubsurfaceDeposit", "TerrainDeposit", --[["SurfaceDeposit", ]] function(o)
		return self:GetVisualDist(o) < self.mine_dist
	end)

		-- if it's concrete and there's a marker then we're good, if it's sub then check depth + tech researched
	if d and (d:IsKindOf("TerrainDepositConcrete") and d:GetDepositMarker() or
					(d:IsKindOfClasses(self.mineable) and
					(d.depth_layer < 2 or self.city:IsTechResearched("DeepMetalExtraction")))) then
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

function PortableMiner:ShowNotWorkingSign(work)
	if work then
		self.notworking_sign = true
		self:AttachSign(self.notworking_sign, "SignNotWorking")
	else
		self.notworking_sign = false
		self:AttachSign(self.notworking_sign, "SignNotWorking")
	end
end

-- get rid of it showing up in the buildings not working OnScreenNotificationPreset
function PortableMiner:SetWorking(work)
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
	local rocket_pos
	if mod_ShowRocket then
		-- get pos of where the "rocket" moves
		local spot = self:GetSpotBeginIndex("Rocket")
		rocket_pos = self:GetSpotLoc(spot)
		self.thumper:SetPos(rocket_pos)
	end

	local skip_end
	if #self.nearby_deposits > 0 then
		-- remove removed stockpile
		if not IsValid(self.stockpile) then
			self.stockpile = false
		end
		-- check if a stockpile is in dist, and if it's the correct res, and not another miner's pile
		if not self.stockpile or self:GetVisualDist(self.stockpile) > 5000 or
					self.stockpile and (self.stockpile.resource ~= self.resource or self.stockpile.miner_handle ~= self.handle) then
			-- try to get one close by
			local stockpile = MapFindNearest(self, "map", "PortableStockpile", function(o)
				return self:GetVisualDist(o) < 5000
			end)

		-- add new stockpile if none
			if not stockpile or stockpile and (stockpile.resource ~= self.resource or stockpile.miner_handle ~= self.handle) then
				-- plunk down a new res stockpile
				stockpile = PortableStockpile:new()
				stockpile:SetPos(MovePointAway(self:GetDestination(), self:GetSpotLoc(self:GetSpotBeginIndex(self.pooper_shooter)), -800))
				stockpile:SetAngle(self:GetAngle())
				stockpile.resource = self.resource
				stockpile.destroy_when_empty = true
			end
			stockpile.miner_handle = self.handle
			stockpile.max_z = self.auto_mode_on and pms.max_z_stack_auto or pms.max_z_stack_man
			-- assign it to the miner
			self.stockpile = stockpile
		end
		--	stop at max_res_amount per stockpile
		if self.stockpile:GetStoredAmount() < (self.auto_mode_on and pms.max_res_amount_auto or pms.max_res_amount_man) then
			-- remove the sign
			self:ShowNotWorkingSign(false)
			-- up n down n up n down
			self:SetStateText(self.default_anim)

			local time = pms.mine_time_anim[self.resource] or self:TimeToAnimEnd()
			-- feel that rocket slide
			if mod_ShowRocket then
				self.thumper:SetVisible(true)
--~ 				self.thumper:SetPos(rocket_pos+point(0,0,300), time)
				self.thumper:SetPos(rocket_pos:AddZ(300), time)
			end
			Sleep(time)

			-- mine some loot
			local mined = self:DigErUp()
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
				-- update selection info panel
				if SelectedObj == self then
					ObjModified(self)
				end
			end
		else
			-- no need to keep on re-showing sign (assuming there isn't a check for this, but an if bool is quicker then whatever it does)
			if not self.notworking_sign then
				self:ShowNotWorkingSign(true)
			end
		end
	end

	if not skip_end then
		local time = pms.mine_time_idle[self.resource] or self:TimeToAnimEnd()
		-- if not idle state then make idle state (the raise up motion of the mining)
		if self:GetState() ~= 0 then
			self:SetStateText(self.default_anim_idle)
			if mod_ShowRocket then
--~ 				self.thumper:SetPos(rocket_pos+point(0,0,-300), time)
				self.thumper:SetPos(rocket_pos:AddZ(-300), time)
			end
		end
		Sleep(time)
		self.thumper:SetVisible(false)
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
function PortableMiner:MineIsEmpty()
	-- it's done so remove our ref to it
	table.iclear(self.nearby_deposits)
	-- needed to mine other concrete
	self.found_deposit = false
	-- if there's a mine nearby then off we go
	if self:DepositNearby() then
		self:SetCommand("Load")
		return
	end
	-- omg it's isn't doing anythings @!@!#!?
	table.insert_unique(g_IdleExtractors, self)
	-- hey look at me!
	self:ShowNotWorkingSign(true)
end

function PortableMiner:DigErUp()
	local d = self.nearby_deposits[1]

	if not IsValid(d) then
		return self:MineIsEmpty()
	end

--[[
	-- stupid surface deposits
	if self.nearby_deposits[1]:IsKindOfClasses{"SurfaceDepositGroup", "SurfaceDepositMetals", "SurfaceDepositConcrete", "SurfaceDepositPolymers"} then
		local res = self.nearby_deposits[1]
		res = res.group and res.group[1] or res
		-- get one with amounts
		while true do
			if res.transport_request:GetActualAmount() == 0 then
				table.remove(self.nearby_deposits[1].group, 1)
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
]]

	local amount = pms.mine_amount
	-- if there isn't much left get what's left
	if amount > d.amount then
		amount = d.amount
	end

	local extracted, paint
	if self.resource == "Concrete" then
		extracted = TerrainDepositExtractor.ExtractResource(self, amount)
		paint = concrete_paint
	else
		extracted = BuildingDepositExploiterComponent.ExtractResource(self, amount)
		paint = metal_paint
	end

	-- if it's empty ExtractResource will delete it
	if extracted == 0 or not IsValid(d) then
		return self:MineIsEmpty()
	end

	-- visual cues
	if pms.visual_cues then
		terrain.SetTypeCircle(GetRandomPassableAround(self, 5000), guim, paint)
	end

	return extracted
end

function PortableMiner:CanExploit()
	-- I don't need to check for tech here, since we check before we add it
	return IsValid(self.nearby_deposits[1])
end

function PortableMiner:OnSelected()
	self:AttachSign(false, "SignNotWorking")
	table.remove_entry(g_IdleExtractors, self)
end

-- needed for Concrete
function PortableMiner:GetExtractionShape()
	return self.mine_area
end

function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.PortableMinerBuilding then
		PlaceObj("BuildingTemplate", {
			"Id", "PortableMinerBuilding",
			"template_class", "PortableMinerBuilding",
			-- pricey?
			"construction_cost_Metals", 40000,
			"construction_cost_MachineParts", 40000,
			"construction_cost_Electronics", 20000,
			-- add a bit of pallor to the skeleton
			"palettes", AttackRover.palette,

			"dome_forbidden", true,
			"display_name", name,
			"display_name_pl", name_pl,
			"description", description,
			"build_category", "ChoGGi",
			"Group", "ChoGGi",
			"display_icon", display_icon,
			"encyclopedia_exclude", true,
			"count_as_building", false,
			"prio_button", false,
			"on_off_button", false,
			"entity", entity,
		})
	end
end
