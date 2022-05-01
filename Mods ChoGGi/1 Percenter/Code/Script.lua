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
		name = T(302535920011336, "1 Percenter"),
	})
end

function OnMsg.NewDay()
	local UIColony = UIColony

	local funding = UIColony.funds.funding

	local amount = (funding / 1000000) * 0.01 -- 0.01 = 1%
	ChangeFunding(amount)

	-- limit so we don't go neg
	if funding > 1000000000000 or funding < 0 then
		UIColony.funds.funding = 1000000000000
	end

	UIColony.funds.funding = floatfloor(UIColony.funds.funding)
	UIColony.funds:ChangeFunding(1)

	CreateGameTimeThread(function()
		AddOnScreenNotification("ChoGGi_1Percenter", nil, {amount = amount})
	end)
end


local function StartupCode()
	local funding = UIColony.funds.funding
	if funding > 1000000000000 or funding < 0 then
		UIColony.funds.funding = 1000000000000
	end
	UIColony.funds:ChangeFunding(1)
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
