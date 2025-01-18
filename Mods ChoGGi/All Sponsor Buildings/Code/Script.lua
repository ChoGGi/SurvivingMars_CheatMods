-- See LICENSE for terms

if not g_AvailableDlc.gagarin then
	print(CurrentModDef.title, ": Space Race DLC not installed! Abort!")
	return
end

local table = table

-- we need to store the list of sponsor locked buildings
local sponsor_buildings = {}

local mod_options = {}

-- build options list
local BuildingTemplates = BuildingTemplates
for id, bld in pairs(BuildingTemplates) do
	for i = 1, 3 do
--~ 		if sponsor_buildings[id] or bld["sponsor_status" .. i] ~= false then
		if sponsor_buildings[id] or bld["sponsor_name" .. i] ~= "" then
			mod_options["ChoGGi_" .. id] = false
			mod_options["ChoGGi_Tech_" .. id] = false
			sponsor_buildings[id] = true
			break
		end
	end
end

-- Set what shows up in resupply dialog (rockets)
local function UpdateCargoDefs()
	local defs = ResupplyItemDefinitions
	for i = 1, #defs do
		local def = defs[i]

		local name = def.id
		if name:sub(1, 2) == "RC" then
			name = name .. "Building"
		end

		if mod_options["ChoGGi_" .. name] then
			def.locked = false
		end
	end
end

-- gotta list them manually
local techs = {
	AdvancedStirlingGenerator = "StirlingGenerator",
--~ 	AutomaticMetalsExtractor = "",
--~ 	ConcretePlant = "",
	CorporateOffice = "BehavioralShaping",
	GameDeveloper = "CreativeRealities",
	JumperShuttleHub = "CO2JetPropulsion",
	LowGLab = "MartianInstituteOfScience",
	MegaMall = "GravityEngineering",
--~ 	MetalsRefinery = "",
--~ 	RareMetalsRefinery = "",
--~ 	RCConstructorBuilding = "DronePrinting",
--~ 	RCDrillerBuilding = "DronePrinting",
--~ 	RCHarvesterBuilding = "DronePrinting",
--~ 	RCSensorBuilding = "DronePrinting",
--~ 	RCSolarBuilding = "DronePrinting",
	SolarArray = "DustRepulsion",
--~ 	TaiChiGarden = "",
	Temple = "Arcology",
}

local function StartupCode()
	BuildingTemplates.ShuttleHub.sponsor_name1 = ""
	BuildingTemplates.ShuttleHub.sponsor_status1 = false

	for bld_id, tech_id in pairs(techs) do
		if mod_options["ChoGGi_Tech_" .. bld_id] then
				-- build menu
			BuildingTechRequirements[bld_id] = {{ tech = tech_id, hide = false, }}
			-- add an entry to unlock it with the tech
			local tech = TechDef[tech_id]
			if not table.find(tech, "Building", bld_id) then
				tech[#tech+1] = PlaceObj("Effect_TechUnlockBuilding", {
					Building = bld_id,
				})
			end
		else
			if BuildingTechRequirements[bld_id] then
				BuildingTechRequirements[bld_id] = nil
			end
		end
	end

	UpdateCargoDefs()
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

-- fired when settings are changed/init
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions
	for id in pairs(mod_options) do
		mod_options[id] = options:GetProperty(id)
	end

	local BuildingTechRequirements = BuildingTechRequirements
--~ ex{"sponsor_buildings",sponsor_buildings}
	local BuildingTemplates = BuildingTemplates
	for id, bld in pairs(BuildingTemplates) do

		-- set each status to false if it isn't
		if sponsor_buildings[id] then
			for i = 1, 3 do
				local str = "sponsor_status" .. i
				if mod_options["ChoGGi_" .. id] then
					bld[str] = false
				elseif bld[str] ~= "" then
					bld[str] = "required"
				end
			end
		end

		-- and this bugger screws me over on GetBuildingTechsStatus when using RCs
		local name = id
		if name:sub(1, 2) == "RC" and name:sub(-8) == "Building" then
			name = name:gsub("Building", "")
		end
		local reqs = BuildingTechRequirements[id]
		local idx = table.find(reqs, "check_supply", name)
		if idx then
			table.remove(reqs, idx)
		end
	end

	-- Make sure we're in-game
	if not UIColony then
		return
	end

	StartupCode()
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- Not sure which Msg I need to use to have this show up for new game, so I'm being lazy.
local ChoOrig_ResupplyItemsInit = ResupplyItemsInit
function ResupplyItemsInit(...)
	-- it doesn't have a return value, but if another mod adds one.
	local ret = ChoOrig_ResupplyItemsInit(...)

	UpdateCargoDefs()

	return ret
end
