-- See LICENSE for terms

local Actions = ChoGGi.Temp.Actions

Actions[#Actions+1] = {ActionName = T(302535920011668, "Set Speed 1"),
	ActionId = "ChoGGi.SetSpeedKeys.SetSpeed1",
	OnAction = function()
		UICity:SetGameSpeed(1)
		UISpeedState = "play"
	end,
	ActionShortcut = "1",
	replace_matching_id = true,
	ActionBindable = true,
}

Actions[#Actions+1] = {ActionName = T(302535920011669, "Set Speed 2"),
	ActionId = "ChoGGi.SetSpeedKeys.SetSpeed2",
	OnAction = function()
		UICity:SetGameSpeed(const.mediumGameSpeed)
		UISpeedState = "medium"
	end,
	ActionShortcut = "2",
	replace_matching_id = true,
	ActionBindable = true,
}

Actions[#Actions+1] = {ActionName = T(302535920011670, "Set Speed 3"),
	ActionId = "ChoGGi.SetSpeedKeys.SetSpeed3",
	OnAction = function()
		UICity:SetGameSpeed(const.fastGameSpeed)
		UISpeedState = "fast"
	end,
	ActionShortcut = "3",
	replace_matching_id = true,
	ActionBindable = true,
}
