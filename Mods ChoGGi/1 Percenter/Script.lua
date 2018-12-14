local CreateRealTimeThread = CreateRealTimeThread
local AddCustomOnScreenNotification = AddCustomOnScreenNotification
local AsyncRand = AsyncRand

local function MsgPopup(Msg,Title,Icon)
	pcall(function()
		-- returns translated text corresponding to number if we don't do tostring for numbers
		Msg = tostring(Msg)
		Title = Title or [[Placeholder]]
		Icon = Icon or "UI/Icons/Notifications/placeholder.tga"
		local id = AsyncRand()
		local timeout = 8000
		if type(AddCustomOnScreenNotification) == "function" then --if we called it where there ain't no UI
			CreateRealTimeThread(function()
				AddCustomOnScreenNotification(
					id,Title,Msg,Icon,nil,{expiration=timeout}
				)
				-- since I use AsyncRand for the id, I don't want this getting too large.
				g_ShownOnScreenNotifications[id] = nil
			end)
		end
	end)
end

local ChangeFunding = ChangeFunding
function OnMsg.NewDay()
	local amount = (UICity.funding / 1000000) * 0.01 -- 0.01 = 1%
	ChangeFunding(amount)
	MsgPopup(
		string.format([[You've received: %s M]],amount),
		[[1 Percenter]]
	)
end
