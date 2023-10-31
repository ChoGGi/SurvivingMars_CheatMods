-- See LICENSE for terms

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function AddNewDef(id, cargo, insert_after)
	local ResupplyItemDefinitions = ResupplyItemDefinitions

	local idx = table.find(ResupplyItemDefinitions, "id", id)
	-- already added
	if idx then
		return
	end

	-- insert after rc transport
	local transport_idx = #ResupplyItemDefinitions
	if insert_after then
		transport_idx = table.find(ResupplyItemDefinitions, "id", insert_after)
	end

	-- function ResupplyItemsInit() (last copied Tito-Hotfix)
  local sponsor = g_CurrentMissionParams and g_CurrentMissionParams.idMissionSponsor or ""
	local def = setmetatable({}, {__index = cargo})
	table.insert(ResupplyItemDefinitions, transport_idx, def)
	local mod = mods[def.id] or 0
	if mod ~= 0 then
		ModifyResupplyDef(def, "price", mod)
	end
	local lock = locks[def.id]
	if lock ~= nil then
		def.locked = lock
	end
	if type(def.verifier) == "function" then
		def.locked = def.locked or not def.verifier(def, sponsor)
	end
end

function OnMsg.LoadGame()
	if not mod_EnableMod then
		return
	end

	-- "RCTransport" is used to insert after, but you can leave it blank to insert at end
	AddNewDef("RCSafari", CargoPreset.RCSafari, "RCTransport")
end
