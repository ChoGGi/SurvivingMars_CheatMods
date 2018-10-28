
local orig_RCTransport_TransferResources = RCTransport.TransferResources
function RCTransport:TransferResources(...)
	if not self.unreachable_objects then
		self.unreachable_objects = {}
	end
	return orig_RCTransport_TransferResources(self,...)
end
