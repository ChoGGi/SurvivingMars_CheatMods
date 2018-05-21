--add items to the cheats pane
function OnMsg.ClassesGenerate()

  --so we can add hints to info pane cheats
  if not ChoGGiX.OrigFunc.InfopanelObj_CreateCheatActions then
    ChoGGiX.OrigFunc.InfopanelObj_CreateCheatActions = InfopanelObj.CreateCheatActions
  end
  function InfopanelObj:CreateCheatActions(win)
    local ret = ChoGGiX.OrigFunc.InfopanelObj_CreateCheatActions(self,win)
    ChoGGiX.SetInfoPanelCheatHints(GetActionsHost(win))
    return ret
  end

  function MechanizedDepot:CheatEmptyDepot()
    ChoGGiX.EmptyMechDepot(self)
  end

end --OnMsg

function OnMsg.LoadGame()
  ChoGGiX.AddAction(
    "Expanded CM/Buildings/Empty Mech Depot",
    ChoGGiX.EmptyMechDepot,
    "Ctrl-Shift-E",
    "Empties out selected/moused over mech depot into a small depot in front of it.",
    "Cube.tga"
  )

  --update menu
  UAMenu.UpdateUAMenu(UserActions.GetActiveActions())

end

function ChoGGiX.SetInfoPanelCheatHints(win)
  local tab = win.actions or empty_table
  for i = 1, #tab do
    if tab[i].ActionId == "EmptyDepot" then
      --name has to be set to make the hint show up
      tab[i].ActionName = tab[i].ActionId
      tab[i].RolloverHint = "sticks small depot in front of mech depot and moves all resources to it (max of 20 000)."
    end
  end

end

--sticks small depot in front of mech depot and moves all resources to it (max of 20 000)
function ChoGGiX.EmptyMechDepot(oldobj)
  if not oldobj or not IsKindOf(oldobj,"MechanizedDepot") then
    oldobj = SelectedObj or SelectionMouseObj()
  end
  if not IsKindOf(oldobj,"MechanizedDepot") then
    return
  end

  local res = oldobj.resource
  local amount = oldobj["GetStored_" .. res](oldobj)
  --not good to be larger then this when game is saved
  if amount > 20000000 then
    amount = amount
  end
  local stock = oldobj.stockpiles[oldobj:GetNextStockpileIndex()]
  local angle = oldobj:GetAngle()
  --new pos based on angle of old depot (so it's in front not under it)
  local newx = 0
  local newy = 0
  if angle == 0 then
    newx = 500
    newy = 0
  elseif angle == 3600 then
    newx = 500
    newy = 500
  elseif angle == 7200 then
    newx = 0
    newy = 500
  elseif angle == 10800 then
    newx = -600
    newy = 0
  elseif angle == 14400 then
    newx = 0
    newy = -500
  elseif angle == 18000 then
    newx = 500
    newy = -500
  end
  local oldpos = stock:GetPos()
  local newpos = point(oldpos:x() + newx,oldpos:y() + newy,oldpos:z())

  --yeah guys. lets have two names for a resource and use them interchangeably, it'll be fine...
  local res2 = res
  if res == "PreciousMetals" then
    res2 = "RareMetals"
  end
  --create new depot, and set max amount to stored amount of old depot
  local newobj = PlaceObj("UniversalStorageDepot", {
    "template_name", "Storage" .. res2,
    "resource", {res},
    "stockpiled_amount", {},
    "max_storage_per_resource", amount,
    --make sure it's on a hex point after we moved it in front
    "Pos", HexGetNearestCenter(newpos),
  })

  --make it align with the depot
  newobj:SetAngle(angle)
  --give it a bit before filling
  CreateRealTimeThread(function()
    local time = 0
    repeat
      Sleep(25)
      time = time + 25
    until type(newobj.requester_id) == "number" or time > 5000
    --since we set new depot max amount to old amount we can just fill it
    newobj:CheatFill()
    --clean out old depot
    oldobj:CheatEmpty()
  end)
end
