-- See LICENSE for terms

local def = CurrentModDef
-- we need to store the list of sponsor locked buildings
local sponsor_buildings = def.sponsor_buildings or {}

local mod_options = {}
local mod_LockBehindTech

-- build options list
local BuildingTemplates = BuildingTemplates
for id, bld in pairs(BuildingTemplates) do
	for i = 1, 3 do
		if sponsor_buildings[id] or bld["sponsor_status" .. i] ~= false then
			mod_options["ChoGGi_" .. id] = false
			sponsor_buildings[id] = true
			break
		end
	end
end

-- fired when settings are changed/init
local function ModOptions()
	local options = CurrentModOptions
	for id in pairs(mod_options) do
		mod_options[id] = options:GetProperty(id)
	end

	mod_LockBehindTech = options:GetProperty("LockBehindTech")

--~ ex(mod_options)
	local BuildingTechRequirements = BuildingTechRequirements
	local table = table

	local BuildingTemplates = BuildingTemplates
	for id, bld in pairs(BuildingTemplates) do

		-- set each status to false if it isn't
		for i = 1, 3 do
			if sponsor_buildings[id] then
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

end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

-- gotta list them manually
local techs = {
	AdvancedStirlingGenerator = "StirlingGenerator",
--~ 	AutomaticMetalsExtractor = "",
--~ 	ConcretePlant = "",
--~ 	CorporateOffice = "",
--~ 	GameDeveloper = "",
	JumperShuttleHub = "CO2JetPropulsion",
	LowGLab = "MartianInstituteOfScience",
--~ 	MegaMall = "",
--~ 	MetalsRefinery = "",
--~ 	RareMetalsRefinery = "",
--~ 	RCConstructorBuilding = "",
--~ 	RCDrillerBuilding = "",
--~ 	RCHarvesterBuilding = "",
--~ 	RCSensorBuilding = "",
--~ 	RCSolarBuilding = "",
--~ 	SolarArray = "",
--~ 	TaiChiGarden = "",
--~ 	Temple = "",
}

local function LockTech(bld_id, tech_id)
	-- build menu
--~ 	if not BuildingTechRequirements[bld_id] then
		BuildingTechRequirements[bld_id] = {{ tech = tech_id, hide = false, }}
--~ 	end
	-- add an entry to unlock it with the tech
	local tech = TechDef[tech_id]
	if not table.find(tech, "Building", bld_id) then
		tech[#tech+1] = PlaceObj("Effect_TechUnlockBuilding", {
			Building = bld_id,
		})
	end

end

local function LockTechs()
	if mod_LockBehindTech then
		for bld_id, tech_id in pairs(techs) do
			LockTech(bld_id, tech_id)
		end
	end
end

OnMsg.CityStart = LockTechs
OnMsg.LoadGame = LockTechs
