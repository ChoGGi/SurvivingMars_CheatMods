-- See LICENSE for terms

local ResourceScale = const.ResourceScale

local gp_dlc = g_AvailableDlc.armstrong
local table = table

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
	if table.find(storable_resources, id) then
		mod_options[id] = false
	end
end

local IsLukeHNewResActive

-- fired when settings are changed/init
local function ModOptions()
	options = CurrentModOptions
	mod_ShuttleAccess = options:GetProperty("ShuttleAccess")
	mod_StoredAmount = options:GetProperty("StoredAmount")

	for i = 1, c do
		local id = storable_resources[i]
		mod_options[id] = options:GetProperty(id)
	end

	IsLukeHNewResActive = table.find(ModsLoaded, "id", "LH_Resources")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

-- all offset by 34 (even spacing between them with seeds)
local seed_offsets = {
-- Fuel/Concrete are unchanged
	MachineParts = point(651, -231, 30),
	Electronics = point(415, -231, 30),
	Polymers = point(179, -231, 30),
	PreciousMetals = point(-57, -231, 30),
	Metals = point(-293, -231, 30),
	Food = point(-529, -231, 30),
	Seeds = point(-765, -231, 30),
}
local skips = {
	Fuel = true,
	Concrete = true,
}

local orig_UniversalStorageDepot_GameInit = UniversalStorageDepot.GameInit
function UniversalStorageDepot:GameInit(...)
	-- we only want the uni depot, not the res-specfic ones
	if self.template_name ~= "UniversalStorageDepot" then
		return orig_UniversalStorageDepot_GameInit(self, ...)
	end

	orig_UniversalStorageDepot_GameInit(self, ...)

	for i = 1, #self.storable_resources do
		local name = self.storable_resources[i]
		-- turn off any resources that are disabled
		if not mod_options[name] then
			self:ToggleAcceptResource(name)
		end

		-- and change res cube offsets (thanks LukeH for the gappage)
		if gp_dlc and not IsLukeHNewResActive and not skips[name] then
			self.placement_offset[name] = seed_offsets[name]
		end

	end

	-- desired slider setting (needs a slight delay to set the "correct" amount)
	CreateRealTimeThread(function()
		self:SetDesiredAmount(mod_StoredAmount * ResourceScale)
		-- ... don't look at me (without this 270 in mod options == 267 in depots)
		Sleep(1000)
		self:SetDesiredAmount(mod_StoredAmount * ResourceScale)
	end)

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
			if spot_name:sub(1, 3) == "Box" and not safe_spots[spot_name] then
				spot_name = "Box8"
			end
			return orig_GetSpotBeginIndex(self, spot_name, ...)
		end
	end

end

-- needed for SetDesiredAmount in depots
local orig_ResourceStockpileBase_GetMax = ResourceStockpileBase.GetMax
function ResourceStockpileBase:GetMax(...)
	if self.template_name == "UniversalStorageDepot" and mod_StoredAmount > 30 then
		return mod_StoredAmount / ResourceScale
	end
	return orig_ResourceStockpileBase_GetMax(self, ...)
end
