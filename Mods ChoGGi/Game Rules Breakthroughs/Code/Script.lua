-- See LICENSE for terms

local options
local mod_BreakthroughsResearched

-- fired when settings are changed and new/load
local function ModOptions()
	mod_BreakthroughsResearched = options.BreakthroughsResearched
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_GameRulesBreakthroughs" then
		return
	end

	ModOptions()
end

local _InternalTranslate = _InternalTranslate
local T = T
local PlaceObj = PlaceObj

local function SafeTrans(...)
	local varargs = ...
	local str
	pcall(function()
		str = _InternalTranslate(T(varargs))
	end)
	return str or "Missing string... Nope just needs UICity which isn't around till the game starts (ask the devs)."
end

function OnMsg.ClassesPostprocess()
	if GameRulesMap.ChoGGi_AdvancedDroneDrive then
		return
	end

	-- sort by id
	local breaks = table.icopy(Presets.TechPreset.Breakthroughs)
	table.sort(breaks, function(a, b)
		return a.id < b.id
	end)

	for i = 1, #breaks do
		local def = breaks[i]
		PlaceObj("GameRules", {
			description = SafeTrans{def.description, def},
			display_name = SafeTrans(11451--[[Breakthrough]]) .. ": " .. SafeTrans(def.display_name),
			group = "Default",
			id = "ChoGGi_" .. def.id,
			PlaceObj("Effect_Code", {
				OnApplyEffect = function(_, city)
					if mod_BreakthroughsResearched then
						city:SetTechResearched(def.id)
					else
						city:SetTechDiscovered(def.id)
					end
				end
			}),
		})
	end

end
