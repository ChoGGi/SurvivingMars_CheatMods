-- See LICENSE for terms

local table = table

-- include RCs?
local lookup_rules = {
	ChoGGi_NoCables = {
		"PowerCables",
	},
	ChoGGi_NoSwitches = {
		"LifesupportSwitch",
		"ElectricitySwitch",
	},
	ChoGGi_NoStirlings = {
		"StirlingGenerator",
		"AdvancedStirlingGenerator",
	},
	ChoGGi_NoTradePads = {
		"TradePad",
	},
	ChoGGi_NoWindTurbines = {
		"WindTurbine",
		"WindTurbine_Large",
	},
	ChoGGi_NoSolarPanels = {
		"SolarPanel",
		"SolarPanelBig",
		"SolarArray",
	},
	ChoGGi_NoSensorTowers = {
		"SensorTower",
	},
	ChoGGi_NoTunnels = {
		"Tunnel",
	},
	ChoGGi_NoBatteries = {
		"Battery_WaterFuelCell",
		"AtomicBattery",
	},
	ChoGGi_NoWaterTanks = {
		"WaterTank",
		"LargeWaterTank",
	},
	ChoGGi_NoPassages = {
		"Passage",
		"PassageRamp",
	},
	ChoGGi_NoSubsurfaceHeaters = {
		"SubsurfaceHeater",
	},
	ChoGGi_NoMDSLasers = {
		"MDSLaser",
		"DefenceTower",
	},
	ChoGGi_NoShuttleHubs = {
		"ShuttleHub",
		"JumperShuttleHub",
	},
	ChoGGi_NoWasteRockSites = {
		"WasteRockDumpBig",
		"WasteRockDumpHuge",
	},
	ChoGGi_NoDepots = {
		"UniversalStorageDepot",
		"MechanizedDepotConcrete",
		"MechanizedDepotElectronics",
		"MechanizedDepotFood",
		"MechanizedDepotFuel",
		"MechanizedDepotMachineParts",
		"MechanizedDepotMetals",
		"MechanizedDepotMysteryResource",
		"MechanizedDepotPolymers",
		"MechanizedDepotRareMetals",
		"MechanizedDepotRareMinerals",
		"MechanizedDepotSeeds",
		"StorageConcrete",
		"StorageElectronics",
		"StorageFood",
		"StorageFuel",
		"StorageMachineParts",
		"StorageMetals",
		"StorageMysteryResource",
		"StoragePolymers",
		"StorageRareMetals",
		"StorageRareMinerals",
		"StorageSeeds",
	},
	ChoGGi_NoFarms = {
		"Farm",
		"FungalFarm",
		"HydroponicFarm",
		"OpenFarm",
		"OpenPasture",
		"InsidePasture",
	},
	ChoGGi_NoTriboelectricScrubbers = {
		"TriboelectricScrubber",
	},
	ChoGGi_NoDroneHubs = {
		"DroneHub",
		"DroneHubExtender",
		"RechargeStation",
	},
	ChoGGi_NoDomes = {
		"DomeBasic",
		"DomeDiamond",
		"DomeHexa",
		"DomeMedium",
		"DomeMega",
		"DomeMegaTrigon",
		"DomeMicro",
		"DomeOval",
		"DomeTrigon",
		"GeoscapeDome",
		"SelfSufficientDome",
		"UndergroundDome",
		"UndergroundDomeMedium",
		"UndergroundDomeMicro",
	},
}

-- Cache rule ids in local table instead of checking game rules each time
local enabled_rule_ids

local function UpdateRules()
	enabled_rule_ids = {}
	local active_rules = g_CurrentMissionParams.idGameRules

	-- abort if no game rules?
	if not active_rules then
		return
	end

	for rule_id, building_ids in pairs(lookup_rules) do
		if active_rules[rule_id] then
			for i = 1, #building_ids do
				enabled_rule_ids[building_ids[i]] = true
			end
		end
	end
end

-- I use this to hide empty subcategories and UIItemMenu to hide cables / etc
function OnMsg.GetAdditionalBuildingLocks(template, locks)
	-- Build list of building template ids
	if not enabled_rule_ids then
		UpdateRules()
	end

	if enabled_rule_ids[template.id] then
		-- I guess thanks B&B for disabled_on_map_type ;)
	  locks.disabled_on_map_type = true
	end
end

local ChoOrig_UIItemMenu = UIItemMenu
function UIItemMenu(category_id, bCreateItems, ...)
	-- items aren't returned without bCreateItems
	if not bCreateItems then
		return ChoOrig_UIItemMenu(category_id, bCreateItems, ...)
	end

	-- Build list of building template ids
	if not enabled_rule_ids then
		UpdateRules()
	end

	local items, count = ChoOrig_UIItemMenu(category_id, bCreateItems, ...)
	for i = #items, 1, -1 do
		if enabled_rule_ids[items[i].Id] then
			table.remove(items, i)
			count = count - 1
		end
	end

	-- Nothing actually uses count, but...
	return items, count
end

