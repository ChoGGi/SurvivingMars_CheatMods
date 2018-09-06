-- I didn't get a harumph outta that guy!
ModEnvBlacklist = {--[[Harumph!--]]}

-- yeah, I know it don't do jack shit your point?



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

function OnMsg.ModsLoaded()
	if not table.find(ModsLoaded,"id","ChoGGi_Library") then
		print([[Error: This mod requires ChoGGi's Library:
https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374
Check Mod Manager to make sure it's enabled.]])
	end
end

-- nope not hacky at all
local is_loaded
function OnMsg.ClassesGenerate()
	Msg("ChoGGi_Library_Loaded","ChoGGi_CheatMenu")
end
function OnMsg.ChoGGi_Library_Loaded(mod_id)
	if is_loaded or mod_id and mod_id ~= "ChoGGi_CheatMenu" then
		return
	end
	is_loaded = true

	local ChoGGi = ChoGGi

	ChoGGi._LICENSE = LICENSE

	local blacklist,Mods = Mods[ChoGGi.id].env,Mods

	-- I should really split this into funcs and settings... one of these days
	ChoGGi._VERSION = Mods[ChoGGi.id].version
	-- is ECM shanghaied by the blacklist?
	ChoGGi.blacklist = blacklist
	-- path to this mods' folder
	ChoGGi.ModPath = blacklist and CurrentModPath or Mods[ChoGGi.id].content_path or Mods[ChoGGi.id].path
	-- Console>Scripts folder
	ChoGGi.scripts = "AppData/ECM Scripts"
	-- you can pry my settings FILE from my cold dead (and not modding SM anymore) hands.
	ChoGGi.SettingsFile = blacklist and nil or "AppData/CheatMenuModSettings.lua"

	if not blacklist then
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
