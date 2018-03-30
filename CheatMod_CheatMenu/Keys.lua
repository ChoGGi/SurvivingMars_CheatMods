ChoGGi.AddAction(nil,UAMenu.ToggleOpen,"F2")
ChoGGi.AddAction(nil,function() ShowConsole(true) end,"~")
ChoGGi.AddAction(nil,function() ShowConsole(true) end,"Enter")
ChoGGi.AddAction(nil,function() quit("restart") end,"Ctrl-Shift-Alt-Numpad Enter")

if ChoGGi.ChoGGiTest then
  table.insert(ChoGGi.FilesCount,"Keys")
end
