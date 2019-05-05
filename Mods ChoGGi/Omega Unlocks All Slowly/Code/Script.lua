-- See LICENSE for terms

-- unlock one per sol (assuming a telescope is working)
function OnMsg.NewDay()
	-- no sense in checking if this isn't true
	if not g_OmegaTelescopeBonusGiven then
		return
	end

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

  StableShuffle(breakthroughs, UICity:CreateResearchRand("OmegaTelescope"), 100)
	local def = TechDef[breakthroughs[1]]

	-- we already checked for breakthroughs[1], but why not check again :)
	if not def then
		return
	end

	UICity:SetTechDiscovered(def.id)

	-- make this optional?
	AddOnScreenNotification("BreakthroughDiscovered", OpenResearchDialog, {name = def.display_name, context = def, rollover_title = def.display_name, rollover_text = def.description})
end
