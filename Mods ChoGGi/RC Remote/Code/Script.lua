-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 63
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error","RC Remote requires ChoGGi's Library (at least v" .. min_version .. [[).
Press OK to download it or check the Mod Manager to make sure it's enabled.]]) == "ok" then
				if p.steam then
					OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
				elseif p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/505/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/89?tab=files")
				end
			end
		end)
	end
end

-- local some globals
local ResourceScale = const.ResourceScale
local vkW = const.vkW
local vkA = const.vkA
local vkS = const.vkS
local vkD = const.vkD
local vkShift = const.vkShift
local function parabola(x)
	return 4 * x - x * x / 25
end
local Min = Min
local ValueLerp = ValueLerp
local Sleep = Sleep
local PlayFX = PlayFX
local PlaySound = PlaySound
local MovePointAway = MovePointAway
local IsKeyPressed = terminal.IsKeyPressed
local IsValid = IsValid
local GetTerrainCursor = GetTerrainCursor
local MapFindNearest = MapFindNearest
--~ local axis_z = axis_z

local TableConcat
local Translate

function OnMsg.ClassesGenerate()
	TableConcat = ChoGGi.ComFuncs.TableConcat
	Translate = ChoGGi.ComFuncs.Translate

--~ 	local Strings = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local c = #Actions

	local function MoveRC(dir)
		local self = SelectedObj
		if self and self:IsKindOf("RCRemote") then
			-- if already moving in the same dir then abort
			if self.jumping or (self.command == "RemoteMove" and self.move_dir == dir) then
				return
			end
			self:SetCommand("RemoteMove",dir)
		end
	end

	local function JumpForward()
		local self = SelectedObj
		if self and self:IsKindOf("RCRemote") then
			self.jumping = true
			PlayFX("Moving", "start", self)
			self:SetState("moveWalk")

			self.fx_actor_class = "JumperShuttle"
			PlayFX("Jump", "start", self)
			PlayFX("JumpUp", "start", self)
			PlayFX("Accelerate", "start", self)
			Sleep(150)

			local old_pos = self:GetPos()
			local pos = MovePointAway(
				old_pos,
				self:GetSpotLoc(self:GetSpotBeginIndex(self.jump_move_spot)),
				self.jump_move_dist
			)
			local points = self:RetParabola(old_pos, pos)
			local count = #points
			for i = 1, count do
				if i == count then
					self:SetPos(points[i]:SetTerrainZ(),250)
				else
					self:SetPos(points[i],250)
				end
				Sleep(250)
			end
			self.fx_actor_class = "ExplorerRover"
			PlayFX("Moving", "end", self)
			self:SetState("idle")

			self.fx_actor_class = "JumperShuttle"
			PlayFX("Accelerate", "end", self)
			PlayFX("Jump", "end", self)
			PlayFX("JumpUp", "end", self)
			PlayFX("JumpDown", "start", self)
			Sleep(250)
			PlayFX("Jump", "end", self)
			PlayFX("JumpDown", "end", self)

			self.fx_actor_class = "ExplorerRover"
			self.jumping = false
		end
	end

	c = c + 1
	Actions[c] = {ActionName = "Remote: Fire Missile",
		ActionId = "RCRemote.FireMissile",
		OnAction = function()
			local self = SelectedObj
			if self and self:IsKindOf("RCRemote") then
				self:FireRocket()
			end
		end,
		ActionToggle = true,
		ActionShortcut = "Q",
		ActionBindable = true,
		ActionMode = "RCRemote",
	}

	c = c + 1
	Actions[c] = {ActionName = "Remote: Jump Forward",
		ActionId = "RCRemote.JumpForward",
		OnAction = function()
			CreateGameTimeThread(JumpForward)
		end,
		ActionToggle = true,
		ActionShortcut = "E",
		ActionBindable = true,
		ActionMode = "RCRemote",
	}

	c = c + 1
	Actions[c] = {ActionName = "Remote: Move Forward",
		ActionId = "RCRemote.Forward",
		OnAction = function()
			MoveRC(1)
		end,
		ActionToggle = true,

		ActionShortcut = "W",
		ActionBindable = true,
		ActionMode = "RCRemote",
	}

	c = c + 1
	Actions[c] = {ActionName = "Remote: Move Backward",
		ActionId = "RCRemote.Backward",
		OnAction = function()
			MoveRC(2)
		end,
		ActionShortcut = "S",
		ActionBindable = true,
		ActionMode = "RCRemote",
	}

	c = c + 1
	Actions[c] = {ActionName = "Remote: Move Left",
		ActionId = "RCRemote.Left",
		OnAction = function()
			MoveRC(3)
		end,
		ActionShortcut = "A",
		ActionBindable = true,
		ActionMode = "RCRemote",
	}

	c = c + 1
	Actions[c] = {ActionName = "Remote: Move Right",
		ActionId = "RCRemote.Right",
		OnAction = function()
			MoveRC(4)
		end,
		ActionShortcut = "D",
		ActionBindable = true,
		ActionMode = "RCRemote",
	}

