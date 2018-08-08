
function OnMsg.ReloadLua()

  CreateRealTimeThread(function()
    local buttons = XTemplates.PGMenu[1][2][3]
    for i = 1, #buttons do
      if buttons[i].ActionId == "idModManager" then
        buttons[i].__condition = function(parent, context)
          -- orig
--~           return Platform.steam or Platform.pc

          -- return true whenever it isn't a console
          return not Platform.console

          --return Platform.desktop
        end
      end
    end
  end)

end

-- return revision, or else you get a blank map on new game
MountPack("ChoGGi_BinAssets", "Packs/BinAssets.hpk")
return dofile("ChoGGi_BinAssets/AssetsRevision.lua") or 233360
