-- See LICENSE for terms

local mod = CurrentModDef

local logos = {
	{
		file = "2d_Space_Launch_Squadron",
		name = "2d Space Launch Squadron",
	},
	{
		file = "23d_Space_Operations_SQ_1",
		name = "23d Space Operations SQ 1",
	},
	{
		file = "23d_Space_Operations_SQ_2",
		name = "23d Space Operations SQ 2",
	},
	{
		file = "AF_Tencap_Special_Applications",
		name = "AF Tencap Special_Applications",
	},
	{
		file = "DEA_Cocaine_Intelligence_Unit",
		name = "DEA Cocaine Intelligence Unit",
	},
	{
		file = "DEA_Financial_Intelligence_Unit",
		name = "DEA Financial Intelligence Unit",
	},
	{
		file = "DEA_Heroin_Intelligence_Unit",
		name = "DEA Heroin Intelligence Unit",
	},
	{
		file = "DEA_Unicorn_System",
		name = "DEA Unicorn System",
	},
	{
		file = "DONT_ASK_NOYFB",
		name = "DONT ASK NOYFB",
	},
	{
		file = "NKAWTG_NOBODY",
		name = "NKAWTG NOBODY",
	},
	{
		file = "NRO",
		name = "National Reconnaissance Office",
	},
	{
		file = "NROL_01",
		name = "NROL 01",
	},
	{
		file = "NROL_04",
		name = "NROL 04",
	},
	{
		file = "NROL_05",
		name = "NROL 05",
	},
	{
		file = "NROL_06",
		name = "NROL 06",
	},
	{
		file = "NROL_08",
		name = "NROL 08",
	},
	{
		file = "NROL_09",
		name = "NROL 09",
	},
	{
		file = "NROL_10",
		name = "NROL 10",
	},
	{
		file = "NROL_11",
		name = "NROL 11",
	},
	{
		file = "NROL_12",
		name = "NROL 12",
	},
	{
		file = "NROL_13",
		name = "NROL 13",
	},
	{
		file = "NROL_14",
		name = "NROL 14",
	},
	{
		file = "NROL_15",
		name = "NROL 15",
	},
	{
		file = "NROL_18",
		name = "NROL 18",
	},
	{
		file = "NROL_19",
		name = "NROL 19",
	},
	{
		file = "NROL_20",
		name = "NROL 20",
	},
	{
		file = "NROL_21",
		name = "NROL 21",
	},
	{
		file = "NROL_22",
		name = "NROL 22",
	},
	{
		file = "NROL_27",
		name = "NROL 27",
	},
	{
		file = "NROL_30",
		name = "NROL 30",
	},
	{
		file = "NROL_32",
		name = "NROL 32",
	},
	{
		file = "NROL_33",
		name = "NROL 33",
	},
	{
		file = "NROL_34",
		name = "NROL 34",
	},
	{
		file = "NROL_37",
		name = "NROL 37",
	},
	{
		file = "NROL_38",
		name = "NROL 38",
	},
	{
		file = "NROL_39",
		name = "NROL 39",
	},
	{
		file = "NROL_41",
		name = "NROL 41",
	},
	{
		file = "NROL_42",
		name = "NROL 42",
	},
	{
		file = "NROL_44",
		name = "NROL 44",
	},
	{
		file = "NROL_45",
		name = "NROL 45",
	},
	{
		file = "NROL_47",
		name = "NROL 47",
	},
	{
		file = "NROL_49",
		name = "NROL 49",
	},
	{
		file = "NROL_52",
		name = "NROL 52",
	},
	{
		file = "NROL_61",
		name = "NROL 61",
	},
	{
		file = "NROL_65",
		name = "NROL 65",
	},
	{
		file = "NROL_66",
		name = "NROL 66",
	},
	{
		file = "NROL_67",
		name = "NROL 67",
	},
	{
		file = "NROL_151",
		name = "NROL 151",
	},
	{
		file = "Si_Ego_Certiorem_Faciam",
		name = "Si Ego Certiorem Faciam",
	},
	{
		file = "USAF_Special_Projects",
		name = "USAF Special Projects",
	},
}
local logos_length = #logos

do -- LoadEntity
	-- no sense in making a new one for each entity
	local entity_template_decal = {
		category_Decors = true,
		entity = {
			fade_category = "Never",
			material_type = "Metal",
		},
	}

	-- local instead of global is quicker
	local EntityData = EntityData
	local EntityLoadEntities = EntityLoadEntities
	local SetEntityFadeDistances = SetEntityFadeDistances
	local ent_path = mod.env.CurrentModPath .. "Entities/"

	for i = 1, logos_length do
		local file = logos[i].file

		EntityData[file] = entity_template_decal
		EntityLoadEntities[#EntityLoadEntities + 1] = {
			mod,
			file,
			ent_path .. file .. ".ent"
		}
		SetEntityFadeDistances(file, -1, -1)
	end
end -- LoadEntity

do -- Postprocess
	local PlaceObj = PlaceObj
	local logo_path = mod.env.CurrentModPath .. "UI/"

	function OnMsg.ClassesPostprocess()
		for i = 1, logos_length do
			local logo = logos[i]
			local file = logo.file

			PlaceObj("MissionLogoPreset", {
				decal_entity = file,
				entity_name = file,
				display_name = "NROL: " .. logo.name,
				id = "NROLMissionBadges_" .. file,
				image = logo_path .. file .. ".png",
			})
		end
	end
end -- Postprocess
