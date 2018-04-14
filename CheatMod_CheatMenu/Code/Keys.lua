--[[
ChoGGi.AddAction(nil,
  function()
    if GetXDialog("SaveLoadDlg") then
      CloseXDialog("SaveLoadDlg")
    else
      OpenXDialog("SaveLoadDlg"):SetMode("Load")
    end
  end,
  "Ctrl-F9"
)
--]]

ChoGGi.AddAction(nil,
  function()
    ShowConsole(true)
    --[[ why doesn't this way work?
    if rawget(_G, "dlgConsole") then
      dlgConsole.idEdit:SetText("")
    end
    --]]
  end,
  "~"
)

ChoGGi.AddAction(nil,
  function()
    ShowConsole(true)
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
--goes to placement mode with last built object
ChoGGi.AddAction(nil,
  function()
    if ChoGGi.LastPlacedObj.entity then
      ChoGGi.ConstructionModeSet(ChoGGi.LastPlacedObj.encyclopedia_id or ChoGGi.LastPlacedObj.entity)
    end
  end,
  "Ctrl-Space"
)
--goes to placement mode with SelectedObj
ChoGGi.AddAction(nil,
  function()
    ChoGGi.ConstructionModeNameClean(ValueToLuaCode(SelectedObj or SelectionMouseObj()))
  end,
  "Ctrl-Shift-Space"
)

ChoGGi.AddAction(nil,UAMenu.ToggleOpen,"F2")
ChoGGi.AddAction(nil,function() quit("restart") end,"Ctrl-Shift-Alt-Numpad Enter")
