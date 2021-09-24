-- See LICENSE for terms

-- fired when we go to first new game section
local function OverrideBackButton(toolbar, something)
	-- skip if we're not in "main" area
	if not toolbar.idnext or something.Mode ~= "properties" then
		return
	end

	local back = toolbar.idback
	local ChoOrig_OnPress = back.OnPress
	function back:OnPress(...)
		CreateRealTimeThread(function(...)
			if WaitMarsQuestion(
				terminal.desktop,
				T(4165, "Back"),
				T(1010, "Main Menu")
			) == "ok" then
				ChoOrig_OnPress(self, ...)
			end
		end)
	end
end

-- add settings button
local ChoOrig_SetPlanetCamera = SetPlanetCamera
function SetPlanetCamera(planet, state, ...)
	-- fire only in mission setup menu
	if not state and not UICity then
		CreateRealTimeThread(function()
			WaitMsg("OnRender")
			local pgmission = Dialogs.PGMainMenu.idContent.PGMission
			if type(pgmission) == "table" then
				local something = pgmission[1][1]
				local toolbar = something.idToolBar

				if pgmission.Mode == "sponsor" then
					OverrideBackButton(toolbar, something)

					-- hook into toolbar button area so we can keep adding the button
					local ChoOrig_RebuildActions = toolbar.RebuildActions
					toolbar.RebuildActions = function(self, context, ...)
						ChoOrig_RebuildActions(self, context, ...)
						OverrideBackButton(toolbar, something)
					end
				end
			end
		end)
	end
	return ChoOrig_SetPlanetCamera(planet, state, ...)
end
