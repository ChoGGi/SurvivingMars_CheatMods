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
local UserActions_AddActions = UserActions.AddActions
local UserActions_RemoveActions = UserActions.RemoveActions
local UserActions_GetActiveActions = UserActions.GetActiveActions
local UAMenu_UpdateUAMenu = UAMenu.UpdateUAMenu

local g_Classes = g_Classes

local are_we_flattening
local visual_circle
local flatten_height

local remove_actions = {
  FlattenGround_RaiseHeight = true,
  FlattenGround_LowerHeight = true,
  FlattenGround_WidenRadius = true,
  FlattenGround_ShrinkRadius = true,
}
local temp_height
local function ToggleHotkeys(bool)
  local FlattenGround = FlattenGround

  if bool then
    UserActions_AddActions({
      FlattenGround_RaiseHeight = {
        key = "Shift-Up",
        action = function()
          temp_height = flatten_height + FlattenGround.FlattenGroundHeightDiff
          --guess i found the ceiling height
          if temp_height > 65535 then
            temp_height = 65535
          end
          flatten_height = temp_height
        end
      },
      FlattenGround_LowerHeight = {
        key = "Shift-Down",
        action = function()
          temp_height = flatten_height - FlattenGround.FlattenGroundHeightDiff
          --and the floor limit (oh look 0 go figure)
          if temp_height < 0 then
            temp_height = 0
          end
          flatten_height = temp_height
        end
      },
      FlattenGround_WidenRadius = {
        key = "Shift-Right",
        action = function()
          FlattenGround.FlattenGroundRadius = FlattenGround.FlattenGroundRadius + FlattenGround.FlattenGroundRadiusDiff

          visual_circle:SetRadius(FlattenGround.FlattenGroundRadius)
          radius = FlattenGround.FlattenGroundRadius * guic
        end
      },
      FlattenGround_ShrinkRadius = {
        key = "Shift-Left",
        action = function()
          FlattenGround.FlattenGroundRadius = FlattenGround.FlattenGroundRadius - FlattenGround.FlattenGroundRadiusDiff

          visual_circle:SetRadius(FlattenGround.FlattenGroundRadius)
          radius = FlattenGround.FlattenGroundRadius * guic
        end
      },
    })
  else
    local UserActions = UserActions
    for k, _ in pairs(UserActions.Actions) do
      if remove_actions[k] then
        UserActions.Actions[k] = nil
      end
    end
  end

  UAMenu_UpdateUAMenu(UserActions_GetActiveActions())
end

function FlattenGround.MenuFuncs.FlattenTerrain_Toggle()
  local FlattenGround = FlattenGround

  if are_we_flattening then
    ToggleHotkeys()
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
    ToggleHotkeys(true)
    flatten_height = terrain_GetHeight(GetTerrainCursor())
    FlattenGround.ComFuncs.MsgPopup(
      string.format(T(302535920001163--[[Flatten height has been choosen %s, press shortcut again to update buildable.--]]),flatten_height),
      T(904--[[Terrain--]]),
      "UI/Icons/Sections/warning.tga"
    )

--~     local terrain_type = mapdata.BaseLayer or "SandRed_1"		-- applied terrain type
--~     local terrain_type_idx = table.find(TerrainTextures, "name", terrain_type)
    visual_circle = g_Classes.Circle:new()
    visual_circle:SetRadius(FlattenGround.FlattenGroundRadius)
    visual_circle:SetColor(white)


    are_we_flattening = CreateRealTimeThread(function()
      --thread gets deleted, but just in case
      while are_we_flattening do
        local cursor = GetTerrainCursor()
        visual_circle:SetPos(cursor)
        terrain_SetHeightCircle(cursor, FlattenGround.FlattenGroundRadius, FlattenGround.FlattenGroundRadius, flatten_height)
        --uncomment to change the texture
        --terrain_SetTypeCircle(cursor, radius, terrain.GetTerrainType(cursor))
        Sleep(10)
      end
    end)

  end

end
