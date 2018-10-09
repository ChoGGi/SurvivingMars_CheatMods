-- See LICENSE for terms

-- tell people know how to get the library
function OnMsg.ModsReloaded()
	local min_version = 20

	local ModsLoaded = ModsLoaded
	local not_found_or_wrong_version
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	if idx then
		if min_version > ModsLoaded[idx].version then
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

function OnMsg.ClassesBuilt()

	ChoGGi.ComFuncs.SaveOrigFunc("RCTransport","TransportRouteLoad")
	ChoGGi.ComFuncs.SaveOrigFunc("RCTransport","TransportRouteUnload")
	local ChoGGi_OrigFuncs = ChoGGi.OrigFuncs
	local CheckForBorkedTransportPath = ChoGGi.CodeFuncs.CheckForBorkedTransportPath

	function RCTransport:TransportRouteLoad(...)
		ChoGGi_OrigFuncs.RCTransport_TransportRouteLoad(self,...)
		CheckForBorkedTransportPath(self)
	end

	function RCTransport:TransportRouteUnload(...)
		ChoGGi_OrigFuncs.RCTransport_TransportRouteUnload(self,...)
		CheckForBorkedTransportPath(self)
	end

end
