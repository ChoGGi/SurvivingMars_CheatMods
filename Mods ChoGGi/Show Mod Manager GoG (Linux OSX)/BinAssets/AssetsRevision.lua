
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

-- return revision, or else you get a blank map on new game
MountPack("ChoGGi_BinAssets", "Packs/BinAssets.hpk")
return dofile("ChoGGi_BinAssets/AssetsRevision.lua") or 233360
