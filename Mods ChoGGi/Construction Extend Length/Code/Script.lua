local function SomeCode()
	GridConstructionController.max_hex_distance_to_allow_build = ConstructionExtendLength.BuildDist or 1000
	const.PassageConstructionGroupMaxSize = ConstructionExtendLength.PassChunks or 1000
end

-- new games
OnMsg.CityStart = SomeCode
-- loaded games
OnMsg.LoadGame = SomeCode
