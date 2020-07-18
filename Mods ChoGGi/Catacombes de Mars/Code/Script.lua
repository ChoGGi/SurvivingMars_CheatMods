-- See LICENSE for terms

local IsValid = IsValid
local MapGet = MapGet
local RoadTileSize = terrain.RoadTileSize()
local pf_AddTunnel = pf.AddTunnel
local pf_GetTunnel = pf.GetTunnel

-- add pathfinding for each tunnel to each tunnel
local function MergeNewTunnel(obj, tunnels)
	tunnels = tunnels or MapGet("map", "Tunnel", function(o)
		-- skip self
		if o ~= obj then
			return true
		end
	end)

	local pathfind = pathfind

	for i = 1, #tunnels do
		local entrance, start_point = obj:GetEntrance(nil, "tunnel_entrance")
		local exit, exit_point = tunnels[i]:GetEntrance(nil, "tunnel_entrance")

		local tunnel_len = entrance[1]:Dist2D(exit[1])
		local enter_exit_len = entrance[1]:Dist2D(entrance[#entrance]) + exit[1]:Dist2D(exit[#exit])
		local weight = (tunnel_len/10 + enter_exit_len) * pathfind[1].terrain / RoadTileSize

		pf_AddTunnel(obj, start_point, exit_point, weight, -1, 0)
	end
end

GlobalVar("g_ChoGGi_CatacombesdeMars_UpdatedTunnels", false)
local function StartupCode()
	if g_ChoGGi_CatacombesdeMars_UpdatedTunnels then
		return
	end

	-- clear and rebuild existing tunnels
	local tunnels = MapGet("map", "Tunnel")
	local tunnels_c = #tunnels
	for i = 1, tunnels_c do
		local tunnel = tunnels[i]
		-- make sure to clear old paths (probably will cause issues leaving dupes)
		tunnel:RemovePFTunnel()
		for j = 1, tunnels_c do
			MergeNewTunnel(tunnel, tunnels)
		end
	end

	g_ChoGGi_CatacombesdeMars_UpdatedTunnels = true
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

-- add newly placed tunnel to all existing tunnels instead of just linked
function Tunnel:AddPFTunnel()
	MergeNewTunnel(self)
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
