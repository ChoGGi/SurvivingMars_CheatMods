-- See LICENSE for terms

local mod_BreakthroughsResearched
local mod_SortBreakthroughs

-- fired when settings are changed/init
local function ModOptions()
	mod_BreakthroughsResearched = CurrentModOptions:GetProperty("BreakthroughsResearched")
	mod_SortBreakthroughs = CurrentModOptions:GetProperty("SortBreakthroughs")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
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

	ModOptions()

	-- sort by id
	local breaks
	if mod_SortBreakthroughs then
		breaks = table.icopy(Presets.TechPreset.Breakthroughs)
		table.sort(breaks, function(a, b)
			return a.id < b.id
		end)
	else
		breaks = Presets.TechPreset.Breakthroughs
	end

	local name
	if mod_BreakthroughsResearched then
		name = _InternalTranslate(T(311, "Research"))
	else
		name = _InternalTranslate(T(510925660723, "Unlock"))
	end

	PlaceObj("GameRules", {
		description = T(302535920011598, string.format("This will %s all breakthroughs <yellow>no matter</yellow> if you've checked or unchecked any in the list.", name)),
		display_name = T(11451, "Breakthrough") .. ": " .. T(302535920011599, string.format("%s All Breakthroughs", name)),
		group = "Default",
		id = "ChoGGi_DoAllBreakthroughs",
		PlaceObj("Effect_Code", {
			OnApplyEffect = function(_, city)
				local func = mod_BreakthroughsResearched and city.SetTechResearched or city.SetTechDiscovered
				for i = 1, #breaks do
					func(city, breaks[i].id)
				end
			end
		}),
	})

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
