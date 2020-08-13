-- See LICENSE for terms

local sorted_pairs = sorted_pairs
local IsKindOf = IsKindOf
local table_concat = table.concat
local T = T
local pcall = pcall

local stat = "<newline><name> <em><amount></em>"
local c

local orig_XRecreateRolloverWindow = XRecreateRolloverWindow
function XRecreateRolloverWindow(win, ...)
	local context = win.context
	if IsKindOf(context, "Colonist") and SelectedObj == context.workplace then
		local text = {
			win.RolloverText, "\n",
			T{stat, name = T(4291, "Health"), amount = context:GetHealth() or 0},
			T{stat, name = T(4293, "Sanity"), amount = context:GetSanity() or 0},
			T{stat, name = T(4295, "Comfort"), amount = context:GetComfort() or 0},
			T{stat, name = T(4297, "Morale"), amount = context:GetMorale() or 0},
			"\n",
		}
		-- build traits list
		c = #text
		local TraitPresets = TraitPresets
		for trait_id in sorted_pairs(context.traits) do
			local trait = TraitPresets[trait_id]
			if trait and trait.show_in_traits_ui then
				c = c + 1
				text[c] = T{4384, "<newline><em><trait></em>: <descr><newline>", trait = trait.display_name, descr = trait.description}
			end
		end

		-- all done
		local safe_data
		pcall(function()
			safe_data = table_concat(text)
		end)
		win.RolloverText = safe_data or win.RolloverText
	end

	return orig_XRecreateRolloverWindow(win, ...)
end
