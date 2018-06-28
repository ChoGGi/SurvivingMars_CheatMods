
function OnMsg.ReloadLua()

  CreateRealTimeThread(function()
    local p = Platform
    local buttons = XTemplates.PGMenu[1][2][3]
    for i = 1, #buttons do
      if buttons[i].ActionId == "idModManager" then
        buttons[i].__condition = function(parent, context)
          --return Platform.steam or Platform.pc
          return p.steam or p.pc or p.linux or p.osx
        end
      end
    end
  end)

end


--return revision, or else you get a blank map on new game
MountPack("ChoGGi_BinAssets", "Packs/BinAssets.hpk")
return tonumber(dofile("ChoGGi_BinAssets/AssetsRevision.lua")) or 0
