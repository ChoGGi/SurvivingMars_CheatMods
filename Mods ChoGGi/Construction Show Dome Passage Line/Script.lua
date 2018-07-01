local GetSpotAnnotation = GetSpotAnnotation
local DoneObject = DoneObject
local PlaceObject = PlaceObject
local GetTerrainCursor = GetTerrainCursor
local table_sort = table.sort
local Dist2D = point(0,0,0).Dist2D

--stores domes with pos of each spot we check
local table_domes = {}

-- add dome spots to table_domes
local function BuildDomeSpots(dome)
  -- skip if we already added it
  if not table_domes[dome.handle] then
    local spots = {}
    local start_id, end_id = dome:GetAllSpots(dome:GetState())
    local name
    -- loop through all the spots and add any of the grass ones (don't need the rest, as they're further in)
    for i = start_id, end_id do
      name = GetSpotAnnotation(dome:GetEntity(), i)
      if name and name:find("DomeGrass") then
        spots[#spots+1] = dome:GetSpotPos(i)
      end
    end
    return spots
  end
end

-- add any existing domes to table_domes
local function BuildExistingDomeSpots()
  local domes = UICity.labels.Dome
  for i = 1, #domes do
    table_domes[domes[i].handle] = BuildDomeSpots(domes[i])
  end
end
function OnMsg.LoadGame()
  BuildExistingDomeSpots()
end
function OnMsg.CityStart()
  BuildExistingDomeSpots()
end

function OnMsg.ClassesGenerate()
  local CursorBuilding = CursorBuilding
  local ConstructionController = ConstructionController
  local dome_lines = {}
  -- no sense in checking domes too far away
  local too_far_away = 50000
  -- how long passages can be
  local max_hex = GridConstructionController.max_hex_distance_to_allow_build - 3 -- removed 3 for the angles they need
  local max_dist = max_hex * 10 * guim

  -- sort the position of the dome spots by the nearest to the pos
  local function RetNearestHexSpot(dome,pos)
    -- sort by nearest
    local pos_spots
    if table_domes[dome.handle] then
      pos_spots = table_domes[dome.handle]
    else
      pos_spots = BuildDomeSpots(dome)
    end

    table_sort(pos_spots,
      function(a,b)
        return Dist2D(a,pos) < Dist2D(b,pos)
      end
    )
    return pos_spots[1]
  end

  local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
  function CursorBuilding:GameInit()
    -- build a list of all domes and a vector for each (polyline with an arrow)
    if self.template:IsKindOf("Dome") then
      -- loop through all domes and attach a vector line
      local domes = UICity.labels.Dome
      for i = 1, #domes do
        -- make sure any new domes are added to the table
        BuildDomeSpots(domes[i])
        -- temp store dome/vector for the dome
        dome_lines[i] = {
          vector = PlaceObject("Vector"),
          dome = domes[i]
        }
      end
    end
    --orig func
    return orig_CursorBuilding_GameInit(self)
  end

  local orig_CursorBuilding_Done = CursorBuilding.Done
  function CursorBuilding:Done()
    if #dome_lines > 0 then
      --cursor is gone, so we're done construction
      for i = 1, #dome_lines do
        --this just deletes any polylines, leaves the table as is
        DoneObject(dome_lines[i].vector)
      end
      --replace table with a blank
      dome_lines = {}
    end
    --orig func
    return orig_CursorBuilding_Done(self)
  end

  local orig_ConstructionController_UpdateCursor = ConstructionController.UpdateCursor
  function ConstructionController:UpdateCursor(pos, force)
    if #dome_lines > 0 then
      local cursor_pos = GetTerrainCursor()
      --loop through domes and show any lines that are close enough
      for i = 1, #dome_lines do
        local v = dome_lines[i].vector
        local d_pos = dome_lines[i].dome:GetVisualPos()
        if Dist2D(pos,d_pos) < too_far_away then
          -- get nearest hex from placed dome to cursor
          local placed_dome_spot = RetNearestHexSpot(dome_lines[i].dome,self.cursor_obj:GetVisualPos())
          -- get nearest hex from cursor dome to placed dome
          local cursor_dome_spot = RetNearestHexSpot(self.cursor_obj,d_pos)
          -- show vector if it's close enough
          if Dist2D(placed_dome_spot,cursor_dome_spot) < max_dist then
            v:Set(cursor_dome_spot,placed_dome_spot)
            v:SetVisible(true)
          else
            v:SetVisible()
          end
        else
          v:SetVisible()
        end
      end
    end
    --orig func
    return orig_ConstructionController_UpdateCursor(self, pos, force)
  end

end
