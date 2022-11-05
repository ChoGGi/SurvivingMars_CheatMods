-- See LICENSE for terms

local table = table
local Sleep = Sleep
local IsTechResearched = IsTechResearched
local GetModEnabled = ChoGGi.ComFuncs.GetModEnabled

-- miner amounts table
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
		PreciousMinerals = 15000,
	},
	mine_time_idle = {
		Concrete = 1500,
		Metals = 3000,
		PreciousMetals = 15000,
		PreciousMinerals = 20000,
	},
}

local mod_ShowRocket

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions

	pms.mine_amount = options:GetProperty("mine_amount") * r
	pms.max_res_amount_man = options:GetProperty("max_res_amount_man") * r
	pms.max_z_stack_man = options:GetProperty("max_res_amount_man") / 10
	pms.max_res_amount_auto = options:GetProperty("max_res_amount_auto") * r
	pms.max_z_stack_auto = options:GetProperty("max_res_amount_auto") / 10

	pms.mine_time_anim.Concrete = options:GetProperty("mine_time_animConcrete")
	pms.mine_time_idle.Concrete = options:GetProperty("mine_time_idleConcrete")
	pms.mine_time_anim.Metals = options:GetProperty("mine_time_animMetals")
	pms.mine_time_idle.Metals = options:GetProperty("mine_time_idleMetals")
	pms.mine_time_anim.PreciousMetals = options:GetProperty("mine_time_animPreciousMetals")
	pms.mine_time_idle.PreciousMetals = options:GetProperty("mine_time_idlePreciousMetals")
	pms.mine_time_anim.PreciousMinerals = options:GetProperty("mine_time_animPreciousMinerals")
	pms.mine_time_idle.PreciousMinerals = options:GetProperty("mine_time_idlePreciousMinerals")
	pms.visual_cues = options:GetProperty("visual_cues")

	mod_ShowRocket = options:GetProperty("ShowRocket")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local lifetime_table = {
	All = 0,
	Concrete = 0,
	Metals = 0,
	PreciousMetals = 0,
	PreciousMinerals = 0,
	-- lukes
	Radioactive = 0,
	Hydrocarbon = 0,
	Crystals = 0,
}

local function StartupCode()

	-- add production table if we haven't already
	local Cities = Cities or ""
	for i = 1, #Cities do
		local city = Cities[i]
		local miners = city.labels.PortableMiner or ""
		for j = 1, #miners do
			local miner = miners[j]
			miner.city = city
			miner:SpawnThumper()
			if not miner.lifetime_table then
				miner.lifetime_table = table.copy(lifetime_table)
			end
		end
	end

	-- add tech lock
	if not BuildingTechRequirements.PortableMinerBuilding then
		BuildingTechRequirements.PortableMinerBuilding = {{ tech = "RoverPrinting", hide = false, }}
	end
	-- add an entry to unlock it with the tech
	local tech = TechDef.RoverPrinting
	if not table.find(tech, "Building", "PortableMinerBuilding") then
		tech[#tech+1] = PlaceObj('Effect_TechUnlockBuilding', {
			Building = "PortableMinerBuilding",
		})
	end

end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

-- for painting the ground
local concrete_paint = GetTerrainTextureIndex("Dig")
local metal_paint = GetTerrainTextureIndex("SandFrozen")

-- needs to be declared in two places so
local display_icon = CurrentModPath .. "UI/rover_combat.png"
--~ local name = T(302535920011207, [[RC Miner]])
--~ local name_pl = T(302535920011208, [[RC Miners]])
--~ local entity = "CombatRover"

