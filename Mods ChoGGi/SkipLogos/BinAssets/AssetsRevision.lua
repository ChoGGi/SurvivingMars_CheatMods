function OnMsg.DesktopCreated()
  --skip the two logos
  PlayInitialMovies = nil
end

local function ChoGGi_Setup()
  --get rid of mod manager warnings (not the reboot one though)
  ParadoxBuildsModEditorWarning = true
  ParadoxBuildsModManagerWarning = true

  --[[
    CreateRealTimeThread(function()

      --opens to load game menu
      OpenPreGameMainMenu("Load")

      --show cheats menu
      UAMenu.ToggleOpen()

      --stop bugging me about missing mods
      function GetMissingMods()
        return "", false
      end

    end)
  --]]
end

function OnMsg.ReloadLua()
  ChoGGi_Setup()
end
function OnMsg.UASetMode()
  ChoGGi_Setup()
end

--return revision, or else you get a blank map on new game
MountPack("ChoGGi_BinAssets", "Packs/BinAssets.hpk")
return tonumber(dofile("ChoGGi_BinAssets/AssetsRevision.lua")) or 0
