function OnMsg.ClassesBuilt()

  local orig_SupplyRocket_UILaunch = SupplyRocket.UILaunch
  function SupplyRocket:UILaunch()
    if self:IsDemolishing() then
      self:ToggleDemolish()
    end

    local host = GetInGameInterface()
    local issue = self:GetLaunchIssue()

    -- we only care about no issues
    if issue then
      orig_SupplyRocket_UILaunch(self)
    else
      -- no issues so show the msg
      CreateRealTimeThread(function()
        local res = WaitPopupNotification("LaunchIssue_Cargo", {
            choice1 = "Launch (your cargo isn't in any danger).",
            choice2 = T(8014, "Abort the launch sequence."),
          }, false, host)
        if res and res == 1 then
          self:SetCommand("Countdown")
        end
      end)
    end
  end

end
