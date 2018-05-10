function OnMsg.LoadGame()
  --not needed, just useful for my testing
  Presets.CommanderProfilePreset.Default.psychologist.param1 = 5

  local commander_profile = GetCommanderProfile()
  if commander_profile.id == "psychologist" then
    commander_profile.param1 = 5
  end
end