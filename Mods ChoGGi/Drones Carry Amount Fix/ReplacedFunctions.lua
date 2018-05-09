function ChoGGiX.ReplacedFunctions_ClassesBuilt()

  if not ChoGGiX.OrigFunc.SingleResourceProducer_Produce then
    ChoGGiX.OrigFunc.SingleResourceProducer_Produce = SingleResourceProducer.Produce
  end
  function SingleResourceProducer:Produce(amount_to_produce)

    --get them lazy drones working (bugfix for drones ignoring amounts less then their carry amount)
    if ChoGGiX.CheatMenuSettings.DroneResourceCarryAmountFix then
      ChoGGiX.FuckingDrones(self)
    end

    return ChoGGiX.OrigFunc.SingleResourceProducer_Produce(self, amount_to_produce)
  end

end
