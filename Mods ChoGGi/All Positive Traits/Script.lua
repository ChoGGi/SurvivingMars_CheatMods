local positive_traits = {}
local negative_traits = {}

-- this will allow us to add/remove any custom traits
function OnMsg.ModsReloaded()
  table.iclear(positive_traits)
	local cp = 0
  table.iclear(negative_traits)
	local cn = 0

	for name,trait in pairs(TraitPresets) do
    if trait.category == "Positive" then
			cp = cp + 1
      positive_traits[cp] = name
    elseif trait.category == "Negative" then
			cn = cn + 1
      negative_traits[cn] = name
    end
	end

end

local function SetTraits(c,traits,func)
  for i = 1, #traits do
    -- true isn't needed for RemoveTrait, and only needed for certain AddTrait
    c[func](c,traits[i],true)
  end
end

local function UpdateTraits(c)
  SetTraits(c,positive_traits,"AddTrait")
  SetTraits(c,negative_traits,"RemoveTrait")
end

-- fires on colonist got off rocket
function OnMsg.ColonistArrived(colonist)
  UpdateTraits(colonist)
end
-- fires on colonist born
function OnMsg.ColonistBorn(colonist)
  UpdateTraits(colonist)
end
-- fires when game is loaded
function OnMsg.LoadGame()
  local colonists = UICity.labels.Colonist or ""
  for i = 1, #colonists do
    UpdateTraits(colonists[i])
  end
end
