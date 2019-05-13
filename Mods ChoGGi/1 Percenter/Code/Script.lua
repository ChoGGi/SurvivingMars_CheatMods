-- See LICENSE for terms

local AsyncRand = AsyncRand
local CreateRealTimeThread = CreateRealTimeThread
local AddCustomOnScreenNotification = AddCustomOnScreenNotification
local ChangeFunding = ChangeFunding

local function MsgPopup(msg)
	-- returns translated text corresponding to number if we don't do tostring for numbers
	CreateRealTimeThread(function()
		AddCustomOnScreenNotification(
			AsyncRand(), [[1 Percenter]], tostring(msg), "UI/Icons/Notifications/placeholder.tga", nil, {expiration=8000}
		)
		-- since I use AsyncRand for the id, I don't want this getting too large.
		g_ShownOnScreenNotifications[id] = nil
	end)

end

function OnMsg.NewDay()
	local amount = (UICity.funding / 1000000) * 0.01 -- 0.01 = 1%
	ChangeFunding(amount)

	MsgPopup("You've received: " .. amount .. " M")
end
