function OnMsg.ColonistBorn(obj)
  if not UICity.ChoGGi_MakeFirstMartianbornCelebrity then
    obj:AddTrait("Celebrity", true)
    UICity.ChoGGi_MakeFirstMartianbornCelebrity = obj.handle
  end
end
