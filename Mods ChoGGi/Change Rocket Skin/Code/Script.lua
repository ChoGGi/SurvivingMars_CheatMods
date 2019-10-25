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

-- replace the default getskins function with ours
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

-- Silva - Orion Heavy Rocket
function OnMsg.ModsReloaded()
	-- check if the mod is loaded and if it was already added to the list
	if not table.find(rockets, "RDM_OrionRocket")
		and table.find(ModsLoaded, "id", "Ucv4buQ")
	then
		-- if not then add to the list
		rockets[#rockets+1] = "RDM_OrionRocket"
		palettes[#palettes+1] = RDM_OrionRocket.rocket_palette
		RDM_OrionRocket.GetSkins = GetSkins
	end
end
