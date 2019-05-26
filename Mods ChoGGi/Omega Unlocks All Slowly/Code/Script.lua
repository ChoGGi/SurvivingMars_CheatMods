-- See LICENSE for terms

local mod_id = "ChoGGi_OmegaUnlocksAllSlowly"
local mod = Mods[mod_id]

local mod_SolsBetweenUnlock = mod.options and mod.options.SolsBetweenUnlock or 1

local function ModOptions()
	mod_SolsBetweenUnlock = mod.options.SolsBetweenUnlock
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end

	ModOptions()
end

-- for some reason mod options aren't retrieved before this script is loaded...
OnMsg.CityStart = ModOptions
OnMsg.LoadGame = ModOptions

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

	-- if there's none left to discover
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

	if not can_unlock then
		return
	end

	local def = TechDef[table.rand(breakthroughs)]

	-- we already checked for breakthroughs[1], but why not check again :)
	if not def then
		return
	end

	UICity:SetTechDiscovered(def.id)

	-- make this optional?
	AddOnScreenNotification("BreakthroughDiscovered", OpenResearchDialog, {name = def.display_name, context = def, rollover_title = def.display_name, rollover_text = def.description})
end
