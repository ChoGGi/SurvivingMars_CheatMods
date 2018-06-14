local function ImmaTrailerBlazerMa()
  g_TrailblazerSkins = {}
  g_TrailblazerSkins.Drone = "Drone_Trailblazer"
  g_TrailblazerSkins.RCRover = "Rover_Trailblazer"
  g_TrailblazerSkins.RCTransport = "RoverTransport_Trailblazer"
  g_TrailblazerSkins.ExplorerRover = "RoverExplorer_Trailblazer"
  g_TrailblazerSkins.SupplyRocket = "Rocket_Trailblazer"
end

function OnMsg.LoadGame()
  ImmaTrailerBlazerMa()
end
function OnMsg.NewMapLoaded()
  ImmaTrailerBlazerMa()
end
