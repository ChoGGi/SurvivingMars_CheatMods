function ChoGGiX.SaveOldPalette(obj)
  local GetPal = obj.GetColorizationMaterial
  if not obj.ChoGGi_origcolors then
    obj.ChoGGi_origcolors = {}
    table.insert(obj.ChoGGi_origcolors,{GetPal(obj,1)})
    table.insert(obj.ChoGGi_origcolors,{GetPal(obj,2)})
    table.insert(obj.ChoGGi_origcolors,{GetPal(obj,3)})
    table.insert(obj.ChoGGi_origcolors,{GetPal(obj,4)})
  end
end
function ChoGGiX.RestoreOldPalette(obj)
  if obj.ChoGGi_origcolors then
    local c = obj.ChoGGi_origcolors
    local SetPal = obj.SetColorizationMaterial
    SetPal(obj,1, c[1][1], c[1][2], c[1][3])
    SetPal(obj,2, c[2][1], c[2][2], c[2][3])
    SetPal(obj,3, c[3][1], c[3][2], c[3][3])
    SetPal(obj,4, c[4][1], c[4][2], c[4][3])
    obj.ChoGGi_origcolors = nil
  end
end

function ChoGGiX.GetPalette(Obj)
  local get = Obj.GetColorizationMaterial
  local pal = {}
  pal.Color1, pal.Roughness1, pal.Metallic1 = get(Obj, 1)
  pal.Color2, pal.Roughness2, pal.Metallic2 = get(Obj, 2)
  pal.Color3, pal.Roughness3, pal.Metallic3 = get(Obj, 3)
  pal.Color4, pal.Roughness4, pal.Metallic4 = get(Obj, 4)
  return pal
end

function ChoGGiX.WaitListChoiceCustom(Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,CustomType)
  local dlg = ListChoiceCustomDialog:new()

  if not dlg then
    return
  end

  if ChoGGiX.Testing then
--easier to fiddle with it like this
ChoGGiX.ListChoiceCustomDialog_Dlg = dlg
  end

  --title text
  dlg.idCaption:SetText(Caption)
  --list
  dlg.idList:SetContent(Items)

  --fiddling with custom value
  if CustomType then
    dlg.idEditValue.auto_select_all = false
    dlg.CustomType = CustomType
    if dlg.CustomType == 2 then
      dlg.idColorHSV:SetVisible(true)
      dlg.idColorCheckAir:SetVisible(true)
      dlg.idColorCheckWater:SetVisible(true)
      dlg.idColorCheckElec:SetVisible(true)
      dlg:SetWidth(800)
      dlg.idList:SetSelection(1, true)
      dlg.sel = dlg.idList:GetSelection()[#dlg.idList:GetSelection()]
      dlg.idEditValue:SetText(tostring(dlg.sel.value))
      dlg:UpdateColourPicker()
    end
  end

  if MultiSel then
    dlg.idList.multiple_selection = true
    if type(MultiSel) == "number" then
      --select all of number
      for i = 1, MultiSel do
        dlg.idList:SetSelection(i, true)
      end
    end
  end

  --setup checkboxes
  if not Check1 and not Check2 then
    dlg.idCheckBox1:SetVisible(false)
    dlg.idCheckBox2:SetVisible(false)
  else
    dlg.idList:SetSize(point(390, 310))

    if Check1 then
      dlg.idCheckBox1:SetText(Check1)
      dlg.idCheckBox1:SetHint(Check1Hint)
    else
      dlg.idCheckBox1:SetVisible(false)
    end
    if Check2 then
      dlg.idCheckBox2:SetText(Check2)
      dlg.idCheckBox2:SetHint(Check2Hint)
    else
      dlg.idCheckBox2:SetVisible(false)
    end
  end
  --where to position dlg
  dlg:SetPos(terminal.GetMousePos())

  --focus on list
  dlg.idList:SetFocus()
  --dlg.idList:SetSelection(1, true)

  --are we showing a hint?
  if Hint then
    dlg.idList:SetHint(Hint)
    dlg.idOK:SetHint(dlg.idOK:GetHint() .. "\n\n\n" .. Hint)
  end

  --waiting for choice
  return dlg:Wait()
end

function ChoGGiX.FireFuncAfterChoice(Func,Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,CustomType)
  if not Func or not Items then
    return
  end

  --sort table by display text
  table.sort(Items,
    function(a,b)
      return ChoGGiX.CompareTableNames(a,b,"text")
    end
  )

  --only insert blank item if we aren't updating other items with it
  if not CustomType then
    --insert blank item for adding custom value
    table.insert(Items,{text = "",hint = "",value = false})
  end

  CreateRealTimeThread(function()
    local option = ChoGGiX.WaitListChoiceCustom(Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,CustomType)
    if option ~= "idClose" then
      Func(option)
    end
  end)
end
