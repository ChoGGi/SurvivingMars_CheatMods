--fired after a game has been loaded.
function OnMsg.LoadGame()
  --remove the -- to uncomment

--shows (non-working) console
  --ShowConsole(true)

--Toggle Infopanel Cheats (add cheat section to selection menu)
  config.BuildingInfopanelCheats = "Enable"
  ReopenSelectionXInfopanel()

--Shift-C Toggle Free Camera
--Ctrl-U Toggle Signs ?
--Ctrl-I Toggle InGame Interface (for taking screenshots)

--Reveal all Deposits (all)
  --CheatMapExplore("scanned")
--Reveal all deposits level 1 and above
  --CheatMapExplore("deep scanned")
--spawn disasters
  --CheatDustDevil()
  --CheatDustDevil("major")
  --CheatDustStorm("normal")
  --CheatDustStorm("great")
  --CheatDustStorm("electrostatic")
  --CheatColdWave()
  --CheatMeteors("single")
  --CheatMeteors("multispawn")
  --CheatMeteors("storm")
--stop disasters
  --StopDustStorm()
  --StopColdWave()
--Research all techs instantly
  --CheatResearchAll()
--Finish current research instantly
  --CheatResearchCurrent()
--Complete all wires and pipes instantly
  --CheatCompleteAllWiresAndPipes()
--Complete all constructions instantly
  --CheatCompleteAllConstructions()
--not a clue
  --CheatChangeMap("POCMap_Alt_00") --Empty Map
  --CheatChangeMap("POCMap_Alt_01") --Phase 1
  --CheatChangeMap("POCMap_Alt_02") --Phase 2 (Early)
  --CheatChangeMap("POCMap_Alt_03") --Phase 2 (Late)
  --CheatChangeMap("POCMap_Alt_04") --Phase 3
--Unlock all techs instantly
  --UnlockAllTech()
--Unlock all buildings for construction
  --CheatUnlockAllBuildings()
--Unlock all breakthroughs on this map
  --CheatUnlockBreakthroughs()
--add funds (10.00 M)
  --ChangeFunding(10000)
--Spawn 1 Colonist
  --CheatSpawnNColonists(1)
--Spawn 100 Colonists
  --CheatSpawnNColonists(100)
--Unpin All Pinned Objects
  --UnpinAll()
--Toggle on-screen hints
  --SetHintNotificationsEnabled(not HintsEnabled)
  --UpdateOnScreenHintDlg()
--Reset on-screen hints
  --g_ShownOnScreenHints = {}
  --UpdateOnScreenHintDlg()
--Toggle Signs (Ctrl-U)
  --ToggleSigns()
--Toggle InGame Interface (Ctrl-I)
  --hr.RenderUIL = hr.RenderUIL == 0 and 1 or 0
--Mod editor
  --ModEditorOpen()
--Open Pregame Menu (main menu)
  --CreateRealTimeThread(OpenPreGameMainMenu)

--dev stuff probably doesn't work
--Toggle Hex Build Grid Visibility
  --debug_build_grid()
--Toggle Terrain Deposit Grid
  --ToggleTerrainDepositGrid()
--Show/Hide the User Actions toolbar
  --ToggleSidebar()
  --ToggleEditorStatusbar()

end

--you can also make it give fire at other times:
--function OnMsg.ColonyApprovalPassed() --fired when the Founder Stage has been passed successfully.
--function OnMsg.SaveGame() --fired when you save a game
--function OnMsg.NewDay(day) --fired every Sol.
--function OnMsg.NewHour(hour) --fired every GameTime hour.
--function OnMsg.RocketLanded(rocket) --fired when a rocket has landed on Mars.
--function OnMsg.AnomalyAnalyzed(anomaly) --fired when a new anomaly has been completely analized.
--function OnMsg.AnomalyRevealed(anomaly) --fired when an anomaly has been releaved.
--for more see Surviving Mars\ModTools\Docs\LuaFunctionDoc_Msg.md.html

--no idea what these do :)
OnMsg.DataLoaded = function()
  AddCheatsUA()
end
CheatsEnabled = function()
  return true
end
