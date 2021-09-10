-- See LICENSE for terms

local Actions = ChoGGi.Temp.Actions

Actions[#Actions+1] = {ActionName = T(302535920011668, "Set Speed 1"),
	ActionId = "ChoGGi.SetSpeedKeys.SetSpeed1",
	OnAction = function()
		UIColony:SetGameSpeed(1)
		UISpeedState = "play"
	end,
	ActionShortcut = "1",
	replace_matching_id = true,
	ActionBindable = true,
}

Actions[#Actions+1] = {ActionName = T(302535920011669, "Set Speed 2"),
	ActionId = "ChoGGi.SetSpeedKeys.SetSpeed2",
	OnAction = function()
		UIColony:SetGameSpeed(const.mediumGameSpeed)
		UISpeedState = "medium"
	end,
	ActionShortcut = "2",
	replace_matching_id = true,
	ActionBindable = true,
}

Actions[#Actions+1] = {ActionName = T(302535920011670, "Set Speed 3"),
	ActionId = "ChoGGi.SetSpeedKeys.SetSpeed3",
	OnAction = function()
		UIColony:SetGameSpeed(const.fastGameSpeed)
		UISpeedState = "fast"
	end,
	ActionShortcut = "3",
	replace_matching_id = true,
	ActionBindable = true,
}

Actions[#Actions+1] = {ActionName = T(302535920012050, "Set Speed 4"),
	ActionId = "ChoGGi.SetSpeedKeys.SetSpeed4",
	OnAction = function()
		UIColony:SetGameSpeed(const.fastGameSpeed*5)
		UISpeedState = "faster"
	end,
	ActionShortcut = "4",
	replace_matching_id = true,
	ActionBindable = true,
}

Actions[#Actions+1] = {ActionName = T(302535920012051, "Set Speed 5"),
	ActionId = "ChoGGi.SetSpeedKeys.SetSpeed5",
	OnAction = function()
		UIColony:SetGameSpeed(const.fastGameSpeed*10)
		UISpeedState = "fastest"
	end,
	ActionShortcut = "5",
	replace_matching_id = true,
	ActionBindable = true,
}
