--See LICENSE for terms

local Concat = Terraformer.ComFuncs.Concat
local T = Terraformer.ComFuncs.Trans

local RecalcBuildableGrid = RecalcBuildableGrid
local ReloadShortcuts = ReloadShortcuts

do -- DeleteAllRocks
  local function DeleteAllRocks(rock_cls)
    ForEach{
      class = rock_cls,
      exec = function(o)
        o:delete()
      end,
    }
  end

  local function CallBackFunc(answer)
    if answer then
      DeleteAllRocks("Deposition")
      DeleteAllRocks("WasteRockObstructorSmall")
      DeleteAllRocks("WasteRockObstructor")
      -- slower n slower
      DeleteAllRocks("StoneSmall")
    end
  end
  function Terraformer.MenuFuncs.DeleteAllRocks()
    Terraformer.ComFuncs.QuestionBox(
      Concat(T(6779--[[Warning--]]),"!\n",T(302535920001238--[[Removes most rocks for that smooth map feel (will take about 30 seconds).--]])),
      CallBackFunc,
      Concat(T(6779--[[Warning--]]),": ",T(302535920000855--[[Last chance before deletion!--]]))
    )
  end
end -- do


local function ToggleCollisions(Terraformer)
  ForEach{
    class = "LifeSupportGridElement",
    exec = function(o)
      Terraformer.CodeFuncs.CollisionsObject_Toggle(o,true)
    end,
  }
end

function Terraformer.MenuFuncs.TerrainEditor_Toggle()
  local Terraformer = Terraformer
  Terraformer.CodeFuncs.Editor_Toggle()
  if Platform.editor then
    editor.ClearSel()
    SetEditorBrush(const.ebtTerrainType)
  else
    -- disable collisions on pipes beforehand, so they don't get marked as uneven terrain
    ToggleCollisions(Terraformer)
    -- update uneven terrain checker thingy
    RecalcBuildableGrid()
    -- and back on when we're done
    ToggleCollisions(Terraformer)

  end
end

function OnMsg.LoadGame()
  ReloadShortcuts()
end
function OnMsg.CityStart()
  ReloadShortcuts()
end
function OnMsg.ReloadLua()
  ReloadShortcuts()
end

local Actions = {
  {
    ActionId = "Terraformer.Terrain Editor Toggle",
    OnAction = Terraformer.MenuFuncs.TerrainEditor_Toggle,
    ActionShortcut = "Ctrl-F",
    replace_matching_id = true,
  },
  {
    ActionId = "Terraformer.Delete All Rocks",
    OnAction = Terraformer.MenuFuncs.DeleteAllRocks,
    ActionShortcut = "Ctrl-Shift-F",
    replace_matching_id = true,
  },
}
function OnMsg.ShortcutsReloaded()
  local XAction = XAction
  local XShortcutsTarget = XShortcutsTarget
  for i = 1, #Actions do
    XShortcutsTarget:AddAction(XAction:new(Actions[i]))
  end
end

