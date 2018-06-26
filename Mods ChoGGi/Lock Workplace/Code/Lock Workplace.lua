local T = LockWorkplace.ComFuncs.Trans
local RetName = LockWorkplace.ComFuncs.RetName

function OnMsg.ClassesBuilt()
  --add button to colonists
  local XTemplates = XTemplates

  if not XTemplates.ipColonist.ChoGGi_Lockworkplace then
    XTemplates.ipColonist.ChoGGi_Lockworkplace = true

    XTemplates.ipColonist[1][#XTemplates.ipColonist[1]+1] = PlaceObj("XTemplateTemplate", {
      "__context_of_kind", "Colonist",
      "__template", "InfopanelActiveSection",
--~       "Icon", "",
--~       "Title", "",
--~       "RolloverText", "",
      "RolloverTitle","",
      "RolloverHint",  "",
      "OnContextUpdate", function(self, context)
        ---
        -- hide button if not working, and make sure to remove the lock (just in case)
        if context.workplace then
          self:SetVisible(true)
        else
          self:SetVisible()
          context.ChoGGi_Lockworkplace = nil
        end

        if context.ChoGGi_Lockworkplace then
          self:SetRolloverText([[Remove the lock on this colonist.]])
          self:SetTitle([[Unlock Workplace]])
          self:SetIcon("UI/Icons/traits_approve.tga")
        else
          self:SetRolloverText(string.format([[Lock this colonist to always work at %s.]],RetName(context.workplace)))
          self:SetTitle([[Lock Workplace]])
          self:SetIcon("UI/Icons/traits_disapprove.tga")
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
          if context.ChoGGi_Lockworkplace then
            context.ChoGGi_Lockworkplace = nil
          else
            context.ChoGGi_Lockworkplace = true
          end
          ---
          ObjModified(context)
        end
      })
    })
  end

  --make the value the button sets actually do something
  local orig_Colonist_SetWorkplace = Colonist.SetWorkplace
  function Colonist:SetWorkplace(building, shift)
    if building and self.ChoGGi_Lockworkplace then
--~     if self.ChoGGi_Lockworkplace then
      return
    end
    --we only fire the func if the lock isn't there, yeah i'm sure this won't cause any issues :)
    return orig_Colonist_SetWorkplace(self, building, shift)
  end

end
