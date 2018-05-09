function OnMsg.ClassesBuilt()
  ChoGGiX.ReplacedFunctions_ClassesBuilt()
end

function OnMsg.NewHour()

  --make them lazy drones stop abusing electricity (we need to have an hourly update if people are using large prod amounts/low amount of drones)
  --if ChoGGi.CheatMenuSettings.DroneResourceCarryAmountFix then
    --Hey. Do I preach at you when you're lying stoned in the gutter? No!
    local tab = UICity.labels.ResourceProducer or empty_table
    for i = 1, #tab do
      ChoGGiX.FuckingDrones(tab[i]:GetProducerObj())
      if tab[i].wasterock_producer then
        ChoGGiX.FuckingDrones(tab[i].wasterock_producer)
      end
    end
  --end

end
