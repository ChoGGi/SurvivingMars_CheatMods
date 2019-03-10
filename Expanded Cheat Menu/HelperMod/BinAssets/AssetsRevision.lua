-- any "mods" that need to be loaded before the game is loaded (skip logos, etc)
dofolder_files("BinAssets/Code")

-- thread needed for WaitMsg
CreateRealTimeThread(function()
	-- needs an inf loop, so it fires whenever mod manager does it's thing.
	while true do
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
		local rev = LuaRevision
		for _,mod in pairs(Mods) do
			if mod_ids[mod.steam_id] then
				mod.lua_revision = rev
				-- just a little overreaching with that blacklist (yeah yeah, safety first and all that)
				mod.env_old = mod.env
				mod.env = nil
				-- add a warning to any mods without a blacklist, so user knows something is up
--~ 				mod.title = mod.title .. " (BL)"
				mod.title = mod.title .. " (Warning)"
--~ 				mod.description = mod.description:gsub([[C:\Users\ChoGGi\AppData\Roaming\Surviving Mars\Mods\]],"AppData/Mods/")
				mod.description = [[Warning: The blacklist function has been removed for this mod!
This means it has no limitations and can access your Steam name, Friends list, and any files on your computer.
In other words, the same as Curiosity and lower.

]] .. mod.description
			end
		end

		-- just in case anything needs it
		Msg("ChoGGi_Blacklist")
	end
end)

-- return revision, or else you get a blank map on new game
MountPack("ChoGGi_BinAssets", "Packs/BinAssets.hpk")
return dofile("ChoGGi_BinAssets/AssetsRevision.lua") or 240905
