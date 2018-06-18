--See LICENSE for terms

--simplest entity object as possible for hexgrids (it went from being laggy with 100 to usable, though that includes some use of local)
DefineClass.FlattenGround_CursorBuilding = {
  __parents = {"CObject"},
  entity = "GridTile"
}

local T = FlattenGround.ComFuncs.Trans

local CreateRealTimeThread = CreateRealTimeThread
local DeleteThread = DeleteThread
local DoneObject = DoneObject
local GetTerrainCursor = GetTerrainCursor
local RecalcBuildableGrid = RecalcBuildableGrid

local guic = guic
local white = white
--local TerrainTextures = TerrainTextures

local terrain_GetHeight = terrain.GetHeight
local terrain_SetHeightCircle = terrain.SetHeightCircle
local terrain_SetTypeCircle = terrain.SetTypeCircle

local g_Classes = g_Classes

local are_we_flattening
local visual_circle
function FlattenGround.MenuFuncs.FlattenTerrain_Toggle()
  local FlattenGround = FlattenGround

  if are_we_flattening then
    are_we_flattening = false
    DeleteThread(are_we_flattening)
    DoneObject(visual_circle)
    FlattenGround.ComFuncs.MsgPopup(
      T(302535920001164--[[Flattening has been stopped, now updating buildable.--]]),
      T(904--[[Terrain--]]),
      "UI/Icons/Sections/WasteRock_1.tga"
    )
    --update uneven terrain checker thingy
    RecalcBuildableGrid()
  else
    local flatten_height = terrain_GetHeight(GetTerrainCursor())
    FlattenGround.ComFuncs.MsgPopup(
      string.format(T(302535920001163--[[Flatten height has been choosen %s, press shortcut again to update buildable.--]]),flatten_height),
      T(904--[[Terrain--]]),
      "UI/Icons/Sections/warning.tga"
    )

--~     local terrain_type = mapdata.BaseLayer or "SandRed_1"		-- applied terrain type
--~     local terrain_type_idx = table.find(TerrainTextures, "name", terrain_type)
    local size = FlattenGround.UserSettings.FlattenSize or 2500
    local radius = size * guic
    visual_circle = g_Classes.Circle:new()
    visual_circle:SetRadius(size)
    visual_circle:SetColor(white)


    are_we_flattening = CreateRealTimeThread(function()
      --thread gets deleted, but just in case
      while are_we_flattening do
        local cursor = GetTerrainCursor()
        visual_circle:SetPos(cursor)
        terrain_SetHeightCircle(cursor, radius, radius, flatten_height)
        --uncomment to change the texture
        --terrain_SetTypeCircle(cursor, radius, terrain.GetTerrainType(cursor))
        Sleep(10)
      end
    end)

  end

end
