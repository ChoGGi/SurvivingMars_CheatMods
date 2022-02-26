-- See LICENSE for terms

return {
	PlaceObj('ModItemDecalEntity', {
		'name', "IdiotDecal",
		'entity_name', "IdiotDecal",
		'filename', "UI/IdiotLogoUI.png",
	}),
	PlaceObj('ModItemMissionLogoPreset', {
		decal_entity = "IdiotDecal",
		entity_name = "IdiotDecal",
		display_name = T(610533935631, "Idiocracy"),
		id = "ChoGGi_Idiocracy2_Logo",
		image = "UI/IdiotLogoUI.png",
		group = "Default",
	}),
	PlaceObj('ModItemMissionSponsorPreset', {
		id = "ChoGGi_Idiocracy2_Sponsor",
		name = "ChoGGi_Idiocracy2_Sponsor",
		default_logo = "ChoGGi_Idiocracy2_Logo",
		initial_applicants = 206,
		initial_rockets = 1,
		challenge_mod = 201,
		display_name = T(610533935631, "Idiocracy"),
		effect = T(219160545510, [[Research per Sol: <research(0)>

- All colonists are <em>Idiots</em>
- No research technologies unlocked
- No sponsored research]]),
		game_apply = function(self, city)
			CreateGameTimeThread(function()
				Sleep(100) -- Wait until applicants generation has completed
				g_ApplicantPoolFilter.Idiot = nil
			end)
			-- Overwrite discovered (but not researched, possibly from the commander profile) techs to achieve the 'no techs unlocked' effect
			local status = UIColony.tech_status
			for _, status in pairs(status) do
				if status.discovered and not status.researched then
					status.discovered = false
				end
			end
		end,
		difficulty = T(0000, "Stupid"),
		funding = 10000,
		initial_techs_unlocked = 0,
		trait = "Idiot",
		PlaceObj('Effect_ModifyLabel', {
			Label = "Consts",
			Percent = -100,
			Prop = "SponsorResearch",
		}),
		group = "Default",
	}),

	PlaceObj("ModItemCommanderProfilePreset", {
		display_name = T(0000, "Pte Bauers"),
		effect = T(0000, [[- Reduce chance of Idiots breaking things by 25%
- Increased water requirements for farm crops by 0.6
- Acts as <color em>Politician</color> for story bits]]),
		group = "Default",
		id = "ChoGGi_Idiocracy2_Commander",
	}),

}
