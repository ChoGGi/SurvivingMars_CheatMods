-- See LICENSE for terms

local FuckingDrones = ChoGGi.ComFuncs.FuckingDrones

function OnMsg.ClassesBuilt()

	local orig_SingleResourceProducer_Produce = SingleResourceProducer.Produce
	function SingleResourceProducer:Produce(...)
		-- get them lazy drones working (bugfix for drones ignoring amounts less then their carry amount)
		FuckingDrones(self)
		-- be on your way
		return orig_SingleResourceProducer_Produce(self,...)
	end

end

local CreateRealTimeThread = CreateRealTimeThread
local Sleep = Sleep
function OnMsg.NewHour()
	CreateRealTimeThread(function()
		Sleep(500)
		local labels = UICity.labels

		-- Hey. Do I preach at you when you're lying stoned in the gutter? No!
		local prods = labels.ResourceProducer or ""
		for i = 1, #prods do
			FuckingDrones(prods[i]:GetProducerObj())
			if prods[i].wasterock_producer then
				FuckingDrones(prods[i].wasterock_producer)
			end
		end

		prods = labels.BlackCubeStockpiles or ""
		for i = 1, #prods do
			FuckingDrones(prods[i])
		end

	end)
end
