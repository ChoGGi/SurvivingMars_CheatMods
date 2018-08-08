function OnMsg.DesktopCreated()
  -- skip the two logos
  PlayInitialMovies = nil
end

local are_we_setup
local function ChoGGi_Setup()
  if are_we_setup then
    return
  end
  are_we_setup = true

  -- get rid of mod manager warnings (not the reboot one though)
  ParadoxBuildsModEditorWarning = true
  ParadoxBuildsModManagerWarning = true

  --[[
    CreateRealTimeThread(function()

      -- opens to load game menu
      OpenPreGameMainMenu("Load")

      --show cheats menu
      UAMenu.ToggleOpen()

      -- stop bugging me about missing mods
      function GetMissingMods()
        return "", false
      end

      -- lets you load saved games that have dlc
      function IsDlcAvailable()
        return true
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

-- return revision, or else you get a blank map on new game
MountPack("ChoGGi_BinAssets", "Packs/BinAssets.hpk")
return dofile("ChoGGi_BinAssets/AssetsRevision.lua") or 233360
