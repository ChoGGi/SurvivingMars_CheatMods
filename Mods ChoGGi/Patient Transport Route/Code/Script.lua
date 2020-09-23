-- See LICENSE for terms

local table_clear = table.clear
local Sleep = Sleep

local mod_Amount

-- fired when settings are changed/init
local function ModOptions()
	mod_Amount = CurrentModOptions:GetProperty("Amount") * const.ResourceScale
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local orig_RCTransport_TransportRouteLoad = RCTransport.TransportRouteLoad
function RCTransport:TransportRouteLoad(...)
	-- [LUA ERROR] Mars/Lua/Units/RCTransport.lua:1018: attempt to index a boolean value (field 'unreachable_objects')
	self.unreachable_objects = self.unreachable_objects or {}

	-- save supply obj
	local supply = self.transport_route.from
	-- fire off orig
	orig_RCTransport_TransportRouteLoad(self, ...)

	-- If this is false then TransportRouteLoad removed it
	if not self.transport_route.from then
		-- add the missing half of the route back so it doesn't remove the route
		self.transport_route.from = supply

		-- If amount > storage then that's bad
		if mod_Amount > self.max_shared_storage then
			mod_Amount = self.max_shared_storage
		end

		-- If not enough res then set to idle anim
		if self:GetStoredAmount() < mod_Amount then
			-- wonder how long this networking func will stick around? (considering there's no MP, unless it's a ged thing)
			self:Gossip("Idle")
			-- set anim to idle state
			self:SetState("idle")
		end

		-- loop till we have enough
		while true do
			-- wait for it...
			Sleep(5000)

			-- If amount > storage then that's bad
			if mod_Amount > self.max_shared_storage then
				mod_Amount = self.max_shared_storage
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
			elseif self:GetStoredAmount() >= mod_Amount then
				-- If we have enough than go to unload func (load n unload are in a loop in transport object)
				break
			end

		end	 -- while
	end -- If
end

local orig_RCTransport_TransportRouteUnload = RCTransport.TransportRouteUnload
function RCTransport:TransportRouteUnload(...)
	-- If amount > storage then that's bad
	if mod_Amount > self.max_shared_storage then
		mod_Amount = self.max_shared_storage
	end

	-- If not enough res then set to idle anim and return to load func
	if self:GetStoredAmount() < mod_Amount then
		-- fix for inf loop
		Sleep(1000)
		return
	end

	return orig_RCTransport_TransportRouteUnload(self, ...)
end
