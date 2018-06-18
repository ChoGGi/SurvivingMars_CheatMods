--See LICENSE for terms

local Concat = FlattenGround.ComFuncs.Concat
local T = FlattenGround.ComFuncs.Trans

local OnMsg = OnMsg
local Msg = Msg

function OnMsg.LoadGame()
  Msg("FlattenGround_Loaded")
end
function OnMsg.CityStart()
  Msg("FlattenGround_Loaded")
end


--fired when game is loaded
function OnMsg.FlattenGround_Loaded()

  FlattenGround.ComFuncs.AddAction(
    Concat("[102]Debug/",T(302535920000485--[[Flatten Terrain Toggle--]])),
    FlattenGround.MenuFuncs.FlattenTerrain_Toggle,
    "Shift-F",
    T(302535920000486--[[Use the shortcut to turn this on as it will use where your cursor is as the height to flatten to.--]]),
    "FixUnderwaterEdges.tga"
  )
end
