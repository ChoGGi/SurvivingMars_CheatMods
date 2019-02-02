-- I make no guarantees of a stable API, best to just to copy what you want :)
-- but if you want to here is what I use:

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 52
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	-- if we can't find mod or mod is less then min_version (we skip steam since it updates automatically)
	if not idx or idx and not Platform.steam and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[XXXXXXXXXX requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

-- generate is late enough that my library is loaded, but early enough to replace anything I need to
-- this way I don't need to worry about the mod load order. hopefully devs will implement that one of these days...
function OnMsg.ClassesGenerate()
end
