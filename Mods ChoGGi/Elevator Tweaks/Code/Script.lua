-- See LICENSE for terms

if not g_AvailableDlc.picard then
	print(CurrentModDef.title, ": Below & Beyond DLC not installed! Abort!")
	return
end

local skip_buildings = {
	-- underground wonders
	AncientArtifact = true,
	BottomlessPit = true,
	JumboCave = true,
	CaveOfWonders = true,
	-- wonders
	AncientArtifactInterface = true,
	ArtificialSun = true,
	BottomlessPitResearchCenter = true,
	GeoscapeDome = true,
	JumboCaveReinforcementStructure = true,
	MoholeMine = true,
	OmegaTelescope = true,
	ProjectMorpheus = true,
	SpaceElevator = true,
	TheExcavator = true,
	-- rockets
	ArkPod = true,
	DragonRocket = true,
	DropPod = true,
	ForeignAidRocket = true,
	ForeignTradeRocket = true,
	LanderRocket = true,
	LanderRocketBuilding = true,
	PodLandingSite = true,
	RefugeeRocket = true,
	RivalsHelpRocket = true,
	RocketExpedition = true,
	RocketLandingSite = true,
	SupplyPod = true,
	SupplyRocket = true,
	SupplyRocketBuilding = true,
	TradeRocket = true,
	ZeusRocket = true,
	-- mystery
	BlackCubeMonolith = true,
	CrystalsBig = true,
	CrystalsSmall = true,
	LightTrap = true,
	MirrorSphere = true,
	PowerDecoy = true,
	Sinkhole = true,
	-- depots/storage
	BlackCubeDump = true,
	StorageConcrete = true,
	StorageElectronics = true,
	StorageFood = true,
	StorageFuel = true,
	StorageMachineParts = true,
	StorageMetals = true,
	StorageMysteryResource = true,
	StoragePolymers = true,
	StorageRareMetals = true,
	StorageRareMinerals = true,
	StorageSeeds = true,
	UniversalStorageDepot = true,
	WasteRockDumpBig = true,
	WasteRockDumpHuge = true,
	-- rovers
	RCConstructorBuilding = true,
	RCDrillerBuilding = true,
	RCExplorerBuilding = true,
	RCHarvesterBuilding = true,
	RCRoverBuilding = true,
	RCSafariBuilding = true,
	RCSensorBuilding = true,
	RCSolarBuilding = true,
	RCTerraformerBuilding = true,
	RCTransportBuilding = true,
	-- misc
	LandscapeClearWasteRock = true,
	LandscapeLakeBig = true,
	LandscapeLakeHuge = true,
	LandscapeLakeMid = true,
	LandscapeLakeSmall = true,
	LandscapeRamp = true,
	LandscapeTerrace = true,
	LandscapeTextureMountains = true,
	LandscapeTextureRockDarkChaos = true,
	LandscapeTextureSandChaos = true,
	LandscapeTextureSandDark = true,
	LandscapeTextureSandRed = true,
	OrbitalProbe = true,
	Passage = true,
	PassageRamp = true,
	SelfSufficientDome = true,
	SurfacePassage = true,
	Track = true,
	UndergroundPassage = true,
}

local function StartupCode()

	if table.find(ResupplyItemDefinitions, "id", "MissingPreset") then
		-- Remove odd items from existing saves
		local CargoPreset = CargoPreset
		for id in pairs(CargoPreset) do
			if skip_buildings[id] then
				CargoPreset[id]:delete()
			end
		end
		-- Fully rebuild ResupplyItemDefinitions
		ResupplyItemsInit(true)

	-- add cargo entry for saved games
	elseif not table.find(ResupplyItemDefinitions, "id", "TriboelectricScrubber") then
		-- Rebuild ResupplyItemDefinitions with new items
		ResupplyItemsInit()
	end

end

-- New games
OnMsg.CityStart = StartupCode
-- Saved ones
OnMsg.LoadGame = StartupCode

function OnMsg.ClassesPostprocess()

	local CargoPreset = CargoPreset
	local BuildingTemplates = BuildingTemplates
	for id, template in pairs(BuildingTemplates) do
		if not CargoPreset[id] and not skip_buildings[id] then
			local icon = template.encyclopedia_image == "" and template.display_icon or template.encyclopedia_image
			PlaceObj("Cargo", {
				description = template.description,
				icon = icon,
				name = template.display_name,
				id = id,
				kg = 5000,
				locked = true,
				price = 200000000,
				group = "Locked",
				SaveIn = "",
			})
		end
	end

	-- The devs skipped a few icons

	local articles = Presets.EncyclopediaArticle.Resources
	local lookup_res = {
		Concrete = articles.Concrete.image,
		Electronics = articles.Electronics.image,
		Food = articles.Food.image,
		Fuel = articles.Fuel.image,
		MachineParts = articles["Mechanical Parts"].image,
		Metals = articles.Metals.image,
		Polymers = articles.Polymers.image,
		PreciousMetals = articles["Rare Metals"].image,
		-- Close enough
		WasteRock = "UI/Messages/Tutorials/Tutorial1/Tutorial1_WasteRockConcreteDepot.tga",
	}
	if g_AvailableDlc.picard then
		lookup_res.PreciousMinerals = articles.ExoticMinerals.image
	end
	if g_AvailableDlc.armstrong then
		lookup_res.Seeds = articles.Seeds.image
	end

	for id, cargo in pairs(CargoPreset) do
		if not cargo.icon then

			if lookup_res[id] then
				cargo.icon = lookup_res[id]
			elseif BuildingTemplates[id] then
				cargo.icon = BuildingTemplates[id].encyclopedia_image
			end

		end
	end

end
