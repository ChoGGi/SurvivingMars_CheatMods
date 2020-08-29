-- See LICENSE for terms

function OnMsg.ClassesPostprocess()
	ChoGGi.ComFuncs.AddXTemplate("ToggleOpenedState", "sectionDome", {
		-- skip any ruined domes
		__condition = function(_, context)
			return context.working
		end,
		Icon = "UI/Icons/bmc_domes_shine.tga",
		Title = T(302535920011727, "Toggle Opened State"),
		func = function(_, context)
			-- odd seeing people walking around an opened dome without any breathing issues.
			if not BreathableAtmosphere then
				return
			end
			if context.open_air then
				context:ChangeOpenAirState(false)
			else
				context:ChangeOpenAirState(true)
			end
		end,
	})
end
