-- See LICENSE for terms

local Sleep = Sleep
local IsValid = IsValid
local GetRandomPassableAround = GetRandomPassableAround
local guim = guim
local Random = ChoGGi.ComFuncs.Random

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
	leave_height = 1000 * guim,
	hover_height = 30 * guim,
	hover_height_orig = 30 * guim,
	arrival_time = 10000,
	min_pos_radius = 250 * guim,
	max_pos_radius = 1500 * guim,
	pre_leave_offset = 1000,
	min_meteor_time = const.DayDuration,
	max_meteor_time = const.DayDuration * 4,

	fx_actor_base_class = "FXRocket",
	fx_actor_class = "SupplyPod",

	display_icon = "UI/Icons/Buildings/supply_pod.tga",

	panel_icon = "",
	panel_text = T(302535920011242, [[Waiting for victim]]),
	ip_template = "ipShuttle",

	thrust_max = 3000,
	accel_dist = 30*guim,
	decel_dist = 60*guim,
	collision_radius = 50*guim,
}
if IsValidEntity("ArcPod") then
	MurderPod.entity = "ArcPod"
	MurderPod.display_icon = "UI/Icons/Buildings/ark_pod.tga"
end

function MurderPod:GameInit()
	self.city = UICity

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

function MurderPod:Spawn(arrival_height)
	if not arrival_height then
		arrival_height = self.arrival_height
	end

	local goto_pos = GetRandomPassableAround(
		self:GetVictimPos(),
		self.max_pos_radius,
		self.min_pos_radius
	):SetTerrainZ(arrival_height)

	Sleep(1000)
	self:SetPos(goto_pos)
	Sleep(5000)
	self.fx_actor_class = "AttackRover"
	self:PlayFX("Land", "start")

	self:SetCommand("StalkerTime")
end

function MurderPod:Leave(leave_height)
	leave_height = leave_height or self.leave_height

	self.fx_actor_class = "SupplyRocket"
	self:PlayFX("RocketEngine", "start")

	Sleep(5000)
	local current_pos = self:GetPos() or point20

	local goto_pos = GetRandomPassableAround(
		current_pos,
		self.max_pos_radius,
		self.min_pos_radius
	)
	leave_height = (terrain.GetHeight(current_pos) + leave_height) * 2
	self.hover_height = leave_height / 4

	self.fx_actor_class = "SupplyRocket"
	self:PlayFX("RocketEngine", "end")
	self:PlayFX("RocketLaunch", "start")

	self:FollowPathCmd(self:CalcPath(
		current_pos,
		goto_pos
	))

	local amount = 4
	-- splines are the flight path being followed
	while self.next_spline do
		Sleep(500)
		amount = amount - 1
		if amount < 1 then
			amount = 1
		end
		self.hover_height = leave_height / amount
	end

	DoneObject(self)
end

function MurderPod:LaunchMeteor(entity)
	--	1 to 4 sols
	Sleep(Random(
		self.min_meteor_time or const.DayDuration,
		self.max_meteor_time or const.DayDuration * 4
	))
--~ 	Sleep(5000)
	local data = DataInstances.MapSettings_Meteor.Meteor_VeryLow
	local descr = SpawnMeteor(data, nil, nil, GetRandomPassable())
	-- I got a missle once, not sure why...
	if descr.meteor:IsKindOf("BombardMissile") then
		g_IncomingMissiles[descr.meteor] = nil
		if IsValid(descr.meteor) then
			DoneObject(descr.meteor)
		end
	else
		descr.meteor:Fall(descr.start)
		descr.meteor:ChangeEntity(entity)
		-- frozen meat popsicle (dark blue)
		descr.meteor:SetColorModifier(-16772609)
		-- it looks reasonable
		descr.meteor:SetState("sitSoftChairIdle")
		-- i don't maybe they swelled up from the heat and moisture permeating in space
		descr.meteor:SetScale(500)
	end
--~ 	ex(descr.meteor)
end

function MurderPod:GetVictimPos()
	local victim = self.target
	-- otherwise float around the victim walking around the dome/whatever building they're in, or if somethings borked then a rand pos
	local pos
	if victim:IsValidPos() then
		pos = victim:GetVisualPos()
	elseif IsValid(victim.holder) and victim.holder:IsValidPos() then
		pos = victim.holder:GetVisualPos()
	else
		pos = GetRandomPassable()
	end
	return pos
end

function MurderPod:Abduct()
	local victim = self.target

	-- stalk if in dome/building/passage
	if not self:IsValidPos() or (victim:IsInDome() and not OpenAirBuildings)
		or (IsValid(victim.lead_in_out) and victim.lead_in_out:IsKindOf("PassageGridElement"))
	then
		self:SetCommand("StalkerTime")
	end

	-- force them outside
	victim:SetCommand("Goto", GetRandomPassableAwayFromBuilding(self.city))

	-- you ain't going nowhere (fire them and override goto func so victim can't move)
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

	-- change the not working sign to something more apropos
	victim.status_effects = {
		StatusEffect_StressedOut = 1
	}
	UpdateAttachedSign(victim, true)

	self:WaitFollowPath(self:CalcPath(
		self:GetPos(),
		victim:GetPos()
	))

	self.fx_actor_class = "Shuttle"
	self:PlayFX("ShuttleLoad", "start", victim)
	victim:SetPos(self:GetPos():AddZ(500), 2500)
	Sleep(2500)
	self:PlayFX("ShuttleLoad", "end", victim)

	-- grab entity before we remove colonist (for our iceberg meteor)
	local entity = victim.inner_entity
	-- no need to keep colonist around now
	victim:Erase()
	-- change selection panel icon
	self.panel_text = T(302535920011243, [[Victim going to "Earth"]])

	-- human shaped meteors (bonus meteors, since murder is bad)
	for _ = 1, Random(1, 3) do
		CreateGameTimeThread(MurderPod.LaunchMeteor, self, entity)
	end

	-- What did Mission Control ever do for us? Without it, where would we be? Free! Free to roam the universe!
	self:SetCommand("Leave")
end

function MurderPod:StalkerTime()
	local victim = self.target
	while IsValid(victim) do

		-- check if they're not in a building/dome/passage (ie: outside)
		local in_dome = victim:IsInDome()
		if victim:IsValidPos() and not (IsValid(victim.lead_in_out)
			and victim.lead_in_out:IsKindOf("PassageGridElement"))
			and (not in_dome or in_dome and OpenAirBuildings)
		then
			self:SetCommand("Abduct")
			break
		end

		-- otherwise float around the victim walking around the dome/whatever building they're in, or if somethings borked then a rand pos
		local goto_pos = GetRandomPassableAround(
			self:GetVictimPos(),
			self.max_pos_radius,
			self.min_pos_radius
		)

		self:FollowPathCmd(self:CalcPath(self:GetPos(), goto_pos))

		while self.next_spline do
			Sleep(2500)
		end

		Sleep(Random(2500, 10000))
	end

	-- soundless sleep
	if IsValid(self) then
		self:SetCommand("Leave")
	end

end

function MurderPod:Idle()
	Sleep(2500)
	if IsValid(self.target) then
		self:SetCommand("StalkerTime")
	else
		self:SetCommand("Leave")
	end
end

function MurderPod:OnSelected()
	SelectionArrowAdd(self.target)
end

-- add switch skins if dlc
if g_AvailableDlc.gagarin then
	local pods = {"SupplyPod", "DropPod", "ArcPod"}
	local palettes = {SupplyPod.rocket_palette, DropPod.rocket_palette, ArkPod.rocket_palette}

	function MurderPod:GetSkins()
		return pods, palettes
	end
end
