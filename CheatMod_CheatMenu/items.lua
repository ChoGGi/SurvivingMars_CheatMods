--items, init, whatever


--keeping sections seperate
local ModPath = "AppData/Mods/CheatMod_CheatMenu/"
dofile(ModPath .. "ConsoleExec.lua")
dofile(ModPath .. "CheatMenuSettings.lua")

-- This must return true for most cheats to function
function CheatsEnabled()
  return true
end

function InitCheats()
  --enable dev mode?
  if CheatMenuSettings["developer"] then
    Platform.developer = true
  end

  -- Turn on editor mode (this is required for cheats to work) and then add the editor commands
  --may not be, but I can't be bothered to find out
  Platform.editor = true
  Platform.cmdline = true
  AddCheatsUA()

  --load up menus
  dofile(ModPath .. "MenuCheats.lua")
  dofile(ModPath .. "MenuToggles.lua")
  dofile(ModPath .. "MenuResources.lua")
  dofile(ModPath .. "MenuGameplayBuildings.lua")
  dofile(ModPath .. "MenuGameplayColonists.lua")
  dofile(ModPath .. "MenuGameplayDronesAndRC.lua")
  dofile(ModPath .. "MenuGameplayMisc.lua")

--[[
  UserActions.AddActions({
    ["TESTING"] = {
      key = "F5",
      menu = "[999]TEST/TEST",
      action = function()
------------

--------

    CreateRealTimeThread(WaitCustomPopupNotification,
      Consts.CargoCapacity,
      "blah",
      { "OK" }
    )

--------

------------
      end
    },
  })
--]]

end

--msgs file (OnMsg.DataLoaded, GameSaved, etc), also loads up settings/cheats
dofile(ModPath .. "OnMsgs.lua")
