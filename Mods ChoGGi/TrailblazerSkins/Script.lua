local function ImmaTrailerBlazerMa()
  g_TrailblazerSkins = {
    Drone = "Drone_Trailblazer",
    RCRover = "Rover_Trailblazer",
    RCTransport = "RoverTransport_Trailblazer",
    ExplorerRover = "RoverExplorer_Trailblazer",
    SupplyRocket = "Rocket_Trailblazer",
  }
end

function OnMsg.LoadGame()
  ImmaTrailerBlazerMa()
end
function OnMsg.NewMapLoaded()
  ImmaTrailerBlazerMa()
end