end

local name = [[RC Remote]]
local description = [[Remote controlled RC]]
local display_icon = CurrentModPath .. "UI/rover_rc.png"

DefineClass.RCRemote = {
	__parents = {
		"BaseRover",
		"ComponentAttach",
	},
  name = name,
	description = description,
	display_icon = display_icon,
	display_name = name,

	entity = "DroneTruck",
--~ 	accumulate_dust = false,
	status_text = false,
	-- refund res
	on_demolish_resource_refund = { Metals = 20 * ResourceScale, MachineParts = 20 * ResourceScale , Electronics = 10 * ResourceScale },

	-- are we moving
	rc_moving = false,
	-- direction we're moving in
	move_dir = 0,

	-- 3 times as fast
	move_speed = 3000,
	-- how much to jump forward
	jump_move_dist = 10000,
	jump_move_spot = "Droneentrance",
	-- trying to move mid-air causes issues
	jumping = false,

	-- select/moving sounds
	fx_actor_class = "ExplorerRover",

	-- my hacky way of moving the rover (get a pos offset from the spot pos)
	dir_lookup = {
		[1] = {
			spot = "Droneentrance",
			amount = 1000,
		},
		[2] = {
			spot = "Droneentrance",
--~ 			amount = -1000,
			amount = -5
			,
		},
		[3] = {
			spot = "Dust2",
			amount = 5,
		},
		[4] = {
			spot = "Dust1",
			amount = 5,
		},
	},

  palette = {
    "rover_base",
    "rover_dark",
    "rover_accent",
    "none"
  },
}

function RCRemote:GameInit()
	self.status_text = Translate(6722--[[Idle--]])
	BaseRover.GameInit(self)

	-- colour #, Color, Roughness, Metallic
	-- middle area
	self:SetColorizationMaterial(1, -14710529, 12, 32)
	-- body
	self:SetColorizationMaterial(2, -14710529, 12, 32)
	-- color of bands
	self:SetColorizationMaterial(3, -13028496, 0, 12)

	-- show the pin info
	self.pin_rollover = T(0,"<ui_command>")
end

function RCRemote:RetParabola(from, to)
  local parabola_h = Min(from:Dist(to), 50 * guim)
  local pos_lerp = ValueLerp(from, to, 100)
  local steps = 10
  local vertices = {}
  for i = 0, steps do
    local x = i * (100 / steps)
    local pos = pos_lerp(x)
    pos = pos:AddZ(parabola(x) * parabola_h / 100)
		vertices[i+1] = pos
  end
	return vertices
end

function RCRemote:Getui_command()
	return self.status_text .. "<newline><left>"
end

-- 1 forward, 2 backwards, 3 left, 4 right
function RCRemote:RemoteMove(dir)
	-- vrrrmmm
	if not self.rc_moving then
		PlayFX("Moving", "start", self)
	end
	-- we need to use our own .moving so we don't get caught up in the dronebase one
	self.rc_moving = true
	self.move_dir = dir

	local dir_lookup = self.dir_lookup[dir]
	local pos = MovePointAway(
		self:GetPos(),
		self:GetSpotLoc(self:GetSpotBeginIndex(dir_lookup.spot)),
		dir_lookup.amount
	)
	self:GotoFromUser(pos:SetTerrainZ())

	if dir == 1 and IsKeyPressed(vkW) then
		self:RemoteMove(dir)
	elseif dir == 2 and IsKeyPressed(vkS) then
		self:RemoteMove(dir)
	elseif dir == 3 and IsKeyPressed(vkA) then
		self:RemoteMove(dir)
	elseif dir == 4 and IsKeyPressed(vkD) then
		self:RemoteMove(dir)
	else
		self.rc_moving = false
		self.move_dir = 0
		PlayFX("Moving", "end", self)
	end
end

