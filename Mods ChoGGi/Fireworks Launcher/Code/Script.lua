-- See LICENSE for terms

local point = point
local IsValidThread = IsValidThread
local IsValid = IsValid
local Sleep = Sleep
local MulDivRound = MulDivRound
local SetLen = SetLen
local Cross = Cross
local asin = asin

local mod_ToggleRain
local mod_RaiseTemps
--~ local mod_RainType

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_ToggleRain = CurrentModOptions:GetProperty("ToggleRain")
	mod_RaiseTemps = CurrentModOptions:GetProperty("RaiseTemps")

	if not g_AvailableDlc.armstrong then
		mod_ToggleRain = false
		mod_RaiseTemps = false
	end

--~ 	local rain_type = CurrentModOptions:GetProperty("RainType")
--~ 	mod_RainType = rain_type = 1 and "normal" or rain_type = 1 and "toxic" or "gamestate"
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- probably shouldn't bother using GlobalVar, but I'll leave since I'm too lazy to test
GlobalVar("FireworksLauncher_targetobj", false)
function OnMsg.SaveGame()
	if IsValid(FireworksLauncher_targetobj) then
		DoneObject(FireworksLauncher_targetobj)
	end
end

local entity = "SupplyPod"
local display_icon = CurrentModPath .. "UI/fireworks_launcher.png"

