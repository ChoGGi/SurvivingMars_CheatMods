-- See LICENSE for terms

if ChoGGi.what_game ~= "Mars" then
	return
end

local ChoGGi_Funcs = ChoGGi_Funcs
local table = table
local pairs, type = pairs, type
local Sleep = Sleep
local IsValid = IsValid
local DoneObject = DoneObject
local T = T
local Translate = ChoGGi_Funcs.Common.Translate
local MsgPopup = ChoGGi_Funcs.Common.MsgPopup
local DeleteObject = ChoGGi_Funcs.Common.DeleteObject
local ToggleWorking = ChoGGi_Funcs.Common.ToggleWorking
local SpawnColonist = ChoGGi_Funcs.Common.SpawnColonist
local FindNearestObject = FindNearestObject

local testing = ChoGGi.testing

function ChoGGi_Funcs.Menus.RemoveInvalidLabelObjects()
	local labels = UIColony.city_labels.labels
	for id, label in pairs(labels) do
		if id ~= "Consts" then
			for i = #label, 1, -1 do
				if not IsValid(label[i]) then
					table.remove(label, i)
				end
			end
		end
	end
	MsgPopup(
		T(302535920001691--[[All]]),
		T(302535920001533--[[Remove Invalid Label Objects]])
	)
end

function ChoGGi_Funcs.Menus.RocketCrashesGameOnLanding()
	local rockets = UIColony.city_labels.labels.SupplyRocket or ""
	for i = 1, #rockets do
		rockets[i]:ForEachAttach("ParSystem", function(a)
			if type(a.polyline) == "string" and a.polyline:find("\0") then
				DoneObject(a)
			end
		end)
	end
	MsgPopup(
		T(302535920001691--[[All]]),
		T(302535920001351--[[Rocket Crashes Game On Landing]])
	)
end

function ChoGGi_Funcs.Menus.ToggleWorkingAll()
	local skips = {"OrbitalProbe", "ResourceStockpile", "WasteRockStockpile", "BaseRover"}
	MapForEach("map", "BaseBuilding", function(o)
		if type(o.ToggleWorking) == "function" and not o:IsKindOfClasses(skips) then
			ToggleWorking(o)
		end
	end)

	MsgPopup(
		T(302535920001691--[[All]]),
		T(302535920001299--[[Toggle Working On All Buildings]])
	)
end

do -- DronesNotRepairingDome
	local looping_thread

	function ChoGGi_Funcs.Menus.DronesNotRepairingDomes()
		local Sleep = Sleep
		MsgPopup(
			T(83--[[Domes]]),
			T(302535920001295--[[Drones Not Repairing Domes]])
		)
		-- just in case someone decides to click it more than once...
		if looping_thread then
			DeleteThread(looping_thread)
			looping_thread = nil
		end
		-- loop 50 times, more than long enough for a drone smart/idle enough to grab the res outside the dome and repair it.
		looping_thread = CreateRealTimeThread(function()
			local count = 0
			while true do
				if count > 49 then
					break
				end
				count = count + 1

				local domes = UIColony:GetCityLabels("Domes")
				for i = 1, #domes do
					local dome = domes[i]
					-- get a list of all res in the center of dome
					local pos = dome:GetSpotPos(-1)
					local realm = GameMaps[ChoGGi_Funcs.Common.RetObjMapId(dome)].realm

					local objs = realm:MapGet(pos, 1000, "ResourcePile")
					-- loop through the spots till we find a Workdrone outside the dome (any spot outside will do)
					local id_start, id_end = dome:GetAllSpots(dome:GetState())
					for j = id_start, id_end do
						if dome:GetSpotName(j) == "Workdrone" then
							local spot_pos = dome:GetSpotPos(j)
							-- and goodbye res
							for k = 1, #objs do
								objs[k]:SetPos(spot_pos)
							end
							break
						end
					end
				end

				Sleep(1000)
			end
			MsgPopup(
				T(1157--[[Complete thread]]),
				T(302535920001295--[[Drones Not Repairing Domes]])
			)
		end)
	end
end -- do

