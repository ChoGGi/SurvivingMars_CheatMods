function OnMsg.ClassesBuilt()
  --local is faster then global
  local XTemplates = XTemplates
  local ObjModified = ObjModified
  local PlaceObj = PlaceObj

  --check if it was already added
  if not XTemplates.ipResourceOverview.SOMETHINGUNIQUE then
    XTemplates.ipResourceOverview.SOMETHINGUNIQUE = true

    --this adds a button that changes depending on Object.working (a building that works...)
    XTemplates.ipResourceOverview[#XTemplates.ipResourceOverview+1] = PlaceObj("XTemplateTemplate", {
    --use OpenExamine(XTemplates) to see the complete list (and check that yours was added).
    --and https://github.com/HaemimontGames/SurvivingMars/tree/master/Lua/XTemplates

      --added to the resource overview panel
      "__context_of_kind", "ResourceOverview",
      --?
      "__template", "InfopanelActiveSection",

      --you can set these here or in OnContextUpdate below
      "Icon", " ",
      "Title", " ",
      "RolloverText", " ",

      "RolloverTitle", "Telepresence",
      "RolloverHint",  "",
      "OnContextUpdate", function(self, context)
        -- context is the object selected
        if context.working then
          self:SetRolloverText("This building is working.")
          self:SetTitle("Working")
          self:SetIcon("UI/Icons/Upgrades/factory_ai_03.tga")
        else
          self:SetRolloverText("This building isn't working.")
          self:SetTitle("Not Working")
          self:SetIcon("UI/Icons/Upgrades/factory_ai_01.tga")
        end
        ---
      end,
    }, {
      PlaceObj("XTemplateFunc", {
        "name", "OnActivate(self, context)",
        "parent", function(parent, context)
          return parent.parent
        end,
        "func", function(self, context)
          ---
          if context.working then
            --do something on a working building
          else
            --and a not working building
          end

          --if you modified a value then use this, if not remove
          ObjModified(context)

        end
      })
    })

    --slider added to all workplaces to adjust number of workers allowed
    XTemplates.sectionWorkplace[#XTemplates.sectionWorkplace+1] = PlaceObj("XTemplateTemplate", {
      "__context_of_kind", "Workplace",
      "__template", "InfopanelSection",
      "RolloverText", "",
      "RolloverHintGamepad", "",
      "Title", " ", --updated below, can't be blank
      "Icon", "UI/Icons/Sections/facility.tga",
    }, {
      PlaceObj("XTemplateTemplate", {
        "__template", "InfopanelSlider",
        "BindTo", "max_workers",
				'StepSize', 5, --change 5 per movement
        "OnContextUpdate", function(self, context)
          self.parent.parent:SetTitle("Change \"max_workers\" limit: " .. context.max_workers)
        end
      })
    })

  end

end
