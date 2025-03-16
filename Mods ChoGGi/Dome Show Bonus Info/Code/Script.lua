-- See LICENSE for terms

local mod_EnableMod

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_Dome_GetUISectionCitizensRollover = Dome.GetUISectionCitizensRollover
function Dome:GetUISectionCitizensRollover(...)
	if not mod_EnableMod then
		return ChoOrig_Dome_GetUISectionCitizensRollover(self, ...)
	end

	local rollover = ChoOrig_Dome_GetUISectionCitizensRollover(self, ...)

	--
	local comfort_amount = 0
	if self.modifications and self.modifications.dome_comfort then
		comfort_amount = self.modifications.dome_comfort.amount
	end
	--
	local morale_amount = 0
	if self.modifications and self.modifications.dome_morale then
		morale_amount = self.modifications.dome_morale.amount
	end
	--
	local research_percent = 0
	if self.label_modifiers and self.label_modifiers.ResearchBuildings then
		for obj, mod in pairs(self.label_modifiers.ResearchBuildings) do
			-- The table seems to keep orphaned objs, not that sites usually move, but mods...
			if IsValid(obj) and obj:IsKindOf("ResearchEffectDeposit") then
				research_percent = research_percent + mod.percent
			end
		end
	end
	--

	if comfort_amount == 0 and morale_amount == 0 and research_percent == 0 then
		return rollover
	end

	rollover[1].j = rollover[1].j + 4
	local tbl = rollover[1].table
	tbl[#tbl+1] = T(0000, "<newline><center><color em>Bonuses</color>")
	tbl[#tbl+1] = T{11460, --[[Comfort boost<right><resource(comfort_increase)>]]
			comfort_increase = comfort_amount,
		}
		tbl[#tbl+1] = T{13601, --[[Morale boost<right><resource(morale_increase)>]]
			morale_increase = morale_amount,
		}
	tbl[#tbl+1] = T{11463, --[[Research boost<right><percent(research_increase)>]]
			research_increase = research_percent,
		}

--~ 	ex(rollover)
	return table.concat(rollover, "<newline><left>")
end