local table = table

local EncodeNumbersToString = EncodeNumbersToString
local GetEntityBuildShape = GetEntityBuildShape
local HexAngleToDirection = HexAngleToDirection
local HexRotate = HexRotate
local HexToWorld = HexToWorld
local point = point
local WorldToHex = WorldToHex

-- simple entity object for hexgrids
DefineClass.ChoGGi_HexSpot = {
  __parents = {"CObject"},
  entity = "GridTile"
}

-- stores domes with pos of each spot we check
local table_domes = {}

-- add dome spots to table_domes
local function BuildDomeSpots(dome)
  -- skip if we already added it
  if not table_domes[dome.handle] then
    local spots = {}

    -- interior shape of dome without roads
    local shape = GetEntityBuildShape(dome.entity)
    -- needed if dome isn't placed in default angle
		local rotation = HexAngleToDirection(dome:GetAngle())
    -- applies the offset of dome shape to the world hex location
    for i = 1, #shape do
      local q1, r1 = WorldToHex(dome)
      local q2, r2 = HexRotate(shape[i]:x(), shape[i]:y(), rotation)
      spots[#spots+1] = point(HexToWorld(q1 + q2, r1 + r2)):SetTerrainZ()
    end

    -- we only want to add placed domes to the stored domes list
    if dome.name then
      table_domes[dome.handle] = spots
    end

    return spots
  end
end

-- add any existing domes to table_domes
local function BuildExistingDomeSpots()
  local domes = UICity.labels.Dome or empty_table
  for i = 1, #domes do
    -- skip ruined domes
    if domes[i].air then
      BuildDomeSpots(domes[i])
    end
  end
end
function OnMsg.LoadGame()
  BuildExistingDomeSpots()
end
-- I doubt any domes are on a new game (maybe a tutorial level?)
function OnMsg.CityStart()
  BuildExistingDomeSpots()
end

local white = EncodeNumbersToString({-1})
-- no sense in checking domes too far away
local too_far_away = 50000
local g_Classes = g_Classes
local CursorBuilding = CursorBuilding
local ConstructionController = ConstructionController
local dome_lines = {}
-- how long passages can be
local max_hex = GridConstructionController.max_hex_distance_to_allow_build - 3 -- removed 3 for the angles they need
local max_dist = max_hex * 10 * guim

-- stripped down version of Vector:Set (without the arrow)
local line_table = {}
function Polyline:Set(a, b)
	self:SetPos(a)
	-- faster to clear a table then make a new one
	table.iclear(line_table)
	line_table[1] = a
	line_table[2] = b
	self:SetPoints(line_table)
end

-- sort the dome spots by the nearest to the "pos"
local function RetNearestSpot(dome,pos)
	local pos_spots
	-- if it's in the table then it's a placed dome
	if table_domes[dome.handle] then
		pos_spots = table_domes[dome.handle]
	else
		-- else it's the cursor building (need to build spot pos each time since it's on the move)
		pos_spots = BuildDomeSpots(dome)
	end
	-- sort by nearest
	table.sort(pos_spots,
		function(a,b)
			return a:Dist2D(pos) < b:Dist2D(pos)
		end
	)
	-- and done
	return pos_spots[1]
end

local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding:GameInit()
	if self.template:IsKindOf("Dome") then
		-- loop through all domes and attach a line
		local domes = UICity.labels.Dome
		for i = 1, #domes do
			-- skip ruined domes
			if domes[i].air then
				-- make sure any new domes are added to the table
				BuildDomeSpots(domes[i])
				-- store dome/objects for the dome
				dome_lines[i] = {
					line = g_Classes.Polyline:new(),
					hex1 = g_Classes.ChoGGi_HexSpot:new(),
					hex2 = g_Classes.ChoGGi_HexSpot:new(),
					dome = domes[i]
				}
				-- not my magic numbers
				dome_lines[i].line:SetCustomDataString(1, 11, white)
			end
		end
	end

	-- orig func
	return orig_CursorBuilding_GameInit(self)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding:Done()
	if #dome_lines > 0 then
		-- cursor is gone, so we're done construction
		for i = 1, #dome_lines do
			-- this deletes the line object, leaves the table as is
			dome_lines[i].line:delete()
			dome_lines[i].hex1:delete()
			dome_lines[i].hex2:delete()
		end
		-- clear out table
		table.iclear(dome_lines)
	end
	-- orig func
	return orig_CursorBuilding_Done(self)
end

local orig_ConstructionController_UpdateCursor = ConstructionController.UpdateCursor
function ConstructionController:UpdateCursor(pos, force)
	-- only do this if the cursor building is a dome
	if #dome_lines > 0 then
		-- loop through domes and show any lines that are close enough
		for i = 1, #dome_lines do
			local d_pos = dome_lines[i].dome:GetVisualPos()
			local dl = dome_lines[i]
			-- any domes too far away, just make the line invis
			if pos:Dist2D(d_pos) > too_far_away then
				dl.line:SetVisible()
			else
				-- get nearest hex from placed dome to cursor
				local placed_dome_spot = RetNearestSpot(dl.dome,self.cursor_obj:GetVisualPos()) or point(0,0)
				-- get nearest hex from cursor dome to placed dome
				local cursor_dome_spot = RetNearestSpot(self.cursor_obj,d_pos) or point(0,0)
				-- show line if it's close enough
				if placed_dome_spot:Dist2D(cursor_dome_spot) > max_dist then
					-- hide it, or we'll have a line pointing at where the dome used to be (till it's too far away)
					dl.line:SetVisible()
					dl.hex1:SetVisible()
					dl.hex2:SetVisible()
				else
					dl.line:Set(cursor_dome_spot,placed_dome_spot)
					dl.line:SetVisible(true)
					dl.hex1:SetPos(cursor_dome_spot)
					dl.hex1:SetVisible(true)
					dl.hex2:SetPos(placed_dome_spot)
					dl.hex2:SetVisible(true)
				end
			end
		end
	end
	-- orig func
	return orig_ConstructionController_UpdateCursor(self, pos, force)
end

function OnMsg.Demolished(building)
  -- remove demo'ed domes from the list
  if table_domes[building.handle] then
    table_domes[building.handle] = nil
  end
end
