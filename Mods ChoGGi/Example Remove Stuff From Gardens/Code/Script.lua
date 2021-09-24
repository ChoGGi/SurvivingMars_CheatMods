-- See LICENSE for terms

local buildings_to_check = {
	GardenLake = true,
	GardenStone = true,
	GardenFountains_01 = true,
	GardenFountains_02 = true,
	GardenFountains_03 = true,
	GardenAlleys_01 = true,
	GardenAlleys_02 = true,
	GardenAlleys_03 = true,
	GardenAlleys_04 = true,
	GardenAlleys_05 = true,
	GardenAlleys_06 = true,
	GardenNatural_01 = true,
	GardenNatural_02 = true,
	GardenNatural_03 = true,
	GardenNatural_04 = true,
	GardenNatural_05 = true,
	GardenNatural_06 = true,
	GardenStatue_01 = true,
	GardenStatue_02 = true,
}

local classes_to_remove = {
	-- roads
	"DomeRoadConnection_08", "DecGardenRoad_05",
	-- lamps
	"LampInt_03",
	-- benches
	"DecorInt_03", "DecorInt_04",
}

local ChoOrig_Service_GameInit = Service.GameInit
function Service:GameInit()


	-- only remove stuff if we're outside of a dome
	if not self.parent_dome and buildings_to_check[self:GetEntity()] then
		self:DestroyAttaches(classes_to_remove)
	end

	-- send the orig func on it's way
	return ChoOrig_Service_GameInit(self)
end
