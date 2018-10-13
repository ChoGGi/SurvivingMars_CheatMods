-- See LICENSE for terms

-- tell people know how to get the library
function OnMsg.ModsReloaded()
	local min_version = 22

	local ModsLoaded = ModsLoaded
	local not_found_or_wrong_version
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	if idx then
		-- steam updates automatically
		if not Platform.steam and min_version > ModsLoaded[idx].version then
			not_found_or_wrong_version = true
		end
	else
		not_found_or_wrong_version = true
	end

	if not_found_or_wrong_version then
		CreateRealTimeThread(function()
			local Sleep = Sleep
			while not UICity do
				Sleep(2500)
			end
			if WaitMarsQuestion(nil,nil,string.format([[Error: Drones Carry Amount requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()

	local FuckingDrones = ChoGGi.ComFuncs.FuckingDrones
	local CompareTableFuncs = ChoGGi.ComFuncs.CompareTableFuncs
	local GetNearestIdleDrone = ChoGGi.ComFuncs.GetNearestIdleDrone

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
