-- copied from Lua\BuildingComponents.lua
local DepositGradeToWasteRockMultipliers = {
	["Metals"] = {
		["Depleted"]  = 1200,
		["Very Low"]  = 1000,
		["Low"]       = 900,
		["Average"]   = 700,
		["High"]      = 600,
		["Very High"] = 400,
	},
	["Water"] = {
		["Depleted"]  = 150,
		["Very Low"]  = 150,
		["Low"]       = 125,
		["Average"]   = 100,
		["High"]      = 75,
		["Very High"] = 50,
	},
	["Concrete"] = {
		["Depleted"]  = 800,
		["Very Low"]  = 600,
		["Low"]       = 500,
		["Average"]   = 400,
		["High"]      = 300,
		["Very High"] = 200,
	},
	["PreciousMetals"] = {
		["Depleted"]  = 1200,
		["Very Low"]  = 1000,
		["Low"]       = 900,
		["Average"]   = 700,
		["High"]      = 600,
		["Very High"] = 400,
	},
}

function OnMsg.ClassesGenerate()

  local r = const.ResourceScale

  local orig_ResourceProducer_ProduceWasteRock = ResourceProducer.ProduceWasteRock
  function ResourceProducer:ProduceWasteRock(amount_produced, deposit_grade)
    -- check if it produces wasterock, and if it's a producer we care for (metal/water/concrete), if you want to filter it to just certain producers
--~     if self.wasterock_producer and self:IsKindOf("BaseMetalsExtractor") or self:IsKindOf("WaterProducer") or self.class == "RegolithExtractor" or self.class == "TheExcavator" then
    if self.wasterock_producer then
      -- pretty much the orig func, all this does is produce half it normally does (the / 2)
      local wasterock_amount = amount_produced * DepositGradeToWasteRockMultipliers[self.exploitation_resource][deposit_grade] / r
--~       self.wasterock_producer:Produce(wasterock_amount)
      -- we do half instead of usual amount
      self.wasterock_producer:Produce(wasterock_amount / 2)
      return self.wasterock_producer:IsStorageFull()
    end
    return false
  end

end
