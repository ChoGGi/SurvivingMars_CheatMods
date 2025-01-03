-- See LICENSE for terms

if not g_AvailableDlc.armstrong then
	print(CurrentModDef.title, ": Green Planet DLC not installed! Abort!")
	return
end
if not g_AvailableDlc.shepard then
	print(CurrentModDef.title, ": Project Laika DLC not installed! Abort!")
	return
end

-- Almost a complete copy pasta of my Alien Visitors mod...
-- The roaming part at least, this adds the other models/limits to when to spawn

local can_graze = {
	Deer = true,
	Goose = true,
	Lama_Ambient = true,
	Ostrich = true,
	Pig = true,
	Pony_01 = true,
	Pony_02 = true,
	Pony_03 = true,
	Rabbit_01 = true,
	Rabbit_02 = true,
	Turkey = true,
}

local animals = {
	{"Chicken", T(299174615385--[[Chicken]])},
	Chicken = {"Chicken", T(299174615385--[[Chicken]])},
	--
	{"Deer", T(409677371105--[[Deer]])},
	Deer = {"Deer", T(409677371105--[[Deer]])},
	--
	{"Goose", T(319767019420--[[Goose]])},
	Goose = {"Goose", T(319767019420--[[Goose]])},
	--
	{"Lama_Ambient", T(808881013020--[[Llama]])},
	Lama_Ambient = {"Lama_Ambient", T(808881013020--[[Llama]])},
	--
	{"Ostrich", T(929526939780--[[Ostrich]])},
	Ostrich = {"Ostrich", T(929526939780--[[Ostrich]])},
	--
	{"Pig", T(221418710774--[[Pig]])},
	Pig = {"Pig", T(221418710774--[[Pig]])},
	--
	{"Pony_01", T(176071455701--[[Pony]])},
	Pony_01 = {"Pony_01", T(176071455701--[[Pony]])},
	{"Pony_02", T(176071455701--[[Pony]])},
	Pony_02 = {"Pony_02", T(176071455701--[[Pony]])},
	{"Pony_03", T(176071455701--[[Pony]])},
	Pony_03 = {"Pony_03", T(176071455701--[[Pony]])},
	--
	{"Rabbit_01", T(520473377733--[[Rabbit]])},
	Rabbit_01 = {"Rabbit_01", T(520473377733--[[Rabbit]])},
	{"Rabbit_02", T(520473377733--[[Rabbit]])},
	Rabbit_02 = {"Rabbit_02", T(520473377733--[[Rabbit]])},
	--
	{"Turkey", T(977344055059--[[Turkey]])},
	Turkey = {"Turkey", T(977344055059--[[Turkey]])},
	--
	{"Tortoise", T(768070368933--[[Tortoise]])},
	Tortoise = {"Tortoise", T(768070368933--[[Tortoise]])},
	--
	{"Platypus", T(210528297343--[[Platypus]])},
	Platypus = {"Platypus", T(210528297343--[[Platypus]])},
	--
	{"Penguin_01", T(397432391921--[[Penguin]])},
	Penguin_01 = {"Penguin_01", T(397432391921--[[Penguin]])},
	{"Penguin_02", T(397432391921--[[Penguin]])},
	Penguin_02 = {"Penguin_02", T(397432391921--[[Penguin]])},
	{"Penguin_03", T(397432391921--[[Penguin]])},
	Penguin_03 = {"Penguin_03", T(397432391921--[[Penguin]])},
}
local temp_animals = {}

local table = table
local point = point
local GetObjectHexGrid = GetObjectHexGrid
local GetDomeAtPoint = GetDomeAtPoint
local GetRandomPassableAround = GetRandomPassableAround
local DomeCollisionCheck = DomeCollisionCheck
local WorldToHex = WorldToHex
local GetBuildableZ = GetBuildableZ
local AsyncRand = AsyncRand
local RotateRadius = RotateRadius

local InvalidPos = ChoGGi.Consts.InvalidPos

local SetPosRandomBuildablePos = ChoGGi_Funcs.Common.SetPosRandomBuildablePos

--~ local mod_options = {}
--~ for i = 1, #animals do
--~ 	mod_options[animals[i][1]] = false
--~ end

local mod_EnableMod
local mod_MaxSpawn
local mod_RandomGrazeTime
local mod_RandomIdleTime

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions

	-- build list of enabled animals for table.rand below
	temp_animals = {}
	local c = 0
	for i = 1, #animals do
		local animal = animals[i]
		local id = animal[1]
		if options:GetProperty(id) then
			c = c + 1
			temp_animals[c] = animal
		end
	end

	mod_EnableMod = options:GetProperty("EnableMod")
	mod_MaxSpawn = options:GetProperty("MaxSpawn")
	mod_RandomGrazeTime = options:GetProperty("RandomGrazeTime") * 1000
	mod_RandomIdleTime = options:GetProperty("RandomIdleTime") * 1000
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

