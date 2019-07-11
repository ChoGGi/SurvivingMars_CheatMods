-- See LICENSE for terms

-- I didn't get a harumph outta that guy!
ModEnvBlacklist = {--[[Harumph!]]}

local ChoGGi = ChoGGi
local mod = Mods.ChoGGi_CheatMenu

-- is ECM shanghaied by the blacklist?
if mod.no_blacklist then
	ChoGGi.blacklist = false
	local env = mod.env
	Msg("ChoGGi_UpdateBlacklistFuncs", env)
	-- makes some stuff easier
	local lib_env = Mods.ChoGGi_Library.env
	lib_env._G = env._G
	lib_env.rawget = env.rawget
	lib_env.getmetatable = env.getmetatable
	lib_env.os = env.os
end

-- I should really split ChoGGi into funcs and settings... one of these days
ChoGGi._VERSION = "v" .. mod.version_major .. "." .. mod.version_minor
-- path to this mods' folder
ChoGGi.mod_path = mod.env.CurrentModPath or mod.content_path or mod.path
-- Console>Scripts folder
ChoGGi.scripts = "AppData/ECM Scripts"
-- you can pry my settings FILE from my cold dead (and not modding SM anymore) hands.
ChoGGi.settings_file = "AppData/CheatMenuModSettings.lua"

if ChoGGi.blacklist then
	ChoGGi.ComFuncs.FileExists = empty_func
else
	local AsyncGetFileAttribute = AsyncGetFileAttribute
	function ChoGGi.ComFuncs.FileExists(file)
		-- folders don't have a size
		local err, _ = AsyncGetFileAttribute(file, "size")
		if not err then
			return true
		end
	end
end
