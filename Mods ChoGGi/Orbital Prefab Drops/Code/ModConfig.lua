-- use gag one if around
--~ local model = "SupplyPod"
local max_models = 2
if IsValidEntity("ArcPod") then
--~ 	model = "ArcPod"
	max_models = 3
end

function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local OrbitalPrefabDrops = OrbitalPrefabDrops

	-- setup menu options
	ModConfig:RegisterMod("OrbitalPrefabDrops", "Orbital Drops")

	ModConfig:RegisterOption("OrbitalPrefabDrops", "PrefabOnly", {
		name = [[Prefab Only]],
		desc = [[Only rocket drop prefabs (or all buildings depending on Inside/Outside Buildings).]],
		type = "boolean",
		default = OrbitalPrefabDrops.PrefabOnly,
	})

	ModConfig:RegisterOption("OrbitalPrefabDrops", "Outside", {
		name = [[Outside buildings]],
		desc = [[If you don't want them being dropped off outside domes.]],
		type = "boolean",
		default = OrbitalPrefabDrops.Outside,
	})

	ModConfig:RegisterOption("OrbitalPrefabDrops", "Inside", {
		name = [[Inside buildings]],
		desc = [[If you don't want them being dropped off inside domes.]],
		type = "boolean",
		default = OrbitalPrefabDrops.Inside,
	})

	ModConfig:RegisterOption("OrbitalPrefabDrops", "DomeCrack", {
		name = [[Dome Crack]],
		desc = [[If the site is in a dome, it'll crack the glass.]],
		type = "boolean",
		default = OrbitalPrefabDrops.DomeCrack,
	})

	ModConfig:RegisterOption("OrbitalPrefabDrops", "ModelType", {
		name = [[Model Type]],
		desc = [[1 = supply pod, 2 = old black hex, 3 = arc pod (needs Space Race DLC).]],
		type = "number",
		min = 1,
		max = max_models,
		step = 1,
		default = OrbitalPrefabDrops.ModelType,
	})

	-- get saved options
	OrbitalPrefabDrops.PrefabOnly = ModConfig:Get("OrbitalPrefabDrops", "PrefabOnly")
	OrbitalPrefabDrops.Outside = ModConfig:Get("OrbitalPrefabDrops", "Outside")
	OrbitalPrefabDrops.Inside = ModConfig:Get("OrbitalPrefabDrops", "Inside")
	OrbitalPrefabDrops.DomeCrack = ModConfig:Get("OrbitalPrefabDrops", "DomeCrack")
	OrbitalPrefabDrops.ModelType = ModConfig:Get("OrbitalPrefabDrops", "ModelType")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "OrbitalPrefabDrops" then
		if option_id == "PrefabOnly" then
			OrbitalPrefabDrops.PrefabOnly = value
		elseif option_id == "Outside" then
			OrbitalPrefabDrops.Outside = value
		elseif option_id == "Inside" then
			OrbitalPrefabDrops.Inside = value
		elseif option_id == "DomeCrack" then
			OrbitalPrefabDrops.DomeCrack = value
		elseif option_id == "ModelType" then
			OrbitalPrefabDrops.ModelType = value
		end
	end
end
