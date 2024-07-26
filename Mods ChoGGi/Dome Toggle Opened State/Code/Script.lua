-- See LICENSE for terms

function OnMsg.ClassesPostprocess()
	ChoGGi_Funcs.Common.AddXTemplate("ToggleOpenedState", "sectionDome", {
		-- skip any ruined domes
		__condition = function(_, context)
			return context.working and not context:IsKindOf("OpenCity")
		end,
		Icon = "UI/Icons/bmc_domes_shine.tga",
		Title = T(302535920011727, "Toggle Opened State"),
		RolloverText = T(302535920011727, "Toggle Opened State"),
		func = function(_, context)
			-- odd seeing people walking around an opened dome without any breathing issues.
			if not GetAtmosphereBreathable(ActiveMapID) then
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

local ChoOrig_Dome_UpdateOpenCloseState = Dome.UpdateOpenCloseState
function Dome:UpdateOpenCloseState(...)
	local orig = OpenAirBuildings
	OpenAirBuildings = false
	ChoOrig_Dome_UpdateOpenCloseState(self, ...)
	OpenAirBuildings = orig
end
