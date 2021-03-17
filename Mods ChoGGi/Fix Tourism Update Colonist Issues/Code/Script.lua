-- See LICENSE for terms

--~ local mod_EnableMod

--~ -- fired when settings are changed/init
--~ local function ModOptions()
--~ 	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
--~ end

--~ -- load default/saved settings
--~ OnMsg.ModsReloaded = ModOptions

--~ -- fired when Mod Options>Apply button is clicked
--~ function OnMsg.ApplyModOptions(id)
--~ 	if id == CurrentModId then
--~ 		ModOptions()
--~ 	end
--~ end

local Colonist = Colonist
local funcs = {
	"LogStatClear",
	"AddToLog",
}

--~ local updated_game = LuaRevision > 1001514
for i = 1, #funcs do
	local func = Colonist[funcs[i]]
	Colonist[funcs[i]] = function(self, log, ...)
--~ 		if mod_EnableMod and log then
		if log then
			return func(self, log, ...)
--~ 		elseif updated_game then
--~ 			return func(self, log, ...)
		end
	end
end
