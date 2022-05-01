-- See LICENSE for terms

local name

-- add keybind for toggle
local Actions = ChoGGi.Temp.Actions
Actions[#Actions+1] = {ActionName = T(302535920011641, "Quicksave"),
	ActionId = "ChoGGi.AddQuicksaveHotkey.Quicksave",
	OnAction = function()
		if not UICity then
			return
		end

		CreateRealTimeThread(function()
			DeleteGame(name or "Quicksave.savegame.sav")
			local err
			err, name = SaveAutosaveGame("Quicksave")

			if err then
				ChoGGi.ComFuncs.MsgPopup(err, T(302535920011641, "Quicksave"))
			else
				ChoGGi.ComFuncs.MsgPopup(name, T(302535920011641, "Quicksave"), {expiration = 3})
			end
		end)
	end,
	ActionShortcut = "Ctrl-F5",
	replace_matching_id = true,
	ActionBindable = true,
}

-- add keybind for toggle
Actions[#Actions+1] = {ActionName = T(302535920011642, "Quickload"),
	ActionId = "ChoGGi.AddQuicksaveHotkey.Quickload",
	OnAction = function()
    g_SaveLoadThread = IsValidThread(g_SaveLoadThread) and g_SaveLoadThread or CreateRealTimeThread(function()
--~ 			LoadingScreenOpen("idLoadingScreen", "LoadSaveGame")
			local err = LoadGame(name or "Quicksave.savegame.sav")
			if not err then
				CloseMenuDialogs()
			end
      if err then
				ChoGGi.ComFuncs.MsgWait(err, T(302535920011642, "Quickload"))
      end
--~ 			LoadingScreenClose("idLoadingScreen", "LoadSaveGame")
    end)
	end,
	ActionShortcut = "Ctrl-F9",
	replace_matching_id = true,
	ActionBindable = true,
}
