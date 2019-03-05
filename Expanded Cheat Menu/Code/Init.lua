-- See LICENSE for terms

-- I didn't get a harumph outta that guy!
ModEnvBlacklist = {--[[Harumph!--]]}
-- yeah, I know it don't do jack your point?

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 58
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error","Expanded Cheat Menu requires ChoGGi's Library (at least v" .. min_version .. [[).
Press OK to download it or check the Mod Manager to make sure it's enabled.]]) == "ok" then
				if p.steam then
					OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
				elseif p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/505/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/89?tab=files")
				end
			end
		end)
	end
end

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()

	local ChoGGi = ChoGGi
	local mod = Mods[ChoGGi.id]
	local blacklist = mod.env

	-- I should really split ChoGGi into funcs and settings... one of these days

	ChoGGi._VERSION = mod.version
	-- is ECM shanghaied by the blacklist?
	ChoGGi.blacklist = blacklist
	-- path to this mods' folder
	ChoGGi.mod_path = blacklist and CurrentModPath or mod.env_old and mod.env_old.CurrentModPath or mod.content_path or mod.path
	-- Console>Scripts folder
	ChoGGi.scripts = "AppData/ECM Scripts"
	-- you can pry my settings FILE from my cold dead (and not modding SM anymore) hands.
	ChoGGi.settings_file = "AppData/CheatMenuModSettings.lua"

	if blacklist then
		ChoGGi.ComFuncs.FileExists = empty_func
	else
		-- used for certain funcs in lib comfuncs
		ChoGGi.Temp._G = _G

		local AsyncGetFileAttribute = AsyncGetFileAttribute
		function ChoGGi.ComFuncs.FileExists(file)
			-- folders don't have a size
			local err,_ = AsyncGetFileAttribute(file,"size")
			if not err then
				return true
			end
		end
	end

end
