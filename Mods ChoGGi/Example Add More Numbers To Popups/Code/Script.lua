-- See LICENSE for terms

local icon_8min_str = "UI/Icons/Buildings/numbers_0%s.tga"
local icon_9_str = string.format("%sUI/numbers_0%s.png",CurrentModPath,"%s")
local icon_10plus_str = string.format("%sUI/numbers_%s.png",CurrentModPath,"%s")

function FillTraitSelectorItems(object, items, traits, align, list)
  local start = #items
  for i = 1, #traits do
    local trait = TraitPresets[traits[i].value]
    if IsTraitAvailable(trait, object.city) then

			-- one little zero...
--~       local icon = "UI/Icons/Buildings/numbers_0" .. start + i .. ".tga"

      local icon
			local num = start + i
			if num < 9 then
				icon = icon_8min_str:format(num)
			elseif num == 9 then
				icon = icon_9_str:format(num)
			else
				icon = icon_10plus_str:format(num)
			end


      local enabled = trait.id ~= object.trait1 and trait.id ~= object.trait2 and trait.id ~= object.trait3
      table.insert(items, HexButtonInfopanel:new({
        ButtonAlign = align,
        name = trait.id,
        icon = icon,
        display_name = trait.display_name,
        description = trait.description,
        hint = enabled and T({
          988789013053,
          "<left_click> Change<newline><em>Ctrl + <left_click> on trait</em> Select in all <display_name_pl>",
          object
        }) or false,
        gamepad_hint = enabled and T({
          958322390788,
          "<ButtonA> Change<newline><em><ButtonX> on trait</em> Select in all <display_name_pl>",
          object
        }) or false,
        enabled = enabled,
        action = function(dataset, delta, controller)
          if not IsValid(dataset.object) then
            return
          end
          local broadcast = controller and delta < 0 or not controller and IsMassUIModifierPressed()
          dataset.object:SetTrait(dataset.idx, trait.id, broadcast)
        end
      }, list))
      align = align == "top" and "bottom" or "top"
    else
    end
  end
  return align
end
