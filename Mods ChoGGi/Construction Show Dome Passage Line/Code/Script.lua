-- See LICENSE for terms

local GetEntityBuildShape = GetEntityBuildShape
local HexAngleToDirection = HexAngleToDirection
local IsValid = IsValid
local AsyncRand = AsyncRand
local HexRotate = HexRotate
local HexToWorld = HexToWorld
local WorldToHex = WorldToHex
local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local point = point
local table = table
local pairs = pairs

local point20 = point20
local green = green
local white_str = EncodeNumbersToString({-1})
-- keep my hexes above dome ones (30 is from UpdateShapeHexes(obj))
local point31 = point(0,0,31)
-- how long passages can be
local max_hex = GridConstructionController.max_hex_distance_to_allow_build - 3 -- removed 3 for the angles passages (may) need
-- hex to hex
local max_dist = max_hex * 10 * guim
-- no sense in checking domes too far away
local too_far_away = 50000
-- stores list of domes, markers, and dome points
local dome_list = {}

-- simple entity object for hexgrids
DefineClass.ChoGGi_HexSpot = {
  __parents = {"CObject"},
  entity = "GridTile"
}

-- I perfer to add a new object then editing existing ones (easier for mass delete as well)
DefineClass.ChoGGi_Polyline2 = {
  __parents = {"Polyline"},
	max_vertices = 2,
}
-- stripped down version of Vector:Set (without the arrow)
local line_table = {}
function ChoGGi_Polyline2:Set(a, b)
	self:SetPos(a)
	-- faster to clear a table then make a new one
	table.iclear(line_table)
	line_table[1] = a
	line_table[2] = b
	self:SetPoints(line_table)
end

-- if these are here when a save is loaded without this mod then it'll spam the console
function OnMsg.SaveGame()
	SuspendPassEdits("DeleteChoGGiDomeLines")
	MapDelete(true, "ChoGGi_HexSpot","ChoGGi_Polyline2")
	ResumePassEdits("DeleteChoGGiDomeLines")
	dome_list = {}
end

-- add dome spots to dome_list
local function BuildDomeSpots(dome)
	local spots = {}
	local c = 0

	-- interior shape of dome without roads (con sites need to use alternative_entity or it's the wrong entity)
	local shape = GetEntityBuildShape(dome.alternative_entity or dome.entity)
	-- needed if dome isn't placed in default angle
	local rotation = HexAngleToDirection(dome:GetAngle())
	-- applies the offset of dome shape to the world hex location
	for i = 1, #shape do
		local q1, r1 = WorldToHex(dome)
		local q2, r2 = HexRotate(shape[i]:x(), shape[i]:y(), rotation)
		c = c + 1
		spots[c] = point(HexToWorld(q1 + q2, r1 + r2)):SetTerrainZ()
	end

	-- we only want to add placed domes to the stored domes list
	if dome.name then
		dome_list[dome].spots = spots
	end

	return spots
end

local function BuildMarkers(dome)
	-- no need to re-add domes to the list
	if not dome_list[dome] then
		dome_list[dome] = {
			line = ChoGGi_Polyline2:new(),
			hex1 = ChoGGi_HexSpot:new(),
			hex2 = ChoGGi_HexSpot:new(),
		}
		BuildDomeSpots(dome)
		dome_list[dome].hex1:SetColorModifier(green)
		dome_list[dome].hex2:SetColorModifier(green)
		-- not my magic numbers
		dome_list[dome].line:SetCustomDataString(1, 11, white_str)
	end
end

-- add any existing domes to dome_list
local function BuildExistingDomeSpots()
  local domes = UICity.labels.Domes or ""
  for i = 1, #domes do
		BuildMarkers(domes[i])
  end
end
function OnMsg.LoadGame()
  BuildExistingDomeSpots()
end
-- I doubt any domes are on a new game (maybe a tutorial level?)
function OnMsg.CityStart()
  BuildExistingDomeSpots()
end

-- sort the dome spots by the nearest to the "pos"
local function RetNearestSpot(dome,pos)
	local pos_spots

	-- if it's in the table then it's a placed dome
	if dome_list[dome] and dome_list[dome].spots then
		pos_spots = dome_list[dome].spots
	else
		-- else it's the cursor building (need to build spot pos each time since it's on the move)
		pos_spots = BuildDomeSpots(dome)
	end

	-- sort by nearest
	table.sort(pos_spots,function(a,b)
		return a:Dist2D(pos) < b:Dist2D(pos)
	end)
	-- and done
	return pos_spots[1]
