-- See LICENSE for terms

if not g_AvailableDlc.picard then
	print(CurrentModDef.title, ": Below & Beyond DLC not installed! Abort!")
	return
end

local function StartupCode()
	-- add cargo entry for saved games
	if not table.find(ResupplyItemDefinitions, "id", "TriboelectricScrubber") then
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
		if not CargoPreset[id] then
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
