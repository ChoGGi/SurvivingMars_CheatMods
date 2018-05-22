ChoGGiX = {
  OrigFuncs = {}
}
--make some functions local for faster access
local FilterObjects = FilterObjects
local FindNearestObject = FindNearestObject
local Msg = Msg

function ChoGGiX.AttachToNearestDome(building)
  local workingdomes = ChoGGiX.FilterFromTable(GetObjects({class="Dome"}),nil,nil,"working")
  --check for dome and ignore outdoor buildings *and* if there aren't any domes on map
  if not building.parent_dome and building:GetDefaultPropertyValue("dome_required") and workingdomes and #workingdomes > 0 then
    --find the nearest dome
    local dome = FindNearestObject(workingdomes,building)
    if dome and dome.labels then
      building.parent_dome = dome
      --add to dome labels
      dome:AddToLabel("InsideBuildings", building)
      --work/res
      if IsKindOf(building,"Workplace") then
        dome:AddToLabel("Workplace", building)
      elseif IsKindOf(building,"Residence") then
        dome:AddToLabel("Residence", building)
      end
      --spires
      if IsKindOf(building,"WaterReclamationSpire") then
        dome:AddToLabel("WaterReclamationSpires", building)
      elseif IsKindOf(building,"NetworkNode") then
        building.parent_dome:SetLabelModifier("BaseResearchLab", "NetworkNode", building.modifier)
      end
    end
  end
end

--backup orginal function for later use (checks if we already have a backup, or else problems)
function ChoGGiX.SaveOrigFunc(ClassOrFunc,Func)
  local ChoGGiX = ChoGGiX
  if Func then
    local newname = ClassOrFunc .. "_" .. Func
    if not ChoGGiX.OrigFuncs[newname] then
      ChoGGiX.OrigFuncs[newname] = _G[ClassOrFunc][Func]
    end
  else
    if not ChoGGiX.OrigFuncs[ClassOrFunc] then
      ChoGGiX.OrigFuncs[ClassOrFunc] = _G[ClassOrFunc]
    end
  end
end

--function to send a Msg whenever a function is called
function ChoGGiX.AddMsgToFunc(ClassName,FuncName,sMsg)
  local ChoGGiX = ChoGGiX
  --save orig
  ChoGGiX.SaveOrigFunc(ClassName,FuncName)
  --redefine it
  _G[ClassName][FuncName] = function(...)
    --I just care about adding self to the msgs
    Msg(sMsg,select(1,...))
    --pass on args to orig func
    return ChoGGiX.OrigFuncs[ClassName .. "_" .. FuncName](...)
  end
end

--RemoveFromTable(GetObjects({class="CObject"}),{ParSystem=1,ResourceStockpile=1},"class")
--RemoveFromTable(GetObjects({class="CObject"}),nil,nil,"working")
function ChoGGiX.FilterFromTable(Table,ExcludeList,IncludeList,Type)
  return FilterObjects({
    filter = function(Obj)
      if ExcludeList or IncludeList then
        if not ExcludeList[Obj[Type]] then
          return Obj
        elseif IncludeList[Obj[Type]] then
          return Obj
        end
      else
        if Obj[Type] then
          return Obj
        end
      end
    end
  },Table)
end

--now that i declared all my functions we'll make this local (local to this lua file)
local ChoGGi = ChoGGi

ChoGGiX.AddMsgToFunc("SpireBase","GameInit","ChoGGiX_SpawnedSpireBase")

--this msg will be msged on every spire spawn
function OnMsg.ChoGGiX_SpawnedSpireBase(Obj)
  ChoGGiX.AttachToNearestDome(Obj)
end

