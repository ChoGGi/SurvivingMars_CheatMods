local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding:GameInit()
  SetPostProcPredicate("hexgrid", true)
  return orig_CursorBuilding_GameInit(self)
end
local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding:Done()
  SetPostProcPredicate("hexgrid", false)
  return orig_CursorBuilding_Done(self)
end
