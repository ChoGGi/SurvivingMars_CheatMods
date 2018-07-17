function OnMsg.ClassesBuilt()

  local XTemplates = XTemplates
  -- check if the buttons were already added (you can have one for each, but meh)
  if not XTemplates.ipSubsurfaceDeposit.ChoGGi_MultipleAMount then
    XTemplates.ipSubsurfaceDeposit.ChoGGi_MultipleAMount = true

    XTemplates.ipSubsurfaceDeposit[1][#XTemplates.ipSubsurfaceDeposit[1]+1] = PlaceObj("XTemplateTemplate", {
      "ChoGGi_MultipleAmount", true,
      "__template", "InfopanelButton",
      "Icon", "UI/Icons/Sections/Metals_2.tga",
      "Title", "5 Times the amount",
      "RolloverText", "Clicking this once will add 5 times the amount of stored resources.",
      "RolloverTitle", "",
      "RolloverHint",  "",
      "OnPress", function()
        ---
        local objs = GetObjects{class="SubsurfaceDeposit"} or empty_table
        for i = 1, #objs do
          -- bump the amounts
          objs[i].max_amount = objs[i].max_amount * 5
          -- and fill them up
          objs[i]:CheatRefill()
          -- just for you XxUnkn0wnxX
          objs[i].grade = "Very High"
        end
        ---
      end,
    })

  end

end