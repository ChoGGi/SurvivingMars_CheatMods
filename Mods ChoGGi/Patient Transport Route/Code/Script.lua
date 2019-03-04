-- See LICENSE for terms

local Sleep = Sleep
local table_clear = table.clear
local ResourceScale = const.ResourceScale
local wait_amount = (PatientTransportRoute.Amount or 1) * ResourceScale

local orig_RCTransport_TransportRouteLoad = RCTransport.TransportRouteLoad
function RCTransport:TransportRouteLoad(...)

	-- [LUA ERROR] Mars/Lua/Units/RCTransport.lua:1018: attempt to index a boolean value (field 'unreachable_objects')
	self.unreachable_objects = self.unreachable_objects or {}

	-- save supply obj
	local supply = self.transport_route.from
	-- fire off orig
	orig_RCTransport_TransportRouteLoad(self,...)

	-- if this is false then TransportRouteLoad removed it
	if not self.transport_route.from then
		-- add the missing half of the route back so it doesn't remove the route
		self.transport_route.from = supply

		-- always need to update (if user changed it)
		wait_amount = (PatientTransportRoute.Amount or 1) * ResourceScale
		-- if amount > storage then that's bad
		if wait_amount > self.max_shared_storage then
			wait_amount = self.max_shared_storage
		end

		-- if not enough res then set to idle anim
		if self:GetStoredAmount() < wait_amount then
			-- wonder how long this networking func will stick around? (considering there's no MP, unless it's a ged thing)
			self:Gossip("Idle")
			-- set anim to idle state
			self:SetState("idle")
		end

		-- loop till we have enough
		while true do
			-- wait for it...
			Sleep(5000)

			-- always need to update (if user changed it)
			wait_amount = (PatientTransportRoute.Amount or 1) * ResourceScale
			-- if amount > storage then that's bad
			if wait_amount > self.max_shared_storage then
				wait_amount = self.max_shared_storage
			end

			-- gotta clear these so they don't cause issues
			table_clear(self.route_visited_dests)
			table_clear(self.route_visited_sources)
			local next_source = self:FindNextRouteSource()
			-- check for nearby deposits
			if next_source then
				self.route_visited_sources[next_source] = true
				self:ProcessRouteObj(next_source)
				break
			elseif self:GetStoredAmount() >= wait_amount then
				-- if we have enough than go to unload func (load n unload are in a loop in transport object)
				break
			end

		end	 -- while
	end -- if
end

local orig_RCTransport_TransportRouteUnload = RCTransport.TransportRouteUnload
function RCTransport:TransportRouteUnload(...)

	-- always need to update (if user changed it)
	wait_amount = (PatientTransportRoute.Amount or 1) * ResourceScale
	-- if amount > storage then that's bad
	if wait_amount > self.max_shared_storage then
		wait_amount = self.max_shared_storage
	end

	-- if not enough res then set to idle anim and return to load func
	if self:GetStoredAmount() < wait_amount then
		return
	end

	return orig_RCTransport_TransportRouteUnload(self,...)
end
