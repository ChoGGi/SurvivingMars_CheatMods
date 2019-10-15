-- See LICENSE for terms

-- I didn't get a harumph outta that guy!
ModEnvBlacklist = {--[[Harumph!]]}

local ChoGGi = ChoGGi
local def = CurrentModDef

-- is ECM shanghaied by the blacklist?
if def.no_blacklist then
	ChoGGi.blacklist = false
	local env = def.env
	Msg("ChoGGi_UpdateBlacklistFuncs", env)
	-- makes some stuff easier
	local lib_env = ChoGGi.def_lib.env
	lib_env._G = env._G
	lib_env.rawget = env.rawget
	lib_env.getmetatable = env.getmetatable
	lib_env.os = env.os
end

-- I should really split ChoGGi into funcs and settings... one of these days
ChoGGi.id = CurrentModId
ChoGGi.def = def
ChoGGi._VERSION = "v" .. def.version_major .. "." .. def.version_minor
-- path to this mods' folder
ChoGGi.mod_path = def.env.CurrentModPath or def.content_path or def.path
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
		local err = AsyncGetFileAttribute(file, "size")
		if not err then
			return true
		end
	end
end
