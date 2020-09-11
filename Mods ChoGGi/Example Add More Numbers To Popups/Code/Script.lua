-- See LICENSE for terms

-- local some globals
local table_insert = table.insert
local T = T
local IsTraitAvailable = IsTraitAvailable
local IsValid = IsValid
local IsMassUIModifierPressed = IsMassUIModifierPressed

local orig_FillTraitSelectorItems = FillTraitSelectorItems
function FillTraitSelectorItems(object, items, traits, align, list, ...)
	local traits_c = #traits

	-- If there's only 9 then return orig func instead of my possibly out of date func
	if traits_c < 10 then
		return orig_FillTraitSelectorItems(object, items, traits, align, list, ...)
	end

	local path_str = CurrentModPath .. "UI/numbers_"

	local TraitPresets = TraitPresets
	local HexButtonInfopanel = HexButtonInfopanel

	local start = #items
	for i = 1, traits_c do
		local trait = TraitPresets[traits[i].value]
		if IsTraitAvailable(trait, object.city) then

			local icon
			local num = start + i
			-- sm includes 01-09
			if num < 10 then
				icon = "UI/Icons/Buildings/numbers_0" .. num .. ".tga"
			else
				icon = path_str .. num .. ".png"
			end

			local enabled = trait.id ~= object.trait1 and trait.id ~= object.trait2 and trait.id ~= object.trait3
			table_insert(items, HexButtonInfopanel:new({
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
		end
	end

	return align
end
