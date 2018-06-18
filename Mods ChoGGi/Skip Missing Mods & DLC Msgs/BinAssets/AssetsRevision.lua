local function ChoGGi_Setup()
  CreateRealTimeThread(function()

    --stop bugging me about missing mods
    function GetMissingMods()
      return "", false
    end

    --lets you load saved games that have dlc
    function IsDlcAvailable()
      return true
    end

  end)

end --OnMsg.UASetMode()

function OnMsg.ReloadLua()
  ChoGGi_Setup()
end
function OnMsg.UASetMode()
  ChoGGi_Setup()
end

--return revision, or else you get a blank map on new game
MountPack("ChoGGi_BinAssets", "Packs/BinAssets.hpk")
return tonumber(dofile("ChoGGi_BinAssets/AssetsRevision.lua")) or 0
