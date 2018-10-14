-- See LICENSE for terms

local S = ChoGGi.Strings

-- easy access to colonist data, cargo, mystery
ChoGGi.Tables = {
	-- display names only! (they're stored as numbers, not names like the rest; which is why i'm guessing)
	ColonistRaces = {
		S[1859--[[White--]]],[S[1859--[[White--]]]] = true,
		S[302535920000739--[[Black--]]],[S[302535920000739--[[Black--]]]] = true,
		S[302535920000740--[[Asian--]]],[S[302535920000740--[[Asian--]]]] = true,
		S[302535920001283--[[Indian--]]],[S[302535920001283--[[Indian--]]]] = true,
		S[302535920001284--[[Southeast Asian--]]],[S[302535920001284--[[Southeast Asian--]]]] = true,
	},
--~ s.race = 1
--~ s:ChooseEntity()

	-- some names need to be fixed when doing construction placement
	ConstructionNamesListFix = {
		RCRover = "RCRoverBuilding",
		RCDesireTransport = "RCDesireTransportBuilding",
		RCTransport = "RCTransportBuilding",
		ExplorerRover = "RCExplorerBuilding",
		Rocket = "SupplyRocket",
	},
	Cargo = {},
	CargoPresets = {},
	Mystery = {},
	NegativeTraits = {},
	PositiveTraits = {},
	OtherTraits = {},
	ColonistAges = {},
	ColonistGenders = {},
	ColonistSpecializations = {},
	ColonistBirthplaces = {},
	Resources = {},
	SchoolTraits = {},
	SanatoriumTraits = {},
}
-- also called after mods are loaded, we call it now for any functions that use it before then
ChoGGi.ComFuncs.UpdateDataTables()
