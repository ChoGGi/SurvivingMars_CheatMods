-- See LICENSE for terms

local mod_id = "ChoGGi_GameRulesBreakthroughs"
local mod = Mods[mod_id]

local mod_BreakthroughsResearched = mod.options and mod.options.BreakthroughsResearched or false

local function ModOptions()
	mod_BreakthroughsResearched = mod.options.BreakthroughsResearched
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end

	ModOptions()
end

OnMsg.CityStart = ModOptions

function OnMsg.ClassesPostprocess()
	if GameRulesMap.ChoGGi_AdvancedDroneDrive then
		return
	end

	local _IT = _InternalTranslate
	local T = T
	local PlaceObj = PlaceObj

	-- sort by id
	local breaks = table.icopy(Presets.TechPreset.Breakthroughs)
	table.sort(breaks,function(a,b)
		return a.id < b.id
	end)

	for i = 1, #breaks do
		local def = breaks[i]
		PlaceObj("GameRules", {
			description = _IT(T{def.description,def}),
			display_name = _IT(T(11451,"Breakthrough")) .. ": " .. _IT(T(def.display_name)),
			group = "Default",
			id = "ChoGGi_" .. def.id,
			PlaceObj("Effect_Code", {
				OnApplyEffect = function(_, city)
					if mod.options and mod.options.BreakthroughsResearched then
						city:SetTechResearched(def.id)
					else
						city:SetTechDiscovered(def.id)
					end
				end
			}),
		})
	end

end

-- fix missing tech defs description in main menu/new game
-- I already do this in my lib mod, so no need to do it twice
if not Mods.ChoGGi_Library then
	local fake_city = {
		GetConstructionCost = empty_func,
		label_modifiers = {},
	}

	local orig_BuildingInfoLine = BuildingInfoLine
	local pcall = pcall

	local function ResetFunc()
		BuildingInfoLine = orig_BuildingInfoLine
	end
	-- we don't need to check once UICity exists
	OnMsg.CityStart = ResetFunc
	OnMsg.LoadGame = ResetFunc

	function BuildingInfoLine(...)
		-- add fake city so BuildingInfoLine doesn't fail
		if not UICity then
			UICity = fake_city
		end

		-- just to on the safe side (don't want to leave UICity as fake_city)
		local _, ret = pcall(orig_BuildingInfoLine, ...)

		if UICity == fake_city then
			UICity = false
		end

		return ret
	end
end
