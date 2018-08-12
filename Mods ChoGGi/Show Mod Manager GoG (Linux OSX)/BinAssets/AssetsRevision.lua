
function OnMsg.ReloadLua()

  CreateRealTimeThread(function()
    local buttons = XTemplates.PGMenu[1][2][3]
    for i = 1, #buttons do
      for j = 1, #buttons[i] do
        local action = buttons[i][j]
        if action.ActionId == "idModManager" then
          action.__condition = function(parent, context)
            -- return true whenever it isn't a console
            return not Platform.console
          end
        end
      end
    end
  end)

end

-- return revision, or else you get a blank map on new game
MountPack("ChoGGi_BinAssets", "Packs/BinAssets.hpk")
return dofile("ChoGGi_BinAssets/AssetsRevision.lua") or 233360
