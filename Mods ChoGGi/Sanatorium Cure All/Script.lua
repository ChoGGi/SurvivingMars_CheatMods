local traits = {'Clone','Alcoholic','Glutton','Lazy','Refugee','ChronicCondition','Infected','Idiot','Hypochondriac','Whiner','Renegade','Melancholic','Introvert','Coward','Tourist','Gambler'}

function OnMsg.ConstructionComplete(building)
  if IsKindOf(building,"Sanatorium") then
    for i = 1, #traits do
      building:SetTrait(i, traits[i])
    end
  end
end

function OnMsg.LoadGame()
  --if you always want to show 16 traits in side pane
  --Sanatorium.max_traits = 16

  local buildings = UICity.labels.Building
  for i = 1, #(buildings or "") do
    local obj = buildings[i]
    if IsKindOf(obj,"Sanatorium") then
      for j = 1, #traits do
        obj:SetTrait(j, traits[j])
      end
    end
  end

  UserActions.AddActions({

    ["ToggleSanMenuFull"] = {
      mode = "Game",
      key = "F4",
      action = function()
        if Sanatorium.max_traits == 16 then
          Sanatorium.max_traits = 3
        elseif Sanatorium.max_traits == 3 then
          Sanatorium.max_traits = 16
        end
      end
    },
  })

end
