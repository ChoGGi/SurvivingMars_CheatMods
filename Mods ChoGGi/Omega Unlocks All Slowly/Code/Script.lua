-- See LICENSE for terms

local mod_SolsBetweenUnlock
local mod_ShowNotification
local mod_RandomChance
local mod_ResearchBreakthroughs

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_SolsBetweenUnlock = CurrentModOptions:GetProperty("SolsBetweenUnlock")
	mod_ShowNotification = CurrentModOptions:GetProperty("ShowNotification")
	mod_RandomChance = CurrentModOptions:GetProperty("RandomChance")
	mod_ResearchBreakthroughs = CurrentModOptions:GetProperty("ResearchBreakthroughs")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

GlobalVar("ChoGGi_OmegaUnlocksAllSlowly_Sols", 0)

-- unlock one per sol (assuming a telescope is working)
function OnMsg.NewDay()
-- testing
--~ function OnMsg.NewHour()

	-- no sense in checking if this isn't true
	if not g_OmegaTelescopeBonusGiven then
		return
	end

	local sols = ChoGGi_OmegaUnlocksAllSlowly_Sols + 1
	-- wait another Sol if we haven't hit the limit
	if sols < mod_SolsBetweenUnlock then
		ChoGGi_OmegaUnlocksAllSlowly_Sols = sols
		return
	end
	-- hit the amount so reset
	ChoGGi_OmegaUnlocksAllSlowly_Sols = 0

	-- If there's none left to discover return
	local breakthroughs = UIColony:GetUnregisteredBreakthroughs()
	if not breakthroughs[1] then
		return
	end

	local can_unlock
	-- check for a working telescope
	local objs = UIColony:GetCityLabels("OmegaTelescope")
	for i = 1, #objs do
		if objs[i]:CanWork() then
			can_unlock = true
			break
		end
	end

	-- nothing working return
	if not can_unlock then
		return
	end

	-- pick a rand bt from the list
	local def = TechDef[table.rand(breakthroughs)]

	-- we already checked for breakthroughs[1], but why not check again :)
	if not def then
		return
	end

	-- gambling time
	if mod_RandomChance > 0 and AsyncRand(100)+1 > mod_RandomChance
	then
		-- add a failed notification?
		return
	end

	if mod_ResearchBreakthroughs then
		UIColony:SetTechResearched(def.id)
	else
		UIColony:SetTechDiscovered(def.id)
	end

	if mod_ShowNotification then
		AddOnScreenNotification("BreakthroughDiscovered", OpenResearchDialog, {name = def.display_name, context = def, rollover_title = def.display_name, rollover_text = def.description})
	end
end

function OnMsg.AddResearchRolloverTexts(ret)
	-- no text if it's set to 1 sol or omega isn't built
	if mod_SolsBetweenUnlock == 1 or not g_OmegaTelescopeBonusGiven then
		return
	end

	ret[#ret+1] = _InternalTranslate("<newline>" .. T{302535920011560,
		"Omega Unlock Sols<right><em><sols></em>",
		sols = mod_SolsBetweenUnlock - ChoGGi_OmegaUnlocksAllSlowly_Sols,
	})
end
