-- See LICENSE for terms

local Sleep = Sleep
local IsValid = IsValid
local GetRandomPassableAround = GetRandomPassableAround
local GetRandomPassable = GetRandomPassable
local PlaySound = PlaySound
local IsSoundPlaying = IsSoundPlaying
local guim = guim
local Random = ChoGGi.ComFuncs.Random
local RetName = ChoGGi.ComFuncs.RetName
local LaunchHumanMeteor = ChoGGi.ComFuncs.LaunchHumanMeteor
local InvalidPos = ChoGGi.Consts.InvalidPos

-- build list of traits/mod options
local mod_options = {}
local traits_list = {}
local c = 0
local mod_SkipTourists
local mod_IgnoreDomes
local mod_LessTakeoffDust
local mod_HideButton

local function AddColonists(list)
	for i = 1, #list do
		c = c + 1
		local id = list[i]
		traits_list[c] = id
		mod_options[id] = false
	end
end
local t = ChoGGi.Tables
AddColonists(t.ColonistAges)
AddColonists(t.NegativeTraits)
AddColonists(t.PositiveTraits)
AddColonists(t.OtherTraits)

-- call down the wrath of Zeus for miscreants
local function UpdateMurderPods()
	local objs = UICity.labels.Colonist or ""
	for i = 1, c do
		local obj = objs[i]
		-- If colonist already has a pod after it then skip
		if obj and not IsValid(obj.ChoGGi_MurderPod) then
			-- quicker to check age instead of looping all traits, so ageism rules
			if mod_options[obj.age_trait] then
				if not mod_SkipTourists or mod_SkipTourists and not obj.traits.Tourist then
					obj:ChoGGi_MP_LaunchPod()
				end
			else
				-- loop through colonist traits for bad ones
				for id in pairs(obj.traits) do
					-- we found it, so stop checking rest of traits and on to next victim
					if mod_options[id] then
						if not mod_SkipTourists or mod_SkipTourists and id ~= "Tourist" then
							obj:ChoGGi_MP_LaunchPod()
							break
						end
					end
				end
			end
		end
	end
end
OnMsg.NewHour = UpdateMurderPods

-- fired when settings are changed/init
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions

	mod_SkipTourists = options:GetProperty("SkipTourists")
	mod_IgnoreDomes = options:GetProperty("IgnoreDomes")
	mod_LessTakeoffDust = options:GetProperty("LessTakeoffDust")
	mod_HideButton = options:GetProperty("HideButton")

	for i = 1, c do
		local id = traits_list[i]
		mod_options[id] = options:GetProperty("Trait_" .. id)
	end

	-- make sure we're in-game
	if not UICity then
		return
	end

	UpdateMurderPods()
end
OnMsg.ModsReloaded = ModOptions
OnMsg.ApplyModOptions = ModOptions

function Colonist:ChoGGi_MP_RemovePod()
	if IsValid(self.ChoGGi_MurderPod) then
		self.ChoGGi_MurderPod:SetCommand("Leave")
		self.ChoGGi_MurderPod = nil
	end
end

function Colonist:ChoGGi_MP_WaitForIt()
	while self.command == "Goto" do
		Sleep(500)
	end
	Sleep(10000)
	if IsValid(self) and IsValid(self.ChoGGi_MurderPod) then
		self:SetCommand("Goto", g_IdiotMonument:GetPos())
		self:ChoGGi_MP_WaitForIt()
	end
end

function Colonist:ChoGGi_MP_LaunchPod()
	-- launch a pod and set to stalk hunt colonist
	local pod = MurderPod:new()
	pod.target = self
	pod.panel_icon = "<image " .. self.infopanel_icon .. " 2500>"
	pod:SetCommand("Spawn")
	-- used to update selection panel and to remove pod if needed
	self.ChoGGi_MurderPod = pod

	-- get outta here
	if IsValid(g_IdiotMonument) then
		CreateGameTimeThread(function()
			Sleep(Random(1000, 15000))
			self:SetCommand("Goto", g_IdiotMonument:GetPos())
			self:ChoGGi_MP_WaitForIt()
		end)
	else
		CreateGameTimeThread(function()
			while IsValid(self) and IsValid(self.ChoGGi_MurderPod) do
				Sleep(1000)
				if IsValid(g_IdiotMonument) then
					self:ChoGGi_MP_WaitForIt()
				end
			end
		end)

	end
