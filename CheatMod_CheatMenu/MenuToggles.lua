UserActions.AddActions({

  ToggleableHint = {
    menu = "Toggles/[0]These are all toggleable menuitems",
    description = "click to enable, again to disable",
    action = function()
      return
    end
  },
  ToggleableHint2 = {
    menu = "Toggles/[1]---------------",
    description = "click to enable, again to disable",
    action = function()
      return
    end
  },

  ["StorageDepotHold1000"] = {
    menu = "Toggles/[2]Storage Depot Hold 1000",
    description = "Larger storage depot space (only newly placed)",
    action = function()
      CheatMenuSettings["StorageDepotSpace"] = not CheatMenuSettings["StorageDepotSpace"]
      WriteSettings()
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "StorageDepotHold1000",
        "Storage",
        "not a space elevator",
        "UI/Icons/Sections/basic.tga",
        nil,
        {expiration=5000})
      )
      CreateRealTimeThread(AddCustomOnScreenNotification(
        "StorageDepotHold10002",
        CheatMenuSettings["StorageDepotSpace"],
        "not a space elevator",
        "UI/Icons/Sections/basic.tga",
        nil,
        {expiration=5000})
      )
    end
  },

})