DefineClass.PortableMiner = {
	__parents = {
		"BaseRover",
		"ComponentAttach",
		-- needed for concrete
		"TerrainDepositExtractor",
		-- not needed for metals, but to show prod info...
		"BuildingDepositExploiterComponent",
		-- ToggleAutoMode() etc
		"AutoMode",
		-- add self.city
		"CityObject",
	},
	-- these are all set above
--~ 	name = T(302535920011207, [[RC Miner]]),
--~ 	display_name = T(302535920011207, [[RC Miner]]),
	description = T(302535920011209, "Will slowly (okay maybe a little quickly) mine Metal or Concrete into a resource pile."),
--~ 	display_icon = display_icon,
	entity = "CombatRover",

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

	malfunction_start_state = "malfunction",
	malfunction_idle_state = "malfunctionIdle",
	malfunction_end_state = "malfunctionEnd",

	-- stops error when adding signs (Missing spot 'Top'), it doesn't have a Top spot, but Rocket is slightly higher then Origin
	sign_spot = "Rocket",

	concrete_paint = concrete_paint,
	metal_paint = metal_paint,

	-- erm... something?
	last_serviced_time = 0,
	-- probably doesn't need a default res, but it may stop some error in the log?
	resource = "Metals",
	-- nearby_deposits name is needed for metal extractor func
	nearby_deposits = false,
	accumulate_dust = true,
	-- refund res
	on_demolish_resource_refund = { Metals = 20 * const.ResourceScale, MachineParts = 20 * const.ResourceScale , Electronics = 10 * const.ResourceScale },

	mineable = {
		"TerrainDepositConcrete",
		-- metals
		"SubsurfaceDepositPreciousMetals", "SubsurfaceDepositMetals",
		"SubsurfaceDepositPreciousMinerals",
		-- LukeH's Resources
		"SubsurfaceDepositCrystals", "SubsurfaceDepositRadioactive", --[["SubsurfaceDepositHydrocarbon",]]
	},

	-- living just enough for the city
	city = false,

	-- show the pin info
	pin_rollover = T(51--[[<ui_command>]]),

	-- add a missile to "grows" while mining
	thumper = false,

	-- needed for pinned icon
	display_icon = display_icon,

	-- picard dlc
  environment_entity = {
    base = "CombatRover",
  },
}

-- ambiguously inherited log spam
PortableMiner.IsIdle = Unit.IsIdle
PortableMiner.OnDepositDepleted = TerrainDepositExtractor.OnDepositDepleted
PortableMiner.GetDepositGrade = TerrainDepositExtractor.GetDepositGrade
PortableMiner.HasNearbyDeposits = TerrainDepositExtractor.HasNearbyDeposits
PortableMiner.ExtractResource = TerrainDepositExtractor.ExtractResource
PortableMiner.GetCurrentDepositQualityMultiplier = TerrainDepositExtractor.GetCurrentDepositQualityMultiplier

DefineClass.PortableMinerBuilding = {
	__parents = {"BaseRoverBuilding"},
	rover_class = "PortableMiner",
}

DefineClass.PortableStockpile = {
	__parents = {"ResourceStockpile", "Demolishable"},
	destroy_when_empty = true,
}

function PortableStockpile:ShouldShowDemolishButton()
--~ 		return true
	if self.stockpiled_amount <= 0 then
		return true
	end
end

function PortableMiner:GameInit()

	if not self.city then
		self.city = Cities[ChoGGi.ComFuncs.RetObjMapId(self)] or MainCity
	end
	self.nearby_deposits = {}

	self.lifetime_table = table.copy(lifetime_table)

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

	self:BuildFilterList()
end

function PortableMiner:BuildFilterList()
	if not self.miner_filter then
		self.miner_filter = {
			Metals = true,
			Concrete = true,
			PreciousMetals = true,
			PreciousMinerals = true,
			Radioactive = true,
			Hydrocarbon = true,
			Crystals = true,
		}
	end
end

function PortableMiner:BuildProdInfo(list, res_name)
	if self.resource ~= res_name then
		list[#list+1] = T{476,
			"Lifetime production<right><resource(LifetimeProduction, resource)>",
			resource = res_name,
			LifetimeProduction = self.lifetime_table[res_name],
			self,
		}
	end
end

-- retrieves prod info

