-- See LICENSE for terms

-- Not much point without it
if not g_AvailableDlc.gagarin then
	print(CurrentModDef.title, ": Space Race DLC not installed! Abort!")
	return
end



-- You should only need to change the list and the sponsor id



-- list of entities we're going to be adding
local entity_list = {
	"Flag_01_Bear",
	"Flag_02_Bear",
	"Flag_03_Bear",
}

-- Use to only replace banners for your sponsor, see below to replace banners for any sponsor
local sponsor_id = "ChoGGi_CanadianSpaceAgency"

-- local instead of global is quicker
local EntityData = EntityData
local EntityLoadEntities = EntityLoadEntities
local SetEntityFadeDistances = SetEntityFadeDistances
local path_loc_str = CurrentModPath .. "Entities/"
local def = CurrentModDef

-- No sense in making a new one for each entity
local entity_template = {
	category_Decors = true,
	entity = {
		class_parent = "BuildingEntityClass",
		fade_category = "Never",
		material_type = "Rock",
	},
}

for i = 1, #entity_list do
	local name = entity_list[i]
	-- Pretty much using what happens when you use ModItemEntity
	EntityData[name] = entity_template
	EntityLoadEntities[#EntityLoadEntities + 1] = {
		def,
		name,
		path_loc_str .. name .. ".ent"
	}
	-- No fade... I think
	SetEntityFadeDistances(name, -1, -1)
end

-- The banner class uses Flag_01_ etc to append sponsor names for entities
-- I use them to pick entities instead
local lookup_table = {
	Flag_01_ = entity_list[1],
	Flag_02_ = entity_list[2],
	Flag_03_ = entity_list[3],
}

-- Override banner entity pick
local OrigFunc_SponsorBannerBase_GetEntity = SponsorBannerBase.GetEntity
function SponsorBannerBase:GetEntity(...)

	-- Remove this to always replace any banner
	-- Keep it to lock to a specific sponsor
	if GetMissionSponsor().id ~= sponsor_id then
--[[
The id is not the name of your sponsor, I believe it's called id in the mod editor...
I don't use the mod editor (you're on your own for that), but you can find your sponsor id in items.lua
]]
		return OrigFunc_SponsorBannerBase_GetEntity(self, ...)
		-- The three ... means varargs, in other words pass along any number of arguments
		-- This func doesn't have any args, but I always use them in case another modder adds one
	end
	-- End of remove this

	-- This returns the proper entity for each flag
	return lookup_table[self.banner]
end
