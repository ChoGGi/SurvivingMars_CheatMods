UserActions.AddActions({

  ChoGGi_ResearchEveryBreakthrough = {
    icon = "ViewArea.tga",
    menu = "Cheats/[04]Research/[11]Research Every Breakthrough",
    description = "Research all Breakthroughs",
    action = ChoGGi.ResearchEveryBreakthrough
  },

  ChoGGi_UnlockEveryBreakthrough = {
    icon = "ViewArea.tga",
    menu = "Cheats/[04]Research/[12]Unlock Every Breakthrough",
    description = "Unlocks all Breakthroughs",
    action = ChoGGi.UnlockEveryBreakthrough
  },

  ChoGGi_ResearchEveryMystery = {
    icon = "ViewArea.tga",
    menu = "Cheats/[04]Research/[13]Research Every Mystery",
    description = "Research all Mysteries",
    action = ChoGGi.ResearchEveryMystery
  },

  ChoGGi_BreakThroughTechsPerGameToggle = {
    icon = "ViewArea.tga",
    menu = "Cheats/[04]Research/[14]Double Amount of Breakthroughs per game",
    description = function()
      local action
      if const.BreakThroughTechsPerGame == 26 then
        action = "(Enabled)"
      else
        action = "(Disabled)"
      end
      return action .. " Doubled amount of breakthroughs per game."
    end,
    action = ChoGGi.BreakThroughTechsPerGameToggle
  },

  --can't be bothered making MenuHelp.lua just for this
  ChoGGi_ShowHelp = {
    icon = "ReportBug.tga",
    menu = "[999]Help/Help",
    action = function()
      CreateRealTimeThread(WaitCustomPopupNotification,
        "Help",
        "Hover mouse over menu item to get description and enabled status"
          .. "\nIf menu item has a '+ num' then that means it'll add to the current amount"
          .. "\n(you can add as many times as you want)",
        {"OK"}
      )
    end
  },

})

if ChoGGi.ChoGGiTest then
  AddConsoleLog("ChoGGi: MenuCheats.lua",true)
end
