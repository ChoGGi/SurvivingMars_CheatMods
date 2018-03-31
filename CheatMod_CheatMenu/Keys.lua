
ChoGGi.AddAction(nil,
  function()
    ShowConsole(true)
    if ChoGGi.CheatMenuSettings.PrependSelObjConsole then
      AddConsolePrompt("SelectedObj")
    end
  end,
  "~"
)

ChoGGi.AddAction(nil,
  function()
    ShowConsole(true)
    if ChoGGi.CheatMenuSettings.PrependSelObjConsole then
      AddConsolePrompt("SelectedObj")
    end
  end,
  "Enter"
)

ChoGGi.AddAction(nil,
  function()
    ShowConsole(true)
    AddConsolePrompt("restart")
  end,
  "Ctrl-Alt-Shift-R"
)

ChoGGi.AddAction(nil,
  function()
    if ChoGGi.LastPlacedObj.entity then
      ChoGGi.SetConstructionMode(ChoGGi.LastPlacedObj.entity)
    end
  end,
  "Ctrl-Space"
)

--goes to placement mode with SelectedObj
ChoGGi.AddAction(nil,
  function()
    ChoGGi.SetConstructionMode(SelectedObj:__toluacode():match("^PlaceObj%('(%a+).*$"))
  end,
  "Ctrl-Shift-Space"
)

ChoGGi.AddAction(nil,UAMenu.ToggleOpen,"F2")
ChoGGi.AddAction(nil,function() quit("restart") end,"Ctrl-Shift-Alt-Numpad Enter")

if ChoGGi.ChoGGiTest then
  table.insert(ChoGGi.FilesCount,"Keys")
end
