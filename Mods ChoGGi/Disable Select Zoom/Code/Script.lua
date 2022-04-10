-- See LICENSE for terms

-- version 9.6
--~ local IsGamepadButtonPressed = ChoGGi.ComFuncs.IsGamepadButtonPressed
local XInput_IsControllerConnected = XInput.IsControllerConnected
local XInput_IsCtrlButtonPressed = XInput.IsCtrlButtonPressed
-- version 9.6

local IsCtrlPressed = ChoGGi.ComFuncs.IsCtrlPressed

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_ViewObjectMars = ViewObjectMars
local function ChoFake_ViewObjectMars(...)
--~ 	if not mod_EnableMod or IsCtrlPressed() or IsGamepadButtonPressed("RightThumbClick") then
	if not mod_EnableMod or IsCtrlPressed()
		-- xbox (maybe not thumb?)
		or XInput_IsCtrlButtonPressed(XInput_IsControllerConnected(s_XInputControllersConnected-1), "LeftShoulder")
	then
		return ChoOrig_ViewObjectMars(...)
	end
end

local function Override(func, ...)
	ViewObjectMars = ChoFake_ViewObjectMars
	pcall(func, ...)
	ViewObjectMars = ChoOrig_ViewObjectMars
end

local ChoOrig_Colonist_Select = Colonist.Select
function Colonist.Select(...)
	Override(ChoOrig_Colonist_Select, ...)
end
local ChoOrig_InfobarObj_CycleLabel = InfobarObj.CycleLabel
function InfobarObj.CycleLabel(...)
	Override(ChoOrig_InfobarObj_CycleLabel, ...)
end
local ChoOrig_InfobarObj_CycleResources = InfobarObj.CycleResources
function InfobarObj.CycleResources(...)
	Override(ChoOrig_InfobarObj_CycleResources, ...)
end
local ChoOrig_InfobarObj_CycleDroneControl = InfobarObj.CycleDroneControl
function InfobarObj.CycleDroneControl(...)
	Override(ChoOrig_InfobarObj_CycleDroneControl, ...)
end
