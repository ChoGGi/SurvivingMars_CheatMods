-- See LICENSE for terms

local ChoOrig_SupplyPod_Shutdown = SupplyPod.Shutdown
function SupplyPod:Shutdown(...)
	CreateGameTimeThread(function()
		self:ToggleDemolish()
	end)
	return ChoOrig_SupplyPod_Shutdown(self, ...)
end
