-- See LICENSE for terms

local options
local mod_ShuttleAccess
local mod_StoredAmount
local mod_options = {}

local table_find = table.find
local storable_resources = {"Concrete", "Electronics", "Food", "Fuel", "MachineParts", "Metals", "Polymers", "PreciousMetals", "Seeds"}
local c = #storable_resources

local Resources = Resources
for id, item in pairs(Resources) do
	if table_find(storable_resources, id) then
		mod_options[id] = nil
	end
end

-- fired when settings are changed/init
local function ModOptions()
	mod_ShuttleAccess = options.ShuttleAccess
	mod_StoredAmount = options.StoredAmount * const.ResourceScale

	for i = 1, c do
		local id = storable_resources[i]
		mod_options[id] = options[id]
	end
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_UniversalDepotDefaults" then
		return
	end

	ModOptions()
end

local base = 34
local seed_offsets = {
	PreciousMetals = 0,
	Polymers = base,
	Metals = base * 2,
	MachineParts = base * 3,
	Fuel = base * 4,
	Food = base * 5,
	Electronics = base * 6,
	Concrete = base * 7,
}

local orig_GameInit = UniversalStorageDepot.GameInit
function UniversalStorageDepot:GameInit(...)
	-- we only want the uni depot, not the 180 ones
	if self.template_name ~= "UniversalStorageDepot" then
		return orig_GameInit(self, ...)
	end

	-- add seeds
	self.storable_resources = storable_resources
	-- register
	self:RegiterResourceRequest("Seeds")

	orig_GameInit(self, ...)

	for i = 1, c do
		local name = storable_resources[i]
		-- turn off any resources that are disabled
		if not mod_options[name] then
			self:ToggleAcceptResource(name)
		end

		-- and change res cube offsets (thanks LukeH for the gappage idea)
		if name ~= "Seeds" then
			self.placement_offset[name] = self.placement_offset[name]:AddX(seed_offsets[name])
		end

	end
	-- seeds (same outer border offset as raremetals)
	local offset = seed_offsets.Concrete * -1
	self.placement_offset.Seeds = self.placement_offset.Concrete:AddX(offset)

	-- slider setting
	self:SetDesiredAmount(mod_StoredAmount)

	-- turn off shuttles
	if not mod_ShuttleAccess then
		self:SetLRTService(false)
	end
end

function OnMsg.ClassesBuilt()
	-- prevent log spam from seeds
	local orig_GetSpotBeginIndex = UniversalStorageDepot.GetSpotBeginIndex
	function UniversalStorageDepot:GetSpotBeginIndex(spot_name, ...)
		return orig_GetSpotBeginIndex(self,
			spot_name == "Box9" and "Box8" or spot_name, ...
		)
	end
end
