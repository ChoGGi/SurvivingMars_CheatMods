-- See LICENSE for terms

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_Tunnel_AddPFTunnel = Tunnel.AddPFTunnel
function Tunnel:AddPFTunnel(...)
	if not mod_EnableMod then
		return ChoOrig_Tunnel_AddPFTunnel(self, ...)
	end

	if not self.working and not self:CanDemolish() and not self:IsDemolishing() then
		return
	end

	return ChoOrig_Tunnel_AddPFTunnel(self, ...)
end

function OnMsg.LoadGame()
	if not mod_EnableMod then
		return
	end

	-- update pf tunnels to stop rovers from using them
  MapForEach("map", "Tunnel", function(t)
		t:RemovePFTunnel()
		t:AddPFTunnel()
	end)
end
