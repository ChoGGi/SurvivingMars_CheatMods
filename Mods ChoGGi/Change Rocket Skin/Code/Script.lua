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

local function GetSkins(self)
	return rockets,palettes
end

local insert = table.insert

if g_AvailableDlc.gagarin then
	insert(rockets,3,"ArcPod")
	insert(palettes,3,ArkPod.rocket_palette)
	insert(rockets,3,"ZeusRocket")
	insert(palettes,3,ZeusRocket.rocket_palette)
	insert(rockets,3,"SpaceYDragonRocket")
	insert(palettes,3,DragonRocket.rocket_palette)
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
		insert(rockets,3,"sRocket_Orion")
		-- rocket_palette = "OrionRocket", doesn't work with changing the colony colour scheme
		insert(palettes,3,{
			"rocket_base",
			"rocket_accent",
			"outside_accent_1",
			"rocket_base"
		})
		sRocket_Orion.GetSkins = GetSkins
	end

end
