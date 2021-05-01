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
	local UICity = UICity

	local amount = (UICity.funding / 1000000) * 0.01 -- 0.01 = 1%
	ChangeFunding(amount)

	-- limit so we don't go neg
	if UICity.funding > 90000000000 or < 0 then
		UICity.funding = 80000000000
	end

	UICity.funding = floatfloor(UICity.funding)
	UICity:ChangeFunding(1)

	CreateRealTimeThread(function()
		AddOnScreenNotification("ChoGGi_1Percenter", nil, {amount = amount})
	end)
end


local function StartupCode()
	if UICity.funding > 90000000000 or < 0 then
		UICity.funding = 80000000000
	end
	UICity:ChangeFunding(1)
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
