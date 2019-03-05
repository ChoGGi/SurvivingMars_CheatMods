-- See LICENSE for terms

-- start with base game rockets (we add space race and silva below)
local rockets = {
	"Rocket",
	"Rocket_Trailblazer",
	"SupplyPod",
	"CombatRover",
}

local palettes = {
	SupplyRocket.rocket_palette,
	SupplyRocket.rocket_palette,
	SupplyPod.rocket_palette,
	AttackRover.palette,
}

local function GetSkins()
	return rockets,palettes
end

if g_AvailableDlc.gagarin then
	rockets[#rockets+1] = "ArcPod"
	palettes[#palettes+1] = ArkPod.rocket_palette
	rockets[#rockets+1] = "ZeusRocket"
	palettes[#palettes+1] = ZeusRocket.rocket_palette
	rockets[#rockets+1] = "SpaceYDragonRocket"
	palettes[#palettes+1] = DragonRocket.rocket_palette
	ZeusRocket.GetSkins = GetSkins
	DragonRocket.GetSkins = GetSkins
end

-- replace the useless getskins function with ours
SupplyRocket.GetSkins = GetSkins

-- Silva - International Fuel Corporation
local fire_once
function OnMsg.ModsReloaded()
	if fire_once then
		return
	end
	fire_once = true

	if table.find(ModsLoaded,"id","o4zrnLN") then
		table.insert(rockets,3,"sRocket_Orion")
		-- rocket_palette = "OrionRocket", doesn't work with changing the colony colour scheme
		table.insert(palettes,3,{
			"rocket_base",
			"rocket_accent",
			"outside_accent_1",
			"rocket_base"
		})
		sRocket_Orion.GetSkins = GetSkins
	end

end
