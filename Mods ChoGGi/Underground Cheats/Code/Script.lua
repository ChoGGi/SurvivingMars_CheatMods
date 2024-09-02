-- See LICENSE for terms

if not g_AvailableDlc.picard then
	print(CurrentModDef.title, ": Below & Beyond DLC not installed! Abort!")
	return
end

local table = table

local mod_EnableMod
local mod_LightTripodRadius
local mod_SupportStrutRadius
local mod_PinRockets

local orig_const_BuriedWonders = table.icopy(const.BuriedWonders)
local fake_BuriedWonders_safe
local fake_BuriedWonders = {}
local fake_BuriedWonders_c = 0

local function UpdateObjs()
	if not mod_EnableMod or not UIColony then
		return
	end

	local labels
	for i = 1, #Cities do
		local city = Cities[i]
		if city.map_id == UIColony.underground_map_id then
			labels = city.labels
			break
		end
	end
	if not labels then
		return
	end

	-- Newly built struts
	SupportStruts.work_radius = mod_SupportStrutRadius
	-- UICity since we checked the active map is underground one
	local struts = labels.SupportStruts or ""
	for i = 1, #struts do
		struts[i].work_radius = mod_SupportStrutRadius
	end

	-- Lights
	BuildingTemplates.LightTripod.reveal_range = mod_LightTripodRadius
	ClassTemplates.Building.LightTripod.reveal_range = mod_LightTripodRadius

	local UpdateRevealObject = UnitRevealDarkness.UpdateRevealObject
	local tripods = labels.LightTripod or ""
	for i = 1, #tripods do
		local obj = tripods[i]
		obj.reveal_range = mod_LightTripodRadius
		UpdateRevealObject(obj)
	end

	-- Pin any rockets
	if mod_PinRockets then
			local under_pins = GameMaps[UIColony.underground_map_id].pinnables.pins
			local objs = GameMaps[MainMapID].pinnables.pins
			for i = 1, #objs do
				local obj = objs[i]
				if obj:IsKindOf("SupplyRocket") then
					if not table.find(under_pins, "handle", obj.handle) then
						under_pins[#under_pins+1] = obj
					end
				end
			end


	end
end

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end
	local options = CurrentModOptions

	fake_BuriedWonders_safe = table.icopy(orig_const_BuriedWonders)
	table.iclear(fake_BuriedWonders)
	fake_BuriedWonders_c = 0
	-- build list of wonders
	for i = 1, #orig_const_BuriedWonders do
		local id = orig_const_BuriedWonders[i]

		if options:GetProperty(id) then
			fake_BuriedWonders_c = fake_BuriedWonders_c + 1
			fake_BuriedWonders[fake_BuriedWonders_c] = id
			-- fake_BuriedWonders_safe has enabled wonders removed, so there's no dupes
			local idx = table.find(fake_BuriedWonders_safe, id)
			if idx then
				table.remove(fake_BuriedWonders_safe, idx)
			end
		end
	end

	mod_EnableMod = options:GetProperty("EnableMod")
	mod_LightTripodRadius = options:GetProperty("LightTripodRadius")
	mod_SupportStrutRadius = options:GetProperty("SupportStrutRadius")
	mod_PinRockets = options:GetProperty("PinRockets")

	UpdateObjs()
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

OnMsg.CityStart = UpdateObjs
OnMsg.LoadGame = UpdateObjs
-- switch between different maps
OnMsg.ChangeMapDone = UpdateObjs

-- pick wonders
local ChoOrig_RandomMapGen_PlaceArtefacts = RandomMapGen_PlaceArtefacts
function RandomMapGen_PlaceArtefacts(...)
	if not mod_EnableMod then
		return ChoOrig_RandomMapGen_PlaceArtefacts(...)
	end

	-- Add a random wonder (use the actual count, so we can rand each new game in a session)
	if fake_BuriedWonders_c == 1 then
		fake_BuriedWonders[2] = table.rand(fake_BuriedWonders_safe)
--~ 	elseif fake_BuriedWonders_c == 0 then
--~ 		fake_BuriedWonders = table.icopy(orig_const_BuriedWonders)
	end

	const.BuriedWonders = fake_BuriedWonders
	-- I do pcalls for safety when wanting to change back a global var
	pcall(ChoOrig_RandomMapGen_PlaceArtefacts, ...)
	const.BuriedWonders = table.icopy(orig_const_BuriedWonders)
end
