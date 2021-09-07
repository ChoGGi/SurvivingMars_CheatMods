-- See LICENSE for terms

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local orig_Tunnel_AddPFTunnel = Tunnel.AddPFTunnel
function Tunnel:AddPFTunnel(...)
	if not mod_EnableMod then
		return orig_Tunnel_AddPFTunnel(self, ...)
	end

	if not self.working and not self:CanDemolish() and not self:IsDemolishing() then
		return
	end

	return orig_Tunnel_AddPFTunnel(self, ...)
end

function OnMsg.LoadGame()
	if not mod_EnableMod then
		return
	end

	-- update pf tunnels to stop rovers from using them
  ActiveGameMap.realm:MapForEach("map", "Tunnel", function(t)
		t:RemovePFTunnel()
		t:AddPFTunnel()
	end)
end
