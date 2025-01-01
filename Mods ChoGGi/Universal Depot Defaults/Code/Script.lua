-- See LICENSE for terms

local ResourceScale = const.ResourceScale

local table = table

local mod_ShuttleAccess
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
		mod_options["StoredAmount_" .. id] = false
	end
end

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions
	mod_ShuttleAccess = options:GetProperty("ShuttleAccess")

	mod_options["StoredAmount_Universal"] = options:GetProperty("StoredAmount")

	for i = 1, c do
		local id = storable_resources[i]
		mod_options[id] = options:GetProperty(id)
		-- individual
--~ 		mod_options["StoredAmount_" .. id] = options:GetProperty("StoredAmount_" .. id)
	end

end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local fix_names = {
	-- Why didn't the devs stick with one name...
	StorageRareMinerals = "StoredAmount_PreciousMinerals",
	StorageRareMetals = "StoredAmount_PreciousMetals",
	-- easier to have them all in one table, but I don't want to reset anyones options.
	UniversalStorageDepot = "StoredAmount_Universal",

	StorageSeeds = "StoredAmount_Seeds",
	StorageConcrete = "StoredAmount_Concrete",
	StorageElectronics = "StoredAmount_Electronics",
	StorageFood = "StoredAmount_Food",
	StorageFuel = "StoredAmount_Fuel",
	StorageMachineParts = "StoredAmount_MachineParts",
	StorageMetals = "StoredAmount_Metals",
	StoragePolymers = "StoredAmount_Polymers",
}

local ChoOrig_UniversalStorageDepot_GameInit = UniversalStorageDepot.GameInit
function UniversalStorageDepot:GameInit(...)
		-- individual
	-- we only want the uni depot, not the res-specfic ones
	if self.template_name ~= "UniversalStorageDepot" then
		return ChoOrig_UniversalStorageDepot_GameInit(self, ...)
	end
		-- individual

	ChoOrig_UniversalStorageDepot_GameInit(self, ...)

	if self.template_name == "UniversalStorageDepot" then
		-- turn off resources
		for i = 1, #self.storable_resources do
			local name = self.storable_resources[i]
			-- turn off any resources that are disabled
			if not mod_options[name] then
				self:ToggleAcceptResource(name)
			end
		end

		-- turn off shuttles
		if not mod_ShuttleAccess then
			self:SetLRTService(false)
		end

	end

	-- Desired amount bs
	local amount = mod_options[fix_names[self.template_name]]
		-- individual
--~ 	-- modded ones
--~ 	if not amount then
--~ 		print("ChoGGi_UniversalDepotDefaults: unknown resource depot:", self.template_name, self.mod)
--~ 		amount = 180
--~ 	end

	-- last checked lua rev 1011166
	-- desired slider setting (needs a slight delay to set the "correct" amount)
	CreateRealTimeThread(function()
		-- The + 1 is needed when setting to 1000 or it'll be set to 0
		-- Though it sometimes also is needed for 2000, so I don't know...
		self:SetDesiredAmount(amount * ResourceScale + 1)
		-- and it consistently sets the non-uni depots to the wrong amount (5 instead of 3)
	end)

end

-- Hacky workaround for large Desired Amounts not setting properly.
local ChoOrig_ResourceStockpileBase_GetMax = ResourceStockpileBase.GetMax
function ResourceStockpileBase:GetMax(...)
	if self.template_name == "UniversalStorageDepot" then
		local amount = mod_options["StoredAmount_Universal"]
		if amount > 30 then
			return amount * ResourceScale
		end
	end

	return ChoOrig_ResourceStockpileBase_GetMax(self, ...)
end

--~ function SavegameFixups.ChoGGi_UniversalDepotDefaults()
	-- check storable_resources for dupes?
--~ end
