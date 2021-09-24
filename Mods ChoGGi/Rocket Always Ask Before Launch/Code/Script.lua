-- See LICENSE for terms

local ChoOrig_RocketBase_UILaunch = RocketBase.UILaunch
function RocketBase:UILaunch()
	if self:IsDemolishing() then
		self:ToggleDemolish()
	end

	-- we only care about no issues
	if self:GetLaunchIssue() then
		ChoOrig_RocketBase_UILaunch(self)
	else
		-- no issues so show the msg
		CreateRealTimeThread(function()
			local result = WaitPopupNotification("LaunchIssue_Cargo", {
					choice1 = T(9072, "Launch the Rocket")
						.. " " .. T(302535920011341, "(worry not; resources were removed)."),
					choice2 = T(8014, "Abort the launch sequence."),
				}, false, GetInGameInterface())

			if result == 1 then
				self:SetCommand("Countdown")
				Msg("RocketManualLaunch", self)
			end
		end)
	end
end
