-- See LICENSE for terms

local sorted_pairs = sorted_pairs
local T = T
local TraitPresets = TraitPresets

local stat = "<newline><name> <em><amount></em>"

local function UpdateColour(amount)
	if amount > 75 then
		return "<color -6881386>" .. amount .. "</color>"
	elseif amount < 50 then
		return "<color -26986>" .. amount .. "</color>"
	else
		return "<color -70278>" .. amount .. "</color>"
	end
end

local cached_workers = {}
function OnMsg.SelectionChange()
	cached_workers = {}
end

local ChoOrig_XRecreateRolloverWindow = XRecreateRolloverWindow
function XRecreateRolloverWindow(win, ...)
	local colonist = win.context
	local workplace = SelectedObj

	if IsKindOf(colonist, "Colonist") and workplace == colonist.workplace then
		if cached_workers[colonist] then
			win.RolloverText = cached_workers[colonist]
		else
			local text = {
				win.RolloverText,
				T("\n\nDome: <em>"), colonist:GetDomeDisplayName(), T("</em>\n"),
				T{stat, name = T(4291--[[Health]]),
					amount = UpdateColour(colonist:GetHealth() or 0),
				},
				T{stat, name = T(4293--[[Sanity]]),
					amount = UpdateColour(colonist:GetSanity() or 0),
				},
				T{stat, name = T(4295--[[Comfort]]),
					amount = UpdateColour(colonist:GetComfort() or 0),
				},
				T{stat, name = T(4297--[[Morale]]),
					amount = UpdateColour(colonist:GetMorale() or 0),
				},
				"\n",
			}
			local c = #text

			-- add info from my spec by exp mod
			if workplace.ChoGGi_SpecByExp then
				c = c + 1
				text[c] = T{0000, "<newline><color -6881386>Spec by Exp</color> Sols trained: <em><time></em><newline>",
					time = UIColony.day - workplace.ChoGGi_SpecByExp[colonist.handle].started_on,
				}
			end

			-- Build traits list
			for trait_id in sorted_pairs(colonist.traits) do
				local trait = TraitPresets[trait_id]
				if trait and trait.show_in_traits_ui then
					local extra_info = ""
					-- neg traits
					if trait_id == "Alcoholic" then
						extra_info = T(4283--[[Worker performance]]) .. ": " .. trait.modify_amount
					elseif trait_id == "ChronicCondition" then
						extra_info = T(4291--[[Health]]) .. " -" .. trait.param .. " Daily"
					elseif trait_id == "DustSickness" then
						extra_info = T(4291--[[Health]]) .. " -" .. trait.param .. " "
							.. T(4144--[[Dust Storms]])
					elseif trait_id == "Glutton" then
						extra_info = T(1022--[[Food]]) .. " *2"
					elseif trait_id == "Hypochondriac" then
						extra_info = T(4293--[[Sanity]]) .. " -" .. trait.param .. " "
							.. T(9428--[[Skip]]) .. " " .. T(90--[[Visit]])
					elseif trait_id == "Infected" then
						extra_info = T(4291--[[Health]]) .. " -" .. trait.param .. " Daily"
					elseif trait_id == "Introvert" then
						-- lua rev 1011166
						-- 4 comes from function Residence:Service(unit, duration)
						extra_info = T(4295--[[Comfort]]) .. " -4 Daily"
					elseif trait_id == "Melancholic" then
						-- Consts.LowStatLevel = 30000
						extra_info = T(4297--[[Morale]]) .. " < 30: "
							.. T(4283--[[Worker performance]]) .. " -" .. trait.param
					elseif trait_id == "Whiner" then
						-- Consts.LowStatLevel = 30000
						extra_info = T(4295--[[Comfort]]) .. " < 30: " .. T(4293--[[Sanity]])
							.. " -" .. trait.param .. " Daily"

					-- pos traits
					elseif trait_id == "Celebrity" then
						-- Consts.HighStatLevel = 70
						extra_info = T(4295--[[Comfort]]) .. " > 70: " .. T(3613--[[Funding]])
							.. " +" .. RomanNumeral(trait.param) .. " Daily"
					elseif trait_id == "Empath" then
						extra_info = T(4297--[[Morale]]) .. " +" .. trait.modify_amount
					elseif trait_id == "Enthusiast" then
						-- Consts.HighStatLevel = 70000
						extra_info = T(4297--[[Morale]]) .. " > 70: "
							.. T(4283--[[Worker performance]]) .. " +" .. trait.param
					elseif trait_id == "Extrovert" then
						-- Consts.ExtrovertIncreaseComfortThreshold = 20000
						extra_info = T(692952504653--[[Dome]]) .. " " .. T(547--[[Colonists]])
							.. " > 30: " .. T(4295--[[Comfort]]) .. " + 20"
					elseif trait_id == "Fit" then
						extra_info = T(4291--[[Health]]) .. " +" .. trait.modify_amount .. " Daily"
					elseif trait_id == "Gamer" then
						extra_info = T(4293--[[Sanity]]) .. " +" .. trait.param
					elseif trait_id == "Genius" then
						-- Consts.HighStatLevel = 70000
						extra_info = T(4293--[[Sanity]]) .. " > 70: " .. T(311--[[Research]])
							.. " +" .. trait.param
					elseif trait_id == "Nerd" then
						-- lua rev 1011166
						-- Lua\Traits.lua > function OnMsg.TechResearched(tech_id, research) = 3 days
						extra_info = T(12153--[[New technologies]]) .. ": " .. T(4297--[[Morale]])
							.. " +" .. trait.param .. " @ 3 " .. T(3779--[[Sols]])
					elseif trait_id == "Religious" then
						extra_info = T(4285--[[Base Morale boost]]) .. ": +" .. trait.modify_amount
					elseif trait_id == "Saint" then
						extra_info = T(692952504653--[[Dome]]) .. " "
							.. T(4285--[[Base Morale boost]]) .. ": +" .. trait.modify_amount
					elseif trait_id == "Sexy" then
						extra_info = T(132876640303--[[Baby Volcano]]) .. ": +"
							.. trait.modify_amount .. "%"
					elseif trait_id == "Survivor" then
						extra_info = T(4291--[[Health]]) .. " loss: -" .. trait.param

					-- other traits
					elseif trait_id == "Dreamer" then
						-- Consts.MysteryDreamSanityDamage = 500
						extra_info = T(6975--[[Sanity damage for Dreamers from Mirages (per hour)]])
							.. " -0.5"
					elseif trait_id == "Guru" then
						extra_info = T(3720--[[Trait]]) .. " spread chance: " .. trait.param
							.. "%"
					elseif trait_id == "Refugee" then
						extra_info = T(4283--[[Worker performance]]) .. ": " .. trait.modify_amount
							.. ", " .. T(4368--[[Renegade]]) .. " chance: " .. trait.param	.. "%"
					-- extra_info end
					end

					c = c + 1
					text[c] = T{"<newline><em><trait></em>: <descr> <grey><extra_info></grey><newline>",
						trait = trait.display_name,
						descr = trait.description,
						extra_info = extra_info,
					}
				end
			end

			-- All done
			local safe_data
			-- pcall in case concat finds something it doesn't like
			pcall(function()
				safe_data = table.concat(text)
			end)

			if safe_data then
				cached_workers[colonist] = safe_data
			end

			win.RolloverText = safe_data or win.RolloverText
		end
	end

	return ChoOrig_XRecreateRolloverWindow(win, ...)
end
