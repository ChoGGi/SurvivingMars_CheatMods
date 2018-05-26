function ChoGGiX.CodeFuncs.ViewAndSelectObject(Obj)
  ViewPos(Obj:GetVisualPos())
  SelectObj(Obj)
end

function ChoGGiX.CodeFuncs.WaitListChoiceCustom(Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,CustomType,CustomFunc)
  local ChoGGiX = ChoGGiX
  local dlg = ChoGGiX_ListChoiceCustomDialog:new()

  if not dlg then
    return
  end

  --title text
  dlg.idCaption:SetText(Caption)
  --list
  dlg.idList:SetContent(Items)

  --fiddling with custom value
  if CustomType then
    dlg.idEditValue.auto_select_all = false
    dlg.CustomType = CustomType
    if CustomType == 2 or CustomType == 5 then
      dlg.idList:SetSelection(1, true)
      dlg.sel = dlg.idList:GetSelection()[#dlg.idList:GetSelection()]
      dlg.idEditValue:SetText(tostring(dlg.sel.value))
      dlg:UpdateColourPicker()
      if CustomType == 2 then
        dlg:SetWidth(800)
        dlg.idColorHSV:SetVisible(true)
        dlg.idColorCheckAir:SetVisible(true)
        dlg.idColorCheckWater:SetVisible(true)
        dlg.idColorCheckElec:SetVisible(true)
      end
    end
  end

  if CustomFunc then
    dlg.Func = CustomFunc
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

function ChoGGiX.CodeFuncs.FireFuncAfterChoice(Func,Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,CustomType,CustomFunc)
  local ChoGGiX = ChoGGiX
  if not Func or not Items then
    return
  end

  --sort table by display text
  local sortby = "text"
  if CustomType == 5 then
    sortby = "sort"
  end
  table.sort(Items,
    function(a,b)
      return ChoGGiX.ComFuncs.CompareTableValue(a,b,sortby)
    end
  )

  --only insert blank item if we aren't updating other items with it
  if not CustomType then
    --insert blank item for adding custom value
    Items[#Items+1] = {text = "",hint = "",value = false}
  end

  CreateRealTimeThread(function()
    local option = ChoGGiX.CodeFuncs.WaitListChoiceCustom(Items,Caption,Hint,MultiSel,Check1,Check1Hint,Check2,Check2Hint,CustomType,CustomFunc)
    if option ~= "idClose" then
      Func(option)
    end
  end)
end

function ChoGGiX.CodeFuncs.Trans(...)
  local data = select(1,...)
  if type(data) == "userdata" then
    return _InternalTranslate(...)
  end
  return _InternalTranslate(T({...}))
end
