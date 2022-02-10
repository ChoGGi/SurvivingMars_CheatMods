-- See LICENSE for terms

local type = type
local pairs = pairs
local table = table
local Sleep = Sleep
local ScaleXY = ScaleXY
local box = box
local Min = Min
local MulDivRound = MulDivRound
local PlaceObject = PlaceObject
local RotateAxis = RotateAxis
local DrawImage = UIL.DrawImage

local mod_AmountOfSaves

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_AmountOfSaves = CurrentModOptions:GetProperty("AmountOfSaves")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- stores saved game spots
local new_markers = {}

local LandingSite_object

local img = CurrentModPath .. "UI/pm_landed.png"
-- draws the saved game spot image (needed to slightly tweak LandingSiteObject:DrawSpot)
local function DrawSpot(win)
	local x = LandingSite_object.spot_image_size:x()
	local y = LandingSite_object.spot_image_size:y()
	local width, height = ScaleXY(win.scale, 50, 50)
	local left = width/2
	local right = width - left
	local up = height / 2
	local down = height - up
	DrawImage(img, box(-left, -up, right, down), box(0, 0, x, y), -1, 0, 0)
end

local spot_counts = {}
-- add our visited icons
local function BuildMySpots()
	-- wait for it...
	while not PlanetRotationObj do
		Sleep(250)
	end
--~ 	local PlanetRotationObj = PlanetRotationObj
	local PlanetRotationObj_spot = PlanetRotationObj:GetSpotBeginIndex("Planet")
	local PlanetRotationObj_pos = PlanetRotationObj:GetPos()
	local PlanetRotationObj_axis = PlanetRotationObj:GetAxis()

	local landing_dlg = LandingSite_object.dialog

	-- double maxwidth limit for text (some people have lots of saves)
	landing_dlg.idtxtCoord:SetMaxWidth(800)

	local template = landing_dlg.idSpotTemplate
	local ChoOrig_template_DrawContent = template.DrawContent
	template.DrawContent = DrawSpot

	-- needs to be removed for now
	template:SetId("")
	template:SetVisible(true)

	-- always start with a blank table
	table.clear(new_markers)

	-- start above the default landing spots added
	local idx = #Presets.LandingSpot.Default

	local SavegamesList = SavegamesList
	-- get list of saves
	SavegamesList:Refresh()

--~ 	-- It can happen
--~ 	if not PlanetRotationObj then
--~ 		return
--~ 	end

	table.clear(spot_counts)

	for i = 1, #SavegamesList do
		local save = SavegamesList[i]
		if type(save.longitude) == "number" and type(save.latitude) == "number" then
			-- use this to build a table of locations for ease of dupe checking
			local table_name = save.latitude .. "_" .. save.longitude

			-- check if this location is already added
			if new_markers[table_name] then
				-- merge save names if dupe location
				local marker = new_markers[table_name]
				local text = marker.text
				-- keep count for adding to marker
				local count = spot_counts[table_name]
				spot_counts[table_name] = count + 1
				-- only update count for text instead of adding more names
				if count >= mod_AmountOfSaves then
					-- is there already a count on the end (reversed text to sub off the end)
					local idx = text:find(" + ", 1, true)
					if idx then
						-- remove old numberand append new
						marker.text = text:sub(1, idx + 2) .. " " .. count
					else
						-- first count
						marker.text = text .. " + " .. count
					end
				else
					marker.text = text .. ", " .. save.displayname
				end
			else
				-- plunk down a new one (most of this code is copied from LandingSiteObject:AttachPredefinedSpots)
				local attach = PlaceObject("Shapeshifter")
				local marker = template:Clone()
				marker:SetParent(landing_dlg)

				idx = idx + 1
				-- store new marker in our list
				local marker_id = "idMarker" .. idx
				new_markers[table_name] = {
					id = marker_id,
					longitude = save.longitude,
					text = save.displayname,
				}

				spot_counts[table_name] = 1

				marker:SetId(marker_id)
				marker.DrawContent = template.DrawContent
				PlanetRotationObj:Attach(attach, PlanetRotationObj_spot)
				marker:AddDynamicPosModifier{id = "planet_pos", target = attach}

				local lat, long = LandingSite_object:CalcPlanetCoordsFromScreenCoords(save.latitude * 60, save.longitude * 60)
				local _, world_pt = LandingSite_object:CalcClickPosFromCoords(lat, long)

				local offset = world_pt - PlanetRotationObj_pos
				--compensate for the planet's rotation
				local planet_angle = 360*60 - MulDivRound(PlanetRotationObj:GetAnimPhase(1), 360*60, LandingSite_object.anim_duration)
				offset = RotateAxis(offset, PlanetRotationObj_axis, -planet_angle)
				attach:SetAttachOffset(offset)
			end
		end
	end

	template:SetId("idSpotTemplate")
	template:SetVisible(false)
	template.DrawContent = ChoOrig_template_DrawContent
end

function OnMsg.ClassesPostprocess()
	PlaceObj("TextStyle", {
		TextColor = -1,
		TextFont = T(986, "SchemeBk, 15, aa"),
		id = "ChoGGi_PlanetUISavedGamesText"
	})
end

local ChoOrig_LandingSiteObject_AttachPredefinedSpots = LandingSiteObject.AttachPredefinedSpots
function LandingSiteObject:AttachPredefinedSpots(...)
	ChoOrig_LandingSiteObject_AttachPredefinedSpots(self, ...)
	-- we only want it to happen during the new game planet
	if UICity then
		return
	end

	-- needed ref above
	LandingSite_object = self
	-- If I don't thread it I get an error from LandingSiteObject:DrawSpot
	CreateRealTimeThread(BuildMySpots)
end

-- are our icons vis?
local ChoOrig_LandingSiteObject_CalcMarkersVisibility = LandingSiteObject.CalcMarkersVisibility
function LandingSiteObject:CalcMarkersVisibility(...)
	-- we only want it to happen during the new game planet
	if UICity then
		return ChoOrig_LandingSiteObject_CalcMarkersVisibility(self, ...)
	end

	local cur_phase = PlanetRotationObj:GetAnimPhase()
	for _, obj in pairs(new_markers) do
		local phase = self:CalcAnimPhaseUsingLongitude(obj.longitude * 60)
		local dist = Min((cur_phase-phase)%self.anim_duration, (phase-cur_phase)%self.anim_duration)
		self.dialog[obj.id]:SetVisible(dist <= 2400)
	end

	return ChoOrig_LandingSiteObject_CalcMarkersVisibility(self, ...)
end

local ChoOrig_LandingSiteObject_DisplayCoord = LandingSiteObject.DisplayCoord
function LandingSiteObject:DisplayCoord(...)
	ChoOrig_LandingSiteObject_DisplayCoord(self, ...)
	-- we only want it to happen during the new game planet
	if UICity then
		return
	end

	-- Is it one of ours
	local params = g_CurrentMapParams
	local marker = new_markers[params.latitude .. "_" .. params.longitude]
	if marker then
		local text = self.dialog.idtxtCoord.text
		self.dialog.idtxtCoord:SetText("<style ChoGGi_PlanetUISavedGamesText>" .. marker.text .. "</style>\n" .. text)
	end
end
