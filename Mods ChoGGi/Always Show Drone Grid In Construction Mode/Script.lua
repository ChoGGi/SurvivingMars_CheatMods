function OnMsg.ClassesGenerate()

  local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
  local orig_CursorBuilding_Done = CursorBuilding.Done

  function CursorBuilding:GameInit()
    local UICity = UICity
--~     ShowHexRanges(UICity, "RCRover")
    ShowHexRanges(UICity, "SupplyRocket")
    ShowHexRanges(UICity, "DroneHub")
    return orig_CursorBuilding_GameInit(self)
  end

  function CursorBuilding:Done()
    local UICity = UICity
--~     HideHexRanges(UICity, "RCRover")
    HideHexRanges(UICity, "SupplyRocket")
    HideHexRanges(UICity, "DroneHub")
    return orig_CursorBuilding_Done(self)
  end

end
