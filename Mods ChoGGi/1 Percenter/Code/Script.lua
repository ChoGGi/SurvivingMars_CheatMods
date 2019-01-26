-- See LICENSE for terms

local AsyncRand = AsyncRand
local CreateRealTimeThread = CreateRealTimeThread
local AddCustomOnScreenNotification = AddCustomOnScreenNotification
local ChangeFunding = ChangeFunding

local function MsgPopup(msg,title,icon)
	if not GameState.gameplay then
		return
	end

	-- returns translated text corresponding to number if we don't do tostring for numbers
	msg = tostring(msg)
	title = [[1 Percenter]]
	icon = icon or "UI/Icons/Notifications/placeholder.tga"
	local id = AsyncRand()
	local timeout = 8000

	CreateRealTimeThread(function()
		AddCustomOnScreenNotification(
			id,title,msg,icon,nil,{expiration=timeout}
		)
		-- since I use AsyncRand for the id, I don't want this getting too large.
		g_ShownOnScreenNotifications[id] = nil
	end)

end

local msg_str = [[You've received: %s M]]
function OnMsg.NewDay()
	local amount = (UICity.funding / 1000000) * 0.01 -- 0.01 = 1%
	ChangeFunding(amount)

	MsgPopup(msg_str:format(amount))
end
