-- See LICENSE for terms

local point = point
local GetObjectHexGrid = GetObjectHexGrid

local mod_MaxSpawn

-- fired when settings are changed/init
local function ModOptions()
	mod_MaxSpawn = CurrentModOptions:GetProperty("MaxSpawn")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local image_pin = CurrentModPath .. "UI/Alien_Pin.png"

local GetDomeAtPoint = GetDomeAtPoint
local DomeCollisionCheck = DomeCollisionCheck
local WorldToHex = WorldToHex
local GetBuildableZ = GetBuildableZ
local AsyncRand = AsyncRand

DefineClass.ChoGGi_Alien = {
--~ 	__parents = { "Unit", "CityObject", "PinnableObject", "Shapeshifter", "InfopanelObj", "CycleMember" },
	__parents = { "Unit", "PinnableObject", "Shapeshifter", "InfopanelObj"},
	entity = "GreenMan",
	-- slightly slower than colonists (wonder why Child doesn't move slower an Adult)
	move_speed = 800,
	radius = 30*guic,
	collision_radius = 30*guic,
	infopanel_icon = image_pin,
	display_icon = image_pin,
	display_name = "Alien",

	pin_rollover = T(7780, "<PinDescription>"),
	pin_progress_value = "",
	pin_progress_max = "",
	pin_on_start = false,
--~ 	pin_icon = image_pin,
--~ 	pin_specialization_icon = false,

	ip_template = "ipChoGGi_Alien",
	-- how far around the next target will be
	roam_target_radius = 500*guim,
	spawn_pos = false,
--~ 	-- magical alien POWAH
--~	 electricity = false,
--~ 	-- how close does it need to be for the POWAH
--~ 	electricity_radius = 100,

--~ 	electricity_production = 10000,
--~ 	nearby_building = false,
--~	 production_lifetime = 0,
}

function ChoGGi_Alien:GetDisplayName()
	return self.display_name or self:GetEntity()
end
function ChoGGi_Alien:PinDescription()
	return T(302535920011388, "Out for a stroll")
end
function ChoGGi_Alien:GetIPDescription()
	return T(302535920011389, "A bland visitor")
end

function ChoGGi_Alien:KillThreads()
	-- I'm sure there's a better way to get rid of the persist errors...
	CreateRealTimeThread(function()
		DeleteThread(self.command_thread, true)
		Sleep(250)
		self:SetCommand("Idle")
	end)
end

local UnbuildableZ = buildUnbuildableZ()
local function IsPlayablePoint(pt)
	return pt:InBox2D(UICity.MapArea) and GetBuildableZ(WorldToHex(pt:xy())) ~= UnbuildableZ and ActiveGameMap.terrain:IsPassable(pt)
end

local names_list = {"Family", "Female", "Male"}
function ChoGGi_Alien:Init()
	local city = self.city or UICity
	self.city = city

	city:AddToLabel("ChoGGi_Alien", self)

	-- get a mars name
	local cat = HumanNames.Mars[table.rand(names_list)]
	self.display_name = table.rand(cat)

	self:Spawn()
	self:SetPos(self.spawn_pos)
end
function ChoGGi_Alien:Done()
	self.city:RemoveFromLabel("ChoGGi_Alien", self)
	if IsValid(self) then
		self:delete()
	end
end

function ChoGGi_Alien:Spawn()
	-- pick a random buildable spot within the playable area
	local city = self.city or UICity
	local spawn_pos = self.spawn_pos
	local sectors = UICity.MapSectors

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
			if not DomeCollisionCheck(pt, pt) then
				spawn_pos = pt
				break
			end
		end
	end
	self.spawn_pos = spawn_pos
end

function ChoGGi_Alien:Idle()
	self:SetCommand("Roam")
end

local m36060 = 360*60
function ChoGGi_Alien:RoamTick()
	-- pick a random playable pos within roam_target_radius, but outside of a dome
	local city = self.city or UICity
	local pos = self:GetPos()
	local roam_target

	for _ = 1, 50 do
		local dist = city:Random(self.roam_target_radius)
		local angle = city:Random(m36060)

		local pt = RotateRadius(dist, angle, pos)
		if IsPlayablePoint(pt) then
			local dome = GetDomeAtPoint(GetObjectHexGrid(city), pt)
			if dome then
				dome:LeadIn(self, dome:GetEntrances())
			else
				-- If we're in a dome and the pt is outside the dome
				if self.current_dome and not dome then
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
--~ 		self.nearby_building = self:GetElecBldNearby()
--~ 		self:PowerNearbyBld()
	end
	Sleep(1000 + self:Random(1000))
end

--~ local gofUnderConstruction = const.gofUnderConstruction
--~ function ChoGGi_Alien:GetElecBldNearby(rad) --within charge range
--~ 	rad = rad or self.electricity_radius

--~ 	local lst = GetRealm(self):MapGet(self, "hex", rad + 1, "ElectricityConsumer", function(o) return o:GetGameFlags(gofUnderConstruction) == 0 end	)
--~ 	local c = FindNearestObject(lst, self)
--~ 	return c and HexAxialDistance(c, self) <= rad and c or false
--~ end

--~ function ChoGGi_Alien:PowerNearbyBld()
--~ 	if not IsValid(self.nearby_building) then
--~ 		return
--~ 	end
--~ print("PowerNearbyBld")

--~	 local old_grid = self.electricity and self.electricity.grid
--~	 local new_grid = self.nearby_building and self.nearby_building.electricity.grid
--~	 if old_grid == new_grid then
--~		 return
--~	 end

--~	 if not self.nearby_building and self.nearby_building then
--~		 PlayFX("Working", "start", self.panel_obj)
--~	 elseif self.nearby_building and not self.nearby_building then
--~		 PlayFX("Working", "end", self.panel_obj)
--~	 end

--~	 if old_grid then
--~		 old_grid:RemoveElement(self.electricity)
--~	 end
--~	 if not new_grid then
--~		 self.production_lifetime = self.production_lifetime + self.electricity.production_lifetime
--~		 self.electricity = false
--~	 else
--~		 if not self.electricity then
--~			 self.electricity = NewSupplyGridProducer(self)
--~			 self.electricity:SetProduction(self.electricity_production)
--~		 end
--~		 new_grid:AddElement(self.electricity)
--~	 end
--~	 if SelectedObj == self then
--~		 ReopenSelectionXInfopanel()
--~	 end
--~ 	ex(self.electricity)
--~ 	ex(self.nearby_building.electricity)
--~ end

function ChoGGi_Alien:Roam()
	while true do
		self:RoamTick()
		if not self:IsValid() then
			self:Done()
			break
		end
	end
end

local function StartupCode()
	-- we don't need that many
	if #(UICity.labels.ChoGGi_Alien or "") > 0 then
		return
	end

	local ChoGGi_Alien = ChoGGi_Alien

	-- spawn a min of 4
	local count = AsyncRand(mod_MaxSpawn)
	if count < 4 then
		count = 4
	end
	for _ = 1, count do
		ChoGGi_Alien:new()
	end

	-- testing
	if false then
		for _ = 1, 600 do
			ChoGGi_Alien:new()
		end
--~ local pt = c()
--~ alien:SetPos(pt:SetTerrainZ())
--~ ex(alien)
	end
end

function OnMsg.CityStart()
	CreateRealTimeThread(function()
		WaitMsg("MarsResume")
		StartupCode()
	end)
end

OnMsg.LoadGame = StartupCode

-- kill off the threads (spews c func persist errors in log)
function OnMsg.SaveGame()
	local arghs = UICity.labels.ChoGGi_Alien or ""
	for i = 1, #arghs do
		arghs[i]:SetCommand("KillThreads")
	end
end

function OnMsg.ClassesPostprocess()
	-- added to stuff spawned with object spawner
	if XTemplates.ipChoGGi_Alien then
		XTemplates.ipChoGGi_Alien:delete()
	end

	PlaceObj("XTemplate", {
		group = "Infopanel Sections",
		id = "ipChoGGi_Alien",
		PlaceObj("XTemplateTemplate", {
			"__context_of_kind", "ChoGGi_Alien",
			"__template", "Infopanel",
		}, {
			PlaceObj("XTemplateTemplate", {
				"__template", "sectionCheats",
			}),
		}),
	})
end
