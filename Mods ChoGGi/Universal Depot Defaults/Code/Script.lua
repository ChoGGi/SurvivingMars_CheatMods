-- See LICENSE for terms

local ResourceScale = const.ResourceScale

local dlc_gp = g_AvailableDlc.armstrong
local dlc_bb = g_AvailableDlc.picard
local table = table

local mod_ShuttleAccess
local mod_StoredAmount
local mod_options = {}

-- Easier to just make my own list then figure out a table to get them from
local storable_resources = {
	"Concrete",
	"Electronics",
	"Food",
	"Fuel",
	"MachineParts",
	"Metals",
	"Polymers",
	"PreciousMetals",
}
local c = #storable_resources
-- No seeds if no green planet
if dlc_gp then
	c = c + 1
	storable_resources[c] = "Seeds"
end
-- etc
if dlc_bb then
	c = c + 1
	storable_resources[c] = "PreciousMinerals"
end

-- Build mod options (doesn't hurt to make sure it's a valid resource)
local Resources = Resources
for id in pairs(Resources) do
	if table.find(storable_resources, id) then
		mod_options[id] = false
	end
end

local IsLukeHNewResActive

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions
	mod_ShuttleAccess = options:GetProperty("ShuttleAccess")
	mod_StoredAmount = options:GetProperty("StoredAmount")

	for i = 1, c do
		local id = storable_resources[i]
		mod_options[id] = options:GetProperty(id)
	end

	IsLukeHNewResActive = table.find(ModsLoaded, "id", "LH_Resources")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- all offset by 247 (even spacing between them with seeds)
--~ o:GetSpotName(0)
--~ o:GetSpotPos(0)
-- always skip Concrete (it's first)
-- 256 is dist between spot 1 & 2
res_offsets_combo = {
	Fuel = point(720, -231, 30),
	MachineParts = point(464, -231, 30),
	Electronics = point(208, -231, 30),
	Polymers = point(-48, -231, 30),
	PreciousMetals = point(-304, -231, 30),
	Metals = point(-560, -231, 30),
	Food = point(-816, -231, 30),
	Seeds = point(-1072, -231, 30),
	PreciousMinerals = point(-1072, -231, 30),
}
-- 247
local res_offsets_aio = {
	Fuel = point(820, -231, 30),
	MachineParts = point(573, -231, 30),
	Electronics = point(326, -231, 30),
	Polymers = point(79, -231, 30),
	PreciousMetals = point(-168, -231, 30),
	Metals = point(-415, -231, 30),
	Food = point(-662, -231, 30),
	Seeds = point(-909, -231, 30),
	PreciousMinerals = point(-1156, -231, 30),
}

local ChoOrig_UniversalStorageDepot_GameInit = UniversalStorageDepot.GameInit
function UniversalStorageDepot:GameInit(...)
	-- we only want the uni depot, not the res-specfic ones
	if self.template_name ~= "UniversalStorageDepot" then
		return ChoOrig_UniversalStorageDepot_GameInit(self, ...)
	end

	ChoOrig_UniversalStorageDepot_GameInit(self, ...)

	dlc_gp = g_AccessibleDlc.armstrong
	dlc_bb = g_AccessibleDlc.picard

	local res_offsets
	if dlc_bb and dlc_gp then
		res_offsets = res_offsets_aio
	elseif dlc_gp or dlc_bb then
		res_offsets = res_offsets_combo
	end

	for i = 1, #self.storable_resources do
		local name = self.storable_resources[i]
		-- turn off any resources that are disabled
		if not mod_options[name] then
			self:ToggleAcceptResource(name)
		end

		-- and change res cube offsets (thanks LukeH for the gappage)
		if (dlc_gp or dlc_bb)
			and not IsLukeHNewResActive and res_offsets[name]
		then
			self.placement_offset[name] = res_offsets[name]
		end

	end

	-- desired slider setting (needs a slight delay to set the "correct" amount: last checked picard)
	CreateRealTimeThread(function()
		self:SetDesiredAmount(mod_StoredAmount * ResourceScale)
	end)

	-- turn off shuttles
	if not mod_ShuttleAccess then
		self:SetLRTService(false)
	end
end

function OnMsg.ClassesPostprocess()
	local store = BuildingTemplates.UniversalStorageDepot.storable_resources
	if dlc_gp then
		table.insert_unique(store, "Seeds")
	end
	if dlc_bb then
		table.insert_unique(store, "PreciousMinerals")
	end
end

-- needed for SetDesiredAmount in depots
local ChoOrig_ResourceStockpileBase_GetMax = ResourceStockpileBase.GetMax
function ResourceStockpileBase:GetMax(...)
	if self.template_name == "UniversalStorageDepot" and mod_StoredAmount > 30 then
		return mod_StoredAmount / ResourceScale
	end
	return ChoOrig_ResourceStockpileBase_GetMax(self, ...)
end
