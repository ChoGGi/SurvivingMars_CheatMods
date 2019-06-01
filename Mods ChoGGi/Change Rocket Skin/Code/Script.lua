-- See LICENSE for terms

-- start with base game rockets (we add space race and silva below)
local rockets = {
	"Rocket",
	"Rocket_Trailblazer",
	"CombatRover",
	"SupplyPod",
}

local palettes = {
	SupplyRocket.rocket_palette,
	SupplyRocket.rocket_palette,
	AttackRover.palette,
	SupplyPod.rocket_palette,
}

local function GetSkins()
	return rockets, palettes
end

-- replace the useless getskins function with ours
SupplyRocket.GetSkins = GetSkins
-- hey if you want to change the skin for a few seconds...
SupplyPod.GetSkins = GetSkins

-- add gag entities
if g_AvailableDlc.gagarin then
	rockets[#rockets+1] = "DropPod"
	rockets[#rockets+1] = "ArcPod"
	rockets[#rockets+1] = "ZeusRocket"
	rockets[#rockets+1] = "SpaceYDragonRocket"
	palettes[#palettes+1] = DropPod.rocket_palette
	palettes[#palettes+1] = ArkPod.rocket_palette
	palettes[#palettes+1] = ZeusRocket.rocket_palette
	palettes[#palettes+1] = DragonRocket.rocket_palette
	ArkPod.GetSkins = GetSkins
	DropPod.GetSkins = GetSkins
	ZeusRocket.GetSkins = GetSkins
	DragonRocket.GetSkins = GetSkins
end

-- Silva - International Fuel Corporation
function OnMsg.ModsReloaded()
	-- already added
	if table.find(rockets, "sRocket_Orion") then
		return
	end

	if table.find(ModsLoaded, "id", "o4zrnLN") then
		rockets[#rockets+1] = "sRocket_Orion"
		-- rocket_palette = "OrionRocket", doesn't work with changing the colony colour scheme
		palettes[#palettes+1] = {
			"rocket_base",
			"rocket_accent",
			"outside_accent_1",
			"rocket_base",
		}
		sRocket_Orion.GetSkins = GetSkins
	end

end
