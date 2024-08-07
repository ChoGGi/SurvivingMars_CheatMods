-- See LICENSE for terms

local sorted_pairs = sorted_pairs
local T = T
local _it = _InternalTranslate
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

local cached_trait_info
local function BuildCachedTraitInfo()
	local t = TraitPresets

	local info = {}

-- neg traits

	info.Alcoholic = _it(T(4283--[[Worker performance]])) .. ": "
		.. t.Alcoholic.modify_amount
	info.ChronicCondition = _it(T(4291--[[Health]])) .. " -"
		.. t.ChronicCondition.param .. " Daily"
	info.DustSickness = _it(T(4291--[[Health]])) .. " -"
		.. t.DustSickness.param .. " " .. _it(T(4144--[[Dust Storms]]))
	info.Glutton = _it(T(1022--[[Food]])) .. " *2"
	info.Hypochondriac = _it(T(4293--[[Sanity]])) .. " -"
		.. t.Hypochondriac.param .. " " .. _it(T(9428--[[Skip]])) .. " "
		.. _it(T(90--[[Visit]]))
	info.Infected = _it(T(4291--[[Health]])) .. " -" .. t.Infected.param .. " Daily"
	-- lua rev 1011166
	-- 4 comes from function Residence:Service(unit, duration)
	info.Introvert = _it(T(4295--[[Comfort]])) .. " -4 Daily"
	-- Consts.LowStatLevel = 30000
	info.Melancholic = _it(T(4297--[[Morale]])) .. " < 30: "
		.. _it(T(4283--[[Worker performance]])) .. " -" .. t.Melancholic.param
	-- Consts.LowStatLevel = 30000
	info.Whiner = _it(T(4295--[[Comfort]])) .. " < 30: " .. _it(T(4293--[[Sanity]]))
			.. " -" .. t.Whiner.param .. " Daily"

-- pos traits

	-- Consts.HighStatLevel = 70
	info.Celebrity = _it(T(4295--[[Comfort]])) .. " > 70: " .. _it(T(3613--[[Funding]]))
		.. " +" .. RomanNumeral(t.Celebrity.param) .. " Daily"
	info.Empath = _it(T(4297--[[Morale]])) .. " +" .. t.Empath.modify_amount
	-- Consts.HighStatLevel = 70000
	info.Enthusiast = _it(T(4297--[[Morale]])) .. " > 70: "
		.. _it(T(4283--[[Worker performance]])) .. " +" .. t.Enthusiast.param
	-- Consts.ExtrovertIncreaseComfortThreshold = 20000
	info.Extrovert = _it(T(692952504653--[[Dome]])) .. " " .. _it(T(547--[[Colonists]]))
		.. " > 30: " .. _it(T(4295--[[Comfort]])) .. " + 20"
	info.Fit = _it(T(4291--[[Health]])) .. " +" .. t.Fit.modify_amount .. " Daily"
	info.Gamer = _it(T(4293--[[Sanity]])) .. " +" .. t.Gamer.param
	-- Consts.HighStatLevel = 70000
	info.Genius = _it(T(4293--[[Sanity]])) .. " > 70: " .. _it(T(311--[[Research]]))
		.. " +" .. t.Genius.param
	-- lua rev 1011166
	-- Lua\Traits.lua > function OnMsg.TechResearched(tech_id, research) = 3 days
	info.Nerd = _it(T(12153--[[New technologies]])) .. ": " .. _it(T(4297--[[Morale]]))
		.. " +" .. t.Nerd.param .. " @ 3 " .. _it(T(3779--[[Sols]]))
	info.Religious = _it(T(4285--[[Base Morale boost]])) .. ": +" .. t.Religious.modify_amount
	info.Saint = _it(T(692952504653--[[Dome]])) .. " "
		.. _it(T(4285--[[Base Morale boost]])) .. ": +" .. t.Saint.modify_amount
	info.Sexy = _it(T(132876640303--[[Baby Volcano]])) .. ": +"
		.. t.Sexy.modify_amount .. "%"
	info.Survivor = _it(T(4291--[[Health]])) .. " loss: -" .. t.Survivor.param

-- other traits

	-- Consts.MysteryDreamSanityDamage = 500
	info.Dreamer = _it(T(6975--[[Sanity damage for Dreamers from Mirages (per hour)]]))
		.. " -0.5"
	info.Guru = _it(T(3720--[[Trait]])) .. " spread chance: " .. t.Guru.param
		.. "%"
	info.Refugee = _it(T(4283--[[Worker performance]])) .. ": " .. t.Refugee.modify_amount
		.. ", " .. _it(T(4368--[[Renegade]])) .. " chance: " .. t.Refugee.param	.. "%"

	cached_trait_info = info
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
		-- Build list of trait info
		if not cached_trait_info then
			BuildCachedTraitInfo()
		end

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

					c = c + 1
					text[c] = T{"<newline><em><trait></em>: <descr> <grey><extra_info></grey><newline>",
						trait = trait.display_name,
						descr = trait.description,
						extra_info = cached_trait_info[trait_id] or "",
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
