-- See LICENSE for terms

local positive_traits = {}
local negative_traits = {}

-- this will allow us to add/remove any mod-added traits
function OnMsg.ModsReloaded()
	table.iclear(positive_traits)
	local cp = 0
	table.iclear(negative_traits)
	local cn = 0

	local TraitPresets = TraitPresets
	for name, trait in pairs(TraitPresets) do
		if trait.category == "Positive" then
			cp = cp + 1
			positive_traits[cp] = name
		elseif trait.category == "Negative" then
			cn = cn + 1
			negative_traits[cn] = name
		end
	end

end

local function SetTraits(c, traits, func)
	for i = 1, #traits do
		-- true isn't needed for RemoveTrait, and only needed for certain AddTrait
		c[func](c, traits[i], true)
	end
end

local function UpdateTraits(c)
	SetTraits(c, positive_traits, "AddTrait")
	SetTraits(c, negative_traits, "RemoveTrait")
end

-- msg sends a single colonist
OnMsg.ColonistArrived = UpdateTraits
OnMsg.ColonistBorn = UpdateTraits

-- fires when game is loaded
function OnMsg.LoadGame()
	-- Gets all colonists in all cities (use UICity for current city map instead)
	local colonists = UIColony:GetCityLabels("Colonist")
	for i = 1, #colonists do
		UpdateTraits(colonists[i])
	end
end
