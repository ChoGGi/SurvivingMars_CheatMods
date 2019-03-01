-- See LICENSE for terms

local orig_Colonist_Work = Colonist.Work
function Colonist:Work(...)
	local dest = self.workplace and self.workplace.parent_dome
	if not IsValid(dest) then
		return orig_Colonist_Work(self,...)
	end

	-- call a shuttle and wait for it
	if dest ~= self.dome and IsTransportAvailableBetween(self.dome, dest) then
		local task = CreateColonistTransportTask(self, self.dome, dest)
		self.transport_task.state = "almost_ready_for_pickup" --so a shuttle can immidiately pick this task up
		self:Roam(const.HourDuration)
		while task.state ~= "Done" do
			Sleep(500)
		end
	end

	return orig_Colonist_Work(self,...)
end
