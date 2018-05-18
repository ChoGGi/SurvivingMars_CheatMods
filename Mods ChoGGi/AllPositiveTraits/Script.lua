local function UpdateTraits(colonist)

--add positive traits
--if not colonist.traits.Workaholic then

  --"Individual performance increased by 20. No penalty for heavy workloads. -Relaxation"
  colonist:AddTrait("Workaholic")
  --"Loses less Health without food, water, oxygen or when living in an unpowered Dome."
  colonist:AddTrait("Survivor")
  --"Greatly increased birth rate."
  colonist:AddTrait("Sexy")
  --"All Sanity losses are halved."
  colonist:AddTrait("Composed")
  --"Generates Research when in the Colony."
  colonist:AddTrait("Genius")
  --"Generates Funding when in the Colony."
  colonist:AddTrait("Celebrity")
  --"Raises the Morale of all Religious people in the Dome. Benefits stack with each additional Saint."
  colonist:AddTrait("Saint")
  --"Higher individual base Morale. Low Sanity never leads to suicide."
  colonist:AddTrait("Religious")
  --"Recovers Sanity when gaming. +Gaming"
  colonist:AddTrait("Gamer")
  --"The Dreamers have emerged from the Mirages with renewed hope. +15 performance"
  colonist:AddTrait("DreamerPostMystery")
  --"Raises the Morale of all Colonists in the Dome. The effects of multiple Empaths stack."
  colonist:AddTrait("Empath")
  --"Gains a temporary Morale boost every time a new technology is researched."
  colonist:AddTrait("Nerd")
  --"No Comfort penalties when eating unprepared food or having no residence."
  colonist:AddTrait("Rugged")
  --"More health recovered while resting. Can work when health is low. +Exercise"
  colonist:AddTrait("Fit")
  --"Increased performance boost when at high Morale."
  colonist:AddTrait("Enthusiast")
  --"Gains twice as much Comfort in gardens and parks."
  colonist:AddTrait("Hippie")
  --"Gains additional Comfort when satisfying social interest. +Social"
  colonist:AddTrait("Extrovert")
  --"Martianborn Colonists never become Earthsick. The Martianborn group of techs can improve this trait significantly."
  colonist:AddTrait("Martianborn")

--remove negative traits
--if colonist.traits.Lazy then

  --"Individual performance decreased by 20 at all jobs."
  colonist:RemoveTrait("Lazy")
  --"Untrained for life on Mars, which results in decreased performance at all jobs. Can become a Renegade."
  colonist:RemoveTrait("Refugee")
  --"Loses Health each day."
  colonist:RemoveTrait("ChronicCondition")
  --"Loses Health each day. Spreads to other Colonists in the Dome."
  colonist:RemoveTrait("Infected")
  --"Can cause a malfunction at workplace (10% chance). Malfunctioning buildings stop working and require maintenance."
  colonist:RemoveTrait("Idiot")
  --"Work performance lowered by 10. Can be caused by Sanity breakdowns. +Drinking"
  colonist:RemoveTrait("Alcoholic")
  --"Has a 50% chance to lose 20 Sanity when visiting a Casino. Can be caused by Sanity breakdowns. +Gambling"
  colonist:RemoveTrait("Gambler")
  --"Eats double rations. Can be caused by Sanity breakdowns. +Dining"
  colonist:RemoveTrait("Glutton")
  --"Will randomly visit Medical buildings and take Sanity damage if unable to do so. Interests: +Medical"
  colonist:RemoveTrait("Hypochondriac")
  --"Loses Sanity when low on Comfort."
  colonist:RemoveTrait("Whiner")
  --"Has half the lifespan of a naturally born human."
  colonist:RemoveTrait("Clone")
  --"Performance decreased by 50 at all jobs. Can cause crime events when there are not enough Security Stations in the Dome."
  colonist:RemoveTrait("Renegade")
  --"Increased performance penalty when at low Morale. Can be caused by Sanity breakdowns."
  colonist:RemoveTrait("Melancholic")
  --"Loses Comfort every day while living in a Dome with population over 30. -Social"
  colonist:RemoveTrait("Introvert")
  --"Double Sanity loss from disasters. Can be caused by Sanity breakdowns."
  colonist:RemoveTrait("Coward")
  --"Doesn't work. Leaves at first opportunity, but will decide to stay if Comfort is high. +Gambling"
  colonist:RemoveTrait("Tourist")

--[[
--set ages (doesn't work)

  --"A senior Colonist, too old to work."
  if colonist.traits.Retiree then
    colonist:RemoveTrait("Retiree")
    colonist:AddTrait("Youth")
	end
  if colonist.traits.Senior then
    colonist:RemoveTrait("Senior")
    colonist:AddTrait("Youth")
	end
  if colonist.traits.MiddleAged then
    colonist:RemoveTrait("Middle Aged")
    colonist:AddTrait("Youth")
	end
  if colonist.traits.Adult then
    colonist:RemoveTrait("Adult")
    colonist:AddTrait("Youth")
	end
  if colonist.traits.Child then
    colonist:RemoveTrait("Child")
    colonist:AddTrait("Youth")
	end

--if no specialization (doesn't work either)

  if colonist.traits.none then
    local jobs = { 'scientist', 'engineer', 'security', 'geologist', 'botanist', 'medic' }
    colonist:AddTrait(jobs[ math.random( #jobs ) ])
	end

--other traits

"One of the first Martian Colonists."
Founder
"Randomly spreads other traits of this colonist to persons in the same Dome with less than 3 traits."
Guru
"Synthetically created humans that function similarly to us - they breathe, they eat and they sleep. However they do not age and cannot reproduce."
Android
"Dreamers make sense of the shared dream but lose Sanity during Mirages."
Dreamer (might bug out certain mysteries so left it here)
"Don't worry. They'll tell you."
Vegan

"A person born biologically male."
Male
"A person born biologically female."
Female
"A person with biological sex that is neither male nor female."
OtherGender
"Children are too young to work and use many of the buildings in the Colony. They can go to School and use certain special buildings such as the Playground and Nursery."
Child
"A young Colonist, able to work in all buildings."
Youth
"An adult Colonist, able to work in all buildings."
Adult
"A middle aged Colonist, approaching retirement, but still able to work in all buildings."
Middle Aged

"No specialization"
none
"A science specialist trained to work in research buildings. Interests: +Gaming, - Shopping"
scientist
"An engineer trained to work in factories. Interests: +Dining, - Social"
engineer
"A security specialist trained to work in security buildings. Interests: +Exercise, - Shopping"
security
"A geology specialist trained to work in extractor buildings. Interests: +Drinking, - Relaxation"
geologist
"A botany specialist trained to work on farms. Interests: +Luxury, - Social"
botanist
"A medical specialist trained to work in medical buildings. Interests: +Luxury, - Relaxation"
medic
--]]
end

function OnMsg.ColonistArrived(colonist)
  UpdateTraits(colonist)
end

function OnMsg.ColonistBorn(colonist)
  UpdateTraits(colonist)
end

--not working?
function OnMsg.LoadGame()
  for _,colonist in ipairs((UICity.labels).Colonist or empty_table) do
    UpdateTraits(colonist)
  end
end

--if you already have people, and you want to apply this to them then uncomment this function.
--this might be laggy for large colonies.

--[[
function OnMsg.ColonistStatusEffect(colonist)
  UpdateTraits(colonist)
end
--]]
