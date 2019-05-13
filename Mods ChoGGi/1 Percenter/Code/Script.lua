-- See LICENSE for terms

local AsyncRand = AsyncRand
local CreateRealTimeThread = CreateRealTimeThread
local AddCustomOnScreenNotification = AddCustomOnScreenNotification
local ChangeFunding = ChangeFunding

local function MsgPopup(msg)
	if not GameState.gameplay then
		return
	end

	-- returns translated text corresponding to number if we don't do tostring for numbers
	msg = tostring(msg)
	local title = [[1 Percenter]]
	local icon = "UI/Icons/Notifications/placeholder.tga"
	local id = AsyncRand()
	local timeout = 8000

	CreateRealTimeThread(function()
		AddCustomOnScreenNotification(
			id, title, msg, icon, nil, {expiration=timeout}
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
