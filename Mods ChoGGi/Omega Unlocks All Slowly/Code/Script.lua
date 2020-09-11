-- See LICENSE for terms

local mod_SolsBetweenUnlock
local mod_ShowNotification

-- fired when settings are changed/init
local function ModOptions()
	mod_SolsBetweenUnlock = CurrentModOptions:GetProperty("SolsBetweenUnlock")
	mod_ShowNotification = CurrentModOptions:GetProperty("ShowNotification")
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

	local UICity = UICity

	-- If there's none left to discover return
	local breakthroughs = UICity:GetUnregisteredBreakthroughs()
	if not breakthroughs[1] then
		return
	end

	local can_unlock
	-- check for a working telescope
	local objs = UICity.labels.OmegaTelescope or ""
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

	UICity:SetTechDiscovered(def.id)

	-- make this optional?
	if mod_ShowNotification then
		AddOnScreenNotification("BreakthroughDiscovered", OpenResearchDialog, {name = def.display_name, context = def, rollover_title = def.display_name, rollover_text = def.description})
	end
end

function OnMsg.AddResearchRolloverTexts(ret)
	-- no text if it's set to 1 sol or omega isn't built
	if mod_SolsBetweenUnlock == 1 or not g_OmegaTelescopeBonusGiven then
		return
	end

	ret[#ret+1] = "<newline>" .. T{302535920011560,
		"Omega Unlock Sols<right><em><sols></em>",
		sols = mod_SolsBetweenUnlock - ChoGGi_OmegaUnlocksAllSlowly_Sols,
	}
end
