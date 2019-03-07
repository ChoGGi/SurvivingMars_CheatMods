-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 58
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error","Change Object Colour requires ChoGGi's Library (at least v" .. min_version .. [[).
Press OK to download it or check the Mod Manager to make sure it's enabled.]]) == "ok" then
				if p.steam then
					OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
				elseif p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/505/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/89?tab=files")
				end
			end
		end)
	end
end

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()

	local S = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions
	local c = #Actions
	local Trans = ChoGGi.ComFuncs.Translate

	c = c + 1
	Actions[c] = {ActionName = Trans(174--[[Color Modifier--]]),
		ActionId = "ChangeObjectColour.Color Modifier",
		OnAction = ChoGGi.ComFuncs.CreateObjectListAndAttaches,
		ActionShortcut = "F6",
		replace_matching_id = true,
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Trans(298035641454--[[Object--]]) .. " " .. Trans(302535920001346--[[Random Colour--]]),
		ActionId = "ChangeObjectColour.ObjectColourRandom",
		OnAction = ChoGGi.ComFuncs.ObjectColourRandom,
		ActionShortcut = "Shift-F6",
		ActionBindable = true,
	}

	c = c + 1
	Actions[c] = {ActionName = Trans(298035641454--[[Object--]]) .. " " .. Trans(302535920000025--[[Default Colour--]]),
		ActionId = "ChangeObjectColour.ObjectColourDefault",
		OnAction = ChoGGi.ComFuncs.ObjectColourDefault,
		ActionShortcut = "Ctrl-F6",
		ActionBindable = true,
	}

end
