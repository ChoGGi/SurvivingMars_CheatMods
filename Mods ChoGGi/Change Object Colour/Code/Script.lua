-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 53
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[Change Object Colour requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				if p.pops then
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
