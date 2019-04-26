-- See LICENSE for terms

-- fired when we go to first new game section
local function OverrideBackButton(toolbar,something)
	-- skip if we're not in "main" area
	if not toolbar.idnext or something.Mode ~= "properties" then
		return
	end

	local back = toolbar.idback
	local orig_OnPress = back.OnPress
	function back:OnPress(...)
		CreateRealTimeThread(function(...)
			if WaitMarsQuestion(
				terminal.desktop,
				T(4165,"Back"),
				T(1010,"Main Menu")
			) == "ok" then
				orig_OnPress(self,...)
			end
		end)
	end
end

-- add settings button
local orig_SetPlanetCamera = SetPlanetCamera
function SetPlanetCamera(planet, state, ...)
	-- fire only in mission setup menu
	if not state and not GameState.gameplay then
		CreateRealTimeThread(function()
			WaitMsg("OnRender")
			local pgmission = Dialogs.PGMainMenu.idContent.PGMission
			local something = pgmission[1][1]
			local toolbar = something.idToolBar

			if pgmission.Mode == "sponsor" then
				OverrideBackButton(toolbar,something)

				-- hook into toolbar button area so we can keep adding the button
				local orig_RebuildActions = toolbar.RebuildActions
				toolbar.RebuildActions = function(self, context, ...)
					orig_RebuildActions(self, context, ...)
					OverrideBackButton(toolbar,something)
				end
			end

		end)
	end
	return orig_SetPlanetCamera(planet, state, ...)
end
