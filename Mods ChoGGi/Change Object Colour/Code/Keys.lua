--See LICENSE for terms

local Concat = ChangeObjectColour.ComFuncs.Concat

local pcall,tostring = pcall,tostring

local CloseXBuildMenu = CloseXBuildMenu
local GetInGameInterface = GetInGameInterface
local GetXDialog = GetXDialog
local PlaceObj = PlaceObj
local Random = Random
local ShowConsole = ShowConsole
local UIGetBuildingPrerequisites = UIGetBuildingPrerequisites
local ValueToLuaCode = ValueToLuaCode

local g_Classes = g_Classes

function ChangeObjectColour.MsgFuncs.Keys_LoadingScreenPreClose()

  ChangeObjectColour.ComFuncs.AddAction(
    nil,
    function()
      ChangeObjectColour.CodeFuncs.ObjectColourRandom(ChangeObjectColour.CodeFuncs.SelObject())
    end,
    "Shift-F6"
  )
  ChangeObjectColour.ComFuncs.AddAction(
    nil,
    function()
      ChangeObjectColour.CodeFuncs.ObjectColourDefault(ChangeObjectColour.CodeFuncs.SelObject())
    end,
    "Ctrl-F6"
  )

end --OnMsg
