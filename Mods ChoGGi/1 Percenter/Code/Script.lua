-- See LICENSE for terms

function OnMsg.ClassesPostprocess()
	if OnScreenNotificationPresets.ChoGGi_1Percenter then
		return
	end

	PlaceObj('OnScreenNotificationPreset', {
		ImagePreview = "UI/Icons/Notifications/placeholder.tga",
		expiration = 150000,
		fx_action = "UINotificationFunding",
		group = "Default",
		id = "ChoGGi_1Percenter",
		image = "UI/Icons/Notifications/placeholder.tga",
		text = T(302535920011384, "You've received: <amount> M"),
		title = T(302535920011336, "1 Percenter"),
	})
end

function OnMsg.NewDay()
	local amount = (UICity.funding / 1000000) * 0.01 -- 0.01 = 1%
	ChangeFunding(amount)
	floatfloor(UICity.funding)
	UICity:ChangeFunding(1)

	CreateRealTimeThread(function()
		AddOnScreenNotification("ChoGGi_1Percenter", nil, {amount = amount})
	end)
end
