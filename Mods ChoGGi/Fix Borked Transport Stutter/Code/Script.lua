-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
local fire_once
function OnMsg.ModsReloaded()
	if fire_once then
		return
	end
	fire_once = true
	local min_version = 24

	local ModsLoaded = ModsLoaded
	-- we need a version check to remind Nexus/GoG users
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
			if WaitMarsQuestion(nil,"Error",string.format([[Borked Transport Stutter requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

function OnMsg.ClassesBuilt()

	ChoGGi.ComFuncs.SaveOrigFunc("RCTransport","TransportRouteLoad")
	ChoGGi.ComFuncs.SaveOrigFunc("RCTransport","TransportRouteUnload")
	local ChoGGi_OrigFuncs = ChoGGi.OrigFuncs
	local CheckForBorkedTransportPath = ChoGGi.ComFuncs.CheckForBorkedTransportPath

	function RCTransport:TransportRouteLoad(...)
		ChoGGi_OrigFuncs.RCTransport_TransportRouteLoad(self,...)
		CheckForBorkedTransportPath(self)
	end

	function RCTransport:TransportRouteUnload(...)
		ChoGGi_OrigFuncs.RCTransport_TransportRouteUnload(self,...)
		CheckForBorkedTransportPath(self)
	end

end
