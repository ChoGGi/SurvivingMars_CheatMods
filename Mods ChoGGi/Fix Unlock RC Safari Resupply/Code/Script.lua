-- See LICENSE for terms

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

function OnMsg.LoadGame()
	if not mod_EnableMod then
		return
	end

	local ResupplyItemDefinitions = ResupplyItemDefinitions
	local idx = table.find(ResupplyItemDefinitions, "id", "RCSafari")
	-- already added
	if idx then
		return
	end

	-- insert after rc transport
--~ 	local transport_idx = table.find(ResupplyItemDefinitions, "id", "RCTransport")

--~ 	-- function RocketPayload_Init() (last copied Tito-Hotfix)
--~   local sponsor = g_CurrentMissionParams and g_CurrentMissionParams.idMissionSponsor or ""
--~ 	local def = setmetatable({}, {__index = CargoPreset.RCSafari})
--~ 	table.insert(ResupplyItemDefinitions, transport_idx, def)
--~ 	local mod = mods[def.id] or 0
--~ 	if mod ~= 0 then
--~ 		ModifyResupplyDef(def, "price", mod)
--~ 	end
--~ 	local lock = locks[def.id]
--~ 	if lock ~= nil then
--~ 		def.locked = lock
--~ 	end
--~ 	if type(def.verifier) == "function" then
--~ 		def.locked = def.locked or not def.verifier(def, sponsor)
--~ 	end

end
