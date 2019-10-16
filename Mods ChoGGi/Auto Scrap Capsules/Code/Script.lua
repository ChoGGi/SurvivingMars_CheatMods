-- See LICENSE for terms

local function DemoPod(func, self, ...)
	CreateRealTimeThread(function()
		Sleep(5000)
		self:ToggleDemolish()
	end)
	return func(self, ...)
end

local orig_SupplyPod_Unload = SupplyPod.Unload
function SupplyPod:Unload(...)
	return DemoPod(orig_SupplyPod_Unload, self, ...)
end

local orig_ArkPod_Unload = ArkPod.Unload
function ArkPod:Unload(...)
	return DemoPod(orig_ArkPod_Unload, self, ...)
end