DefineClass.ChoGGi_RoamingAnimal = {
	__parents = { "Unit", "Shapeshifter", "InfopanelObj", "PinnableObject"},
	-- slightly slower than colonists (wonder why Child doesn't move slower an Adult or vice vs)
	move_speed = 800,
	radius = 30*guic,
	collision_radius = 30*guic,
	display_name = "",
	-- If no entity then it won't walk even with ChangeEntity later on
	entity = "GreenMan",

	ip_template = "ipChoGGi_RoamingAnimal",
	-- how far around the next target will be
	roam_target_radius = 500*guim,
	spawn_pos = false,

	-- don't hang out with same animal type too often
	nearby_hangout_count = 0,

	pin_rollover = T(51, "<ui_command>"),
	-- "generic" icon to use in pins dialog
	display_icon = "UI/Icons/Buildings/boomerang_garden.tga",
}

-- pin info
function ChoGGi_RoamingAnimal:Getui_command()
	return self.command .. "<newline><left>"
end

-- Remove directional arrow
ChoGGi_RoamingAnimal.CreateSelectionArrow = empty_func

function ChoGGi_RoamingAnimal:GetDisplayName()
	return self.display_name or self:GetEntity()
end
function ChoGGi_RoamingAnimal:GetIPDescription()
	return T(0000, "An animal doing animal things")
end

function ChoGGi_RoamingAnimal:KillThreads()
	-- I'm sure there's a better way to get rid of the persist errors...
	CreateRealTimeThread(function()
		DeleteThread(self.command_thread, true)
		Sleep(250)
		self:SetCommand("Idle")
	end)
end

local UnbuildableZ = buildUnbuildableZ()
local terrain
local function IsPlayablePoint(pt)
	if not terrain then
		terrain = GameMaps[MainMapID].terrain
	end
	return pt:InBox2D(MainCity.MapArea) and GetBuildableZ(WorldToHex(pt:xy())) ~= UnbuildableZ and terrain:IsPassable(pt)
end

-- Build list of all names in HumanNames
local names = {}
local iappend = table.iappend
local HumanNames = HumanNames
for _, nation in pairs(HumanNames) do
	for _, name_list in pairs(nation) do
		iappend(names, name_list)
	end
end

function ChoGGi_RoamingAnimal:Init()
	local city = self.city or MainCity
	self.city = city

	city:AddToLabel("ChoGGi_RoamingAnimal", self)

	local animal = table.rand(temp_animals)
	self:ChangeEntity(animal[1])

	-- Pick a name for animal
--~ 	self.display_name = animal[2]
	self.display_name = table.rand(names)

	self:Spawn()
	self:SetPos(self.spawn_pos)
end

function ChoGGi_RoamingAnimal:Done()
	self.city:RemoveFromLabel("ChoGGi_RoamingAnimal", self)
end

function ChoGGi_RoamingAnimal:Spawn()
	-- pick a random buildable spot within the playable area
	local city = self.city or MainCity
	local spawn_pos = self.spawn_pos
	local sectors = MainCity.MapSectors

	-- pick position
	while not spawn_pos do
		local sector_x = city:Random(1, 10)
		local sector_y = city:Random(1, 10)
		local sector = sectors[sector_x][sector_y]

		--local maxx, maxy = sector.area:
		local minx, miny = sector.area:minxyz()
		local maxx, maxy = sector.area:maxxyz()

		local x = city:Random(minx, maxx)
		local y = city:Random(miny, maxy)
		local pt = point(x, y)

		if IsPlayablePoint(pt) and not GetDomeAtPoint(GetObjectHexGrid(city), pt) then
			pt = pt:SetStepZ()
			if not DomeCollisionCheck(city, pt, pt) then
				spawn_pos = pt
				break
			end
		end
	end
	self.spawn_pos = spawn_pos
end

function ChoGGi_RoamingAnimal:Idle()
	self:SetCommand("Roam")
end

local realm

function ChoGGi_RoamingAnimal:FindAnimal(pos)
	-- close by animal of the same type
	local nearby_objs = realm:MapGet(pos, self.roam_target_radius / 2, "ChoGGi_RoamingAnimal", function(obj)
		return self.display_name == obj.display_name
	end)
	-- close by animals
	if #nearby_objs == 0 then
		nearby_objs = realm:MapGet(pos, self.roam_target_radius / 2, "ChoGGi_RoamingAnimal")
	end

	return nearby_objs
end

function ChoGGi_RoamingAnimal:FindTree(pos)
	local nearby_objs = realm:MapGet(pos, self.roam_target_radius, "VegetationTree")

	-- any tree
	if #nearby_objs == 0 then
		nearby_objs = realm:MapGet("map", "VegetationTree")
	end
	-- rand pos
	if #nearby_objs == 0 then
		return false
	end

	return nearby_objs
end

local m36060 = 360*60
function ChoGGi_RoamingAnimal:RoamTick()
	-- Pick a random playable pos within roam_target_radius, but outside of a dome
	-- Or tree/animal nearby
	local city = self.city or MainCity
	local pos = self:GetPos()
	local roam_target

	if not realm then
		realm = GameMaps[MainMapID].realm
	end

	local nearby_objs = self:FindAnimal(pos)

	if #nearby_objs > 0 then
		self.nearby_hangout_count = self.nearby_hangout_count + 1
	end

	-- nearby trees
	if #nearby_objs == 0 then
		nearby_objs = self:FindTree(pos)
	end

	local rand = AsyncRand(10)
	if rand < 3 and self.nearby_hangout_count < 10 then
		self.nearby_hangout_count = self.nearby_hangout_count + 1

		-- basically just tort and peng can't
		if can_graze[self.entity] then
			self:SetState("graze")
		else
			self:SetState("idle")
		end
		Sleep(mod_RandomGrazeTime + self:Random(25000))
	elseif rand < 7 and self.nearby_hangout_count < 10 then
		self.nearby_hangout_count = self.nearby_hangout_count + 1

		self:SetState("idle")
		Sleep(mod_RandomIdleTime + self:Random(25000))
	else
		-- Reset count and use rand tree instead
		if self.nearby_hangout_count > 10 then
			self.nearby_hangout_count = 0
			nearby_objs = self:FindTree(pos)
		end

		-- Try 50 times then give up
		for _ = 1, 50 do

			local pt
			if nearby_objs then
				local obj = table.rand(nearby_objs)
				pt = GetRandomPassableAround(obj:GetPos(), 1000, 250, self.city)
			else
				local dist = city:Random(self.roam_target_radius)
				local angle = city:Random(m36060)
				pt = RotateRadius(dist, angle, pos)
			end

			if pt and IsPlayablePoint(pt) then
				local dome = GetDomeAtPoint(GetObjectHexGrid(city), pt)
				if dome then
					dome:LeadIn(self, dome:GetEntrances())
				else
					-- If we're in a dome and the pt is outside the dome
					if self.current_dome then
						self.current_dome:LeadOut(self, self.current_dome:GetEntrances())
					else
						roam_target = pt
						break
					end
				end
			end
		end

		if roam_target then
			self:Goto(roam_target)
		end
	end

	self:SetState("idle")
	Sleep(1000)
end

function ChoGGi_RoamingAnimal:Roam()
	while true do
		self:RoamTick()

		if not IsValid(self) then
			DoneObject(self)
			break
		end
	end
end

local function StartupCode()

	local objs = MainCity.labels.ChoGGi_RoamingAnimal or ""
	-- check for invalid pos and stick on surface
	for i = 1, #objs do
		local obj = objs[i]
		if obj:GetPos() == InvalidPos then
			SetPosRandomBuildablePos(obj)
		end
	end

end

function OnMsg.CityStart()
	CreateRealTimeThread(function()
		WaitMsg("MarsResume")
		StartupCode()
	end)
end

OnMsg.LoadGame = StartupCode

function OnMsg.NewDay()
	if not mod_EnableMod
		-- Only spawn when there's a bunch of (large) trees
		or promoted_trees_count < 100
		-- Too many animals
		or #(MainCity.labels.ChoGGi_RoamingAnimal or "") > mod_MaxSpawn
	then
		return
	end

	local ChoGGi_RoamingAnimal = ChoGGi_RoamingAnimal

	-- Spawn a max of 25 per Sol
	local count = AsyncRand(mod_MaxSpawn)
	if count > 25 then
		count = 25
	end
	local current = #(MainCity.labels.ChoGGi_RoamingAnimal or "")
	if count > mod_MaxSpawn then
		count = mod_MaxSpawn - current
	end
--~ 	printC(count)

	for _ = 1, count do
		local obj = ChoGGi_RoamingAnimal:new()
		-- Not really needed but eh
		SetPosRandomBuildablePos(obj)
	end

	-- testing
	if ChoGGi.testing then
		for _ = 1, 600 do
			local obj = ChoGGi_RoamingAnimal:new()
			ChoGGi_Funcs.Common.SetPosRandomBuildablePos(obj)
		end
	end
end

-- kill off the threads (spews c func persist errors in log)
function OnMsg.SaveGame()
	local arghs = MainCity.labels.ChoGGi_RoamingAnimal or ""
	for i = 1, #arghs do
		arghs[i]:SetCommand("KillThreads")
	end
end

function OnMsg.ClassesPostprocess()
	-- added to stuff spawned with object spawner
	if XTemplates.ipChoGGi_RoamingAnimal then
		XTemplates.ipChoGGi_RoamingAnimal:delete()
	end

	PlaceObj("XTemplate", {
		group = "Infopanel Sections",
		id = "ipChoGGi_RoamingAnimal",
		PlaceObj("XTemplateTemplate", {
			"__context_of_kind", "ChoGGi_RoamingAnimal",
			"__template", "Infopanel",
		}, {
			PlaceObj("XTemplateTemplate", {
				"__template", "sectionCheats",
			}),
		}),
	})
end
