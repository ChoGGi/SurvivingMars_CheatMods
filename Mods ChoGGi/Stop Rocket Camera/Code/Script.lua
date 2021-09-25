-- See LICENSE for terms

local mod_StopNotificationCamera

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_StopNotificationCamera = CurrentModOptions:GetProperty("StopNotificationCamera")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_CycleObjs = OnScreenNotification.CycleObjs
function OnScreenNotification:CycleObjs(cycle_objs, ...)
	if not mod_StopNotificationCamera then
		return ChoOrig_CycleObjs(self, cycle_objs, ...)
	end

	if cycle_objs and self.notification_id == ("NewTradeOffer" .. UICity.map_id) then
		return cycle_objs[1]
	end
	return ChoOrig_CycleObjs(self, cycle_objs, ...)
end

-- stop rocket snap on new exped
local ChoOrig_ViewAndSelectObject = ViewAndSelectObject
local fake_ViewAndSelectObject = empty_func

local ChoOrig_SendRocketToMarsPoint = SendRocketToMarsPoint
function SendRocketToMarsPoint(obj, spot, ...)
	if spot.spot_type == "project" then
		return ChoOrig_SendRocketToMarsPoint(obj, spot, ...)
	end

	ViewAndSelectObject = fake_ViewAndSelectObject

	ChoOrig_SendRocketToMarsPoint(obj, spot, ...)
	-- we need the WaitMsg since the orig func does it as well
	CreateRealTimeThread(function()
		WaitMsg("PlanetCameraSet")
		WaitMsg("OnRender")
		ViewAndSelectObject = ChoOrig_ViewAndSelectObject
	end)

end
