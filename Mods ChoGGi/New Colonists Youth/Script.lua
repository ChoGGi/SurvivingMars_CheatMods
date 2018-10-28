local traits_age = {}

--build age trait list
function OnMsg.ModsReloaded()
  table.iclear(traits_age)
	local c = 0

	for name,trait in pairs(TraitPresets) do
    if trait.category == "Age Group" then
			c = c + 1
      traits_age[c] = name
    end
	end
end

local function UpdateTraits(colonist)
	-- remove all age traits and add back youth
	for i = 1, #traits_age do
		colonist:RemoveTrait(traits_age[i])
	end
	colonist:AddTrait("Youth")
end

function OnMsg.ColonistArrived(colonist)
  UpdateTraits(colonist)
end

function OnMsg.ColonistBorn(colonist)
  UpdateTraits(colonist)
end
