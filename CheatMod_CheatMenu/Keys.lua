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
  ChoGGi_CheatsMenuToggle = {
    key = "F2",
    action = UAMenu.ToggleOpen
  },
  ChoGGi_Console = {
    key = "~",
    action = function()
      dlgConsole:Show(true)
      --ShowConsole(true)
    end
  },
  ChoGGi_Console2 = {
    key = "Enter",
    action = function()
      dlgConsole:Show(true)
      --ShowConsole(true)
    end
  },

})

if ChoGGi.ChoGGiComp then
  AddConsoleLog("ChoGGi: Keys.lua",true)
end
