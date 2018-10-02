-- See LICENSE for terms

-- tell people know how to get the library
function OnMsg.ModsReloaded()
	local library_version = 18

	local ModsLoaded = ModsLoaded
	local not_found_or_wrong_version
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	if idx then
		if ModsLoaded[idx].version > library_version then
			not_found_or_wrong_version = true
		end
	else
		not_found_or_wrong_version = true
	end

	if not_found_or_wrong_version then
		CreateRealTimeThread(function()
			local Sleep = Sleep
			while not UICity do
				Sleep(1000)
			end
			if WaitMarsQuestion(nil,nil,string.format([[Error: This mod requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],library_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()

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
