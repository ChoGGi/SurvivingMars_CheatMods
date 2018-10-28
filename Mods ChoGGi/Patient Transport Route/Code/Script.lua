-- See LICENSE for terms

local pairs = pairs
local Sleep = Sleep

local orig_RCTransport_TransportRouteLoad = RCTransport.TransportRouteLoad
function RCTransport:TransportRouteLoad(...)
	-- save supply obj
	local supply = self.transport_route.from
	-- fire off orig
	orig_RCTransport_TransportRouteLoad(self,...)

	-- if this is false then that probably means the supply area is empty, and it got set to false from orig func
	if not self:FindNextRouteSource() then
		-- add the missing half of the route back so it doesn't remove the route
		self.transport_route.from = supply
		-- check each stored res and see if there's enough for a cube
		local enough
		for _,value in pairs(self.stockpiled_amount) do
			if value > 1000 then
				enough = true
				-- we only need to know if there's enough, no sense in looping anymore
				break
			end
		end
		-- and unload if so
		if enough then
			self:TransportRouteUnload()
		else
			-- wonder how long this networking func will stick around? (considering there's no networking, unless it's a ged thing)
			self:Gossip("Idle")
			-- set anim to idle state
			self:SetState("idle")
			-- wait for it... (it'll just loop back here)
			Sleep(2500)
		end
	end
end
