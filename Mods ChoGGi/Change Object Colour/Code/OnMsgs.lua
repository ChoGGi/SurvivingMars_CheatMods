--  See LICENSE for terms
--  i like keeping all my OnMsgs in one file (go go gadget anal retentiveness)

local Concat = ChangeObjectColour.ComFuncs.Concat
local T = ChangeObjectColour.ComFuncs.Trans

local pairs,type,next,tostring,print,pcall = pairs,type,next,tostring,print,pcall
local getmetatable,rawget,rawset = getmetatable,rawget,rawset

local AsyncFileToString = AsyncFileToString
local box = box
local ClassDescendantsList = ClassDescendantsList
local CreateRealTimeThread = CreateRealTimeThread
local GetObjects = GetObjects
local IsValid = IsValid
local LuaCodeToTuple = LuaCodeToTuple
local Msg = Msg
local OpenGedApp = OpenGedApp
local PlaceObj = PlaceObj
local ReopenSelectionXInfopanel = ReopenSelectionXInfopanel
local SetLightmodelOverride = SetLightmodelOverride
local ShowConsoleLog = ShowConsoleLog
local UpdateDroneResourceUnits = UpdateDroneResourceUnits
local WaitMsg = WaitMsg

local black = black

local UserActions_ClearGlobalTables = UserActions.ClearGlobalTables
local UserActions_GetActiveActions = UserActions.GetActiveActions
local terminal_SetOSWindowTitle = terminal.SetOSWindowTitle

local g_Classes = g_Classes
local OnMsg = OnMsg

local function SomeCode()

  if not UICity then
    return
  end

  --add custom actions
  ChangeObjectColour.MsgFuncs.MiscMenu_LoadingScreenPreClose()
  ChangeObjectColour.MsgFuncs.Keys_LoadingScreenPreClose()

end

function OnMsg.CityStart()
  SomeCode()
end

function OnMsg.LoadGame()
  SomeCode()
end
