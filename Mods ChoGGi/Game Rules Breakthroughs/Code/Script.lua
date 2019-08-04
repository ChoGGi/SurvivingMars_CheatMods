-- See LICENSE for terms

local options
local mod_BreakthroughsResearched

-- fired when settings are changed/init
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

local T = T
local _InternalTranslate = _InternalTranslate
local procall = procall

local function SafeTrans(...)
	local varargs = ...
	local str
	procall(function()
		str = _InternalTranslate(T(varargs))
	end)
	return str or T(302535920011424, "Missing text... Nope just needs UICity which isn't around till the game starts (ask the devs).")
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

	local PlaceObj = PlaceObj
	for i = 1, #breaks do
		local def = breaks[i]
		PlaceObj("GameRules", {
			description = SafeTrans{def.description, def},
			display_name = T(11451, "Breakthrough") .. ": " .. T(def.display_name),
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

-- prevent blank mission profile screen
function OnMsg.LoadGame()
	local rules = g_CurrentMissionParams.idGameRules or empty_table
	local GameRulesMap = GameRulesMap
	for rule_id in pairs(rules) do
		-- if it isn't in the map then it isn't a valid rule
		if not GameRulesMap[rule_id] then
			rules[rule_id] = nil
		end
	end
end
