-- See LICENSE for terms

local options
local mod_SolsBetweenUnlock

-- fired when settings are changed and new/load
local function ModOptions()
	mod_SolsBetweenUnlock = options.SolsBetweenUnlock
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_OmegaUnlocksAllSlowly" then
		return
	end

	ModOptions()
end

GlobalVar("ChoGGi_OmegaUnlocksAllSlowly_Sols", 0)

-- unlock one per sol (assuming a telescope is working)
function OnMsg.NewDay()
--~ function OnMsg.NewHour()

	-- no sense in checking if this isn't true
	if not g_OmegaTelescopeBonusGiven then
		return
	end

	local sols = ChoGGi_OmegaUnlocksAllSlowly_Sols
	sols = sols + 1
	-- wait another sol
	if sols < mod_SolsBetweenUnlock then
		ChoGGi_OmegaUnlocksAllSlowly_Sols = sols
		return
	end
	-- hit the amount so reset
	ChoGGi_OmegaUnlocksAllSlowly_Sols = 0

	local UICity = UICity

	-- if there's none left to discover return
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
	AddOnScreenNotification("BreakthroughDiscovered", OpenResearchDialog, {name = def.display_name, context = def, rollover_title = def.display_name, rollover_text = def.description})
end