function PortableMiner:GetChoGGi_ui_production()
	local info = {}
	self:BuildProdInfo(info, self.resource)

	-- change lifetime to lifetime of that res
	self.lifetime_production = self.lifetime_table[self.resource]
	info[#info+1] = ResourceProducer.GetUISectionResourceProducerRollover(self)
	self.lifetime_production = self.lifetime_table.All
	return table.concat(info, "<newline><left>")
end

function PortableMiner:GetUISectionProdRollover()
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

	local thumper = PlaceObjectIn("MeteorInterceptParabolicRocket", self:GetMapID())
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
	-- If stockpile is filled and user takes rc to new mine than make sure we mine from new mine
	table.iclear(self.nearby_deposits)
	self.stockpile = false
	-- needed to mine other concrete
	self.found_deposit = false
	-- hide my shame
	self.thumper:SetVisible(false)
	self:AttachSign(false, "SignNotWorking")
	return Unit.Goto(self, ...)
end

-- for auto mode
function PortableMiner:ProcAutomation()
	self:BuildFilterList()
	local realm = GetRealm(self)

	local unreachable_objects = self:GetUnreachableObjectsTable()
	local deposit = realm:MapFindNearest(self, "map", "SubsurfaceDeposit", "TerrainDeposit", --[["SurfaceDeposit", ]] function(d)
		if (d:IsKindOf("TerrainDepositConcrete") and d:GetDepositMarker() or
				(d:IsKindOfClasses(self.mineable) and
				(d.depth_layer < 2 or IsTechResearched("DeepMetalExtraction")
			))) and self.miner_filter[d.resource]
		then
			return not unreachable_objects[d]
		end
	end)

	if deposit then
		local deposit_pos = realm:GetPassablePointNearby(deposit:GetPos())
		if self:HasPath(deposit_pos, "Origin") then
			-- If leaving an empty site then this sign should be turned off
			self:AttachSign(false, "SignNotWorking")
			self:SetCommand("Goto", deposit_pos)
		else
			unreachable_objects[deposit] = true
		end
	else

		Sleep(5000)
		-- turn off auto for all miners if no deposits
		local miners = self.city.labels.PortableMiner or ""
		for i = 1, #miners do
			local miner = miners[i]
			miner:SetAutoMode(false)
			self:AttachSign(true, "SignNotWorking")
			miner:SetCommand("Idle")
		end
	end
	Sleep(2500)
end

-- If we're in auto-mode then make the stockpile take more
function PortableMiner:ToggleAutoMode(broadcast, ...)
	-- If it's on it's about to be turned off
	if IsValid(self.stockpile) then
		self.stockpile.max_z = self:IsAutoModeEnabled() and pms.max_z_stack_man or pms.max_z_stack_auto
	end
	return AutoMode.ToggleAutoMode(self, broadcast, ...)
end

function PortableMiner:Idle()
	-- If there's one near then mine that bugger
	if self:DepositNearby() then
		self:AttachSign(false, "SignNotWorking")
		--	get to work
		self:SetCommand("Load")
	-- we in auto-mode?
	elseif g_RoverAIResearched and self:IsAutoModeEnabled() then
		self:ProcAutomation()
	-- check if stockpile is existing and full
	elseif not self:GetAttach("SignNotWorking") and IsValid(self.stockpile)
		and (self:GetVisualDist(self.stockpile) >= 5000 or
		self.stockpile:GetStoredAmount() < (self:IsAutoModeEnabled()
		and pms.max_res_amount_auto or pms.max_res_amount_man))
	then
		self:AttachSign(false, "SignNotWorking")
	end

	-- freezing issue with flatten ground?
	Sleep(1000)

	self:Gossip("Idle")
	self:SetState("idle")
	-- kill off thread if we're in one
	Halt()
end

function PortableMiner:DepositNearby()
	local d = GetRealm(self):MapFindNearest(self, "map", "SubsurfaceDeposit", "TerrainDeposit", --[["SurfaceDeposit", ]] function(o)
		return self:GetVisualDist(o) < self.mine_dist
	end)

		-- If it's concrete and there's a marker then we're good, if it's sub then check depth + tech researched
	if d and (d:IsKindOf("TerrainDepositConcrete") and d:GetDepositMarker() or
					(d:IsKindOfClasses(self.mineable) and
					(d.depth_layer < 2 or IsTechResearched("DeepMetalExtraction")))) then
		-- let miner know what kind we're mining
		self.resource = d.resource
		-- we need to store res as [1] to use the built-in metal extract func
		self.nearby_deposits[1] = d
		-- concrete...
		self.found_deposit = d
		-- untouched concrete starts off with false for the amount...
		d.amount = d.amount or d.max_amount

		return true
	end

	-- nadda
	table.iclear(self.nearby_deposits)
	self.found_deposit = false
	return false
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

function PortableMiner:GetStockpile()
	-- remove removed stockpile
	if not IsValid(self.stockpile) then
		self.stockpile = false
	end
	-- check if a stockpile is in dist, and if it's the correct res, and not another miner's pile
	if not self.stockpile or self:GetVisualDist(self.stockpile) > 5000 or
				self.stockpile and (self.stockpile.resource ~= self.resource or self.stockpile.miner_handle ~= self.handle) then
		-- try to get one close by
		local stockpile = GetRealm(self):MapFindNearest(self, "map", "PortableStockpile", function(o)
			return self:GetVisualDist(o) < 5000
		end)

	-- add new stockpile if none
		if not stockpile or stockpile and (stockpile.resource ~= self.resource or stockpile.miner_handle ~= self.handle) then
			-- plunk down a new res stockpile
			stockpile = PlaceObjectIn("PortableStockpile", self:GetMapID())
			stockpile:SetPos(MovePointAway(self:GetDestination(), self:GetSpotLoc(self:GetSpotBeginIndex(self.pooper_shooter)), -800))
			stockpile:SetAngle(self:GetAngle())
			stockpile.resource = self.resource
		end
		stockpile.miner_handle = self.handle
		stockpile.max_z = self:IsAutoModeEnabled() and pms.max_z_stack_auto or pms.max_z_stack_man
		-- assign it to the miner
		self.stockpile = stockpile
	end
end

-- called it Load so it uses the load resource icon in pins
function PortableMiner:Load()
	-- freezing issue with flatten ground?
	Sleep(100)

	local rocket_pos
	if mod_ShowRocket then
		-- get pos of where the "rocket" moves
		local spot = self:GetSpotBeginIndex("Rocket")
		rocket_pos = self:GetSpotLoc(spot)
		self.thumper:SetPos(rocket_pos)
	end

	local skip_end
	if self.nearby_deposits[1] then
		-- create or use existing
		self:GetStockpile()
		--	stop at max_res_amount per stockpile
		if self.stockpile:GetStoredAmount() < (self:IsAutoModeEnabled() and pms.max_res_amount_auto or pms.max_res_amount_man) then
			-- remove the sign
			self:AttachSign(false, "SignNotWorking")
			-- up n down n up n down
			self:SetStateText(self.default_anim)

			local time = pms.mine_time_anim[self.resource] or self:TimeToAnimEnd()
			-- feel that rocket slide
			if mod_ShowRocket then
				self.thumper:SetVisible(true)
				self.thumper:SetPos(rocket_pos:AddZ(300), time)
			end
			Sleep(time)

			-- mine some loot
			local mined = self:DigErUp()
			if mined then
				-- make sure there's a stockpile to use, if it gets deleted by somebody mid mine :)
				self:GetStockpile()
				-- doesn't hurt to check
				if IsValid(self.stockpile) then
					-- update stockpile
					self.stockpile:AddResourceAmount(mined)
				else
					skip_end = true
					self.stockpile = false
				end

				local infoamount = g_ResourceOverviewCity[self:GetMapID()].data[self.resource]
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
			if not self:GetAttach("SignNotWorking") then
				self:AttachSign(true, "SignNotWorking")
			end
		end
	end

	if not skip_end then
		local time = pms.mine_time_idle[self.resource] or self:TimeToAnimEnd()
		-- If not idle state then make idle state (the raise up motion of the mining)
		if self:GetState() ~= 0 then
			self:SetStateText(self.default_anim_idle)
			if mod_ShowRocket then
				self.thumper:SetPos(rocket_pos:AddZ(-300), time)
			end
		end
		Sleep(time)
		self.thumper:SetVisible(false)
	end
end

function OnMsg.NewDay() -- NewSol...
	-- reset the prod count (for overview or something)
	local miners = UIColony.city_labels.labels.PortableMiner or ""
	for i = 1, #miners do
		miners[i].production_per_day = 0
	end
end

-- called when the mine is gone/empty (returns nil to skip the add res amount stuff)
function PortableMiner:MineIsEmpty()
	-- freezing issue with flatten ground?
	Sleep(100)

	-- It's done so remove our ref to it
	table.iclear(self.nearby_deposits)
	-- needed to mine other concrete
	self.found_deposit = false
	-- If there's a mine nearby then off we go
	if self:DepositNearby() then
		self:SetCommand("Load")
		return
	end
	-- omg it's isn't doing anythings @!@!#!?
	table.insert_unique(g_IdleExtractors, self)
	-- hey look at me!
	self:AttachSign(true, "SignNotWorking")
end

function PortableMiner:DigErUp()
	-- freezing issue with flatten ground?
	Sleep(100)

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
			res.transport_request:SetAmount(-amount)
		end
	else
		amount = self.nearby_deposits[1]:TakeAmount(amount)
	end
]]

	local amount = pms.mine_amount
	-- If there isn't much left get what's left
	if amount > d.amount then
		amount = d.amount
	end

	local extracted, paint
	if self.resource == "Concrete" then
		extracted = TerrainDepositExtractor.ExtractResource(self, amount)
		paint = self.concrete_paint or concrete_paint
	else
		extracted = BuildingDepositExploiterComponent.ExtractResource(self, amount)
		paint = self.metal_paint or metal_paint
	end

	-- If it's empty ExtractResource will delete it
	if extracted == 0 or not IsValid(d) then
		return self:MineIsEmpty()
	end

	-- visual cues
	if pms.visual_cues then
		GetGameMap(self).terrain:SetTypeCircle(GetRandomPassableAround(self, 5000), guim, paint)
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

		-- added, not uploaded
		"disabled_in_environment1", "",
		"disabled_in_environment2", "",
		"disabled_in_environment3", "",
		"disabled_in_environment4", "",

			"Id", "PortableMinerBuilding",
			"template_class", "PortableMinerBuilding",
			-- pricey?
			"construction_cost_Metals", 40000,
			"construction_cost_MachineParts", 40000,
			"construction_cost_Electronics", 20000,
			-- add a bit of pallor to the skeleton
			"palettes", AttackRover.palette,

			"dome_forbidden", true,
			"display_name", T(302535920011207, "RC Miner"),
			"display_name_pl", T(302535920011208, "RC Miners"),
			"description", T(302535920011209, "Will slowly (okay maybe a little quickly) mine Metal or Concrete into a resource pile."),
			"build_category", "ChoGGi",
			"Group", "ChoGGi",
			"display_icon", display_icon,
			"encyclopedia_exclude", true,
			"count_as_building", false,
			"prio_button", false,
			"on_off_button", false,
			"entity", "CombatRover",
		})
	end

	local template = XTemplates.ipRover[1]
	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(template, "ChoGGi_Template_PortableMinerProdInfo", true)
	template[#template+1] = PlaceObj("XTemplateTemplate", {
		"ChoGGi_Template_PortableMinerProdInfo", true,
		"Id", "ChoGGi_PortableMinerProdInfo",
		"__context_of_kind", "PortableMiner",
		"__template", "InfopanelSection",
		"RolloverText", T("<UISectionProdRollover>"),
		"RolloverTitle", T(80, "Production"),
		"Title", T(80, "Production"),
		"Icon", "UI/Icons/Sections/facility.tga",
	}, {
		PlaceObj("XTemplateTemplate", {
			"__template", "InfopanelText",
			"Text", T("<ChoGGi_ui_production>"),
		}),
	})

	local lukeh_newres = GetModEnabled("LH_Resources") and true

	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(template, "ChoGGi_Template_PortableMinerResFilter", true)
	template[#template+1] = PlaceObj("XTemplateTemplate", {
			"ChoGGi_Template_PortableMinerResFilter", true,
			"Id", "ChoGGi_PortableMinerResFilter",
			"__context_of_kind", "PortableMiner",
			"__template", "InfopanelSection",
			"RolloverText", T(302535920011631, "Filter types of resources when looking with automated mode."),
			"RolloverTitle", T(302535920011632, "Automated Filter"),
			"Title", T(302535920011633, "Filter"),
			"Icon", "UI/Icons/Sections/facility.tga",
		}, {


		-- yeah I need to loop this


		PlaceObj("XTemplateTemplate", {
			"__template", "InfopanelActiveSection",
			"Title", T(229258768953--[[Exotic Minerals]]),
			"__condition", function()
				return g_AccessibleDlc.picard
			end,
			"OnContextUpdate", function(self, context)
				if context.miner_filter.PreciousMinerals then
					self:SetIcon("UI/Icons/Sections/resource_accept.tga")
				else
					self:SetIcon("UI/Icons/Sections/resource_no_accept.tga")
				end
			end,
		}, {
			PlaceObj("XTemplateFunc", {
				"name", "OnActivate(self, context)",
				"parent", function(self)
					return self.parent
				end,
				"func", function(self, context)
					---
					context:BuildFilterList()
					context.miner_filter.PreciousMinerals = not context.miner_filter.PreciousMinerals
					context:SetCommand("Idle")
					ObjModified(context)
					---
				end
			}),
		}),

		PlaceObj("XTemplateTemplate", {
			"__template", "InfopanelActiveSection",
			"Title", T(4139--[[Rare Metals]]),
			"OnContextUpdate", function(self, context)
				if context.miner_filter.PreciousMetals then
					self:SetIcon("UI/Icons/Sections/resource_accept.tga")
				else
					self:SetIcon("UI/Icons/Sections/resource_no_accept.tga")
				end
			end,
		}, {
			PlaceObj("XTemplateFunc", {
				"name", "OnActivate(self, context)",
				"parent", function(self)
					return self.parent
				end,
				"func", function(self, context)
					---
					context:BuildFilterList()
					context.miner_filter.PreciousMetals = not context.miner_filter.PreciousMetals
					context:SetCommand("Idle")
					ObjModified(context)
					---
				end
			}),
		}),

		PlaceObj("XTemplateTemplate", {
			"__template", "InfopanelActiveSection",
			"Title", T(3514--[[Metals]]),
			"OnContextUpdate", function(self, context)
				if context.miner_filter.Metals then
					self:SetIcon("UI/Icons/Sections/resource_accept.tga")
				else
					self:SetIcon("UI/Icons/Sections/resource_no_accept.tga")
				end
			end,
		}, {
			PlaceObj("XTemplateFunc", {
				"name", "OnActivate(self, context)",
				"parent", function(self)
					return self.parent
				end,
				"func", function(self, context)
					---
					context:BuildFilterList()
					context.miner_filter.Metals = not context.miner_filter.Metals
					context:SetCommand("Idle")
					ObjModified(context)
					---
				end
			}),
		}),

		PlaceObj("XTemplateTemplate", {
			"__template", "InfopanelActiveSection",
			"Title", T(3513--[[Concrete]]),
			"OnContextUpdate", function(self, context)
				if context.miner_filter.Concrete then
					self:SetIcon("UI/Icons/Sections/resource_accept.tga")
				else
					self:SetIcon("UI/Icons/Sections/resource_no_accept.tga")
				end
			end,
		}, {
			PlaceObj("XTemplateFunc", {
				"name", "OnActivate(self, context)",
				"parent", function(self)
					return self.parent
				end,
				"func", function(self, context)
					---
					context:BuildFilterList()
					context.miner_filter.Concrete = not context.miner_filter.Concrete
					context:SetCommand("Idle")
					ObjModified(context)
					---
				end
			}),
		}),

		PlaceObj("XTemplateTemplate", {
			"__template", "InfopanelActiveSection",
			"Title", T(1107010705--[[Radioactive Materials]]),
			"__condition", function ()
				return lukeh_newres
			end,
			"OnContextUpdate", function(self, context)
				if context.miner_filter.Radioactive then
					self:SetIcon("UI/Icons/Sections/resource_accept.tga")
				else
					self:SetIcon("UI/Icons/Sections/resource_no_accept.tga")
				end
			end,
		}, {
			PlaceObj("XTemplateFunc", {
				"name", "OnActivate(self, context)",
				"parent", function(self)
					return self.parent
				end,
				"func", function(self, context)
					---
					context:BuildFilterList()
					context.miner_filter.Radioactive = not context.miner_filter.Radioactive
					context:SetCommand("Idle")
					ObjModified(context)
					---
				end
			}),
		}),

		PlaceObj("XTemplateTemplate", {
			"__template", "InfopanelActiveSection",
			"Title", T(1107012118--[[Hydrocarbon]]),
			"__condition", function ()
				return lukeh_newres
			end,
			"OnContextUpdate", function(self, context)
				if context.miner_filter.Hydrocarbon then
					self:SetIcon("UI/Icons/Sections/resource_accept.tga")
				else
					self:SetIcon("UI/Icons/Sections/resource_no_accept.tga")
				end
			end,
		}, {
			PlaceObj("XTemplateFunc", {
				"name", "OnActivate(self, context)",
				"parent", function(self)
					return self.parent
				end,
				"func", function(self, context)
					---
					context:BuildFilterList()
					context.miner_filter.Hydrocarbon = not context.miner_filter.Hydrocarbon
					context:SetCommand("Idle")
					ObjModified(context)
					---
				end
			}),
		}),

		PlaceObj("XTemplateTemplate", {
			"__template", "InfopanelActiveSection",
			"Title", T(1107010505--[[Crystals]]),
			"__condition", function ()
				return lukeh_newres
			end,
			"OnContextUpdate", function(self, context)
				if context.miner_filter.Crystals then
					self:SetIcon("UI/Icons/Sections/resource_accept.tga")
				else
					self:SetIcon("UI/Icons/Sections/resource_no_accept.tga")
				end
			end,
		}, {
			PlaceObj("XTemplateFunc", {
				"name", "OnActivate(self, context)",
				"parent", function(self)
					return self.parent
				end,
				"func", function(self, context)
					---
					context:BuildFilterList()
					context.miner_filter.Crystals = not context.miner_filter.Crystals
					context:SetCommand("Idle")
					ObjModified(context)
					---
				end
			}),
		}),

	})


	template = XTemplates.ipResourcePile[1]
	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(template, "ChoGGi_Template_PortableMinerStockpileSalvage", true)

	template[#template+1] = PlaceObj("XTemplateTemplate", {
		"ChoGGi_Template_PortableMinerStockpileSalvage", true,
		"Id", "ChoGGi_PortableMinerStockpileSalvage",
		"comment", "salvage",
		"__context_of_kind", "Demolishable",
		"__condition", function (_, context)
			return context:ShouldShowDemolishButton()
		end,
		"__template", "InfopanelButton",
		"RolloverTitle", T(3973, --[[XTemplate ipBuilding RolloverTitle]] "Salvage"),
		"RolloverHintGamepad", T(7657, --[[XTemplate ipBuilding RolloverHintGamepad]] "<ButtonY> Activate"),
		"Id", "idSalvage",
		"OnContextUpdate", function (self, context, ...)
			local refund = context:GetRefundResources() or empty_table
			local rollover = T(7822, "Destroy this building.")
			if IsKindOf(context, "LandscapeConstructionSiteBase") then
				self:SetRolloverTitle(T(12171, "Cancel Landscaping"))
				rollover = T(12172, "Cancel this landscaping project. The terrain will remain in its current state")
			end
			if refund[1] then
				rollover = rollover .. "<newline><newline>" .. T(7823, "<UIRefundRes> will be refunded upon salvage.")
			end
			self:SetRolloverText(rollover)
			context:ToggleDemolish_Update(self)
		end,
		"OnPressParam", "ToggleDemolish",
		"Icon", "UI/Icons/IPButtons/salvage_1.tga",
	}, {
		PlaceObj("XTemplateFunc", {
			"name", "OnXButtonDown(self, button)",
			"func", function (self, button)
				if button == "ButtonY" then
					return self:OnButtonDown(false)
				elseif button == "ButtonX" then
					return self:OnButtonDown(true)
				end
				return (button == "ButtonA") and "break"
			end,
		}),
		PlaceObj("XTemplateFunc", {
			"name", "OnXButtonUp(self, button)",
			"func", function (self, button)
				if button == "ButtonY" then
					return self:OnButtonUp(false)
				elseif button == "ButtonX" then
					return self:OnButtonUp(true)
				end
				return (button == "ButtonA") and "break"
			end,
		}),
	})

end
