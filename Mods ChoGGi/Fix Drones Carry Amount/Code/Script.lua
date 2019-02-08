-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 55
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[Drones Carry Amount requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				if p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/505/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/89?tab=files")
				end
			end
		end)
	end
end

local FuckingDrones
local CompareTableFuncs
local GetNearestIdleDrone

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()
	FuckingDrones = ChoGGi.ComFuncs.FuckingDrones
	CompareTableFuncs = ChoGGi.ComFuncs.CompareTableFuncs
	GetNearestIdleDrone = ChoGGi.ComFuncs.GetNearestIdleDrone
end

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
