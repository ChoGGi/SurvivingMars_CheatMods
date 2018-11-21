-- See LICENSE for terms

local is_gag = g_AvailableDlc.gagarin

local function GetSkins(self)
	local p = self.rocket_palette
	if is_gag then
		return {
			"Rocket",
			"Rocket_Trailblazer",
			"SpaceYDragonRocket",
			"ZeusRocket",
			"ArcPod",
			"SupplyPod",
			"CombatRover",
		}, {p,p,p,p,p,p,p}
	else
		return {
			"Rocket",
			"Rocket_Trailblazer",
			"SupplyPod",
			"CombatRover",
		}, {p,p,p,p}
	end
end

if is_gag then
	ZeusRocket.GetSkins = GetSkins
	DragonRocket.GetSkins = GetSkins
end
SupplyRocket.GetSkins = GetSkins
