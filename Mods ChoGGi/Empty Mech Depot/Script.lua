local select,tostring,table = select,tostring,table
local TConcat = oldTableConcat or table.concat

-- this is also used instead of string .. string; anytime you do that lua will hash the new string, and store it till exit
-- which means this is faster, and uses less memory
local concat_table = {}
local function Concat(...)
  -- i assume sm added a c func to clear tables, which does seem to be faster than a lua for loop
  table.iclear(concat_table)
  -- build table from args
  local concat_value
  local concat_type
  for i = 1, select("#",...) do
    concat_value = select(i,...)
    -- no sense in calling a func more then we need to
    concat_type = type(concat_value)
    if concat_type == "string" or concat_type == "number" then
      concat_table[i] = concat_value
    else
      concat_table[i] = tostring(concat_value)
    end
  end
  -- and done
  return TConcat(concat_table)
end

local function FilterFromTable(Table,ExcludeList,IncludeList,Type)
  return FilterObjects({
    filter = function(Obj)
      if ExcludeList or IncludeList then
        if ExcludeList and IncludeList then
          if not ExcludeList[Obj[Type]] then
            return Obj
          elseif IncludeList[Obj[Type]] then
            return Obj
          end
        elseif ExcludeList then
          if not ExcludeList[Obj[Type]] then
            return Obj
          end
        elseif IncludeList then
          if IncludeList[Obj[Type]] then
            return Obj
          end
        end
      else
        if Obj[Type] then
          return Obj
        end
      end
    end
  },Table)
end


--returns whatever is selected > moused over > nearest non particle object to cursor
local function SelObject()
  return SelectedObj or SelectionMouseObj() or NearestObject(
    GetTerrainCursor(),
    GetObjects{
      filter = function(o)
        if o.class ~= "ParSystem" then
          return o
        end
      end,
    },
    1500
  )
end

--sticks small depot in front of mech depot and moves all resources to it (max of 20 000)
local function EmptyMechDepot(oldobj)
  if not oldobj or not oldobj:IsKindOf("MechanizedDepot") then
    oldobj = SelObject()
  end
  if not oldobj:IsKindOf("MechanizedDepot") then
    return
  end

  local res = oldobj.resource
  local amount = oldobj[Concat("GetStored_",res)](oldobj)
  --not good to be larger then this when game is saved
  if amount > 20000000 then
    amount = amount
  end
  local stock = oldobj.stockpiles[oldobj:GetNextStockpileIndex()]
  local angle = oldobj:GetAngle()
  --new pos based on angle of old depot (so it's in front not inside)
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
    "template_name", Concat("Storage",res2),
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
--~   if not XT.sectionStorageMechanized.ChoGGiEmpty then
--~     XT.sectionStorageMechanized.ChoGGiEmpty = true

--~     XT.sectionStorageMechanized[#XT.sectionStorageMechanized+1] = PlaceObj("XTemplateTemplate", {
  if not XT.sectionStorage.ChoGGiEmpty then
    XT.sectionStorage.ChoGGiEmpty = true

    XT.sectionStorage[1][#XT.sectionStorage[1]+1] = PlaceObj("XTemplateTemplate", {
      "ChoGGi_EmptyMechDepot", true,
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
