-- See LICENSE for terms

if LuaRevision > 1001586 then
	return
end

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local Untranslated = Untranslated

local orig_RocketBase_GetDisplayName = RocketBase.GetDisplayName
function RocketBase:GetDisplayName(...)
	if mod_EnableMod and self.name then
		return Untranslated(self.name)
	end
	return orig_RocketBase_GetDisplayName(self, ...)
end