local function CheckMM(action)
	if action.ActionId == "idModManager" then
		action.__condition = function()
			-- return true whenever it isn't a console
			return not Platform.console
		end
		return true
	end
end

function OnMsg.ReloadLua()

	-- loop through a bunch of menu items till we find the correct one
	CreateRealTimeThread(function()
		local buttons = XTemplates.PGMenu[1][2][3]
		for i = 1, #buttons do
			if CheckMM(buttons[i]) then
				break
			end
			for j = 1, #buttons[i] do
				if CheckMM(buttons[i][j]) then
					break
				end
			end
		end
	end)

end
