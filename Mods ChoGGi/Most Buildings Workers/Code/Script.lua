-- See LICENSE for terms

local table_find = table.find
local rawget = rawget
local RetTemplateOrClass = ChoGGi.ComFuncs.RetTemplateOrClass
local ToggleWorking = ChoGGi.ComFuncs.ToggleWorking

-- can't be auto about it here, since we need them before ClassesPostprocess
local workplaces = {
	AdvancedStirlingGenerator = true,
	Apartments = true,
	Arcology = true,
	AtomicBattery = true,
	AutomaticMetalsExtractor = true,
	Battery_WaterFuelCell = true,
	CarbonateProcessor = true,
	ConcretePlant = true,
	CoreHeatConvector = true,
	DefenceTower = true,
	DroneHub = true,
	ElectricityStorage = true,
	ForestationPlant = true,
	FuelFactory = true,
	GHGFactory = true,
	HangingGardens = true,
	JumperShuttleHub = true,
	LandingPad = true,
	LargeWaterTank = true,
	LivingQuarters = true,
	LivingQuarters_Small = true,
	MagneticFieldGenerator = true,
	MartianUniversity = true,
	MDSLaser = true,
	MetalsRefinery = true,
	MoistureVaporator = true,
	MOXIE = true,
	Nursery = true,
	OpenAirGym = true,
	OpenCity = true,
	OpenFarm = true,
	OxygenTank = true,
	OxygenTank_Large = true,
	OxygenTankLarge = true,
	Playground = true,
	RareMetalsRefinery = true,
	RechargeStation = true,
	RegolithExtractor = true,
	Sanatorium = true,
	School = true,
	SensorTower = true,
	ShuttleHub = true,
	SmartHome = true,
	SmartHome_Small = true,
	SolarArray = true,
	SolarPanel = true,
	SolarPanelBig = true,
	StirlingGenerator = true,
	SubsurfaceHeater = true,
	TaiChiGarden = true,
	TradePad = true,
	TriboelectricScrubber = true,
	Tunnel = true,
	WasteRockProcessor = true,
	WaterExtractor = true,
	WaterTank = true,
	WaterTankLarge = true,
	WindTurbine = true,
	WindTurbine_Large = true,
}

local mod_DefaultPerformance
local UpdateWorkers
local options

-- fired when settings are changed/init
local function ModOptions()
	options = CurrentModOptions
	mod_DefaultPerformance = options:GetProperty("DefaultPerformance")

	if not UICity then
		return
	end

	local objs = UICity.labels.Workplace or ""
	for i = 1, #objs do
		local obj = objs[i]
		local template = RetTemplateOrClass(obj)
		if workplaces[template] then
			UpdateWorkers(obj, template)
		end
	end
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

-- update any existing objs
GlobalVar("g_ChoGGi_MostBuildingsWorkersAdded", false)

function OnMsg.LoadGame()
	if g_ChoGGi_MostBuildingsWorkersAdded then
		return
	end
	g_ChoGGi_MostBuildingsWorkersAdded = true

	local ShiftsBuilding_Init = ShiftsBuilding.Init
	local ShiftsBuilding_GameInit = ShiftsBuilding.GameInit
	local DomeOutskirtBld_GameInit = DomeOutskirtBld.GameInit
	local Workplace_Init = Workplace.Init
	local Workplace_GameInit = Workplace.GameInit
	local ShiftsBuilding_ToggleShift = ShiftsBuilding.ToggleShift

	local objs = UICity.labels.Building or ""
	for i = 1, #objs do
		local obj = objs[i]
		local template = RetTemplateOrClass(obj)
		if workplaces[template] and options:GetProperty(template) and not obj.workers then
			ShiftsBuilding_Init(obj)
			Workplace_Init(obj)
			ShiftsBuilding_GameInit(obj)
			DomeOutskirtBld_GameInit(obj)
			Workplace_GameInit(obj)
			UpdateWorkers(obj, template)
			-- needed to make some buildings work
			ToggleWorking(obj)
			-- some buildings need this as well (or wait a shift)
			ShiftsBuilding_ToggleShift(obj, 1)
			ShiftsBuilding_ToggleShift(obj, 1)
			ShiftsBuilding_ToggleShift(obj, 2)
			ShiftsBuilding_ToggleShift(obj, 2)
			ShiftsBuilding_ToggleShift(obj, 3)
			ShiftsBuilding_ToggleShift(obj, 3)
		end
--~ 		local spec = specs[template]
--~ 		if spec then
--~ 			obj.specialist = spec
--~ 		end
	end
end

UpdateWorkers = function(obj, template)
	local workers = options:GetProperty(template)
	if workers then
		obj.max_workers = workers
		if workers == 0 then
			obj.automation = 1
			obj.auto_performance = mod_DefaultPerformance or 100
		else
			obj.automation = 0
			obj.auto_performance = 0
		end
	end
end

-- else it'll default to 5
local orig_GameInit = Workplace.GameInit
function Workplace:GameInit(...)
	local template = RetTemplateOrClass(self)
	if workplaces[template] then
		UpdateWorkers(self, template)
	else
		self.max_workers = 0
		self.automation = 1
		self.auto_performance = mod_DefaultPerformance or 100
	end
	return orig_GameInit(self, ...)
end

-- add workplace parent so we get the funcs and default values
local g = _G
for id in pairs(workplaces) do
	local cls = rawget(g, id)
	if cls then
		local p = cls.__parents
		if not table_find(p, "Workplace") then
			p[#p+1] = "Workplace"
		end
	end
end
