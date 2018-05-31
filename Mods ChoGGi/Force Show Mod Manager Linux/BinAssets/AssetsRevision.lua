function OnMsg.Autorun()

  --if the menu order gets changed this won't work
  XTemplates.PGMenu[1][2][3][5].__condition = function(parent, context)
    --return Platform.steam or Platform.pc
    return true
  end

end

--return revision, or else you get a blank map on new game
return 19673
