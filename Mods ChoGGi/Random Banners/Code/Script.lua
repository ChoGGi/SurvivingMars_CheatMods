-- See LICENSE for terms

-- not much point without it
if not g_AvailableDlc.gagarin then
	return
end

-- GetEntity seems to be called a little too early (for my setup only probably)
local lookup_table = {
	Flag_01_ = {"Hex1_Placeholder"},
	Flag_02_ = {"Hex1_Placeholder"},
	Flag_03_ = {"Hex1_Placeholder"},
}

-- if any mods add flags
function OnMsg.ModsReloaded()
	-- build lists of flag entities (nation names)
	local flag_c = 0
	local flag_spons_1 = lookup_table.Flag_01_
	local EntityData = EntityData
	for key in pairs(EntityData) do
		if key:find("Flag_01_") then
			flag_c = flag_c + 1
			flag_spons_1[flag_c] = key:sub(9)
		end
	end
	local flag_spons_2 = lookup_table.Flag_02_
	local flag_spons_3 = lookup_table.Flag_03_
	for i = 1, flag_c do
		flag_spons_2[i] = "Flag_02_" .. flag_spons_1[i]
		flag_spons_3[i] = "Flag_03_" .. flag_spons_1[i]
		flag_spons_1[i] = "Flag_01_" .. flag_spons_1[i]
	end
	lookup_table.Flag_01_ = flag_spons_1
	lookup_table.Flag_02_ = flag_spons_2
	lookup_table.Flag_03_ = flag_spons_3

	-- welcome to our bonus eh
	flag_c = flag_c + 1
	flag_spons_1[flag_c] = "Flag_01_Pride"
	flag_spons_2[flag_c] = "Flag_02_Pride"
	flag_spons_3[flag_c] = "Flag_03_Pride"
end

function SponsorBannerBase:GetEntity()
	-- default entity = return a random flag
	if self.entity == "Hex1_Placeholder" then
		return table.rand(lookup_table[self.banner])
	else
		return self.entity
	end
end

function SponsorBannerBase:GetSkins()
	return lookup_table[self.banner]
end



-- for those of you interested in adding new flags (you'll also have to do something with SponsorBannerBase:GetEntity())

-- list of entities we're going to be adding
local entity_list = {
	"Flag_01_Pride",
	"Flag_02_Pride",
	"Flag_03_Pride",
	"Cemetery",
}

-- local instead of global is quicker
local EntityData = EntityData
local EntityLoadEntities = EntityLoadEntities
local SetEntityFadeDistances = SetEntityFadeDistances
-- getting called a bunch, so make them local
local path_loc_str = CurrentModPath .. "Entities/"
local mod = Mods.ChoGGi_RandomBanners

-- no sense in making a new one for each entity
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
	-- pretty much using what happens when you use ModItemEntity
	EntityData[name] = entity_template
	EntityLoadEntities[#EntityLoadEntities + 1] = {
		mod,
		name,
		path_loc_str .. name .. ".ent"
	}
	SetEntityFadeDistances(name, -1, -1)
end
