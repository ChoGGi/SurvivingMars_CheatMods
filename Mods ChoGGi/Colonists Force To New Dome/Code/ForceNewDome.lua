local PopupToggle = ForceNewDome.ComFuncs.PopupToggle
local Concat = ForceNewDome.ComFuncs.Concat
local RetName = ForceNewDome.ComFuncs.RetName

local rawget = rawget
local XTemplates = XTemplates
local PlaceObj = PlaceObj
local GetObjects = GetObjects
local IsValid = IsValid
local ViewPos = ViewPos

local function ClickObj(old,new,button)
  --skip selected dome
  if not old or not IsValid(new) then
    return
  end
  if button == "L" then
    local c = old.labels.Colonist
    for i = #c, 1, -1 do
      c[i]:SetDome(new)
    end
  elseif button == "R" then
    ViewObjectMars(new)
  end
end

local function ListBuildings(parent,dome)
  local domes = UICity.labels.Dome or empty_table

  local ItemList = {}

  --make it pretty
  for i = 1, #domes do
    --skip ruined domes, and self
    if domes[i].air and domes[i].handle ~= dome.handle then
      local pos = domes[i]:GetVisualPos()
      ItemList[#ItemList+1] = {
        pos = pos,
        name = RetName(domes[i]),
        class = "XTextButton",
        hint = Concat(
          "Position: ",
          pos,
          "\n\nColonists: ",
          #domes[i].labels.Colonist or empty_table,
          "\n\nLiving Spaces: ",
          domes[i]:GetLivingSpace() or 0
        ), -- provide a slight reference
        clicked = function(_,_,button)
          ClickObj(dome,domes[i],button)
        end,
      }
    end
  end

  if #ItemList == 0 then
    return
  end

  --add controller for ease of movement
  ItemList[#ItemList+1] = {
    name = [[ Current Dome]],
    pos = dome:GetVisualPos(),
    class = "XTextButton",
    hint = [[Currently selected dome]],
    clicked = function(_,_,button)
      ClickObj(false,dome,button)
    end,
  }

  local popup = rawget(terminal.desktop, "idForceNewDomeMenu")
  if popup then
    popup:Close()
  else
    PopupToggle(parent,"idForceNewDomeMenu",ItemList)
  end

end

function OnMsg.ClassesBuilt()

  --don't add if button already added
  if not XTemplates.sectionDome.ChoGGi_ForceNewDome then
    XTemplates.sectionDome.ChoGGi_ForceNewDome = true

    XTemplates.sectionDome[1][#XTemplates.sectionDome[1]+1] = PlaceObj("XTemplateTemplate", {
      "ChoGGi_ForceNewDome", true,
--~       "__context_of_kind", "Building",
      "__template", "InfopanelSection",
      -- skip any ruined domes
      "__condition", function (parent, context) return context.air end,
      "RolloverTitle", " ",
      "RolloverHint",  "",
      "Title",  "Force New Dome",
      "RolloverText",  "Use this to force colonists to migrate.",
      "Icon",  "UI/Icons/bmc_domes_shine.tga",
    }, {
      PlaceObj("XTemplateFunc", {
        "name", "OnActivate(self, context)",
        "parent", function(parent, context)
          return parent.parent
        end,
        "func", function(self, context)
          ---
          ListBuildings(self, context)
          ---
        end
      })
    })

  end --if

end --OnMsg
