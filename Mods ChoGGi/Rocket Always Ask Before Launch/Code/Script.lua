-- See LICENSE for terms

local orig_SupplyRocket_UILaunch = SupplyRocket.UILaunch
function SupplyRocket:UILaunch()
	if self:IsDemolishing() then
		self:ToggleDemolish()
	end

	-- we only care about no issues
	if self:GetLaunchIssue() then
		orig_SupplyRocket_UILaunch(self)
	else
		-- no issues so show the msg
		CreateRealTimeThread(function()
			local result = WaitPopupNotification("LaunchIssue_Cargo", {
					choice1 = T(9072, "Launch the Rocket")
						.. " (worry not; resources were removed).",
					choice2 = T(8014, "Abort the launch sequence."),
				}, false, GetInGameInterface())

			if result == 1 then
				self:SetCommand("Countdown")
				Msg("RocketManualLaunch", self)
			end
		end)
	end
end
