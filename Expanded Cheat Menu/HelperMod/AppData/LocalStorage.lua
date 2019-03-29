-- load settings before anything else (for anything in /Code that uses them)
local new_settings_file = "AppData/LocalStorage_Settings.lua"
g_LocalStorageFile = new_settings_file
local settings = dofile(new_settings_file)
LocalStorage = settings

-- any "mods" that need to be loaded before the game is loaded (skip logos, etc)
dofolder_files("AppData/BinAssets/Code")

-- a less restrictive env
local original_G = _G
local function LuaModEnv(env)
  env = env or {}
  env._G = original_G
	setmetatable(env, {
		__index = function(_, key)
			return original_G[key]
		end,
		__newindex = function(_, key, value)
			original_G[key] = value
		end,
	})
  return env
end

CreateRealTimeThread(function()

	-- build a list of ids from lua files in "Mod Ids"
	local AsyncFileToString = AsyncFileToString
	local mod_ids = {}
	local err, files = AsyncListFiles("AppData/BinAssets/Mod Ids","*.lua")
	if not err and #files > 0 then
		for i = 1, #files do
			local err,id = AsyncFileToString(files[i])
			if not err then
				mod_ids[id] = true
			end
		end
	end

	-- needs an inf loop, so it fires whenever mod manager does it's thing.
	while true do
		-- wait till mods are loaded
		WaitMsg("ModDefsLoaded")

		-- remove blacklist for any mods in "Mod Ids"
		local rev = LuaRevision
		for _,mod in pairs(Mods) do
			if mod_ids[mod.steam_id] then
				mod.lua_revision = rev
				-- just a little overreaching with that blacklist (yeah yeah, safety first and all that)
				mod.no_blacklist = true
				mod.env.Msg = nil
				mod.env.getmetatable = nil
				mod.env.os = nil
				mod.env = LuaModEnv(mod.env)
				-- add a warning to any mods without a blacklist, so user knows something is up
--~ 				mod.title = mod.title .. " (BL)"
				mod.title = mod.title .. " (Warning)"
--~ 				mod.description = mod.description:gsub([[C:\Users\ChoGGi\AppData\Roaming\Surviving Mars\Mods\]],"AppData/Mods/")
				mod.description = [[Warning: The blacklist function has been removed for this mod!
This means it has no limitations and can access your Steam name, Friends list, and any files on your computer.

]] .. mod.description
			end
		end

		-- just in case anything needs it
		Msg("ChoGGi_Blacklist")
	end
end)

-- and done
return settings
