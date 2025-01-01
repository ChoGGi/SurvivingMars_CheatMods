-- See LICENSE for terms

local mod_EnableMod
local mod_JustRockets

local skins, palettes

-- Used for overriding skin funcs
local function ReturnSkins(func, self, ...)
	if not mod_EnableMod then
		return func(self, ...)
	end
	return skins, palettes
end

-- Replace GetSkins to add my skins
local rockets = {
	"RocketBase",
}
if g_AvailableDlc.gagarin then
	rockets[#rockets+1] = "DragonRocket"
	rockets[#rockets+1] = "ZeusRocket"
end
if g_AvailableDlc.picard then
	rockets[#rockets+1] = "LanderRocketBase"
end
for i = 1, #rockets do
	local rocket = rockets[i]
	local ChoOrig_GetSkins = _G[rocket].GetSkins
	_G[rocket].GetSkins = function(...)
		return ReturnSkins(ChoOrig_GetSkins, ...)
	end
end

local ChoOrig_RDM_OrionRocket_GetSkins

-- Check if door is opened for rockets and reset it after changing from a pod/rover skin
local ChoOrig_Building_ChangeSkin = Building.ChangeSkin
local function ChangeSkin(self, skin, palette, ...)
	if not mod_EnableMod then
		return ChoOrig_Building_ChangeSkin(self, skin, palette, ...)
	end

	if self:GetStateText() == "disembarkIdle" then
		self.ChoGGi_ChangeRocketSkin_state = true
	end

	return ChoOrig_Building_ChangeSkin(self, skin, palette, ...)
end
Building.ChangeSkin = ChangeSkin

local ChoOrig_Building_OnSkinChanged = Building.OnSkinChanged
function Building:OnSkinChanged(skin, palette, ...)
	if not mod_EnableMod then
		return ChoOrig_Building_OnSkinChanged(self, skin, palette, ...)
	end

	if self.ChoGGi_ChangeRocketSkin_state and table.find(self:GetStates(), "disembarkIdle") then
		self:SetStateText("disembarkIdle")
		self.ChoGGi_ChangeRocketSkin_state = nil
	end

	return ChoOrig_Building_OnSkinChanged(self, skin, palette, ...)
end

-- Build list of usable skins
local function GenerateSkins()

	-- Start with base game skins
	skins = {
		"Rocket",
		"Rocket_Trailblazer",
	}

	palettes = {
		-- No idea what this palette is for, but it makes the rocket orange
--~ 		RocketBase.rocket_palette,
		{},
		{},
	}

	-- Override needed for Coloured Depots mod
	RocketBase.ChangeSkin = ChangeSkin

	if not mod_JustRockets then
		skins[#skins+1] = "CombatRover"
		skins[#skins+1] = "SupplyPod"
		palettes[#palettes+1] = AttackRover.palette
		palettes[#palettes+1] = SupplyPod.rocket_palette
	end

	-- Add space race entities
	if g_AvailableDlc.gagarin then
		skins[#skins+1] = "ZeusRocket"
		skins[#skins+1] = "SpaceYDragonRocket"
		palettes[#palettes+1] = ZeusRocket.rocket_palette
		palettes[#palettes+1] = DragonRocket.rocket_palette

		if not mod_JustRockets then
			skins[#skins+1] = "DropPod"
			skins[#skins+1] = "ArcPod"
			palettes[#palettes+1] = DropPod.rocket_palette
			palettes[#palettes+1] = ArkPod.rocket_palette
		end
	end

	-- Landers
	if g_AvailableDlc.picard then
		skins[#skins+1] = "LanderRocket"
		skins[#skins+1] = "LanderRocket_Asteroid"
		palettes[#palettes+1] = LanderRocketBase.rocket_palette
		palettes[#palettes+1] = LanderRocketBase.rocket_palette
	end

	-- Silva - Orion Heavy Rocket
	if table.find(ModsLoaded, "id", "Ucv4buQ") then
		skins[#skins+1] = "RDM_OrionRocket"
		palettes[#palettes+1] = RDM_OrionRocket.rocket_palette
		if not ChoOrig_RDM_OrionRocket_GetSkins then
			ChoOrig_RDM_OrionRocket_GetSkins = RDM_OrionRocket.GetSkins
		end
		if mod_EnableMod then
			RDM_OrionRocket.GetSkins = function()
				return skins, palettes
			end
		else
			RDM_OrionRocket.GetSkins = ChoOrig_RDM_OrionRocket_GetSkins
		end
	end
end


-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_JustRockets = CurrentModOptions:GetProperty("JustRockets")

	GenerateSkins()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- Unlock Trailblazer skins :)
local tb = g_TrailblazerSkins
tb.Drone = "Drone_Trailblazer"
tb.RCRover = "Rover_Trailblazer"
tb.RCTransport = "RoverTransport_Trailblazer"
tb.ExplorerRover = "RoverExplorer_Trailblazer"
tb.SupplyRocket = "Rocket_Trailblazer"
