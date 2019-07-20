-- See LICENSE for terms

local orig_CycleObjs = OnScreenNotification.CycleObjs
function OnScreenNotification:CycleObjs(cycle_objs, ...)
	if cycle_objs and self.notification_id == "NewTradeOffer" then
		return cycle_objs[1]
	end
	return orig_CycleObjs(self, cycle_objs, ...)
end

-- stop rocket snap on new exped
local orig_ViewAndSelectObject = ViewAndSelectObject
local fake_ViewAndSelectObject = empty_func

local orig_SendRocketToMarsPoint = SendRocketToMarsPoint
function SendRocketToMarsPoint(...)
	ViewAndSelectObject = fake_ViewAndSelectObject
	orig_SendRocketToMarsPoint(...)
	-- we need the WaitMsg since the orig func does it as well
	CreateRealTimeThread(function()
		WaitMsg("PlanetCameraSet")
		ViewAndSelectObject = orig_ViewAndSelectObject
	end)
end
