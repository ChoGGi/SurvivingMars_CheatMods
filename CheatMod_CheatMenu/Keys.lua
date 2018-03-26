UserActions.RemoveActions({
  --these will switch the map without asking to save
  "G_ModsEditor",
  "G_OpenPregameMenu",
  --added to toggles menu
  "G_ToggleInfopanelCheats",
})

UserActions.AddActions({
--[[
  TESTING = {
    key = "F3",
    action = function()
      ChoGGi.MsgPopup("TESTING",
        "TESTING","UI/Icons/IPButtons/assign_residence.tga"
      )
----------------------
ChoGGi.Dump(tostring(ChoGGi.Examine.idText))

-----------------------
    end
  },
--]]
  ChoGGi_ToggleCheatsMenu = {
    key = "F2",
    action = function()
      UAMenu.ToggleOpen()
    end
  },
  ChoGGi_Console = {
    key = "~",
    action = function()
      ShowConsole(true)
    end
  },
  ChoGGi_Console2 = {
    key = "Enter",
    action = function()
      ShowConsole(true)
    end
  },

})

if ChoGGi.ChoGGiComp then
  AddConsoleLog("ChoGGi: Keys.lua",true)
end