end

GlobalVar("g_IdiotMonument", false)

DefineClass.IdiotMonument = {
	__parents = {
		"Building",
	},
	entity = "IceSet_05",
}

function IdiotMonument:GameInit()
	-- If there's already one replace with new one
	if IsValid(g_IdiotMonument) then
		g_IdiotMonument:OnDemolish()
	end
	g_IdiotMonument = self

	self:SetScale(25)
--~ 	self:SetPos(self:GetPos():AddZ(5000), 10000)
end

function IdiotMonument:OnDemolish()
	g_IdiotMonument = false

	CreateGameTimeThread(function()
		PlayFX("ElectrostaticStormArea", "start", self)
		self.fx_actor_class = "Crystal"
		PlayFX("CrystalCompose", "attach1", self)
		Sleep(2500)
		for i = 100, 1, -1 do
			self:SetOpacity(i)
			Sleep(25)
		end
		DoneObject(self)
	end)
end

function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.IdiotMonument then
		PlaceObj("BuildingTemplate", {
			"Id", "IdiotMonument",
			"template_class", "IdiotMonument",
			"construction_cost_Concrete", 1000,
			"display_name", T(302535920011239, "Idiot Monument"),
			"display_name_pl", T(302535920011240, "Idiot Monuments"),
			"description", T(302535920011241, "Here kitty kitty kitty"),
			"display_icon", CurrentModPath .. "UI/IdiotMonument.png",
			"build_category", "ChoGGi",
			"Group", "ChoGGi",
			"dome_forbidden", true,
			"encyclopedia_exclude", true,
			"on_off_button", false,
		})
	end

	local xt = XTemplates
	local template = xt.ipColonist[1]

	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(template, "ChoGGi_Template_ColonistSucker", true)

	-- we want to insert above warning
	local warning = table.find(template, "__template", "sectionWarning")
	if warning then
		warning = warning
	else
		-- screw it stick it at the end
		warning = #template
	end

	table.insert(
		template,
		warning,
		PlaceObj('XTemplateTemplate', {
			"ChoGGi_Template_ColonistSucker", true,
			"Id", "ChoGGi_ColonistSucker",
			"__template", "InfopanelActiveSection",
			"__condition", function()
				return not mod_HideButton
			end,
			"Icon", "UI/Icons/traits_disapprove.tga",
			"Title", T(302535920011244, "Remove Colonist"),
			"RolloverTitle", T(302535920011244, "Remove Colonist"),
			"RolloverText", T(302535920011245, "Thumbs down means colonist will get sucked up and deported to Earth."),
			"RolloverHint", T(302535920011246, "<left_click> Toggle"),
			"OnContextUpdate", function(self, context)
				---
				if context.ChoGGi_MurderPod then
					self:SetIcon("UI/Icons/traits_disapprove.tga")
					self:SetTitle(T(302535920011596, "Removing Colonist!"))
					self:SetRolloverTitle(T(302535920011596, "Removing Colonist!"))
				else
					self:SetIcon("UI/Icons/traits_approve.tga")
					self:SetTitle(T(302535920011244, "Remove Colonist"))
					self:SetRolloverTitle(T(302535920011244, "Remove Colonist"))
				end
				---
			end,
		}, {
			PlaceObj("XTemplateFunc", {
				"name", "OnActivate(self, context)",
				"parent", function(self)
					return self.parent
				end,
				"func", function(self, context)
					---
					if context.ChoGGi_MurderPod then
						-- tell pod to piss off
						context:ChoGGi_MP_RemovePod()
					elseif not mod_SkipTourists or mod_SkipTourists and not context.traits.Tourist then
						-- send down a pod
						context:ChoGGi_MP_LaunchPod()
					end
					ObjModified(context)
					---
				end,
			}),
		})
	)

	template = xt.ipShuttle[1]
	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(template, "ChoGGi_Template_ColonistSucker", true)

	-- we want to insert above warning
	warning = table.find(template, "__template", "sectionCheats")
	if warning then
		warning = warning - 1
	else
		-- screw it stick it at the end
		warning = #template
	end

	table.insert(
		template,
		warning,
		PlaceObj('XTemplateTemplate', {
			"ChoGGi_Template_ColonistSucker", true,
			"__template", "InfopanelActiveSection",
			"__context_of_kind", "MurderPod",
			"__condition", function(_, context)
				return not mod_HideButton and IsValid(context.target)
			end,
			"Icon", "UI/Icons/Sections/colonist.tga",
			"Title", T(302535920011247, "Select Colonist"),
			"RolloverTitle", T(302535920011247, "Select Colonist"),
			"RolloverText", T{302535920011248, "Select <name>.",
				name = function(self)
					return RetName(self[1].target)
			end},
			"RolloverHint", T(302535920011249, "<left_click> Select"),
		}, {
			PlaceObj("XTemplateFunc", {
				"name", "OnActivate(self, context)",
				"parent", function(self)
					return self.parent
				end,
				"func", function(_, context)
					---
					ViewAndSelectObject(context.target)
					---
				end,
			}),
		})
	)