local function ResetRover(rc)
	local drones
	if rc.attached_drones then
		drones = #rc.attached_drones
		for i = 1, #rc.attached_drones do
			DoneObject(rc.attached_drones[i])
		end
	end
	local pos = rc:GetVisualPos()
	local new = rc:Clone()
	DoneObject(rc)
	new:SetPos(GetRealm(new):GetPassablePointNearby(pos))
	-- add any missing drones
	if drones > #new.attached_drones then
		repeat
			new:SpawnDrone()
		until drones == #new.attached_drones
	end
end

function ChoGGi_Funcs.Menus.ResetCommanders()
	CreateRealTimeThread(function()
		local Sleep = Sleep
		local GetStateIdx = GetStateIdx
		local before_table = {}

		-- get all commanders stuck in deploy with at least one drone
		MapForEach("map", "RCRover", function(rc)
			local drones = #rc.attached_drones > 0
			if drones then
				if rc:GetState() == GetStateIdx("deployIdle") then
					-- store them in a table for later
					before_table[rc.handle] = {rc = rc, amount = #rc.attached_drones}
				-- borked, no sense in waiting for later
				elseif rc:GetState() == GetStateIdx("idle") and rc.waiting_on_drones then
					ResetRover(rc)
				end
			end
		end)
		-- let user know something is happening
		MsgPopup(
			T(5438--[[Rovers]]),
			T(302535920000464--[[Updating Rovers]])
		)
		--wait awhile just to be sure
		Sleep(5000)
		--go through and reset any rovers still doing the same thing
		for _, rc_table in pairs(before_table) do
			local state = rc_table.rc:GetState() == GetStateIdx("deployIdle")
			local drones = #rc_table.rc.attached_drones == rc_table.amount
			if state and drones then
				ResetRover(rc_table.rc)
			end
		end
	end)
end

function ChoGGi_Funcs.Menus.ResetAllColonists()
	local function CallBackFunc(answer)
		if answer then
			local objs = UIColony:GetCityLabels("Colonist")
			for i = 1, #objs do
				local c = objs[i]
				local city = Cities[ChoGGi_Funcs.Common.RetObjMapId(c)]
				local is_valid = IsValid(c)
				SpawnColonist(c, nil, is_valid and c:GetVisualPos(), city)
				if is_valid then
					DoneObject(c)
				end
			end
		end
	end

	ChoGGi_Funcs.Common.QuestionBox(
		T(6779--[[Warning]]) .. "!\n" .. T(302535920000055--[[Reset All Colonists]])
			.. "\n" .. T(302535920000939--[["Fix certain freezing issues (mouse still moves screen, keyboard doesn't), will lower comfort by about 20."]]),
		CallBackFunc,
		T(6779--[[Warning]]) .. ": " .. T(302535920000055--[[Reset All Colonists]])
	)
end

function ChoGGi_Funcs.Menus.ColonistsTryingToBoardRocketFreezesGame()
	local rockets = UIColony:GetCityLabels("SupplyRocket")
	local objs = UIColony:GetCityLabels("Colonist")
	for i = 1, #objs do
		local c = objs[i]
		local is_valid = IsValid(c)
		if is_valid and c:GetStateText() == "movePlanet" then
			local city = Cities[ChoGGi_Funcs.Common.RetObjMapId(c)]
			local rocket = FindNearestObject(rockets, c)
			SpawnColonist(c, rocket, c:GetVisualPos(), city)
			DeleteObject(c)
		end
	end

	MsgPopup(
		T(302535920001691--[[All]]),
		T(302535920000591--[[Colonists Trying To Board Rocket Freezes Game]])
	)
end

local function AttachedColonist(c, pos, rocket, city)
	-- try to remove attached colonist from rocket, and get pos so we can create a new c at the same pos
	if IsValid(c) then
		c:Detach()
		SpawnColonist(c, rocket, pos, city)
		DoneObject(c)
	else
		SpawnColonist(nil, nil, rocket, pos, city)
	end
end
function ChoGGi_Funcs.Menus.ColonistsStuckOutsideRocket()
	local InvalidPos = ChoGGi.Consts.InvalidPos
	local rockets = UIColony:GetCityLabels("SupplyRocket")
	for i = 1, #rockets do
		local rocket = rockets[i]
		-- SupplyRocket also returns rockets in space
		if rocket:GetPos() ~= InvalidPos then
			local city = Cities[ChoGGi_Funcs.Common.RetObjMapId(rocket)]
			local pos = GetRealm(rocket):GetPassablePointNearby(rocket:GetPos())
			rocket:ForEachAttach("Colonist", AttachedColonist, pos, rocket, city)
		end
	end
	MsgPopup(
		T(5238--[[Rockets]]),
		T(302535920000585--[[Colonists Stuck Outside Rocket]])
	)
end

function ChoGGi_Funcs.Menus.ParticlesWithNullPolylines()
	SuspendPassEdits("ChoGGi_Funcs.Menus.ParticlesWithNullPolylines")
	local objs = MapGet(true, "ParSystem", function(o)
		if type(o.polyline) == "string" and o.polyline:find("\0") then
			return true
		end
	end)
	for i = #objs, 1, -1 do
		DoneObject(objs[i])
	end
	ResumePassEdits("ChoGGi_Funcs.Menus.ParticlesWithNullPolylines")

	MsgPopup(
		T(302535920001691--[[All]]),
		T(302535920000593--[[Remove Particles With Null Polylines]])
	)
end

function ChoGGi_Funcs.Menus.RemoveMissingClassObjects()
	local function CallBackFunc(answer)
		if answer then
			SuspendPassEdits("ChoGGi_Funcs.Menus.RemoveMissingClassObjects")
			MapDelete(true, "UnpersistedMissingClass")
			ResumePassEdits("ChoGGi_Funcs.Menus.RemoveMissingClassObjects")
			MsgPopup(
				T(302535920001691--[[All]]),
				T(302535920000587--[[Remove Missing Class Objects]])
			)
		end
	end

	ChoGGi_Funcs.Common.QuestionBox(
 		T(6779--[[Warning]]) .. "!\n"
			.. T(302535920000588--[[May crash game, SAVE FIRST. These are probably from mods that were removed (if you're getting a PinDlg error then this should fix it).]]),
		CallBackFunc,
		T(6779--[[Warning]]) .. ": " .. T(302535920000587--[[Remove Missing Class Objects]])
	)
end

function ChoGGi_Funcs.Menus.MirrorSphereStuck()
	local objs = MainCity.labels.MirrorSpheres or ""
	for i = 1, #objs do
		local obj = objs[i]
		if not IsValid(obj.target) then
			DeleteObject(obj)
		end
	end

	SuspendPassEdits("ChoGGi_Funcs.Menus.MirrorSphereStuck")
	objs = GetRealmByID(MainMapID):MapGet(true, "ParSystem", function(o)
		if o:GetParticlesName() == "PowerDecoy_Captured" and
				type(o.polyline) == "string" and o.polyline:find("\0") then
			return true
		end
	end)
	for i = #objs, 1, -1 do
		DoneObject(objs[i])
	end

	ResumePassEdits("ChoGGi_Funcs.Menus.MirrorSphereStuck")

	MsgPopup(
		T(302535920001691--[[All]]),
		T(302535920000595--[[Mirror Sphere Stuck]])
	)
end

function ChoGGi_Funcs.Menus.StutterWithHighFPS()
	local CheckForBorkedTransportPath = ChoGGi_Funcs.Common.CheckForBorkedTransportPath
	local bad_objs = {}
	local objs = UIColony:GetCityLabels("Unit")
	for i = 1, #objs do
		CheckForBorkedTransportPath(objs[i], bad_objs)
	end
	if testing then
		ex(bad_objs)
	end

	ChoGGi_Funcs.Common.ResetHumanCentipedes()
	MsgPopup(
		T(302535920001691--[[All]]),
		T(302535920000597--[[Stutter With High FPS]])
	)
end

do -- DronesKeepTryingBlockedAreas
	local function ResetPriorityQueue(cls_name)
		local max = const.MaxBuildingPriority
		MapForEach("map", cls_name, function(o)
			-- clears out the queues
			o.priority_queue = {}
			for priority = -1, max do
				o.priority_queue[priority] = {}
			end
		end)
	end

	function ChoGGi_Funcs.Menus.DronesKeepTryingBlockedAreas()
		ResetPriorityQueue("SupplyRocket")
		ResetPriorityQueue("RCRover")
		ResetPriorityQueue("DroneHub")
		-- toggle working state on all ConstructionSite (wakes up drones else they'll wait at hub)
		MapForEach("map", "ConstructionSite", ToggleWorking)
		MsgPopup(
			T(302535920001691--[[All]]),
			T(302535920000599--[[Drones Keep Trying Blocked Areas]])
		)
	end
end -- do

function ChoGGi_Funcs.Menus.AlignAllBuildingsToHexGrid()
	local HexGetNearestCenter = HexGetNearestCenter
	MapForEach("map", "Building", function(o)
		o:SetPos(HexGetNearestCenter(o:GetVisualPos()))
	end)
	MsgPopup(
		T(302535920001691--[[All]]),
		T(302535920000621--[[Align All Buildings To Hex Grid]])
	)
end

do -- RemoveUnreachableConstructionSites
	local type, pairs = type, pairs
	local function RemoveUnreachable(cls_name, realm)
		realm:MapForEach("map", cls_name, function(o)
			local unreach = o.unreachable_buildings or empty_table
			for bld in pairs(unreach) do
				if type(bld.IsKindOf) == "function" and bld:IsKindOf("ConstructionSite") then
					bld:Cancel()
				end
			end
			o.unreachable_buildings = false
		end)
	end

	function ChoGGi_Funcs.Menus.RemoveUnreachableConstructionSites()
		local objs = MainCity.labels.Drone or ""
		for i = 1, #objs do
			objs[i]:CleanUnreachables()
		end
		local realm = GetRealmByID(MainMapID)
		RemoveUnreachable("DroneHub", realm)
		RemoveUnreachable("RCRover", realm)
		RemoveUnreachable("SupplyRocket", realm)

		MsgPopup(
			T(302535920000971--[[Sites]]),
			T(302535920000601--[[Idle Drones Won't Build When Resources Available]])
		)
	end
end -- do

function ChoGGi_Funcs.Menus.RemoveYellowGridMarks()
	SuspendPassEdits("ChoGGi_Funcs.Menus.RemoveYellowGridMarks")
	MapDelete(true, "GridTile")
	MapDelete(true, "GridTileWater")
	ResumePassEdits("ChoGGi_Funcs.Menus.RemoveYellowGridMarks")
	MsgPopup(
		T(302535920001691--[[All]]),
		T(302535920000603--[[Remove Yellow Grid Marks]])
	)
end

function ChoGGi_Funcs.Menus.RemoveBlueGridMarks()
	SuspendPassEdits("ChoGGi_Funcs.Menus.RemoveBlueGridMarks")
	local objs = MapGet(true, "RangeHexRadius", function(o)
		if not o.ToggleWorkZone then
			return true
		end
	end)
	for i = #objs, 1, -1 do
		DoneObject(objs[i])
	end
	-- remove the rover outlines added from https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-persistent-transport-route-blueprint-on-map.1121333/
	objs = MapGet(true, "WireFramedPrettification", function(o)
		if o:GetEntity() == "RoverTransport" then
			return true
		end
	end)
	for i = #objs, 1, -1 do
		DoneObject(objs[i])
	end

	ResumePassEdits("ChoGGi_Funcs.Menus.RemoveBlueGridMarks")

	MsgPopup(
		T(302535920001691--[[All]]),
		T(302535920001193--[[Remove Blue Grid Marks]])
	)
end

function ChoGGi_Funcs.Menus.ProjectMorpheusRadarFellDown()
	local objs = UIColony.city_labels.labels.ProjectMorpheus or ""
	for i = 1, #objs do
		objs[i]:ChangeWorkingStateAnim(false)
		objs[i]:ChangeWorkingStateAnim(true)
	end
	MsgPopup(
		T(302535920001691--[[All]]),
		T(302535920000605--[[Project Morpheus Radar Fell Down]])
	)
end

function ChoGGi_Funcs.Menus.RebuildWalkablePointsInDomes()
	MapForEach("map", "Dome", function(o)
		o.walkable_points = false
		o:GenerateWalkablePoints()
	end)
	MsgPopup(
		T(302535920001691--[[All]]),
		T(302535920000583--[[Rebuild Walkable Points In Domes]])
	)
end

function ChoGGi_Funcs.Menus.AttachBuildingsToNearestWorkingDome()
	local AttachToNearestDome = ChoGGi_Funcs.Common.AttachToNearestDome
	local objs = UIColony.city_labels.labels.InsideBuildings or ""
	for i = 1, #objs do
		AttachToNearestDome(objs[i])
	end

	MsgPopup(
		T(3980--[[Buildings]]),
		T(302535920000609--[[Attach Buildings To Nearest Working Dome]])
	)
end

function ChoGGi_Funcs.Menus.ColonistsFixBlackCube()
	local objs = UIColony.city_labels.labels.Colonist or ""
	for i = 1, #objs do
		local c = objs[i]
		if c:GetEntity():find("Child") and c.specialist ~= "none" then
			c.specialist = "none"

			c.traits.Youth = nil
			c.traits.Adult = nil
			c.traits["Middle Aged"] = nil
			c.traits.Senior = nil
			c.traits.Retiree = nil

			c.traits.Child = true
			c.age_trait = "Child"
			c.age = 0
			c:ChooseEntity()
			c:SetResidence(false)
			c:UpdateResidence()
		end
	end
	MsgPopup(
		T(302535920001691--[[All]]),
		T(302535920000619--[[Fix Black Cube Colonists]])
	)
end

do -- CablesAndPipesRepair
	local function RepairBorkedObjects(borked)
		local just_in_case = 0
		while #borked > 0 do

			for i = #borked, 1, -1 do
				local element = borked[i]
				if element.Repair and IsValid(element) then
					element:Repair()
				end
			end

			if just_in_case > 25000 then
				break
			end
			just_in_case = just_in_case + 1

		end
	end

	function ChoGGi_Funcs.Menus.CablesAndPipesRepair()
		local g_BrokenSupplyGridElements = g_BrokenSupplyGridElements
		RepairBorkedObjects(g_BrokenSupplyGridElements.electricity)
		RepairBorkedObjects(g_BrokenSupplyGridElements.water)

		MsgPopup(
			T(302535920001691--[[All]]),
			T(302535920000157--[[Cables & Pipes]]) .. ": " .. T(302535920000607--[[Instant Repair]])
		)
	end
end -- do

--~ function ChoGGi_Funcs.Menus.FireMostFixes()
--~ 	CreateRealTimeThread(function()
--~ 		local Menus = ChoGGi_Funcs.Menus

--~ 		pcall(Menus.RemoveUnreachableConstructionSites)
--~ 		pcall(Menus.ParticlesWithNullPolylines)
--~ 		pcall(Menus.StutterWithHighFPS)
--~ 		pcall(Menus.ColonistsTryingToBoardRocketFreezesGame)
--~ 		pcall(Menus.AttachBuildingsToNearestWorkingDome)
--~ 		pcall(Menus.DronesKeepTryingBlockedAreas)
--~ 		pcall(Menus.RemoveYellowGridMarks)
--~ 		pcall(Menus.RemoveBlueGridMarks)
--~ 		pcall(Menus.CablesAndPipesRepair)
--~ 		pcall(Menus.MirrorSphereStuck)
--~ 		pcall(Menus.ProjectMorpheusRadarFellDown)
--~ 		pcall(Menus.RemoveInvalidLabelObjects)

--~ 		-- loop through and remove all my msgs from the onscreen popups
--~ 		CreateRealTimeThread(function()
--~ 			local MsgPopups = ChoGGi.Temp.MsgPopups
--~ 			Sleep(500)
--~ 			while #MsgPopups < 10 do
--~ 				Sleep(100)
--~ 			end
--~ 			local popups = MsgPopups or ""
--~ 			for i = #popups, 1, -1 do
--~ 				popups[i]:delete()
--~ 			end
--~ 			table.iclear(MsgPopups)
--~ 		end)
--~ 	end)
--~ end

------------------------- toggles

function ChoGGi_Funcs.Menus.FixMissingModBuildings_Toggle()
	ChoGGi.UserSettings.FixMissingModBuildings = not ChoGGi.UserSettings.FixMissingModBuildings
	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.FixMissingModBuildings),
		T(302535920001483--[[Missing Mod Buildings]])
	)
end

-- broked ai mods... (fix your crap or take it down kthxbai)
function ChoGGi_Funcs.Menus.ColonistsStuckOutsideServiceBuildings_Toggle()
	if ChoGGi.UserSettings.ColonistsStuckOutsideServiceBuildings then
		ChoGGi.UserSettings.ColonistsStuckOutsideServiceBuildings = nil
	else
		ChoGGi.UserSettings.ColonistsStuckOutsideServiceBuildings = true
		ChoGGi_Funcs.Common.ResetHumanCentipedes()
	end

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.ColonistsStuckOutsideServiceBuildings),
		T(302535920000248--[[Colonists Stuck Outside Service Buildings]])
	)
end

function ChoGGi_Funcs.Menus.DroneResourceCarryAmountFix_Toggle()
	ChoGGi.UserSettings.DroneResourceCarryAmountFix = ChoGGi_Funcs.Common.ToggleValue(ChoGGi.UserSettings.DroneResourceCarryAmountFix)

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.DroneResourceCarryAmountFix),
		T(302535920000613--[[Drone Carry Amount]])
	)
end

function ChoGGi_Funcs.Menus.SortCommandCenterDist_Toggle()
	ChoGGi.UserSettings.SortCommandCenterDist = ChoGGi_Funcs.Common.ToggleValue(ChoGGi.UserSettings.SortCommandCenterDist)

	ChoGGi_Funcs.Settings.WriteSettings()
	MsgPopup(
		ChoGGi_Funcs.Common.SettingState(ChoGGi.UserSettings.SortCommandCenterDist),
		T(302535920000615--[[Sort Command Center Dist]])
	)
end

---------------------------------------------------Testers

--~ GetDupePositions(UIColony.city_labels.labels.Colonist or "")
--~ function ChoGGi_Funcs.Menus.GetDupePositions(list)
--~	 local dupes = {}
--~	 local positions = {}
--~	 local pos
--~	 for i = 1, #list do
--~		 pos = list[i]:GetPos()
--~		 pos = tostring(point(pos:x(), pos:y()))
--~		 if not positions[pos] then
--~			 positions[pos] = true
--~		 else
--~			 dupes[pos] = true
--~		 end
--~	 end
--~	 if dupes[1] then
--~		 table.sort(dupes)
--~		 ChoGGi_Funcs.Common.OpenInExamineDlg(dupes)
--~	 end
--~ end

--~ function ChoGGi_Funcs.Menus.DeathToObjects(cls)
--~ use MapDelete above
--~ 	end

--~ ChoGGi_Funcs.Menus.DeathToObjects("BaseRover")
--~ ChoGGi_Funcs.Menus.DeathToObjects("Colonist")
--~ ChoGGi_Funcs.Menus.DeathToObjects("CargoShuttle")
--~ ChoGGi_Funcs.Menus.DeathToObjects("Building")
--~ ChoGGi_Funcs.Menus.DeathToObjects("Drone")
--~ ChoGGi_Funcs.Menus.DeathToObjects("SupplyRocket")
--~ ChoGGi_Funcs.Menus.DeathToObjects("Unit") --rovers/drones/colonists

--~ --show all elec consumption
--~ local amount = 0
--~ MapForEach("map", nil, function(o)
--~ 	if o.class and o.electricity and o.electricity.consumption then
--~ 		local temp = o.electricity.consumption / 1000
--~ 		amount = amount + temp
--~ 		print(o.class, ": ", temp)
--~ 	end
--~ end)
--~ print(amount)
