-- See LICENSE for terms

local ResourceScale = const.ResourceScale

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
if g_AvailableDlc.armstrong then
	c = c + 1
	storable_resources[c] = "Seeds"
end
-- etc
if g_AvailableDlc.picard then
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

end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_UniversalStorageDepot_GameInit = UniversalStorageDepot.GameInit
function UniversalStorageDepot:GameInit(...)
	-- we only want the uni depot, not the res-specfic ones
	if self.template_name ~= "UniversalStorageDepot" then
		return ChoOrig_UniversalStorageDepot_GameInit(self, ...)
	end

	ChoOrig_UniversalStorageDepot_GameInit(self, ...)

	-- turn off resources
	for i = 1, #self.storable_resources do
		local name = self.storable_resources[i]
		-- turn off any resources that are disabled
		if not mod_options[name] then
			self:ToggleAcceptResource(name)
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

-- needed for SetDesiredAmount in depots
local ChoOrig_ResourceStockpileBase_GetMax = ResourceStockpileBase.GetMax
function ResourceStockpileBase:GetMax(...)
	if self.template_name == "UniversalStorageDepot" and mod_StoredAmount > 30 then
		return mod_StoredAmount / ResourceScale
	end
	return ChoOrig_ResourceStockpileBase_GetMax(self, ...)
end

--~ function SavegameFixups.ChoGGi_UniversalDepotDefaults()
	-- check storable_resources for dupes?
--~ end
