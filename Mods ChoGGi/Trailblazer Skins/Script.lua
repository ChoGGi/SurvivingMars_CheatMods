local skins = {
  Drone = "Drone_Trailblazer",
  RCRover = "Rover_Trailblazer",
  RCTransport = "RoverTransport_Trailblazer",
  ExplorerRover = "RoverExplorer_Trailblazer",
  SupplyRocket = "Rocket_Trailblazer",
}

g_TrailblazerSkins = skins

function OnMsg.PopsOwnedProductsChanged()
  CreateRealTimeThread(function()
    Sleep(1000)
    g_TrailblazerSkins = skins
  end)
end
