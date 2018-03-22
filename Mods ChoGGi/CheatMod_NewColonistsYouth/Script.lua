local function UpdateTraits(colonist)
  for i,colonist in ipairs((UICity.labels).Colonist or empty_table) do
    if colonist.traits.Retiree then
      colonist.age_trait = "Youth"
    elseif colonist.traits.Senior then
      colonist.age_trait = "Youth"
    elseif colonist.traits.Adult then
      colonist.age_trait = "Youth"
    elseif colonist.traits.Child then
      colonist.age_trait = "Youth"
    elseif colonist.traits["Middle Aged"] then
      colonist.age_trait = "Youth"
    end
    --uncomment to also make sex to Other (so no more babies at all)
    --colonist.gender = "Other"
  end
end

function OnMsg.ColonistArrived(colonist)
  UpdateTraits(colonist)
end

function OnMsg.ColonistBorn(colonist)
  UpdateTraits(colonist)
end
