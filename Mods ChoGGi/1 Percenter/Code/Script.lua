-- See LICENSE for terms

local AsyncRand = AsyncRand
local CreateRealTimeThread = CreateRealTimeThread
local AddCustomOnScreenNotification = AddCustomOnScreenNotification
local ChangeFunding = ChangeFunding

local params = {expiration = 8000}

function OnMsg.NewDay()
	local amount = (UICity.funding / 1000000) * 0.01 -- 0.01 = 1%
	ChangeFunding(amount)

	local id = AsyncRand()
	-- returns translated text corresponding to number if we don't do tostring for numbers
	CreateRealTimeThread(function()
		AddCustomOnScreenNotification(
			id,
			T(302535920011336, "1 Percenter"),
			T{302535920011384, "You've received: <amount> M", amount = amount},
			"UI/Icons/Notifications/placeholder.tga",
			nil,
			params
		)
		-- since I use AsyncRand for the id, I don't want this getting too large.
		g_ShownOnScreenNotifications[id] = nil
	end)
end
