function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local OrbitalPrefabDrops = OrbitalPrefabDrops

	-- setup menu options
	ModConfig:RegisterMod("OrbitalPrefabDrops", "Orbital Drops")

	ModConfig:RegisterOption("OrbitalPrefabDrops", "PrefabOnly", {
		name = "Only drop prefabs",
		type = "boolean",
		default = OrbitalPrefabDrops.PrefabOnly,
	})

	ModConfig:RegisterOption("OrbitalPrefabDrops", "Outside", {
		name = "Allow outside buildings to drop",
		type = "boolean",
		default = OrbitalPrefabDrops.Outside,
	})

	ModConfig:RegisterOption("OrbitalPrefabDrops", "Inside", {
		name = "Allow inside buildings to drop",
		type = "boolean",
		default = OrbitalPrefabDrops.Inside,
	})

	ModConfig:RegisterOption("OrbitalPrefabDrops", "DetachRockets", {
		name = "Rockets detach and fall to the ground.",
		type = "boolean",
		default = OrbitalPrefabDrops.DetachRockets,
	})
	ModConfig:RegisterOption("OrbitalPrefabDrops", "DetachRocketsPassages", {
		name = "Rockets detach for passages (busy).",
		type = "boolean",
		default = OrbitalPrefabDrops.DetachRocketsPassages,
	})

	ModConfig:RegisterOption("OrbitalPrefabDrops", "RocketDamage", {
		name = "Rockets cause damage when they hit the ground.",
		type = "boolean",
		default = OrbitalPrefabDrops.RocketDamage,
	})

	ModConfig:RegisterOption("OrbitalPrefabDrops", "DomeCrack", {
		name = "Drops will damage dome.",
		type = "boolean",
		default = OrbitalPrefabDrops.DomeCrack,
	})

	-- get saved options
	OrbitalPrefabDrops.PrefabOnly = ModConfig:Get("OrbitalPrefabDrops", "PrefabOnly")
	OrbitalPrefabDrops.Outside = ModConfig:Get("OrbitalPrefabDrops", "Outside")
	OrbitalPrefabDrops.Inside = ModConfig:Get("OrbitalPrefabDrops", "Inside")
	OrbitalPrefabDrops.DetachRockets = ModConfig:Get("OrbitalPrefabDrops", "DetachRockets")
	OrbitalPrefabDrops.DetachRocketsPassages = ModConfig:Get("OrbitalPrefabDrops", "DetachRocketsPassages")
	OrbitalPrefabDrops.RocketDamage = ModConfig:Get("OrbitalPrefabDrops", "RocketDamage")
	OrbitalPrefabDrops.DomeCrack = ModConfig:Get("OrbitalPrefabDrops", "DomeCrack")

end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "OrbitalPrefabDrops" then
		if option_id == "PrefabOnly" then
			OrbitalPrefabDrops.PrefabOnly = value
		elseif option_id == "Outside" then
			OrbitalPrefabDrops.Outside = value
		elseif option_id == "Inside" then
			OrbitalPrefabDrops.Inside = value
		elseif option_id == "DetachRockets" then
			OrbitalPrefabDrops.DetachRockets = value
		elseif option_id == "DetachRocketsPassages" then
			OrbitalPrefabDrops.DetachRocketsPassages = value
		elseif option_id == "RocketDamage" then
			OrbitalPrefabDrops.RocketDamage = value
		elseif option_id == "DomeCrack" then
			OrbitalPrefabDrops.DomeCrack = value
		end
	end
end
