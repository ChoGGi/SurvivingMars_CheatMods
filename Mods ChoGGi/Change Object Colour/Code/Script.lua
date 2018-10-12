-- See LICENSE for terms

-- tell people know how to get the library
function OnMsg.ModsReloaded()
	local min_version = 19

	local ModsLoaded = ModsLoaded
	local not_found_or_wrong_version
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	if idx then
		if min_version > ModsLoaded[idx].version then
			not_found_or_wrong_version = true
		end
	else
		not_found_or_wrong_version = true
	end

	if not_found_or_wrong_version then
		CreateRealTimeThread(function()
			local Sleep = Sleep
			while not UICity do
				Sleep(1000)
			end
			if WaitMarsQuestion(nil,nil,string.format([[Error: Change Object Colour requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],library_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()

	local S = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local c = #Actions

	c = c + 1
	Actions[c] = {ActionName = S[174--[[Color Modifier--]]],
		ActionId = "ChangeObjectColour.Color Modifier",
		OnAction = function()
			ChoGGi.ComFuncs.CreateObjectListAndAttaches()
		end,
		ActionShortcut = "F6",
		replace_matching_id = true,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = string.format("%s %s",S[298035641454--[[Object--]]],S[302535920001346--[[Random Colour--]]]),
		ActionId = "ChangeObjectColour.ObjectColourRandom",
		OnAction = function()
			ChoGGi.ComFuncs.ObjectColourRandom(ChoGGi.ComFuncs.SelObject())
		end,
		ActionShortcut = "Shift-F6",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = string.format("%s %s",S[298035641454--[[Object--]]],S[302535920000025--[[Default Colour--]]]),
		ActionId = "ChangeObjectColour.ObjectColourDefault",
		OnAction = function()
			ChoGGi.ComFuncs.ObjectColourDefault(ChoGGi.ComFuncs.SelObject())
		end,
		ActionShortcut = "Ctrl-F6",
		ActionBindable = true,
	}

end
