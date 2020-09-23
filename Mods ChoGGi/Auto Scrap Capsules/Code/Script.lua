-- See LICENSE for terms

local function DemoPod(func, self, ...)
	CreateRealTimeThread(function()
		self:ToggleDemolish()
	end)
	return func(self, ...)
end

local orig_SupplyPod_Shutdown = SupplyPod.Shutdown
function SupplyPod:Shutdown(...)
	return DemoPod(orig_SupplyPod_Shutdown, self, ...)
end

if rawget(_G, "ArkPod") then
	local orig_ArkPod_Shutdown = ArkPod.Shutdown
	function ArkPod:Shutdown(...)
		return DemoPod(orig_ArkPod_Shutdown, self, ...)
	end
end
