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
