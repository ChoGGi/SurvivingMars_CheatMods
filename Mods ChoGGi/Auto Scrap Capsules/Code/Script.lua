-- See LICENSE for terms

local orig_SupplyPod_Shutdown = SupplyPod.Shutdown
function SupplyPod:Shutdown(...)
	CreateGameTimeThread(function()
		self:ToggleDemolish()
	end)
	return orig_SupplyPod_Shutdown(self, ...)
end
