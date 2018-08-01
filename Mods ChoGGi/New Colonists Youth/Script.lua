local function UpdateTraits(colonist)
  for i,colonist in ipairs((UICity.labels).Colonist or empty_table) do
    colonist.age_trait = "Youth"
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
