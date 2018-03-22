function OnMsg.LoadGame() --fired when you load a game
  ChangeFunding(10000)
end

--you can also make it give money at other times:
--function OnMsg.ColonyApprovalPassed() --fired when the Founder Stage has been passed successfully.
--function OnMsg.SaveGame() --fired when you save a game
--function OnMsg.NewDay(day) --fired every Sol.
--function OnMsg.NewHour(hour) --fired every GameTime hour.
--function OnMsg.RocketLanded(rocket) --fired when a rocket has landed on Mars.
--function OnMsg.AnomalyAnalyzed(anomaly) --fired when a new anomaly has been completely analized.
--function OnMsg.AnomalyRevealed(anomaly) --fired when an anomaly has been releaved.
--for more see Surviving Mars\ModTools\Docs\LuaFunctionDoc_Msg.md.html