DefineClass.FireworksLauncher = {
	__parents = {
		"Building",
	},

	-- stores sleep thread for fireworks (since there's no global var to check)
	waiting_thread = false,

	building_thread = false,
	explode_thread = false,
	landing_thread = false,
}

function FireworksLauncher:GameInit()
	-- for the rocket particles
	self.fx_actor_class = "SupplyPod"

	local self_pos = self:GetPos()

	self.building_thread = CreateGameTimeThread(function()
		local cover = EntityClass:new()
		cover:ChangeEntity("Hex1_Placeholder")
		cover:SetColorModifier(-16777216)
		cover:SetScale(325)
		-- move just below the ground
		cover:SetPos(self_pos+point(0, 0, -3300))

		cover:SetPos(self_pos, 5000)
		Sleep(5000)

		-- now we make it look like the building

		-- -128 to 127
		self:SetColorizationMaterial(1, 7602176, 127, 120)
		self:SetColorizationMaterial(2, 10790052, 120, 16)
		self:SetColorizationMaterial(3, 11016730, -128, 48)
		SetRollPitchYaw(self, 0, 10800, 0)
		local new_pos = self_pos+point(0, 0, 2800)
		self:SetPos(new_pos)

		-- add some attaches

		local rocket = EntityClass:new()
		rocket:ChangeEntity("DefenceTurretRocket")
		rocket:SetScale(500)
		self:Attach(rocket)
		SetRollPitchYaw(rocket, 0, 10800, 0)
		rocket:SetAttachOffset(point(0, 0, 610))
		rocket.fx_actor_class = "AttackRover"
		self.rocket_attach = rocket

		local base = EntityClass:new()
		base:ChangeEntity("ReprocessingPlantBarrel")
		base:SetColorizationMaterial(1, -9175040, -128, 120)
		base:SetColorizationMaterial(2, -5987164, 120, 20)
		base:SetColorizationMaterial(3, -5694693, -128, 48)
		self:Attach(base)
		SetRollPitchYaw(base, 0, 16200, 0)
		base:SetAttachOffset(point(650, 0, 1500))

		Sleep(8000)
		-- move cover back below ground
		cover:SetPos(self_pos+point(0, 0, -3300), 5000)
		Sleep(5000)

		DoneObject(cover)
	end)

end

-- eeeh probably overkill
function FireworksLauncher:Done()
	if IsValidThread(self.building_thread) then
		DeleteThread(self.building_thread)
	end
	if IsValidThread(self.waiting_thread) then
		DeleteThread(self.waiting_thread)
	end
	if IsValidThread(self.explode_thread) then
		DeleteThread(self.explode_thread)
	end
	if IsValidThread(self.landing_thread) then
		DeleteThread(self.landing_thread)
	end
end

-- self for this is the rocket, NOT the fireworks building
function FireworksLauncher:RocketMove()
	local tick = 50
	local dir = SetLen(self.move_dir, self.start_speed)
	-- half height so it doesn't take too long for rains
	local max_height = GetGameMap(self).terrain:GetMapHeight() / 4
	local target = self.target
	local max_travel = MulDivRound(self.max_speed, tick, 1000)

	while IsValid(self) and self:GetZ() < max_height do
		local target_pos = target:GetPos()
		local pos = self:GetVisualPos()
		local v = target_pos - pos
		local dist = v:Len()
		local pull = SetLen(v, MulDivRound(self.pull, tick, 1000))
		dir = dir + pull
		local travel = dir:Len()
		if max_travel < travel then
			dir = SetLen(dir, max_travel)
		end
		local next_pos = pos + dir
		local dx, dy, dz = dir:xyz()
		local axis, angle
		if dx == 0 and dy == 0 then
			axis = axis_y
			angle = 10800
		else
			axis = Cross(point(dx, dy, 0), axis_z)
			angle = asin(MulDivRound(dz, 4096, dir:Len())) - 5400
		end
		if dist <= travel then
			next_pos = pos
			tick = MulDivRound(tick, dist, travel)
			self:SetPos(pos, tick)
			self:SetAxis(axis, tick)
			self:SetAngle(angle, tick)
			break
		else
			self:SetPos(next_pos, tick)
			self:SetAxis(axis, tick)
			self:SetAngle(angle, tick)
			Sleep(tick)
		end
	end
end

function FireworksLauncher:LaunchFireworks(visual_only)
	-- are fireworks already happening
	if IsValidThread(self.waiting_thread) then
		return
	end
	local gamemap = GetGameMap(self)

	TriggerFireworks()

	self.waiting_thread = CreateGameTimeThread(function()
		-- 3 * const.HourDuration is from function TriggerFireworks()
		Sleep(3 * const.HourDuration)
		self.waiting_thread = false
	end)

	-- no temp bumps allowed
	if visual_only or g_NoTerraforming then
		return
	end

	-- fire?
	self.landing_thread = CreateGameTimeThread(function()
		PlayFX("RocketLand", "start", self)
		Sleep(const.HourDuration / 8)
		PlayFX("RocketLand", "end", self)
	end)

	-- shoot off a rocket, because
	local rocket = RocketProjectile:new()
	local rocket_pos = self.rocket_attach:GetPos()
	rocket:SetPos(rocket_pos)
	rocket:SetScale(400)
	rocket.move_dir = axis_z
	rocket.shooter = self
	local x, y = gamemap.terrain:GetMapSize()
	local target
	if IsValid(FireworksLauncher_targetobj) then
		target = FireworksLauncher_targetobj
	else
		target = InvisibleObject:new()
		FireworksLauncher_targetobj = target
	end

	local target_pos = point(self:Random(0, x), self:Random(0, y), gamemap.terrain:GetMapHeight() / 4)
	target:SetPos(target_pos)
	rocket.target = target
	rocket.Move = self.RocketMove
	rocket:StartMoving()

	PlayFX("MissileFired", "start", self.rocket_attach, nil, rocket_pos, axis_z)
	self.explode_thread = CreateGameTimeThread(function()
		if IsValid(self.parent_dome) then
			local _, dome_pt = BaseMeteor.HitsDome(
				{start = self.parent_dome:GetPos()}, self:GetPos()
			)
			self.parent_dome:AddFracture("Small", dome_pt)
		end
		while rocket.move_thread do
			Sleep(500)
		end
		PlayFX("GroundExplosion", "start", self)
		if mod_ToggleRain then
			if RainsDisasterThreads[g_RainDisaster] then
				StopRainsDisaster(g_RainDisaster)
			else
				CheatRainsDisaster("Normal_High")
			end
		end
	end)

	-- got enough to raise the temps?
	if mod_RaiseTemps and UIColony.funds.funding > (100 * 1000000) then
		ChangeFunding(-100)

		local name = "Temperature"
		local temp = Terraforming[name] or 0
		temp = temp + 10
		Terraforming[name] = temp
		-- UpdateTerraformEffects() is local, so ...
		temp = GetTerraformParam(name)
		SetTerraformParam(name, temp)
	end
end

function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.FireworksLauncher then
		PlaceObj("BuildingTemplate", {

		-- added, not uploaded
		"disabled_in_environment1", "",
		"disabled_in_environment2", "",
		"disabled_in_environment3", "",
		"disabled_in_environment4", "",

			"Id", "FireworksLauncher",
			"template_class", "FireworksLauncher",
			"construction_cost_Concrete", 15000,
			"construction_cost_Metal", 5000,
			"palette_color1", "outside_base",
			"palette_color2", "inside_base",
			"palette_color3", "rover_base",
			"display_name", T(302535920011418,"Fireworks Launcher"),
			"display_name_pl", T(302535920011419, "Fireworks Launchers"),
			"description", T(302535920011420, "Launches fireworks and slightly raises temperature."),
			"display_icon", display_icon,
			"entity", entity,
			"build_category", "ChoGGi",
			"Group", "ChoGGi",
			"encyclopedia_exclude", true,
			"on_off_button", false,
			"prio_button", false,
			"use_demolished_state", true,
			"demolish_sinking", range(2, 10),
			"auto_clear", false,
		})
	end

	local building = XTemplates.ipBuilding[1]

	-- check for and remove existing template
	ChoGGi_Funcs.Common.RemoveXTemplateSections(building, "ChoGGi_Template_FireworksLauncher_DoStuff", true)

	table.insert(building, 1,
		PlaceObj('XTemplateTemplate', {
			"ChoGGi_Template_FireworksLauncher_DoStuff", true,
			"Id", "ChoGGi_FireworksLauncher_DoStuff",
			"comment", "something something",
			"__context_of_kind", "FireworksLauncher",
			"__template", "InfopanelButton",
			"RolloverText", T(302535920011421, [[Fire off some fireworks (Costs 100 million to use).
Right-click to skip cost/temperature increase (also happens if you don't have enough cash).]]),
			"RolloverTitle", T(302535920000944, [[Yamato Hasshin!]]),
			"RolloverHint", T(302535920011422, [[<left_click> Hot Fireworks <right_click> Visual Fireworks]]),
			"Icon", "UI/Icons/IPButtons/drill.tga",
			"OnPress", function(self, gamepad)
				-- left click action (arg is if ctrl is being held down)
				self.context:LaunchFireworks(false, not gamepad and IsMassUIModifierPressed())
				ObjModified(self.context)
			end,
			"AltPress", true,
			"OnAltPress", function(self, gamepad)
				-- right click action
				if gamepad then
					self.context:LaunchFireworks(true, true)
				else
					self.context:LaunchFireworks(true, IsMassUIModifierPressed())
				end
				ObjModified(self.context)
			end,
		})
	)

end
