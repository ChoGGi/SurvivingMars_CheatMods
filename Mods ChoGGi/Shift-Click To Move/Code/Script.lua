-- See LICENSE for terms

-- check for shift
local IsKeyPressed = terminal.IsKeyPressed
local vkShift = const.vkShift
local function IsShiftPressed()
	return IsKeyPressed(vkShift)
end

-- move cam to mouse pos
local ViewObjectRTS = ViewObjectRTS
local GetTerrainCursor = GetTerrainCursor
local function go_to()
	ViewObjectRTS(GetTerrainCursor())
end

-- override what's normally intercepting clicks
local orig_SelectionModeDialog_OnMouseButtonDown = SelectionModeDialog.OnMouseButtonDown
function SelectionModeDialog:OnMouseButtonDown(pt, button, ...)
	if button == "L" and IsShiftPressed() then
		return CreateRealTimeThread(go_to)
	end
	return orig_SelectionModeDialog_OnMouseButtonDown(self, pt, button, ...)
end

-- disable edge scrolling
local function StartupCode()
	if not CtrlClickToMove.MouseScrolling then
		cameraRTS.SetProperties(1,{ScrollBorder = 0})
	end
end

function OnMsg.CityStart()
	StartupCode()
end

function OnMsg.LoadGame()
	StartupCode()
end
