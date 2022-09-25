-- See LICENSE for terms

local sorted_pairs = sorted_pairs
local T = T

local stat = "<newline><name> <em><amount></em>"
local c

local function UpdateColour(amount)
	if amount > 75 then
		return "<color -6881386>" .. amount .. "</color>"
	elseif amount < 50 then
		return "<color -26986>" .. amount .. "</color>"
	else
		return "<color -3618666>" .. amount .. "</color>"
	end
end

local ChoOrig_XRecreateRolloverWindow = XRecreateRolloverWindow
function XRecreateRolloverWindow(win, ...)
	local context = win.context
	if IsKindOf(context, "Colonist") and SelectedObj == context.workplace then
		local text = {
			win.RolloverText, "\n",
			T{stat, name = T(4291, "Health"), amount = UpdateColour(context:GetHealth() or 0)},
			T{stat, name = T(4293, "Sanity"), amount = UpdateColour(context:GetSanity() or 0)},
			T{stat, name = T(4295, "Comfort"), amount = UpdateColour(context:GetComfort() or 0)},
			T{stat, name = T(4297, "Morale"), amount = UpdateColour(context:GetMorale() or 0)},
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
			safe_data = table.concat(text)
		end)
		win.RolloverText = safe_data or win.RolloverText
	end

	return ChoOrig_XRecreateRolloverWindow(win, ...)
end
