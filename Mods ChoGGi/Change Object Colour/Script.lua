function ChoGGiX.MsgPopup(Msg,Title,Icon)
  pcall(function()
    --returns translated text corresponding to number if we don't do tostring for numbers
    Msg = tostring(Msg)
    Title = Title or "Placeholder"
    Icon = Icon or "UI/Icons/Notifications/placeholder.tga"
    local id = AsyncRand()
    local timeout = 8000
    if type(AddCustomOnScreenNotification) == "function" then --if we called it where there ain't no UI
      CreateRealTimeThread(function()
        AddCustomOnScreenNotification(
          id,Title,Msg,Icon,nil,{expiration=timeout}
        )
        --since I use AsyncRand for the id, I don't want this getting too large.
        g_ShownOnScreenNotifications[id] = nil
      end)
    end
  end)
end

function OnMsg.LoadGame()

  --build n show a list of attaches for changing colour
  function ChoGGiX.CreateObjectListAndAttaches()
    local obj = SelectedObj or SelectionMouseObj()
    if not obj then
      return
    end
    local ItemList = {}

    --has no Attaches so just open as is
    if obj:GetNumAttaches() == 0 then
      ChoGGiX.ChangeObjectColour(obj)
      return
    else
      table.insert(ItemList,{
        text = " " .. obj.class,
        value = obj.class,
        obj = obj,
        hint = "Change main object colours."
      })
      local Attaches = obj:GetAttaches()
      for i = 1, #Attaches do
        table.insert(ItemList,{
          text = Attaches[i].class,
          value = Attaches[i].class,
          parentobj = obj,
          obj = Attaches[i],
          hint = "Change colours of a part of an object."
        })
      end
    end

    local CallBackFunc = function(choice)
      return
    end

    local hint = "Double click to open object/attachment to edit."
    ChoGGiX.FireFuncAfterChoice(CallBackFunc,ItemList,"Change Colour: " .. obj.class,hint,nil,nil,nil,nil,nil,1)
  end

  function ChoGGiX.ChangeObjectColour(obj,Parent)
    if not obj and not obj:IsKindOf("ColorizableObject") then
      ChoGGiX.MsgPopup("Can't colour object","Colour")
      return
    end
    --SetPal(Obj,i,Color,Roughness,Metallic)
    local SetPal = obj.SetColorizationMaterial
    local pal = ChoGGiX.GetPalette(obj)

    local ItemList = {}
    for i = 1, 4 do
      table.insert(ItemList,{
        text = "Colour " .. i,
        value = pal["Color" .. i],
        hint = "Use the colour picker (dbl-click for instant change).",
      })
      table.insert(ItemList,{
        text = "Metallic " .. i,
        value = pal["Metallic" .. i],
        hint = "Don't use the colour picker: Numbers range from -255 to 255.",
      })
      table.insert(ItemList,{
        text = "Roughness " .. i,
        value = pal["Roughness" .. i],
        hint = "Don't use the colour picker: Numbers range from -255 to 255.",
      })
    end
    table.insert(ItemList,{
      text = "X_BaseColour",
      value = 6579300,
      obj = obj,
      hint = "single colour for object (this colour will interact with the other colours).\nIf you want to change the colour of an object you can't with 1-4 (like drones).",
    })

    --callback
    local CallBackFunc = function(choice)
      if #choice == 13 then
        --keep original colours as part of object
        local base = choice[13].value
        --used to check for grid connections
        local CheckAir = ChoGGiX.ListChoiceCustomDialog_ColorCheckAir
        local CheckWater = ChoGGiX.ListChoiceCustomDialog_ColorCheckWater
        local CheckElec = ChoGGiX.ListChoiceCustomDialog_ColorCheckElec
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
          ChoGGiX.RestoreOldPalette(Object)
          --6579300 = reset base color
          Object:SetColorModifier(6579300)
        end
        local function SetColours(Object)
          ChoGGiX.SaveOldPalette(Object)
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
          if CheckAir and Building.air and FakeParent.air and Building.air.grid.elements[1].building.handle == FakeParent.air.grid.elements[1].building.handle then
            Func(Object)
          end
          if CheckWater and Building.water and FakeParent.water and Building.water.grid.elements[1].building.handle == FakeParent.water.grid.elements[1].building.handle then
            Func(Object)
          end
          if CheckElec and Building.electricity and FakeParent.electricity and Building.electricity.grid.elements[1].building.handle == FakeParent.electricity.grid.elements[1].building.handle then
            Func(Object)
          end
          if not CheckAir and not CheckWater and not CheckElec then
            Func(Object)
          end
        end

        --store table so it's the same as was displayed
        table.sort(choice,
          function(a,b)
            return ChoGGiX.CompareTableNames(a,b,"text")
          end
        )
        --All of type checkbox
        if ChoGGiX.ListChoiceCustomDialog_CheckBox1 then
          for _,building in ipairs(UICity.labels[Label] or empty_table) do
            if Parent then
              local Attaches = building:GetAttaches()
              for i = 1, #Attaches do
                if Attaches[i].class == obj.class then
                  if ChoGGiX.ListChoiceCustomDialog_CheckBox2 then
                    CheckGrid(SetOrigColours,Attaches[i],building)
                  else
                    CheckGrid(SetColours,Attaches[i],building)
                  end
                end
              end
            else --not parent
              if ChoGGiX.ListChoiceCustomDialog_CheckBox2 then
                CheckGrid(SetOrigColours,building,building)
              else
                CheckGrid(SetColours,building,building)
              end
            end --Parent
          end --for
        else --single building change
          if ChoGGiX.ListChoiceCustomDialog_CheckBox2 then
            CheckGrid(SetOrigColours,obj,obj)
          else
            CheckGrid(SetColours,obj,obj)
          end
        end

        ChoGGiX.MsgPopup("Colour is set on " .. obj.class,"Colour")
      end
    end
    local hint = "If number is 8421504 (0 for Metallic/Roughness) then you probably can't change that colour.\n\nThe colour picker doesn't work for Metallic/Roughness.\nYou can copy and paste numbers if you want (click item again after picking)."
    local hint_check1 = "Change all objects of the same type."
    local hint_check2 = "if they're there; resets to default colours."
    ChoGGiX.FireFuncAfterChoice(CallBackFunc,ItemList,"Change Colour: " .. obj.class,hint,true,"All of type",hint_check1,"Default Colour",hint_check2,2)
  end

  ChoGGiX.AddAction(
    "Expanded CM/Buildings/Change Colour",
    ChoGGiX.CreateObjectListAndAttaches,
    "F6",
    "Select a building to change the colour (of some buildings).",
    "toggle_dtm_slots.tga"
  )

end
