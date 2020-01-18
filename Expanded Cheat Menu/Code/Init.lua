function OnMsg.ClassesPostprocess()
    BuildingTemplates.CarbonateProcessor.consumption_amount = 3000
end

--Production - the amount is consumed for 1 unit of the produced resource. If not enough, production is lowered accordingly
function CarbonateProcessor:Consume_Production(for_amount_to_produce, delim) --pass the amount you are gona produce, func returns max possible production, ==for_amount_to_produce if enough consumption resources or less if not.
    if for_amount_to_produce <= 0 then return 0, 0 end
    delim = delim or const.ResourceScale
    local amount_to_consume = MulDivTrunc(for_amount_to_produce, self.consumption_amount, delim)
    local deduced_amount = MulDivTrunc(amount_to_consume, delim, self.consumption_amount)
    local frac = for_amount_to_produce - deduced_amount

    -- added orig func as test
    print("amount_to_consume", amount_to_consume, for_amount_to_produce, self.consumption_resource_type, self.consumption_amount)

    amount_to_consume = self:Consume_Internal(amount_to_consume)
    local ret_amount = MulDivTrunc(amount_to_consume, delim, self.consumption_amount)
    if frac > 0 and self.consumption_stored_resources > 0 then
        self:AccumulateFracProduction(frac)
        ret_amount = ret_amount + frac
    end
    if self.consumption_resource_type == "WasteRock" and self:IsKindOf("ResourceProducer") then
        Msg("WasteRockConversion", amount_to_consume, self.producers)
    end
    return ret_amount, amount_to_consume
end


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
