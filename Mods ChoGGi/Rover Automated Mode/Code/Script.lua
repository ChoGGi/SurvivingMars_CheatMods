local function StartupCode()
	if g_RoverAIResearched then
		return
	end

  g_RoverAIResearched = true
  MapForEach("map", "BaseRover", function(r)
    if r.has_auto_mode and (r.command == "Idle" or r.command == "LoadingComplete") then
      r:SetCommand(r.command)
      if r == SelectedObj then
        ObjModified(r)
      end
    end
  end)
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
