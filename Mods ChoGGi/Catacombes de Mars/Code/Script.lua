-- See LICENSE for terms

local RoadTileSize = const.TerrainRoadTileSize
local pf_AddTunnel = pf.AddTunnel
local pf_GetTunnel = pf.GetTunnel
local pathfind = pathfind

-- add pathfinding for each tunnel to each tunnel
local function MergeNewTunnel(obj, tunnels)
	for i = 1, #tunnels do
		local tunnel = tunnels[i]
		if obj ~= tunnel then
			local entrance, start_point = obj:GetEntrance(nil, "tunnel_entrance")
			local exit, exit_point = tunnel:GetEntrance(nil, "tunnel_entrance")

			local tunnel_len = entrance[1]:Dist2D(exit[1])
			local enter_exit_len = entrance[1]:Dist2D(entrance[#entrance]) + exit[1]:Dist2D(exit[#exit])
			local weight = (tunnel_len/10 + enter_exit_len) * pathfind[1].terrain / RoadTileSize

			pf_AddTunnel(obj, start_point, exit_point, weight, -1, 0)
		end
	end
end

local function ReloadTunnels()
	-- clear and rebuild existing tunnels
	local tunnels = UICity.labels.Tunnel or ""
	local tunnels_c = #tunnels
	for i = 1, tunnels_c do
		local tunnel = tunnels[i]
		-- make sure to clear old paths (probably will cause issues leaving dupes)
		tunnel:RemovePFTunnel()
		for _ = 1, tunnels_c do
			MergeNewTunnel(tunnel, tunnels)
		end
	end
end

OnMsg.CityStart = ReloadTunnels
OnMsg.LoadGame = ReloadTunnels

-- add newly placed tunnel to all existing tunnels instead of just linked
--~ local orig_AddPFTunnel = Tunnel.AddPFTunnel
function Tunnel:AddPFTunnel()
	ReloadTunnels()
end

-- change .linked_obj to end_point tunnel (otherwise rover just goes in n out on a loop)
local orig_Tunnel_TraverseTunnel = Tunnel.TraverseTunnel
function Tunnel:TraverseTunnel(unit, start_point, end_point, ...)
	-- just in case...
	if start_point and end_point then
		self.linked_obj = pf_GetTunnel(end_point, start_point)
	end

	return orig_Tunnel_TraverseTunnel(self, unit, start_point, end_point, ...)
end
