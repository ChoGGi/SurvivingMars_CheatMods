-- See LICENSE for terms

-- tell people know how to get the library
function OnMsg.ModsReloaded()
	local min_version = 19

	local ModsLoaded = ModsLoaded
	-- we need a version check to remind Nexus/GoG users
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
			if WaitMarsQuestion(nil,nil,string.format([[Error: Random Object Colour requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],library_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

local orig_BaseBuilding_GameInit = BaseBuilding.GameInit
function BaseBuilding:GameInit(...)
	orig_BaseBuilding_GameInit(self,...)

	-- we need to wait a sec before we can edit attaches
	CreateRealTimeThread(function()
		ChoGGi.ComFuncs.ObjectColourRandom(self)
		-- reset any signs to default colour
		local SetDefColour = ChoGGi.ComFuncs.SetDefColour
		if self:IsKindOf("ComponentAttach") then
			self:ForEachAttach("BuildingSign",function(a)
				SetDefColour(a)
			end)
		end
	end)

end
