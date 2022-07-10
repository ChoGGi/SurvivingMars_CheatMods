-- See LICENSE for terms

local mod_StopNotificationCamera
local mod_StopDomeFracture

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_StopNotificationCamera = CurrentModOptions:GetProperty("StopNotificationCamera")
	mod_StopDomeFracture = CurrentModOptions:GetProperty("StopDomeFracture")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_OnScreenNotification_CycleObjs = OnScreenNotification.CycleObjs
function OnScreenNotification:CycleObjs(cycle_objs, ...)
	if not mod_StopNotificationCamera then
		return ChoOrig_OnScreenNotification_CycleObjs(self, cycle_objs, ...)
	end

	if cycle_objs and self.notification_id == ("NewTradeOffer" .. GetMapID()) then
		return cycle_objs[1]
	end
	return ChoOrig_OnScreenNotification_CycleObjs(self, cycle_objs, ...)
end

-- used for funcs below
local ChoOrig_ViewAndSelectObject = ViewAndSelectObject
local fake_ViewAndSelectObject = empty_func

-- stop rocket snap on new exped
local ChoOrig_SendRocketToMarsPoint = SendRocketToMarsPoint
function SendRocketToMarsPoint(obj, spot, ...)
--~ 	if spot and spot.spot_type == "project" then
--~ 		return ChoOrig_SendRocketToMarsPoint(obj, spot, ...)
--~ 	end

	ViewAndSelectObject = fake_ViewAndSelectObject

	-- I do pcalls for safety when wanting to change back a global var
	pcall(ChoOrig_SendRocketToMarsPoint, obj, spot, ...)

	-- we need the WaitMsg since the orig func does it as well
	CreateRealTimeThread(function()
		WaitMsg("PlanetCameraSet")
		WaitMsg("OnRender")
		ViewAndSelectObject = ChoOrig_ViewAndSelectObject
	end)

end

local ChoOrig_StoryBitState_OpenPopup = StoryBitState.OpenPopup
function StoryBitState:OpenPopup(...)
	if not mod_StopDomeFracture then
		return ChoOrig_StoryBitState_OpenPopup(self, ...)
	end
--~  local storybit = StoryBits[self.id]

	if self.id == "DomeLeaks" or self.id:find("DomeLeaks_") then
		ViewAndSelectObject = fake_ViewAndSelectObject
	end

	pcall(ChoOrig_StoryBitState_OpenPopup, self, ...)

	ViewAndSelectObject = ChoOrig_ViewAndSelectObject
end
