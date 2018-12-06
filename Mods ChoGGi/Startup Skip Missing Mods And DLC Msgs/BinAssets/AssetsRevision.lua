-- any "mods" that need to be loaded before the game is loaded (skip logos, etc)
dofolder_files("BinAssets/Code")

CreateRealTimeThread(function()
	-- wait till mods are loaded
	WaitMsg("ModDefsLoaded")

	-- build a list of ids from lua files in "Mod Ids"
	local AsyncFileToString = AsyncFileToString
	local mod_ids = {}
	local err, files = AsyncListFiles("BinAssets/Mod Ids","*.lua")
	if not err and #files > 0 then
		for i = 1, #files do
			local err,id = AsyncFileToString(files[i])
			if not err then
				mod_ids[id] = true
			end
		end
	end

	-- remove blacklist for any mods in "Mod Ids"
	local StringFormat = string.format
	local LuaRevision = LuaRevision
	local Mods = Mods
	for _,mod in pairs(Mods) do
		if mod_ids[mod.steam_id] then
			-- i don't set this in mod\metadata.lua so it gives an error
			mod.lua_revision = LuaRevision
			-- save the old env somewhere, CurrentModPath maybe
			mod.env_old = mod.env
			-- just a little overreaching with that blacklist (yeah yeah, safety first and all that)
			mod.env = nil
			-- add a warning to any mods without a blacklist, so user knows something is up
			mod.title = StringFormat("%s (Warning)",mod.title)
			mod.description = StringFormat([[Warning: The blacklist function added in the Da Vinci update has been removed for this mod!
This means it has no limitations and can access your Steam name, Friends list, and any files on your computer.
In other words, the same as Curiosity and lower.

%s]],mod.description)
		end
	end

	-- just in case anything needs it
	Msg("ChoGGi_Blacklist")
end)

-- return revision, or else you get a blank map on new game
MountPack("ChoGGi_BinAssets", "Packs/BinAssets.hpk")
return dofile("ChoGGi_BinAssets/AssetsRevision.lua") or 235636