end

--~ GlobalVar("g_ChoGGi_RemoveUnwantedColonists_StuckPassageFix", false)
--~ GlobalVar("g_ChoGGi_RemoveUnwantedColonists_StuckAirColonist", false)

--~ -- remove any invalid colonists from passages (fix for mod < v0.5)
--~ function OnMsg.LoadGame()
--~ 	-- so it only loops once per game
--~ 	if not g_ChoGGi_RemoveUnwantedColonists_StuckPassageFix then
--~ 		local remove = table.remove

--~ 		local objs = UICity.labels.Passage or ""
--~ 		for i = 1, #objs do
--~ 			local traversing = objs[i].traversing_colonists or ""
--~ 			for j = #traversing, 1, -1 do
--~ 				if not IsValid(traversing[j]) then
--~ 					remove(traversing, j)
--~ 				end
--~ 			end
--~ 		end

--~ 		g_ChoGGi_RemoveUnwantedColonists_StuckPassageFix = true

--~ 	end

--~ 	if not g_ChoGGi_RemoveUnwantedColonists_StuckAirColonist then
--~ 		local objs = UICity.labels.Colonist or ""
--~ 		for i = 1, #objs do
--~ 			local obj = objs[i]
--~ 			if obj.ChoGGi_MurderPod and not IsValid(obj.ChoGGi_MurderPod) then
--~ 				obj:Erase()
--~ 			end
--~ 		end
--~ 		g_ChoGGi_RemoveUnwantedColonists_StuckAirColonist = true
--~ 	end

--~ end

DefineClass.MurderPod = {
	__parents = {
		"CommandObject",
		"FlyingObject",
		"InfopanelObj",
		"CameraFollowObject",
		"PinnableObject",
		"SkinChangeable",
	},
	palette = {
		"outside_accent_1",
		"outside_base",
		"outside_dark",
		"outside_base",
	},
	-- victim
	target = false,
	arrival_height = 1000 * guim,
	leave_height = 1000 * guim,
	hover_height = 30 * guim,
	hover_height_orig = 30 * guim,
	arrival_time = 10000,
	min_pos_radius = 250 * guim,
	max_pos_radius = 750 * guim,
	pre_leave_offset = 1000,

	fx_actor_base_class = "FXRocket",
	fx_actor_class = "SupplyPod",
	-- add a moving around sound
	fx_move_sound = false,

	entity = "SupplyPod",
	display_icon = "UI/Icons/Buildings/supply_pod.tga",

	panel_icon = "",
	panel_text = T(302535920011242, "Waiting for victim"),
	ip_template = "ipShuttle",

	thrust_max = 3000,
	accel_dist = 30*guim,
	decel_dist = 60*guim,
	collision_radius = 50*guim,
}

