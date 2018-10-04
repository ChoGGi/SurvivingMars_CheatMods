
function OnMsg.ReloadLua()

  CreateRealTimeThread(function()
		-- loop through menu items till we find the correct one
		local buttons = XTemplates.PGMenu[1][2][3]
		local TableFind = table.find
		for i = 1, #buttons do

			local idx = TableFind(buttons[i],"ActionId","idModManager")
			if idx then
				buttons[i][idx].__condition = function()
					return true
				end
				break
			end

		end
	end)

end
