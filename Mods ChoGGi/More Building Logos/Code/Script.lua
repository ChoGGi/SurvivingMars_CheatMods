-- See LICENSE for terms

local GetAllAttaches = ChoGGi_Funcs.Common.GetAllAttaches
local GetCityLabels = ChoGGi_Funcs.Common.GetCityLabels

local mod_EnableMod

GlobalVar("g_ChoGGi_MoreBuildingLogos", false)

local logo_buildings = {
	RCSensorBuilding = {
		offset = point(470, 0, 400),
		angle = 3*60*60,
		scale = 75,
	},
	RCSafariBuilding = {
		offset = point(-445, 258, 300),
		angle = 3*60*60,
		scale = 60,
	},
	RCExplorerBuilding = {
		scale = 60,
		offset = point(130, 180, 300),
		angle = 16200,
	},
	RCTransportBuilding = {
		scale = 40,
		offset = point(230, 60, 400),
		angle = 5400,
	},
	RCRoverBuilding = {
		offset = point(300, 0, 400),
		angle = 3*60*60,
	},
	RCTerraformerBuilding = {
		offset = point(675, 0, 50),
		angle = 3*60*60,
	},
	RCDrillerBuilding = {
		scale = 75,
		angle = -4096,
		axis = point(0, 4096, 0),
		offset = point(130, -5, 800),
	},

	LandingPad = {
		scale = 350,
		offset = point(-2000, 0, 0),
		angle = 3*60*60,
	},
	RechargeStation = {
		scale = 200,
	},
	StationSmall = {
		scale = 175,
		offset = point(1500, 0, 400),
		angle = -4096,
		axis = point(0, 4096, 0),
	},
	StationBig = {
		-- Add two logos
		multi = {
			offset = point(-200, -1390, 450),
		},
		scale = 175,
		offset = point(200, 1390, 450),
		angle = -4096,
		axis = point(0, 4096, 0),
	},
	ShuttleHub = {
		offset = point(-520, -15, 3100),
		angle = 5400,
	},
	SubsurfaceHeater = {
		offset = point(0, 0, 1200),
		angle = 3*60*60,
	},
	Elevator = {
		offset = point(775, 1570, 1400),
		scale = 200,
	},
	UndergroundElevator = {
		offset = point(775, 1570, 1400),
		scale = 200,
	},
	ConcretePlant = {
		offset = point(-850, 5, 1250),
		scale = 175,
		angle = 3*60*60,
	},
	MetalsExtractor = {
		attach_to = "MetalsExtractorElevator",
		offset = point(0, 0, 100),
		angle = 5400,
	},
	FarmHydroponic = {
		offset = point(0, 360, 1750),
		angle = 5400,
		scale = 125,
	},
	InsidePasture = {
		offset = point(1170, 700, 700),
		angle = 1700,
		scale = 300,
	},
	OpenPasture = {
		offset = point(0, 100, 0),
		angle = 16200,
		scale = 1300,
	},
	PassageRamp = {
		offset = point(0, 0, 400),
		angle = 5400,
		scale = 400,
	},
	LivingQuarters_Small = {
		multi = {
			offset = point(-616, 700, 460),
		},
		angle = 3*60*60,
		scale = 15,
		offset = point(-616, 780, 460),
		-- filter by entity
		entity = "LivingQuartersSmallCP3_01",
	},
	Apartments = {
		offset = point(0, -550, 700),
		angle = 5400,
		scale = 200,
		entity = "HiveHabitat",
	},
	Diner = {
		entity = "Restaurant",
		scale = 275,
		angle = -4096,
		axis = point(0, 4096, 0),
		offset = point(-850, 865, 800),
	},
	MedicalPostCCP1 = {
		offset = point(-270, 0, 250),
		scale = 50,
	},
	HospitalCCP1 = {
		offset = point(570, 330 , 1050),
		scale = 150,
		angle = 12550,
	},
	OpenAirGym = {
		offset = point(0, -1800 , 0),
		scale = 200,
		angle = 5400,
	},
	CasinoComplex = {
		entity = "Casino",
		scale = 175,
		angle = 16200,
		offset = point(-10, 685, 800),
	},
	SecurityPostCCP1 = {
		scale = 190,
		offset = point(0, 0, 1100),
	},
	SecurityStation = {
		scale = 150,
		offset = point(0, 570, 2000),
	},
	Amphitheater = {
		scale = 150,
		offset = point(0, 1000, 0),
		angle = 16200,
	},
	ShopsElectronics = {
		entity = "ShopsElectronics",
		scale = 50,
		offset = point(240, 330, 1000),
		angle = 5400,
	},
}
--[[
		scale = 175,
		offset = point(200, 1390, 450),
		angle = 5400,
		angle = 16200,
		angle = 12550,
		angle = 9050,
-- use these two for 90 surface
		angle = -4096,
		axis = point(0, 4096, 0),
-- entity filter
		entity = "LivingQuartersSmallCP3_01",
-- attach to an attach
		attach_to = "MetalsExtractorElevator",
-- Add two logos
		multi = {
			offset = point(-200, -1390, 450),
		},
]]

