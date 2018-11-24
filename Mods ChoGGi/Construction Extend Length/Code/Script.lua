-- new games
function OnMsg.CityStart()
	GridConstructionController.max_hex_distance_to_allow_build = ConstructionExtendLength.BuildDist or 1000
	const.PassageConstructionGroupMaxSize = ConstructionExtendLength.PassChunks or 1000
end
-- loaded games
function OnMsg.LoadGame()
	GridConstructionController.max_hex_distance_to_allow_build = ConstructionExtendLength.BuildDist or 1000
	const.PassageConstructionGroupMaxSize = ConstructionExtendLength.PassChunks or 1000
end
