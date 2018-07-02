local DoneObject = DoneObject
local GetSpotAnnotation = GetSpotAnnotation
local GetTerrainCursor = GetTerrainCursor
local PlaceObject = PlaceObject
local table = table
local table_iclear = table.iclear
local table_sort = table.sort

--stores domes with pos of each spot we check
local table_domes = {}

-- add dome spots to table_domes
local function BuildDomeSpots(dome)
  -- skip if we already added it
  if not table_domes[dome.handle] then
    local spots = {}
    local start_id, end_id = dome:GetAllSpots(dome:GetState())
    local name
    -- loop through all the spots and add any of the grass ones (don't need the rest, as they're further in or outside)
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
  local domes = UICity.labels.Dome or empty_table
  for i = 1, #domes do
    table_domes[domes[i].handle] = BuildDomeSpots(domes[i])
  end
end
function OnMsg.LoadGame()
  BuildExistingDomeSpots()
end
-- I doubt any domes are on a new game (maybe a tutorial level?)
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
    table_sort(pos_spots,
      function(a,b)
        return a:Dist2D(pos) < b:Dist2D(pos)
      end
    )
    -- and done
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
    -- orig func
    return orig_CursorBuilding_GameInit(self)
  end

  local orig_CursorBuilding_Done = CursorBuilding.Done
  function CursorBuilding:Done()
    if #dome_lines > 0 then
      -- cursor is gone, so we're done construction
      for i = 1, #dome_lines do
        -- this deletes the line object, leaves the table as is
        DoneObject(dome_lines[i].vector)
      end
      -- clear out table (slightly faster then just making a new table?)
      table_iclear(dome_lines)
--~       dome_lines = {}
    end
    -- orig func
    return orig_CursorBuilding_Done(self)
  end

  local orig_ConstructionController_UpdateCursor = ConstructionController.UpdateCursor
  function ConstructionController:UpdateCursor(pos, force)
    -- only do this if the cursor building is a dome
    if #dome_lines > 0 then
      local cursor_pos = GetTerrainCursor()
      -- loop through domes and show any lines that are close enough
      for i = 1, #dome_lines do
        local d_pos = dome_lines[i].dome:GetVisualPos()
        -- any domes too far away, just make the line invis
        if pos:Dist2D(d_pos) > too_far_away then
          dome_lines[i].vector:SetVisible()
        else
          local v = dome_lines[i].vector
          -- get nearest hex from placed dome to cursor
          local placed_dome_spot = RetNearestSpot(dome_lines[i].dome,self.cursor_obj:GetVisualPos())
          -- get nearest hex from cursor dome to placed dome
          local cursor_dome_spot = RetNearestSpot(self.cursor_obj,d_pos)
          -- show line if it's close enough
          if placed_dome_spot:Dist2D(cursor_dome_spot) > max_dist then
            -- hide it, or we'll have a line pointing at where the dome used to be (till it's too far away)
            v:SetVisible()
          else
            v:Set(cursor_dome_spot,placed_dome_spot)
            v:SetVisible(true)
          end
        end
      end
    end
    -- orig func
    return orig_ConstructionController_UpdateCursor(self, pos, force)
  end

end