-- New rules (added below)
local rules = {
	{
		description = T(0000, "Stirling Generators can't be built."),
		display_name = T(0000, "No Stirling Generators"),
		id = "ChoGGi_NoStirlings",
		challenge_mod = 25,
	},
	{
		description = T(0000, "Trade Pads can't be built."),
		display_name = T(0000, "No Trade Pads"),
		id = "ChoGGi_NoTradePads",
		challenge_mod = 25,
	},
	{
		description = T(0000, "Wind Turbines can't be built."),
		display_name = T(0000, "No Wind Turbines"),
		id = "ChoGGi_NoWindTurbines",
		challenge_mod = 25,
	},
	{
		description = T(0000, "Solar Panels can't be built."),
		display_name = T(0000, "No Solar Panels"),
		id = "ChoGGi_NoSolarPanels",
		challenge_mod = 25,
	},
	{
		description = T(0000, "Sensor Towers can't be built."),
		display_name = T(0000, "No Sensor Towers"),
		id = "ChoGGi_NoSensorTowers",
		challenge_mod = 25,
	},
	{
		description = T(0000, "Tunnels can't be built."),
		display_name = T(0000, "No Tunnels"),
		id = "ChoGGi_NoTunnels",
		challenge_mod = 25,
	},
	{
		description = T(0000, "Water Tanks can't be built."),
		display_name = T(0000, "No Water Tanks"),
		id = "ChoGGi_NoWaterTanks",
		challenge_mod = 50,
	},
	{
		description = T(0000, "Batteries can't be built."),
		display_name = T(0000, "No Batteries"),
		id = "ChoGGi_NoBatteries",
		challenge_mod = 50,
	},
	{
		description = T(0000, "Passages can't be built."),
		display_name = T(0000, "No Passages"),
		id = "ChoGGi_NoPassages",
		challenge_mod = 50,
	},
	{
		description = T(0000, "Subsurface Heaters can't be built."),
		display_name = T(0000, "No Subsurface Heaters"),
		id = "ChoGGi_NoSubsurfaceHeaters",
		challenge_mod = 50,
	},
	{
		description = T(0000, "MDS Lasers / Defensive Turrets can't be built."),
		display_name = T(0000, "No MDS Lasers / Defensive Turrets"),
		id = "ChoGGi_NoMDSLasers",
		challenge_mod = 50,
	},
	{
		description = T(0000, "Shuttle Hubs can't be built."),
		display_name = T(0000, "No Shuttle Hubs"),
		id = "ChoGGi_NoShuttleHubs",
		challenge_mod = 50,
	},
	{
		description = T(0000, "Waste Rock Sites can't be built."),
		display_name = T(0000, "No Waste Rock Sites"),
		id = "ChoGGi_NoWasteRockSites",
		challenge_mod = 50,
	},
	{
		description = T(0000, "Cables can't be built."),
		display_name = T(0000, "No Cables"),
		id = "ChoGGi_NoCables",
		challenge_mod = 75,
	},
	{
		description = T(0000, "Depots / Mech Depots can't be built."),
		display_name = T(0000, "No Depots / Mech Depots"),
		id = "ChoGGi_NoDepots",
		challenge_mod = 75,
	},
	{
		description = T(0000, "Farms / Ranches can't be built."),
		display_name = T(0000, "No Farms / Ranches"),
		id = "ChoGGi_NoFarms",
		challenge_mod = 75,
	},
	{
		description = T(0000, "Switches / Valves can't be built."),
		display_name = T(0000, "No Switches / Valves"),
		id = "ChoGGi_NoSwitches",
		challenge_mod = 100,
	},
	{
		description = T(0000, "Triboelectric Scrubbers can't be built."),
		display_name = T(0000, "No Triboelectric Scrubbers"),
		id = "ChoGGi_NoTriboelectricScrubbers",
		challenge_mod = 100,
	},
	{
		description = T(0000, "Drone Hubs / Recharge Stations / Drone Hub Extenders can't be built."),
		display_name = T(0000, "No Drone Hubs / Recharge Stations / Drone Hub Extenders"),
		id = "ChoGGi_NoDroneHubs",
		challenge_mod = 100,
	},
	{
		description = T(0000, "Domes of any type can't be built."),
		display_name = T(0000, "No Domes"),
		id = "ChoGGi_NoDomes",
		challenge_mod = 250,
	},
	{
		description = T(0000, "You can't request passenger rockets."),
		display_name = T(0000, "No Passenger Rockets"),
		id = "ChoGGi_NoPassengerRockets",
		challenge_mod = 150,
	},
}
function OnMsg.ClassesPostprocess()
	if GameRulesMap.ChoGGi_NoPassages then
		return
	end

	local CmpLower = CmpLower
	table.sort(rules, function(a, b)
		return CmpLower(a.id, b.id)
	end)

	local PlaceObj = PlaceObj
	for i = 1, #rules do
		local rule = rules[i]
		PlaceObj("GameRules", {
			id = rule.id,
			display_name = rule.display_name,
			description = rule.description,
			challenge_mod = rule.challenge_mod,
			group = "Default",
		})
	end
end

-- NoPassengerRockets rule below

local ChoOrig_AreNewColonistsAccepted = AreNewColonistsAccepted
function AreNewColonistsAccepted(...)
	if IsGameRuleActive("ChoGGi_NoPassengerRockets") then
		return false
	end

	return ChoOrig_AreNewColonistsAccepted(...)
end

local ChoOrig_RocketPayloadObject_PassengerRocketDisabledRolloverTitle = RocketPayloadObject.PassengerRocketDisabledRolloverTitle
function RocketPayloadObject.PassengerRocketDisabledRolloverTitle(...)
	if IsGameRuleActive("ChoGGi_NoPassengerRockets") then
		return T(0000, "No Passenger Rockets")
	end

	return ChoOrig_RocketPayloadObject_PassengerRocketDisabledRolloverTitle(...)
end

local ChoOrig_RocketPayloadObject_PassengerRocketDisabledRolloverText = RocketPayloadObject.PassengerRocketDisabledRolloverText
function RocketPayloadObject.PassengerRocketDisabledRolloverText(...)
	if IsGameRuleActive("ChoGGi_NoPassengerRockets") then
		return T(0000, [[You can't request passenger rockets.


(No Passenger Rockets Game Rule)]])
	end

	return ChoOrig_RocketPayloadObject_PassengerRocketDisabledRolloverText(...)
end
