-- See LICENSE for terms

local Sleep = Sleep
local IsValid = IsValid
local IsValidThread = IsValidThread
local PlayFX = PlayFX
local GetRandomPassableAround = GetRandomPassableAround
local GetHeight = terrain.GetHeight

local guim = guim

local Random

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()
	Random = ChoGGi.ComFuncs.Random
end

DefineClass.MurderPod = {
	__parents = {
		"CommandObject",
		"FlyingObject",
		"InfopanelObj",
		"CameraFollowObject",
		"PinnableObject",
		"SkinChangeable",
	},
	palette = { "outside_accent_1", "outside_base", "outside_dark", "outside_base" },
	entity = "SupplyPod",
	-- victim
	target = false,
  arrival_height = 1000 * guim,
  hover_height = 30 * guim,
  arrival_time = 10000,
	min_pos_radius = 250 * guim,
	max_pos_radius = 1500 * guim,
  pre_leave_offset = 1000,
	min_meteor_time = const.Scale.sols,
	max_meteor_time = const.Scale.sols * 4,

	fx_actor_base_class = "FXRocket",
	fx_actor_class = "SupplyPod",

	panel_icon = "",
	panel_text = [[Waiting for victim]],
	ip_template = "ipShuttle",
}
if IsValidEntity("ArcPod") then
	MurderPod.entity = "ArcPod"
end

function MurderPod:GameInit()
	self:SetColorizationMaterial(1, -9169900, -50, 0)
	self:SetColorizationMaterial(2, -12254204, 0, 0)
	self:SetColorizationMaterial(3, -9408400, -127, 0)
end

function MurderPod:Getdescription()
	return self.panel_text
end
function MurderPod:GetCarriedResourceStr()
	return self.panel_icon
end
function MurderPod:GetDisplayName()
	return self:GetEntity()
end

function MurderPod:Spawn(arrival_height, hover_height, time)
--~ 	self:SetScale(25)

  arrival_height = arrival_height or self.arrival_height
  hover_height = hover_height or self.hover_height
  time = time or self.arrival_time

	local current_pos = self.target:GetPos()
	local pos = GetRandomPassableAround(
		current_pos,
		self.max_pos_radius,
		self.min_pos_radius
	):SetStepZ(GetHeight(current_pos) + arrival_height)

  PlayFX("MetatronPreArrive", "start", self, nil, pos)
  Sleep(1000)
  self:SetPos(pos)
  PlayFX("MetatronArrive", "start", self)
  pos = pos:SetStepZ(hover_height)
  self:SetPos(pos, time)
  Sleep(time)
  PlayFX("MetatronArrive", "end", self)
	Sleep(5000)

--~ 	PlayFX("RocketLand", "end", self)
	self.fx_actor_class = "AttackRover"
	self:PlayFX("Land","start")
	self:SetCommand("StalkerTime")
end

function MurderPod:Leave(arrival_height, time)
  time = time or self.arrival_time
  arrival_height = arrival_height or self.arrival_height

  Sleep(5000)

  PlayFX("MetatronLeave", "start", self)

	local current_pos = self:GetPos()
	local pos = GetRandomPassableAround(
		current_pos,
		self.max_pos_radius,
		self.min_pos_radius
	):SetZ(GetHeight(current_pos) + arrival_height)

  self:SetPos(pos, time)
  Sleep(Max(0, time - self.pre_leave_offset))
  PlayFX("MetatronLeave", "pre-leave", self)
  Sleep(self.pre_leave_offset)
  PlayFX("MetatronLeave", "end", self)
  DoneObject(self)
end

function MurderPod:LaunchMeteor(entity)
	Sleep(Random(self.min_meteor_time,self.max_meteor_time))
--~ 	Sleep(5000)
	local data = DataInstances.MapSettings_Meteor.Meteor_VeryLow
	local descr = SpawnMeteor(data,nil,nil,GetRandomPassable())
	-- I got a missle once, not sure why...
	if descr.meteor:IsKindOf("BombardMissile") then
		g_IncomingMissiles[descr.meteor] = nil
		if IsValid(descr.meteor) then
			DoneObject(descr.meteor)
		end
	else
		descr.meteor:Fall(descr.start)
		descr.meteor:ChangeEntity(entity)
		descr.meteor:SetColorModifier(-16772609)
		descr.meteor:SetState("sitSoftChairIdle")
		descr.meteor:SetScale(500)
	end
--~ 	ex(descr.meteor)
end

local point500 = point(0,0,500)
function MurderPod:Abduct()
	local victim = self.target

	if victim:IsInDome() or not self:IsValidPos() then
		self:SetCommand("StalkerTime")
	end

	victim:SetCommand("Goto",self:GetPos())
	-- you ain't going nowhere
	if IsValid(victim.workplace) then
		victim.workplace:FireWorker(victim)
	end
	victim.Goto = function()
		Sleep(10000)
		if not IsValid(self) then
			victim.Goto = Colonist.Goto
		end
	end
	victim:ClearPath()
	victim:SetCommand("Idle")
	victim:SetState("standPanicIdle")
	victim:PushDestructor(function()
		while true do
			Sleep(1000)
		end
	end)
	victim.status_effects = {
		StatusEffect_StressedOut = 1
	}
	UpdateAttachedSign(victim,true)

	local path = self:CalcPath(
		self:GetPos(),
		victim:GetPos()
	)
	self:WaitFollowPath(path)

	self.fx_actor_class = "Shuttle"
	self:PlayFX("ShuttleLoad", "start", victim)
	victim:SetPos(self:GetPos()+point500,2500)
	Sleep(2500)
	self:PlayFX("ShuttleLoad", "end", victim)
	self.fx_actor_class = "SupplyPod"

	-- no need to keep colonist around now
	local entity = victim.inner_entity
	victim:Erase()
	-- change selection panel icon
	self.panel_text = [[Victim going to "Earth"]]

	-- human shaped meteors
	for i = 1, Random(1,3) do
		CreateGameTimeThread(MurderPod.LaunchMeteor,self,entity)
	end

	-- What did Mission Control ever do for us? Without it, where would we be? Free! Free to roam the universe!
	self:Leave()
end

function MurderPod:StalkerTime()
	local victim = self.target
	while IsValid(victim) do

		local validpos = victim:IsValidPos()
		if validpos and not victim:IsInDome() then
			self:SetCommand("Abduct")
			break
		end

		local x,y
		if validpos then
			x,y = victim:GetVisualPosXYZ()
		elseif victim.holder and victim.holder:IsValidPos() then
			x,y = victim.holder:GetVisualPosXYZ()
		else
			local rand = GetRandomPassable()
			x,y = rand:x(),rand:y()
		end

		local path = self:CalcPath(
			self:GetPos(),
			point(x+Random(-1500,1500), y+Random(-1500,1500))
		)

		self:WaitFollowPath(path)
		Sleep(Random(2500,5000))
	end

	-- soundless sleep
	if IsValid(self) then
		self:Leave()
	end

end

function MurderPod:Idle()
	Sleep(2500)
	self:SetCommand("StalkerTime")
end

-- switch skins if dlc
if g_AvailableDlc.gagarin then
	local rockets = {"SupplyPod","ArcPod"}
	local palettes = {SupplyPod.rocket_palette,ArkPod.rocket_palette}
	function MurderPod:GetSkins()
		return rockets,palettes
	end
end
