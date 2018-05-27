--sticks small depot in front of mech depot and moves all resources to it (max of 20 000)
local function EmptyMechDepot(oldobj)
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

function OnMsg.ClassesBuilt()
  local XT = XTemplates
  --add button to side panel
  if not XT.sectionStorageMechanized.ChoGGiEmpty then
    XT.sectionStorageMechanized.ChoGGiEmpty = true

    XT.sectionStorageMechanized[#XT.sectionStorageMechanized+1] = PlaceObj("XTemplateTemplate", {
      "__context_of_kind", "MechanizedDepot",
      "__template", "InfopanelActiveSection",
      "Icon", "UI/Icons/Sections/storage.tga",
      "Title", "Empty Depot",
      "RolloverText", "Info",
      "RolloverTitle", "Empty Mech Depot",
      "RolloverHint", "Empties depot into a new resource pile in front of it.",
      "OnContextUpdate", function(self, context)
        if context.stockpiled_amount > 0 then
          self:SetVisible(true)
          self:SetMaxHeight()
        else
          self:SetVisible(false)
          self:SetMaxHeight(0)
        end
      end
    }, {
      PlaceObj("XTemplateFunc", {
      "name", "OnActivate(self, context)",
      "parent", function(parent, context)
          return parent.parent
        end,
      "func", function()
        EmptyMechDepot(context)
      end
      })
    })
  end

end
