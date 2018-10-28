-- See LICENSE for terms

local StringFormat = string.format

local img = StringFormat("%sUI/pm_landed.png",CurrentModPath)
local idmarker = "idMarker%s"
local marker_name = "%s_%s"

-- stores saved game spots
local new_markers = {}

local LandingSite_object
local PlanetRotation_object

-- draws the saved game spot image (needed to slightly tweak LandingSiteObject:DrawSpot)
local ScaleXY = ScaleXY
local box = box
local DrawImage = UIL.DrawImage
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

-- add our visited icons
local MulDivRound = MulDivRound
local PlaceObject = PlaceObject
local RotateAxis = RotateAxis
local function BuildMySpots()
	local landing_dlg = LandingSite_object.dialog
	PlanetRotation_object = PlanetRotationObj

	-- double maxwidth limit for text (some people have lots of saves)
	landing_dlg.idtxtCoord:SetMaxWidth(800)

	local template = landing_dlg.idSpotTemplate
	local orig_template_DrawContent = template.DrawContent
	template.DrawContent = DrawSpot

	-- needs to be removed for now
	template:SetId("")
	template:SetVisible(true)

	-- always start with a blank table
	table.clear(new_markers)

	-- start above the default landing spots added
	local idx = #Presets.LandingSpot.Default+1

	local SavegamesList = SavegamesList
	-- get list of saves
	SavegamesList:Refresh()

	for i = 1, #SavegamesList do
		local save = SavegamesList[i]
		if type(save.longitude) == "number" and type(save.latitude) == "number" then
			-- use this to build a table of locations for ease of dupe checking
			local table_name = marker_name:format(save.latitude,save.longitude)

			-- check if this location is already added
			if new_markers[table_name] then
				-- merge save names if dupe location
				local marker = new_markers[table_name]
				marker.text = StringFormat("%s, %s",marker.text,save.displayname)
			else
				-- plunk down a new one (most of this code is copied from LandingSiteObject:AttachPredefinedSpots)
				local attach = PlaceObject("Shapeshifter")
				local marker = template:Clone()
				marker:SetParent(landing_dlg)

				-- store new marker in our list
				local marker_id = idmarker:format(idx)
				new_markers[table_name] = {
					id = marker_id,
					longitude = save.longitude,
					text = save.displayname,
				}

				idx = idx + 1
				marker:SetId(marker_id)
				marker.DrawContent = template.DrawContent
				PlanetRotation_object:Attach(attach, PlanetRotation_object:GetSpotBeginIndex("Planet"))
				marker:AddDynamicPosModifier{id = "planet_pos", target = attach}

				local lat, long = LandingSite_object:CalcPlanetCoordsFromScreenCoords(save.latitude * 60, save.longitude * 60)
				local _, world_pt = LandingSite_object:CalcClickPosFromCoords(lat, long)

				local offset = world_pt - PlanetRotation_object:GetPos()
				--compensate for the planet's rotation
				local planet_angle = 360*60 - MulDivRound(PlanetRotation_object:GetAnimPhase(1), 360 * 60, LandingSite_object.anim_duration)
				offset = RotateAxis(offset, PlanetRotation_object:GetAxis(), -planet_angle)
				attach:SetAttachOffset(offset)
			end
		end
	end

	template:SetId("idSpotTemplate")
	template:SetVisible(false)
	template.DrawContent = orig_template_DrawContent

end

local orig_LandingSiteObject_AttachPredefinedSpots = LandingSiteObject.AttachPredefinedSpots
function LandingSiteObject:AttachPredefinedSpots(...)
	orig_LandingSiteObject_AttachPredefinedSpots(self,...)
	LandingSite_object = self
	-- if I don't thread it I get an error from LandingSiteObject:DrawSpot
	CreateRealTimeThread(BuildMySpots)
end

-- are our icons vis?
local pairs = pairs
local Min = Min
local orig_LandingSiteObject_CalcMarkersVisibility = LandingSiteObject.CalcMarkersVisibility
function LandingSiteObject:CalcMarkersVisibility()
	local cur_phase = PlanetRotationObj:GetAnimPhase()
	for name,obj in pairs(new_markers) do
		local phase = self:CalcAnimPhaseUsingLongitude(obj.longitude * 60)
		local dist = Min((cur_phase-phase)%self.anim_duration, (phase-cur_phase)%self.anim_duration)
		self.dialog[obj.id]:SetVisible(dist <= 2400)
	end

	return orig_LandingSiteObject_CalcMarkersVisibility(self)
end

local orig_LandingSiteObject_DisplayCoord = LandingSiteObject.DisplayCoord
function LandingSiteObject:DisplayCoord(pt, lat, long, lat_org, long_org)
	orig_LandingSiteObject_DisplayCoord(self, pt, lat, long, lat_org, long_org)

	-- is it one of ours
	local g_CurrentMapParams = g_CurrentMapParams
	local marker = new_markers[marker_name:format(g_CurrentMapParams.latitude,g_CurrentMapParams.longitude)]
	if marker then
		local text = self.dialog.idtxtCoord.text
		self.dialog.idtxtCoord:SetText(StringFormat("<font HelpHint>%s</font>\n%s",marker.text,text))
	end
end
