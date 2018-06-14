--See LICENSE for terms
--any funcs called from Code/*

local Concat = ChangeObjectColour.ComFuncs.Concat
local T = ChangeObjectColour.ComFuncs.Trans

local pcall,print,rawget,tostring,type,table = pcall,print,rawget,tostring,type,table

local AsyncFileDelete = AsyncFileDelete
local CloseXBuildMenu = CloseXBuildMenu
local CloseXDialog = CloseXDialog
local CreateRealTimeThread = CreateRealTimeThread
local DestroyBuildingImmediate = DestroyBuildingImmediate
local DoneObject = DoneObject
local FilterObjects = FilterObjects
local FindNearestObject = FindNearestObject
local GetInGameInterface = GetInGameInterface
local GetObjects = GetObjects
local GetPreciseCursorObj = GetPreciseCursorObj
local GetTerrainCursor = GetTerrainCursor
local GetTerrainCursorObjSel = GetTerrainCursorObjSel
local GetXDialog = GetXDialog
local HexGetNearestCenter = HexGetNearestCenter
local IsValid = IsValid
local NearestObject = NearestObject
local OpenXBuildMenu = OpenXBuildMenu
local PlaceObj = PlaceObj
local point = point
local Random = Random
local SelectionMouseObj = SelectionMouseObj
local SelectObj = SelectObj
local Sleep = Sleep
local ViewPos = ViewPos

local terminal_GetMousePos = terminal.GetMousePos
local UIL_GetScreenSize = UIL.GetScreenSize
local cameraRTS_SetProperties = cameraRTS.SetProperties
local cameraRTS_SetZoomLimits = cameraRTS.SetZoomLimits
local camera_SetFovY = camera.SetFovY
local camera_SetFovX = camera.SetFovX

local g_Classes = g_Classes

--returns whatever is selected > moused over > nearest non particle object to cursor
function ChangeObjectColour.CodeFuncs.SelObject()
  local _,ret = pcall(function()
    local objs = ChangeObjectColour.ComFuncs.FilterFromTable(GetObjects({class="CObject"}),{ParSystem=1},"class")
    return SelectedObj or SelectionMouseObj() or NearestObject(GetTerrainCursor(),objs,500)
  end)
  return ret
end


function ChangeObjectColour.CodeFuncs.SaveOldPalette(Obj)
  local GetPal = Obj.GetColorizationMaterial
  if not Obj.ChangeObjectColour_origcolors then
    Obj.ChangeObjectColour_origcolors = {}
    Obj.ChangeObjectColour_origcolors[#Obj.ChangeObjectColour_origcolors+1] = {GetPal(Obj,1)}
    Obj.ChangeObjectColour_origcolors[#Obj.ChangeObjectColour_origcolors+1] = {GetPal(Obj,2)}
    Obj.ChangeObjectColour_origcolors[#Obj.ChangeObjectColour_origcolors+1] = {GetPal(Obj,3)}
    Obj.ChangeObjectColour_origcolors[#Obj.ChangeObjectColour_origcolors+1] = {GetPal(Obj,4)}
  end
end
function ChangeObjectColour.CodeFuncs.RestoreOldPalette(Obj)
  if Obj.ChangeObjectColour_origcolors then
    local c = Obj.ChangeObjectColour_origcolors
    local SetPal = Obj.SetColorizationMaterial
    SetPal(Obj,1, c[1][1], c[1][2], c[1][3])
    SetPal(Obj,2, c[2][1], c[2][2], c[2][3])
    SetPal(Obj,3, c[3][1], c[3][2], c[3][3])
    SetPal(Obj,4, c[4][1], c[4][2], c[4][3])
    Obj.ChangeObjectColour_origcolors = nil
  end
end

function ChangeObjectColour.CodeFuncs.GetPalette(Obj)
  local g = Obj.GetColorizationMaterial
  local pal = {}
  pal.Color1, pal.Roughness1, pal.Metallic1 = g(Obj, 1)
  pal.Color2, pal.Roughness2, pal.Metallic2 = g(Obj, 2)
  pal.Color3, pal.Roughness3, pal.Metallic3 = g(Obj, 3)
  pal.Color4, pal.Roughness4, pal.Metallic4 = g(Obj, 4)
  return pal
end

function ChangeObjectColour.CodeFuncs.RandomColour(Amount)
  local ChangeObjectColour = ChangeObjectColour
  local Random = Random
  --local AsyncRand = AsyncRand
  --AsyncRand(16777216) * -1

  --amount isn't a number so return a single colour
  if type(Amount) ~= "number" then
    return Random(-16777216,0) --24bit colour
  end

  local randcolors = {}
  --populate list with amount we want
  for _ = 1, Amount do
    randcolors[#randcolors+1] = Random(-16777216,0)
  end
  --now remove all dupes and add more till we hit amount
  while true do
    --remove dupes
    randcolors = ChangeObjectColour.ComFuncs.RetTableNoDupes(randcolors)
    if #randcolors == Amount then
      break
    end
    --then loop missing amount
    for _ = 1, Amount - #randcolors do
      randcolors[#randcolors+1] = Random(-16777216,0)
    end
  end
  return randcolors
end

local function SetRandColour(Obj,ChangeObjectColour)
  local colour = ChangeObjectColour.CodeFuncs.RandomColour()
  local SetPal = Obj.SetColorizationMaterial
  local GetPal = Obj.GetColorizationMaterial
  local c1,c2,c3,c4 = GetPal(Obj,1),GetPal(Obj,2),GetPal(Obj,3),GetPal(Obj,4)
  --likely can only change basecolour
  if Base or (c1 == 8421504 and c2 == 8421504 and c3 == 8421504 and c4 == 8421504) then
    Obj:SetColorModifier(colour)
  else
    if not Obj.ChangeObjectColour_origcolors then
      ChangeObjectColour.CodeFuncs.SaveOldPalette(Obj)
    end
    --s,1,Color, Roughness, Metallic
    SetPal(Obj, 1, ChangeObjectColour.CodeFuncs.RandomColour(), 0,0)
    SetPal(Obj, 2, ChangeObjectColour.CodeFuncs.RandomColour(), 0,0)
    SetPal(Obj, 3, ChangeObjectColour.CodeFuncs.RandomColour(), 0,0)
    SetPal(Obj, 4, ChangeObjectColour.CodeFuncs.RandomColour(), 0,0)
  end
end

function ChangeObjectColour.CodeFuncs.ObjectColourRandom(Obj,Base)
  if not Obj or Obj and not Obj:IsKindOf("ColorizableObject") then
    return
  end
  local ChangeObjectColour = ChangeObjectColour
  SetRandColour(Obj,ChangeObjectColour)
  local Attaches = Obj:GetAttaches() or empty_table
  for i = 1, #Attaches do
    SetRandColour(Attaches[i],ChangeObjectColour)
  end
--~   return colour
end

local function SetDefColour(Obj)
  Obj:SetColorModifier(6579300)
  if Obj.ChangeObjectColour_origcolors then
    local SetPal = Obj.SetColorizationMaterial
    local c = Obj.ChangeObjectColour_origcolors
    SetPal(Obj,1, c[1][1], c[1][2], c[1][3])
    SetPal(Obj,2, c[2][1], c[2][2], c[2][3])
    SetPal(Obj,3, c[3][1], c[3][2], c[3][3])
    SetPal(Obj,4, c[4][1], c[4][2], c[4][3])
  end
end

function ChangeObjectColour.CodeFuncs.ObjectColourDefault(Obj)
  if not Obj or Obj and not Obj:IsKindOf("ColorizableObject") then
    return
  end
  SetDefColour(Obj)
  local Attaches = Obj:GetAttaches() or empty_table
  for i = 1, #Attaches do
    SetDefColour(Attaches[i])
  end
end

function ChangeObjectColour.CodeFuncs.ChangeObjectColour(obj,Parent)
  local ChangeObjectColour = ChangeObjectColour
  if not obj or obj and not obj:IsKindOf("ColorizableObject") then
    ChangeObjectColour.ComFuncs.MsgPopup(T(302535920000015--[[Can't colour object--]]),T(302535920000016--[[Colour--]]))
    return
  end
  --SetPal(Obj,i,Color,Roughness,Metallic)
  local SetPal = obj.SetColorizationMaterial
  local pal = ChangeObjectColour.CodeFuncs.GetPalette(obj)

  local ItemList = {}
  for i = 1, 4 do
    local text = Concat("Color",i)
    ItemList[#ItemList+1] = {
      text = text,
      value = pal[text],
      hint = T(302535920000017--[[Use the colour picker (dbl right-click for instant change).--]]),
    }
    text = Concat("Metallic",i)
    ItemList[#ItemList+1] = {
      text = text,
      value = pal[text],
      hint = T(302535920000018--[[Don't use the colour picker: Numbers range from -255 to 255.--]]),
    }
    text = Concat("Roughness",i)
    ItemList[#ItemList+1] = {
      text = text,
      value = pal[text],
      hint = T(302535920000018--[[Don't use the colour picker: Numbers range from -255 to 255.--]]),
    }
  end
  ItemList[#ItemList+1] = {
    text = "X_BaseColour",
    value = 6579300,
    obj = obj,
    hint = T(302535920000019--[[single colour for object (this colour will interact with the other colours).\nIf you want to change the colour of an object you can't with 1-4 (like drones).--]]),
  }

  --callback
  local CallBackFunc = function(choice)
    if #choice == 13 then
      --keep original colours as part of object
      local base = choice[13].value
      --used to check for grid connections
      local CheckAir = choice[1].checkair
      local CheckWater = choice[1].checkwater
      local CheckElec = choice[1].checkelec
      --needed to set attachment colours
      local Label = obj.class
      local FakeParent
      if Parent then
        Label = Parent.class
        FakeParent = Parent
      else
        FakeParent = obj.parentobj
      end
      if not FakeParent then
        FakeParent = obj
      end
      --they get called a few times so
      local function SetOrigColours(Object)
        ChangeObjectColour.CodeFuncs.RestoreOldPalette(Object)
        --6579300 = reset base color
        Object:SetColorModifier(6579300)
      end
      local function SetColours(Object)
        ChangeObjectColour.CodeFuncs.SaveOldPalette(Object)
        for i = 1, 4 do
          local Color = choice[i].value
          local Metallic = choice[i+4].value
          local Roughness = choice[i+8].value
          SetPal(Object,i,Color,Roughness,Metallic)
        end
        Object:SetColorModifier(base)
      end
      --make sure we're in the same grid
      local function CheckGrid(Func,Object,Building)
        if CheckAir and Building.air and FakeParent.air and Building.air.grid.elements[1].building == FakeParent.air.grid.elements[1].building then
          Func(Object)
        end
        if CheckWater and Building.water and FakeParent.water and Building.water.grid.elements[1].building == FakeParent.water.grid.elements[1].building then
          Func(Object)
        end
        if CheckElec and Building.electricity and FakeParent.electricity and Building.electricity.grid.elements[1].building == FakeParent.electricity.grid.elements[1].building then
          Func(Object)
        end
        if not CheckAir and not CheckWater and not CheckElec then
          Func(Object)
        end
      end

      --store table so it's the same as was displayed
      table.sort(choice,
        function(a,b)
          return ChangeObjectColour.ComFuncs.CompareTableValue(a,b,"text")
        end
      )
      --All of type checkbox
      if choice[1].check1 then
        local tab = UICity.labels[Label] or empty_table
        for i = 1, #tab do
          if Parent then
            local Attaches = type(tab[i].GetAttaches) == "function" and tab[i]:GetAttaches(obj.class) or empty_table
            for j = 1, #Attaches do
              --if Attaches[j].class == obj.class then
                if choice[1].check2 then
                  CheckGrid(SetOrigColours,Attaches[j],tab[i])
                else
                  CheckGrid(SetColours,Attaches[j],tab[i])
                end
              --end
            end
          else --not parent
            if choice[1].check2 then
              CheckGrid(SetOrigColours,tab[i],tab[i])
            else
              CheckGrid(SetColours,tab[i],tab[i])
            end
          end --Parent
        end
      else --single building change
        if choice[1].check2 then
          CheckGrid(SetOrigColours,obj,obj)
        else
          CheckGrid(SetColours,obj,obj)
        end
      end

      ChangeObjectColour.ComFuncs.MsgPopup(Concat(T(302535920000020--[[Colour is set on--]])," ",obj.class),T(302535920000016--[[Colour--]]))
    end
  end
  ChangeObjectColour.ComFuncs.OpenInListChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = Concat(T(302535920000021--[[Change Colour--]]),": ",ChangeObjectColour.ComFuncs.RetName(obj)),
    hint = T(302535920000022--[[If number is 8421504 (0 for Metallic/Roughness) then you probably can't change that colour.\n\nThe colour picker doesn't work for Metallic/Roughness.\nYou can copy and paste numbers if you want (click item again after picking).--]]),
    multisel = true,
    custom_type = 2,
    check1 = T(302535920000023--[[All of type--]]),
    check1_hint = T(302535920000024--[[Change all objects of the same type.--]]),
    check2 = T(302535920000025--[[Default Colour--]]),
    check2_hint = T(302535920000026--[[if they're there; resets to default colours.--]]),
  })
end