end

local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding:GameInit(...)
--~ ex(dome_list)
	if self.template:IsKindOf("Dome") then
		-- loop through all domes and attach a line
		local domes = UICity.labels.Domes or ""
		for i = 1, #domes do
			BuildMarkers(domes[i])
		end
	end

	-- orig func
	return orig_CursorBuilding_GameInit(self,...)
end

-- remove removed domes from dome_list
local function ListCleanup(dome,item)
	item.line:delete()
	item.hex1:delete()
	item.hex2:delete()
	dome_list[dome] = nil
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding:Done(...)
	-- we're done construction hide all the markers
	SuspendPassEdits("ChoGGi_CleanupOldMarkers")
	for dome,item in pairs(dome_list) do
		if IsValid(dome) then
			item.line:SetVisible()
			item.hex1:SetVisible()
			item.hex2:SetVisible()
		else
			ListCleanup(dome,item)
		end
	end
	ResumePassEdits("ChoGGi_CleanupOldMarkers")
	return orig_CursorBuilding_Done(self,...)
end

local function UpdateMarkers(self,pos)
	pos = pos or self.cursor_obj:GetVisualPos()
	-- loop through domes and show any lines that are close enough
	for dome,item in pairs(dome_list) do
		if IsValid(dome) then
			local d_pos = dome:GetVisualPos()
			-- any domes too far away, just hide markers instead of checking for hex closeness
			if pos:Dist2D(d_pos) > too_far_away then
				item.line:SetVisible()
				item.hex1:SetVisible()
				item.hex2:SetVisible()
			else
				-- get nearest hex from placed dome to cursor
				local placed_dome_spot = RetNearestSpot(dome,pos) or point20
				-- get nearest hex from cursor dome to placed dome
				local cursor_dome_spot = RetNearestSpot(self.cursor_obj,d_pos) or point20
				-- show line if it's close enough
				if placed_dome_spot:Dist2D(cursor_dome_spot) > max_dist then
					-- hide it, or we'll have a line pointing at where the dome used to be (till it's too far away)
					item.line:SetVisible()
					item.hex1:SetVisible()
					item.hex2:SetVisible()
				else
					item.line:Set(cursor_dome_spot,placed_dome_spot)
					item.line:SetVisible(true)
					item.hex1:SetPos(cursor_dome_spot + point31)
					item.hex1:SetVisible(true)
					item.hex2:SetPos(placed_dome_spot + point31)
					item.hex2:SetVisible(true)
				end
			end
		else
			ListCleanup(dome,item)
		end
	end
end

local orig_ConstructionController_Rotate = ConstructionController.Rotate
function ConstructionController:Rotate(delta,...)
	-- it needs to fire first so we can get updated angle
	local ret = orig_ConstructionController_Rotate(self, delta,...)
	UpdateMarkers(self)
	return ret
end

local orig_ConstructionController_UpdateCursor = ConstructionController.UpdateCursor
function ConstructionController:UpdateCursor(pos, force,...)
	UpdateMarkers(self,pos)
	return orig_ConstructionController_UpdateCursor(self, pos, force,...)
end

-- they should get removed when the cursor building is removed, but just in case
function OnMsg.Demolished(dome)
  -- remove demo'ed domes from the list
  if dome_list[dome] then
		ListCleanup(dome,dome_list[dome])
  end
end
