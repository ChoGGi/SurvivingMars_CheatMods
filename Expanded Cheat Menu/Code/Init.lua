-- I didn't get a harumph outta that guy!
ModEnvBlacklist = {--[[Harumph!--]]}
-- yeah, I know it don't do jack your point?



-- See LICENSE for terms

local LICENSE = [[
Any code from https://github.com/HaemimontGames/SurvivingMars is copyright by their LICENSE

All of my code is licensed under the MIT License as follows:

MIT License

Copyright (c) [2018] [ChoGGi]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 53
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[Expanded Cheat Menu requires ChoGGi's Library (at least v%s).
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

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()

	local ChoGGi,Mods = ChoGGi,Mods
	local mod = Mods[ChoGGi.id]
	local blacklist = mod.env
	ChoGGi._LICENSE = LICENSE

	-- I should really split ChoGGi into funcs and settings... one of these days

	ChoGGi._VERSION = mod.version
	-- is ECM shanghaied by the blacklist?
	ChoGGi.blacklist = blacklist
	-- path to this mods' folder
	ChoGGi.mod_path = blacklist and CurrentModPath or mod.env_old and mod.env_old.CurrentModPath or mod.content_path or mod.path
	-- Console>Scripts folder
	ChoGGi.scripts = "AppData/ECM Scripts"
	-- you can pry my settings FILE from my cold dead (and not modding SM anymore) hands.
	ChoGGi.settings_file = blacklist and nil or "AppData/CheatMenuModSettings.lua"

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
