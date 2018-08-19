local T = LockWorkplace.ComFuncs.Trans
local RetName = LockWorkplace.ComFuncs.RetName

local string = string

local PlaceObj = PlaceObj
local XTemplates = XTemplates
local ObjModified = ObjModified

local function LoopWorkplace(context,which)
  for i = 1, #context.workers do
    for j = 1, #context.workers[i] do
      local c = context.workers[i][j]
      c.ChoGGi_Lockworkplace = which
    end
  end
end

function OnMsg.ClassesBuilt()
  --add button to colonists

  if not XTemplates.ipColonist.ChoGGi_Lockworkplace then
    XTemplates.ipColonist.ChoGGi_Lockworkplace = true

    --add button to colonists
    XTemplates.ipColonist[1][#XTemplates.ipColonist[1]+1] = PlaceObj("XTemplateTemplate", {
      "ChoGGi_LockworkplaceColonist", true,
      "__context_of_kind", "Colonist",
      "__template", "InfopanelActiveSection",
      "RolloverTitle","",
      "RolloverHint",  "",
      "OnContextUpdate", function(self, context)
        ---
        -- hide button if not working, and make sure to remove the lock (just in case)
        if context.workplace and not context.workplace:IsKindOf("TrainingBuilding") then
          self:SetVisible(true)
          self:SetMaxHeight()
        else
          self:SetMaxHeight(0)
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

    --add button to workplaces
    XTemplates.sectionWorkplace[#XTemplates.sectionWorkplace+1] = PlaceObj("XTemplateTemplate", {
      "ChoGGi_LockworkplaceWorkplace", true,
      "__context_of_kind", "Workplace",
      "__template", "InfopanelActiveSection",
      "RolloverTitle","",
      "RolloverHint",  "",
      "OnContextUpdate", function(self, context)
        ---
        if context.ChoGGi_Lockworkplace then
          self:SetRolloverText([[Remove the lock on this workplace.]])
          self:SetTitle([[Unlock Workers]])
          self:SetIcon("UI/Icons/traits_approve.tga")
        else
          self:SetRolloverText([[Lock all workers to this workplace (if more workers are added you'll need to toggle this or lock each of them).]])
          self:SetTitle([[Lock Workers]])
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
            LoopWorkplace(context)
          else
            context.ChoGGi_Lockworkplace = true
            LoopWorkplace(context,true)
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
