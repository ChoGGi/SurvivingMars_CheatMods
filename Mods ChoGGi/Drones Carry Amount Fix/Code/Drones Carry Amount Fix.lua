-- See LICENSE for terms

function OnMsg.ModsLoaded()
	if not table.find(ModsLoaded,"id","ChoGGi_Library") then
		CreateRealTimeThread(function()
			local Sleep = Sleep
			while not UICity do
				Sleep(1000)
			end
			if WaitMarsQuestion(nil,nil,[[Error: This mod requires ChoGGi's Library.
Press Ok to download it or check Mod Manager to make sure it's enabled.]]) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

-- nope not hacky at all
local is_loaded
function OnMsg.ClassesGenerate()
	Msg("ChoGGi_Library_Loaded")
end
function OnMsg.ChoGGi_Library_Loaded()
	if is_loaded then
		return
	end
	is_loaded = true
	-- nope nope nope

	local FuckingDrones = ChoGGi.CodeFuncs.FuckingDrones
	local CompareTableFuncs = ChoGGi.CodeFuncs.CompareTableFuncs
	local GetNearestIdleDrone = ChoGGi.CodeFuncs.GetNearestIdleDrone

	function OnMsg.ClassesBuilt()
		ChoGGi.ComFuncs.SaveOrigFunc("SingleResourceProducer","Produce")
		local ChoGGi_OrigFuncs = ChoGGi.OrigFuncs

		function g_Classes.SingleResourceProducer:Produce(...)
			-- get them lazy drones working (bugfix for drones ignoring amounts less then their carry amount)
			FuckingDrones(self)
			-- be on your way
			return ChoGGi_OrigFuncs.SingleResourceProducer_Produce(self,...)
		end

	end

	local DelayedCall = DelayedCall
	function OnMsg.NewHour()
		DelayedCall(500, function()
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

end
