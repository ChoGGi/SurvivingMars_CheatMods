-- See LICENSE for terms


if not g_AvailableDlc.gagarin then
	print(CurrentModDef.title, ": Space Race DLC not installed! Abort!")
	return {
		PlaceObj("ModItemOptionToggle", {
			"name", "NODLC",
			"DisplayName", T(0000, "Space Race DLC not installed!"),
		}),
	}
end

local T = T
local PlaceObj = PlaceObj
local table = table

local mod_options = {}
local c = #mod_options

-- show name of tech
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

--~ 'AdvancedStirlingGenerator' = true
--~ 'AutomaticMetalsExtractor' = true
--~ 'ConcretePlant' = true
--~ 'CorporateOffice' = true
--~ 'GameDeveloper' = true
--~ 'JumperShuttleHub' = true
--~ 'LowGLab' = true
--~ 'MegaMall' = true
--~ 'MetalsRefinery' = true
--~ 'RareMetalsRefinery' = true
--~ 'RCConstructorBuilding' = true
--~ 'RCDrillerBuilding' = true
--~ 'RCHarvesterBuilding' = true
--~ 'RCSensorBuilding' = true
--~ 'RCSolarBuilding' = true
--~ 'ShuttleHub' = true
--~ 'SolarArray' = true
--~ 'TaiChiGarden' = true
--~ 'Temple' = true

local BuildingTemplates = BuildingTemplates
for id, bld in pairs(BuildingTemplates) do
	for i = 1, 3 do
--~ 		if bld["sponsor_status" .. i] ~= false
--~ 			-- Shuttle Hub has "disabled" to block it when Jumper (paradox spons) is enabled.
--~ 			and bld["sponsor_status" .. i] ~= "disabled"
--~ 		then
		if bld["sponsor_name" .. i] ~= ""
			-- Shuttle Hub has "disabled" to block it when Jumper (paradox spons) is enabled.
			and bld.id ~= "ShuttleHub"
		then

			-- Get an image to use for desc
			local image = ""
			if bld.encyclopedia_image and bld.encyclopedia_image ~= "" then
				image = "\n\n<image " .. bld.encyclopedia_image .. ">"
			elseif bld.display_icon and bld.display_icon ~= "" then
				image = "\n\n<image " .. bld.display_icon .. ">"
			end

			-- The building itself
			c = c + 1
			mod_options[c] = PlaceObj("ModItemOptionToggle", {
				"name", "ChoGGi_" .. id,
				"DisplayName", T(bld.display_name),
				"Help", table.concat(T(bld.description) .. image),
				"DefaultValue", true,
			})

			-- lock building behind tech
			local tech_lock = techs[id]
			if tech_lock then
				local def = TechDef[tech_lock]
				c = c + 1
				mod_options[c] = PlaceObj("ModItemOptionToggle", {
					"name", "ChoGGi_Tech_" .. id,
					"DisplayName", table.concat(T(bld.display_name) .. " " .. T(3734--[[Tech]])),
					"Help", table.concat(
						T(0000, "Lock behind tech unlock.")
						.. "\n\n" .. def.display_name
						.. "\n\n<image " .. def.icon .. ">"
					),
					"DefaultValue", false,
				})
			end
			break
		end

	end
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(mod_options, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

--~ ex{"mod_options",mod_options}
return mod_options
