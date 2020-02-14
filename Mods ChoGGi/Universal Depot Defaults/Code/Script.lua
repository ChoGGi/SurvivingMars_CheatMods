-- See LICENSE for terms

local gp_dlc = g_AvailableDlc.armstrong
local table_find = table.find

local options
local mod_ShuttleAccess
local mod_StoredAmount
local mod_options = {}

local storable_resources = {"Concrete", "Electronics", "Food", "Fuel", "MachineParts", "Metals", "Polymers", "PreciousMetals"}
local c = #storable_resources
-- no seeds if no green planet
if gp_dlc then
	c = c + 1
	storable_resources[c] = "Seeds"
end

-- build mod options
local Resources = Resources
for id in pairs(Resources) do
	if table_find(storable_resources, id) then
		mod_options[id] = false
	end
end

-- fired when settings are changed/init
local function ModOptions()
	mod_ShuttleAccess = options:GetProperty("ShuttleAccess")
	mod_StoredAmount = options:GetProperty("StoredAmount") * const.ResourceScale

	for i = 1, c do
		local id = storable_resources[i]
		mod_options[id] = options:GetProperty(id)
	end
end

local IsLukeHNewResActive
-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()

	IsLukeHNewResActive = table_find(ModsLoaded, "id", "LH_Resources")
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
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
	-- we only want the uni depot, not the res-specfic ones
	if self.template_name ~= "UniversalStorageDepot" then
		return orig_GameInit(self, ...)
	end

	orig_GameInit(self, ...)

	for i = 1, #self.storable_resources do
		local name = self.storable_resources[i]
		-- turn off any resources that are disabled
		if not mod_options[name] then
			self:ToggleAcceptResource(name)
		end

		-- and change res cube offsets (thanks LukeH for the gappage idea)
		if gp_dlc and name ~= "Seeds" and not IsLukeHNewResActive then
			self.placement_offset[name] = self.placement_offset[name]:AddX(seed_offsets[name])
		end

	end

	if gp_dlc and not IsLukeHNewResActive then
		-- seeds (same outer border offset as raremetals)
		local offset = seed_offsets.Concrete * -1
		self.placement_offset.Seeds = self.placement_offset.Concrete:AddX(offset)
	end

	-- desired slider setting
	self:SetDesiredAmount(mod_StoredAmount)

	-- turn off shuttles
	if not mod_ShuttleAccess then
		self:SetLRTService(false)
	end
end


if gp_dlc then

	function OnMsg.ClassesPostprocess()
		table.insert_unique(BuildingTemplates.UniversalStorageDepot.storable_resources, "Seeds")
	end

	local safe_spots = {
		Box1 = true,
		Box2 = true,
		Box3 = true,
		Box4 = true,
		Box5 = true,
		Box6 = true,
		Box7 = true,
		Box8 = true,
	}

	function OnMsg.ClassesBuilt()
		-- prevent log spam from seeds
		local orig_GetSpotBeginIndex = UniversalStorageDepot.GetSpotBeginIndex
		function UniversalStorageDepot:GetSpotBeginIndex(spot_name, ...)
			if not safe_spots[spot_name] then
				spot_name = "Box8"
			end
			return orig_GetSpotBeginIndex(self, spot_name, ...)
		end
	end
end
