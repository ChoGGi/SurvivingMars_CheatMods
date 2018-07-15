local PositiveTraits
local NegativeTraits

-- this will allow us to add/remove any custom traits
function OnMsg.ModsLoaded()
  PositiveTraits = {}
  NegativeTraits = {}
  local traits = DataInstances.Trait
  for i = 1, #traits do
    if traits[i].category == "Positive" then
      PositiveTraits[#PositiveTraits+1] = traits[i].name
    elseif traits[i].category == "Negative" then
      NegativeTraits[#NegativeTraits+1] = traits[i].name
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
  SetTraits(c,PositiveTraits,"AddTrait")
  SetTraits(c,NegativeTraits,"RemoveTrait")
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
  local colonists = UICity.labels.Colonist or empty_table
  for i = 1, #colonists do
    UpdateTraits(colonists[i])
  end
end
