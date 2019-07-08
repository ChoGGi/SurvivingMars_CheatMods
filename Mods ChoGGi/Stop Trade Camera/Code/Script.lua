-- See LICENSE for terms

local orig_CycleObjs = OnScreenNotification.CycleObjs
function OnScreenNotification:CycleObjs(cycle_objs, ...)
	if cycle_objs and self.notification_id == "NewTradeOffer" then
		return cycle_objs[1]
	end
	return orig_CycleObjs(self, cycle_objs, ...)
end
