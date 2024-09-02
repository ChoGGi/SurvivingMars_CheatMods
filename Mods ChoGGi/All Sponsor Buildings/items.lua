-- See LICENSE for terms


if not g_AvailableDlc.gagarin then
	print(CurrentModDef.title, ": Space Race DLC not installed! Abort!")
	return {
		PlaceObj("ModItemOptionToggle", {
			"name", "NODLC",
			"DisplayName", T(0000, "Space Race DLC not installed!"),
			"DefaultValue", true,
		}),
	}
end

local def = CurrentModDef
-- we need to store the list of sponsor locked buildings
local sponsor_buildings = def.sponsor_buildings or {}

local T = T
local PlaceObj = PlaceObj
local table = table

local mod_options = {}
local c = #mod_options

-- shown ame of tech
local techs = {
	AdvancedStirlingGenerator = "StirlingGenerator",
	CorporateOffice = "BehavioralShaping",
	GameDeveloper = "CreativeRealities",
	JumperShuttleHub = "CO2JetPropulsion",
	LowGLab = "MartianInstituteOfScience",
	MegaMall = "GravityEngineering",
	SolarArray = "DustRepulsion",
	Temple = "Arcology",
}
local TechDef = TechDef

local BuildingTemplates = BuildingTemplates
for id, bld in pairs(BuildingTemplates) do
	for i = 1, 3 do
		if (sponsor_buildings[id] or bld["sponsor_status" .. i] ~= false)
			-- Shuttle Hub has "disabled" to block it when jumper (paradox spons) is enabled.
			and bld["sponsor_status" .. i] ~= "disabled"
		then
			sponsor_buildings[id] = true

			local image = ""
			if bld.encyclopedia_image and bld.encyclopedia_image ~= "" then
				image = "\n\n<image " .. bld.encyclopedia_image .. ">"
			elseif bld.display_icon and bld.display_icon ~= "" then
				image = "\n\n<image " .. bld.display_icon .. ">"
			end
			c = c + 1
			mod_options[c] = PlaceObj("ModItemOptionToggle", {
				"name", "ChoGGi_" .. id,
				"DisplayName", T(bld.display_name),
				"Help", table.concat(T(bld.description) .. image),
				"DefaultValue", true,
			})
			local tech_lock = techs[id]
			if tech_lock then
				local def = TechDef[tech_lock]
				c = c + 1
				mod_options[c] = PlaceObj("ModItemOptionToggle", {
					"name", "ChoGGi_Tech_" .. id,
					"DisplayName", table.concat(T(bld.display_name) .. " " .. T(3734, "Tech")),
					"Help", table.concat(T(0000, "Lock behind tech unlock.") ..
						"\n\n" .. def.display_name ..
						"\n\n<image " .. def.icon .. ">"
					),
					"DefaultValue", true,
				})
			end
			break
		end
	end
end

-- If first time then save them
if not def.sponsor_buildings then
	def.sponsor_buildings = sponsor_buildings
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(mod_options, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return mod_options
