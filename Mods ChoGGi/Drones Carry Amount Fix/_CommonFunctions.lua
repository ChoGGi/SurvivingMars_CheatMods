ChoGGiX = { OrigFunc = {} }

--force drones to pickup from producers even if they have a large carry cap
function ChoGGiX.FuckingDrones(Producer)
  --Come on, Bender. Grab a jack. I told these guys you were cool.
  --Well, if jacking on will make strangers think I'm cool, I'll do it.
  if not Producer then
    return
  end
  local amount = Producer:GetAmountStored()
  if amount > 1000 then
    local p = Producer.parent
    local cc = FindNearestObject(p.command_centers,p).drones
    --i'm looking at you rocket
    if #cc == 0 then
      --get a command_center, i'm not sure how to tell nearest to skip an object without drones
      for i = 1, #p.command_centers do
        if #p.command_centers[i].drones > 0 then
          cc = p.command_centers[i].drones
        end
      end
    end
    --get an idle drone
    local drone
    for i = 1, #cc do
      if cc[i].command == "Idle" then
        drone = cc[i]
        break
      end
    end
    if drone then
      --round to nearest 1000 (don't want uneven stacks)
      amount = (amount - amount % 1000) / 1000 * 1000
      --pick that shit up
      drone:SetCommandUserInteraction(
        "PickUp",
        Producer.stockpiles[Producer:GetNextStockpileIndex()].supply_request,
        false,
        Producer.resource_produced,
        amount
      )
    end
  end
end