function RCRemote:FireRocket(target)
	local pt = GetTerrainCursor()
	target = target or MapFindNearest(pt,pt,1500)
	if not IsValid(target) then
		return
	end

	local pos, _, axis = self:GetSpotLoc(self:GetSpotBeginIndex("Drone"))

	local rocket = PlaceObject("RocketProjectile", {
		shooter = self,
		target = target,
	})

  rocket:SetPos(pos)
  rocket.move_dir = axis
  rocket:StartMoving()

	self.fx_actor_class = "DefenceTower"
	PlayFX("MissileFired", "start", self, nil, pos, axis)
	self.fx_actor_class = "ExplorerRover"

	if target:IsKindOfClasses("Deposition","WasteRockObstructorSmall","WasteRockObstructor","StoneSmall") then
		CreateGameTimeThread(self.ExplodeRock,self,target,rocket)
	end

end

function RCRemote:ExplodeRock(target,rocket)
	while rocket.move_thread do
		Sleep(500)
	end
	-- maybe it was removed before we arrived?
	if IsValid(target) then
		local snd = PlaySound("Mystery Bombardment ExplodeAir", "ObjectOneshot", nil, 0, false, target)
		PlayFX("GroundExplosion", "start", target, target, target:GetPos())
		target:delete()
	end
end

local pfFinished = const.pfFinished
local pfStranded = const.pfStranded
function RCRemote:Goto(...)
	local pfStep = self.Step
	local status = pfStep(self, ...)
	if status < 0 then
		return status == pfFinished
	end
	local pfSleep = self.MoveSleep
	while true do
--~ 		print(status)
		if status > 0 then
			pfSleep(self, status)
		elseif status == pfStranded then
			if not self:OnStrandedFallback(...) then
				break
			end
		else
			break
		end
		status = pfStep(self, ...)
	end
	self.last_spot_tried = false

	return status == pfFinished
end

function RCRemote:GotoFromUser(...)
	self.status_text = Translate(63--[[Travelling--]])
	return BaseRover.GotoFromUser(self,...)
end

function RCRemote:Idle()
	if self.rc_moving then
		self.rc_moving = false
		self.move_dir = 0
		PlayFX("Moving", "end", self)
	end

	self.status_text = Translate(6722--[[Idle--]])

	self:SetState("idle")
	self:Gossip("Idle")

	DeleteThread(self.command_thread,true)
	self.command_thread = false
end

DefineClass.RCRemoteBuilding = {
	__parents = {"BaseRoverBuilding"},
	rover_class = "RCRemote",
}

function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.RCRemoteBuilding then
		PlaceObj("BuildingTemplate",{
			"Id","RCRemoteBuilding",
			"template_class","RCRemoteBuilding",
			"construction_cost_Metals",1000,
			"construction_cost_MachineParts",1000,
			"construction_cost_Electronics",1000,
			-- add a bit of pallor to the skeleton
			"palette_color1", "rover_base",

			"dome_forbidden",true,
			"display_name",name,
			"display_name_pl",name,
			"description",description,
			"build_category","ChoGGi",
			"Group", "ChoGGi",
			"display_icon", display_icon,
			"encyclopedia_exclude",true,
			"on_off_button",false,
			"entity", "RCRoverBuilding",
		})
	end
end

-- also fires when changing selection
local shortcuts_mode
function OnMsg.SelectionAdded(obj)
	if obj:IsKindOf("RCRemote") then
		-- set camera to follow mode (needs a delay or it's a funky camera mode)
		CreateRealTimeThread(function()
			WaitMsg("OnRender")
			Camera3pFollow(obj)
			SelectedObj = obj
			-- enable kb controls, and gamepad
			shortcuts_mode = XShortcutsTarget and XShortcutsTarget:GetActionsMode()
			XShortcutsSetMode("RCRemote")
		end)
	elseif shortcuts_mode then
		XShortcutsSetMode(shortcuts_mode)
		shortcuts_mode = false
	end
end
function OnMsg.SelectionRemoved()
	-- go back to normal controls
  if shortcuts_mode then
		XShortcutsSetMode(shortcuts_mode)
		shortcuts_mode = false
	end
end

-- add all the rc skins with Droneentrance spot (maybe add the rest when I'm not lazy)
local entity = {
	"DroneTruck",
	"RoverTransport",
	"CombatRover",
}

local palettes = {
	RCRover.palette,
	RCTransport.palette,
	AttackRover.palette,
}

if g_AvailableDlc.gagarin then
	entity[#entity+1] = "RoverIndiaConstructor"
	palettes[#palettes+1] = RCConstructor.palette
	entity[#entity+1] = "RoverRussiaDriller"
	palettes[#palettes+1] = RCDriller.palette
	entity[#entity+1] = "RoverEuropeCuriosityRC"
	palettes[#palettes+1] = RCSensor.palette
	entity[#entity+1] = "RoverChinaSolarRC"
	palettes[#palettes+1] = RCSolar.palette
end

function RCRemote:GetSkins()
	return entity,palettes
end

