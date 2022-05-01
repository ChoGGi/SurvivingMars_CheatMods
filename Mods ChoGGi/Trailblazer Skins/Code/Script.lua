-- See LICENSE for terms

local trailblazer_skins = {
	Drone = "Drone_Trailblazer",
	RCRover = "Rover_Trailblazer",
	RCTransport = "RoverTransport_Trailblazer",
	ExplorerRover = "RoverExplorer_Trailblazer",
	SupplyRocket = "Rocket_Trailblazer",
}

g_TrailblazerSkins = trailblazer_skins

function OnMsg.PopsOwnedProductsChanged()
	CreateRealTimeThread(function()
		Sleep(1000)
		g_TrailblazerSkins = trailblazer_skins
	end)
end
