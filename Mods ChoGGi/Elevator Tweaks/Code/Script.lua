-- See LICENSE for terms

if not g_AvailableDlc.picard then
	print(CurrentModDef.title, ": Below & Beyond DLC not installed! Abort!")
	return
end

local skip_buildings = {
	BlackCubeMonolith = true,
	BottomlessPit = true,
	BottomlessPitResearchCenter = true,
	CaveOfWonders = true,
	CrystalsBig = true,
	CrystalsSmall = true,
	DragonRocket = true,
	DropPod = true,
	ForeignAidRocket = true,
	ForeignTradeRocket = true,
	JumboCave = true,
	JumboCaveReinforcementStructure = true,
	LanderRocket = true,
	LanderRocketBuilding = true,
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
	LightTrap = true,
	MirrorSphere = true,
	OrbitalProbe = true,
	Passage = true,
	PassageRamp = true,
	PodLandingSite = true,
	PowerDecoy = true,
	RefugeeRocket = true,
	RivalsHelpRocket = true,
	RocketExpedition = true,
	SelfSufficientDome = true,
	Sinkhole = true,
	SupplyPod = true,
	SupplyRocket = true,
	SupplyRocketBuilding = true,
	SurfacePassage = true,
	Track = true,
	TradeRocket = true,
	UndergroundPassage = true,
	ZeusRocket = true,
}

local function StartupCode()

	local do_resupply = false

	-- Remove odd items from existing saves
	if table.find(ResupplyItemDefinitions, "id", "BlackCubeMonolith") then
		local CargoPreset = CargoPreset
		for id in pairs(skip_buildings) do
			CargoPreset[id]:delete()
		end
		do_resupply = true

	-- add cargo entry for saved games
	elseif not table.find(ResupplyItemDefinitions, "id", "TriboelectricScrubber") then
		do_resupply = true
	end

	if do_resupply then
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
			PlaceObj("Cargo", {
				description = template.description,
				icon = template.encyclopedia_image,
				name = template.display_name,
				id = id,
				kg = 5000,
				locked = false,
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
		PreciousMinerals = articles.ExoticMinerals.image,
		-- Close enough
		WasteRock = "UI/Messages/Tutorials/Tutorial1/Tutorial1_WasteRockConcreteDepot.tga",
	}
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
