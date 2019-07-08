-- See LICENSE for terms

local function WaitItOut(self, func, ...)
	if g_MeteorStorm then
		self:SetState("idle")
		Sleep(5000)
		self:SetCommand("Idle")
	else
		return func(self, ...)
	end
end

local orig_ExplorerRover_Idle = ExplorerRover.Idle
function ExplorerRover:Idle(...)
	return WaitItOut(self, orig_ExplorerRover_Idle, ...)
end

local orig_RCTransport_Automation_Gather = RCTransport.Automation_Gather
function RCTransport:Automation_Gather(...)
	return WaitItOut(self, orig_RCTransport_Automation_Gather, ...)
end