function MurderPod:GameInit()
	if self.city ~= UICity then
		self.city = UICity
	end

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
	local current_pos = self:GetPos() or GetRandomPassable()

	local goto_pos = GetRandomPassableAround(
		current_pos,
		self.max_pos_radius,
		self.min_pos_radius
	)
	leave_height = (GetGameMap(self).terrain:GetHeight(current_pos) + leave_height) * 2
	self.hover_height = leave_height / 4

	self.fx_actor_class = "SupplyRocket"
	self:PlayFX("RocketEngine", "end")

	if not mod_LessTakeoffDust then
		self:PlayFX("RocketLaunch", "start")
	end

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

function MurderPod:GetVictimPos()
	local victim = self.target
	-- otherwise float around the victim walking around the dome/whatever building they're in, or if somethings borked then a rand pos
	local pos = victim:GetVisualPos()
	if victim:IsValidPos() and pos ~= InvalidPos then
--~ 		pos = victim:GetVisualPos()
	elseif IsValid(victim.holder) and victim.holder:IsValidPos() then
		pos = victim.holder:GetVisualPos()
	else
		pos = GetRandomPassable()
	end
	return pos or GetRandomPassable()
end

function MurderPod:Abduct()
	local victim = self.target

	-- stalk if in dome/building/passage
	local inside = not victim.outside_start
	if inside and not GetOpenAirBuildings(ActiveMapID) and not mod_IgnoreDomes then
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
	-- no need to keep colonist around now (func from storybits, used to remove colonist without affecting any stats)
	victim:Erase()
	-- change selection panel icon
	self.panel_text = T(302535920011243, [[Victim going to "Earth"]])

	-- human shaped meteors (bonus meteors, since murder is bad)
	for _ = 1, Random(1, 3) do
		CreateGameTimeThread(LaunchHumanMeteor, entity)
	end

	-- What did Mission Control ever do for us? Without it, where would we be? Free! Free to roam the universe!
	if IsValid(self) then
		self:SetCommand("Leave")
	end
end

function MurderPod:FlyingSound()
	-- It only lasts for so long, and it doesn't want to play right away
	local snd = self.fx_move_sound
	if not snd or snd and not IsSoundPlaying(snd) then
		self.fx_move_sound = PlaySound("Unit Rocket Fly", "ObjectMineLoop", nil, 0, true, self, 50)
		-- PlaySound(sound, _type, volume, fade_time, looping, point_or_object, loud_distance)
	end
end

function MurderPod:StalkerTime()
	while IsValid(self.target) do
		local victim = self.target

		self:FlyingSound()

		-- outside_start is a count of oxygen left, false if out of spacesuit
		local outside = victim.outside_start
		if mod_IgnoreDomes or outside or (not outside and GetOpenAirBuildings(ActiveMapID)) then
			-- just in case, probably where the new crash is coming from?
			if self:GetVictimPos() ~= InvalidPos then
				self:SetCommand("Abduct")
				break
			end
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

		self:FlyingSound()
		Sleep(Random(2500, 10000))
		self:FlyingSound()
	end

--~ 	StopSound(self.fx_move_sound)

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

-- crash fix for lastest update (probably, guessing it was tracking people out of bounds)
function OnMsg.LoadGame()
	local objs = MapGet("map", "MurderPod")
	for i = 1, #objs do
		local obj = objs[i]
		-- actually 33325, but it'll do
		if obj:GetPos():z() > 30000 then
			DoneObject(obj)
		end
	end
end
