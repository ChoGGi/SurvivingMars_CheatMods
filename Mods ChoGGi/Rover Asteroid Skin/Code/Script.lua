-- See LICENSE for terms

local IsValidEntity = IsValidEntity

local mod_EnableMod

local trailblazer_skins = {
	Drone = "Drone_Trailblazer",
	RCRover = "Rover_Trailblazer",
	RCTransport = "RoverTransport_Trailblazer",
	ExplorerRover = "RoverExplorer_Trailblazer",
	SupplyRocket = "Rocket_Trailblazer",
}

-- picard overrides the orig func with an environment check for the asteroid skins
local BaseRover_GetSkins = BaseRover.GetSkins
function BaseRover:GetSkins(...)
	if not mod_EnableMod then
		return BaseRover_GetSkins(self, ...)
	end

	local trailblazer_entity = trailblazer_skins[self.class]
	local entity = g_Classes[self.class].entity
	local asteroid

	if g_AvailableDlc.picard
		and self.environment_entity and IsValidEntity(self.environment_entity.Asteroid)
	then
		asteroid = self.environment_entity.Asteroid
	end

	if asteroid and entity and trailblazer_entity then
		return { entity, trailblazer_entity, asteroid}, { self.palette, self.palette, self.palette, }
	elseif asteroid and entity then
		return { entity, asteroid}, { self.palette, self.palette, }
	elseif entity and trailblazer_entity then
		return { entity, trailblazer_entity, }, { self.palette, self.palette, }
	end
end

local function UpdateEnv(func, self, skin, ...)
	if mod_EnableMod and g_AvailableDlc.picard then
		-- function DroneBase:TransformToEnvironment(environment)
		if skin:find("Flying", 1, true) then
			self.fx_actor_base_class = self.environment_fx.Asteroid
		else
			self.fx_actor_base_class = self.environment_fx.base
		end
	end
	return func(self, skin, ...)
end
--
local ChoOrig_RCRover_OnSkinChanged = RCRover.OnSkinChanged
function RCRover.OnSkinChanged(...)
	return UpdateEnv(ChoOrig_RCRover_OnSkinChanged, ...)
end
function OnMsg.ClassesPostprocess()
	local ChoOrig_BaseRover_OnSkinChanged = BaseRover.OnSkinChanged
	function BaseRover.OnSkinChanged(...)
		return UpdateEnv(ChoOrig_BaseRover_OnSkinChanged, ...)
	end
end

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