function AddLogoEntity(obj, settings)
	-- Check for correct entity on buildings with multiple
	if settings.entity and obj:GetEntity() ~= settings.entity then
		return
	end

	local logo_attach = PlaceObjectIn("Logo", obj:GetMapID())
	logo_attach.ChoGGi_MoreBuildingLogos_fakelogo = true

	if settings.attach_to then
		local attach = GetAllAttaches(obj, nil, settings.attach_to)
		attach[1]:Attach(logo_attach)
	else
		obj:Attach(logo_attach)
	end
	--
	if settings.offset then
		logo_attach:SetAttachOffset(settings.offset)
	end
	--
	if settings.scale then
		logo_attach:SetScale(settings.scale)
	end
	--
	if settings.axis then
		logo_attach:SetAxis(settings.axis)
	end
	--
	if settings.angle then
		logo_attach:SetAngle(settings.angle)
	end

end

-- used if more than one logo being added
local temp_settings = {}
--
function AddLogo(obj)
	local settings = logo_buildings[obj.template_name]
	if not settings then
		printC("settings AddLogo", obj.template_name)
		return
	end

	-- Already has logos
	local abort = false
	obj:DestroyAttaches(function(attach)
		if attach.ChoGGi_MoreBuildingLogos_fakelogo then
			abort = true
		end
	end)
	if abort then
		return
	end

	-- Rovers
	if obj.rover_class then
		-- Need to get pos/realm before building obj is removed
		local pos = obj:GetSpotLoc(obj:GetSpotBeginIndex("Rover"))
		local realm = GetRealm(obj)
		-- Slight delay till rover is created
		CreateRealTimeThread(function()
			local rover = realm:MapGet(pos, 0, "BaseRover")
			if rover and rover[1] then
				AddLogoEntity(rover[1], settings)
			end
		end)

		return
	end

	-- Adding single logo
	AddLogoEntity(obj, settings)

	-- Extra logo
	if settings.multi then
		table.clear(temp_settings)
		temp_settings = table.copy(settings)
		for k, v in pairs(settings.multi) do
			temp_settings[k] = v
		end

		AddLogoEntity(obj, temp_settings)
	end

end

-- On load / mod options changed
local function AddLogosToBuildings()
	if not mod_EnableMod
		-- Already added logos to existing buildings than abort
		or g_ChoGGi_MoreBuildingLogos == CurrentModDef.version
	then
		return
	end

	-- loop through buildings and add logos
	for template_name in pairs(logo_buildings) do
		local objs = GetCityLabels(template_name)
		for i = 1, #objs do
			AddLogo(objs[i])
		end
	end

	-- update with current mod version, so we can check when I add new buildings
	g_ChoGGi_MoreBuildingLogos = CurrentModDef.version
end
OnMsg.CityStart = AddLogosToBuildings
OnMsg.LoadGame = AddLogosToBuildings

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- make sure we're in-game
	if not UIColony then
		return
	end
	AddLogosToBuildings()
end
OnMsg.ModsReloaded = ModOptions
OnMsg.ApplyModOptions = ModOptions

-- Add logo to new buildings
function OnMsg.BuildingInit(obj)
	if not mod_EnableMod then
		return
	end

	printC("BuildingInit", obj.template_name)
	AddLogo(obj)
end

-- Add logo when skin changes
function OnMsg.ClassesPostprocess()
	local ChoOrig_Building_ChangeEntity = Building.ChangeEntity
	function Building:ChangeEntity(...)
		if not mod_EnableMod then
			return ChoOrig_Building_ChangeEntity(self, ...)
		end

		ChoOrig_Building_ChangeEntity(self, ...)
		-- Needs a delay for entity to change
		CreateRealTimeThread(AddLogo, self)
	end
end




-- Test area
-- I really should make something to drag the logo around...
do return end

local obj = o

local obj = s
obj:DestroyAttaches(function(attach)
	if attach.ChoGGi_MoreBuildingLogos_fakelogo then
		return true
	end
end)
local logo_attach = PlaceObjectIn("Logo", obj:GetMapID())
obj:Attach(logo_attach)
ex(logo_attach)


local obj = s
local logo_attach = PlaceObjectIn("Logo", obj:GetMapID())
logo_attach.ChoGGi_MoreBuildingLogos_fakelogo = true
obj:Attach(logo_attach, 5)
ex(logo_attach)

-- xy z
o:SetAttachOffset(point(-600, 000, 300))
o:SetAttachOffset(point(230, 60, 400))
o:SetAttachOffset(point(-300, 250, 300))
--
o:SetAttachOffset(point(300, 000, 400))
o:SetAttachOffset(point(470, 000, 400))

o:SetAttachOffset(point(00, 00, 1000))
o:SetAttachOffset(point(100, 00, 00))

o:SetAngle(1*60*60)
o:SetAngle(2*60*60)
o:SetAngle(3*60*60)
o:SetAngle(4*60*60)
o:SetAngle(5*60*60)
o:SetAngle(6*60*60)
o:SetAngle(5400)
o:SetAngle(12550)


o:SetScale(200)
o:SetScale(175)
o:SetScale(150)
o:SetScale(75)
o:SetScale(50)




o:SetAngle(-4096)
o:SetAxis(0, 4096, 0)
