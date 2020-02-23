-- See LICENSE for terms

-- I use the mirror ball thingy to hide my shame
if not g_AvailableDlc.contentpack1 then
	return
end

local point = point
local table_find = table.find
local table_iclear = table.iclear
local table_rand = table.rand
local IsValidEntity = IsValidEntity
local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local GetConstructionController = GetConstructionController
local Translate = ChoGGi.ComFuncs.Translate

local icon_path = CurrentModPath .. "UI/"
local description = T(302535920011004, "It's a wall (use button to rotate after placing).") .. "\n\n"
local wall_types = {
	ChoGGi_BaseWall = {
		build_pos = 2,
		display_name = T(302535920011005, "Adjustable Length Wall"),
		display_name_pl = T(302535920011006, "Adjustable Length Walls"),
		display_icon = icon_path .. "wall_adjust.png",
		description = description,
	},
	ChoGGi_BaseWallCap = {
		build_pos = 3,
		display_name = T(302535920011007, "Wall Cap"),
		display_name_pl = T(302535920011008, "Walls Cap"),
		display_icon = icon_path .. "wall_cap.png",
		description = description .. T(302535920011009, "Cap off a wall."),
	},
	ChoGGi_BaseWallCapSmall = {
		build_pos = 4,
		display_name = T(302535920011010, "Wall Cap Small"),
		display_name_pl = T(302535920011011, "Walls Cap Small"),
		display_icon = icon_path .. "wall_capsmall.png",
		description = description .. T(302535920011012, "Cap off a wall chibi."),
	},
	ChoGGi_BaseTurnWallSmall = {
		build_pos = 5,
		display_name = T(302535920011013, "Turn Wall Small"),
		display_name_pl = T(302535920011014, "Turn Walls Small"),
		display_icon = icon_path .. "wall_turn.png",
		description = description .. T(302535920011015, "Small turn gate."),
	},
	ChoGGi_BaseTurnWallLarge = {
		build_pos = 6,
		display_name = T(302535920011016, "Turn Wall Large"),
		display_name_pl = T(302535920011017, "Turn Walls Large"),
		display_icon = icon_path .. "wall_turnlarge.png",
		description = description .. T(302535920011018, "Large turn gate."),
	},
	ChoGGi_BaseWallRamp = {
		build_pos = 7,
		display_name = T(302535920011019, "Drone Ramp"),
		display_name_pl = T(302535920011020, "Drone Ramps"),
		display_icon = "UI/Icons/Buildings/passage_ramp.tga",
		description = description .. T(302535920011021, "Help the wee ones over the walls."),
	},
}

-- used for the two holder corners
local corner_objects = {
	"LightSphere",
	"PlanetEarth",
	"PlanetMars",
	"Mystery_MirrorSphere",
}
local description_corner = T(302535920011022, "Something to use instead of the turns.") .. "\n\n"
-- add some corners joiners if people don't like the crappy curves
local corner_types = {
	ChoGGi_CornerJoiner_Eye = {
		build_pos = 1,
		entity = "DefenceTurretPlatform",
		display_name = T(302535920011023, "Eye"),
		display_name_pl = T(302535920011024, "Eyes"),
		display_icon = icon_path .. "corner_eye.png",
		description = description_corner .. T(302535920011025, "Eyes always watching you."),
	},
	ChoGGi_CornerJoiner_Stumpy = {
		build_pos = 2,
		entity = "ReprocessingPlantBarrel",
		display_name = T(302535920011026, "Stumpy"),
		display_name_pl = T(302535920011027, "Stumpies"),
		display_icon = icon_path .. "corner_stumpy.png",
		description = description_corner .. T(302535920011028, "Hunk 'o stump."),
	},
	ChoGGi_CornerJoiner_Holder = {
		build_pos = 3,
		entity = "DefenceTurret",
		display_name = T(302535920011029, "Holder Sphere"),
		display_name_pl = T(302535920011030, "Holder Spheres"),
		display_icon = icon_path .. "corner_holder.png",
		description = description_corner .. T(302535920011031, "Glory be to the light (or planet or mirror)."),
		objects = corner_objects,
	},
	-- add a switch corner button?
	ChoGGi_CornerJoiner_Star = {
		build_pos = 4,
		entity = "RoverChinaSolarPanel",
		display_name = T(302535920011032, "Mars Star"),
		display_name_pl = T(302535920011033, "Mars Stars"),
		display_icon = icon_path .. "corner_marsstar.png",
		description = description_corner .. T(302535920011034, "Bask in the glory of Mother Mars."),
		objects = corner_objects,
	},
	ChoGGi_CornerJoiner_Umbrella = {
		build_pos = 5,
		entity = "StirlingGeneratorCP3",
		display_name = T(302535920011035, "Umbrella"),
		display_name_pl = T(302535920011036, "Umbrellas"),
		display_icon = icon_path .. "corner_umbrella.png",
		description = description_corner .. T(302535920011037, "Protect the poor walls from the deadly sun."),
	},
}

-- + - numbers intertwined (spacing between passages)
local offsets = {}
do -- offset points
	local c_m = -1
	local c_p = 0
	for i = 500, 200500, 1000 do
		c_p = c_p + 2
		offsets[c_p] = point(i, 0, 0)
	end
	for i = -500, -200500, -1000 do
		c_m = c_m + 2
		offsets[c_m] = point(i, 0, 0)
	end
	--~ ex(offsets)
end -- do

-- simple ent obj, we don't need any attaches or whatnot for the entities
DefineClass.ChoGGi_BaseWallClass = {
	__parents = {
		"ComponentAttach",
	},

	building_scale = 25,

	building_cap_entity = IsValidEntity("TubeChromeJoint")
		and "TubeChromeJoint" or "TubeJoint",
	building_scale_cap = 255,
	building_cap_offset = point(-400, 0, 0),
	building_cap_angle = 180 * 60,

	offsets = offsets,
	coll_flags = const.efWalkable,

	-- table from types list
	item_table = false,
	current_holder_object = false,
	-- wall/wall_adjust/corner
	item_type = false,

	-- we change this in build mode
	spawn_wall_count = 1,

	spawning_objs = false,
}
local OBaseWallClass

-- when we call it from building templates
local cursor_building = false

DefineClass.ChoGGi_BaseWalls = {
	__parents = {
		"Building",
	},
	-- buttons
	ip_template = "ipChoGGi_BaseWalls",
	-- store attached stuff
	attached_objs = false,
}
function ChoGGi_BaseWalls:GameInit()
	self.attached_objs = {}
end

-- default to reg pass
function ChoGGi_BaseWalls:SpawnBaseObj(cls, parent)
	local obj = OBaseWallClass:new()
	obj:ChangeEntity(cls or "PassageCovered")

	if cursor_building then
		cursor_building:Attach(obj)
	else
		(parent or self):Attach(obj)
	end

	if not parent and self.attached_objs then
		self.attached_objs[#self.attached_objs+1] = obj
	end
	return obj
end

function ChoGGi_BaseWalls:SpawnPassages(amount, offset, angle, parent)
	if not amount then
		local obj = self:SpawnBaseObj()
		if offset then
			obj:SetAttachOffset(offset)
		end
		if angle then
			obj:SetAttachAngle(angle)
		end
		return obj
	end

	-- we scaled them down to 25% so 4==1
	-- had to go to 25, so we can fit "turn"s in one hex
	amount = amount * 4
	for i = 1, amount do
		self:SpawnBaseObj(nil, parent):SetAttachOffset(self.offsets[i])
	end
end

function ChoGGi_BaseWalls:SpawnTurn(offset)
	local obj = self:SpawnBaseObj("PassageCoveredTurn")
	if offset then
		obj:SetAttachOffset(offset)
	end
	return obj
end

function ChoGGi_BaseWalls:SpawnJoint(parent)
	local cap = OBaseWallClass:new()
	cap:ChangeEntity(self.building_cap_entity)
	cap:SetScale(self.building_scale_cap)

	-- yes it needs the "do end"
	do (parent or self):Attach(cap) end
	return cap
end

function ChoGGi_BaseWalls:SpawnCap()
	local entrance = self:SpawnBaseObj("PassageEntrance")

	local cap = self:SpawnJoint(entrance)
	cap:SetAttachOffset(self.building_cap_offset)
	cap:SetAngle(self.building_cap_angle)

	return entrance, cap
end
function ChoGGi_BaseWalls:SpawnShortTurnCover(offset, parent)
	local obj = self:SpawnBaseObj("DomeDoorEntrance_01", parent)
	if offset then
		obj:SetAttachOffset(offset)
	end
	obj:SetAxisAngle(point(-2495, 1402, 2930), 16957)
	return obj
end

function ChoGGi_BaseWalls:UpdateHoldee(obj, entity, mars_star)
	if entity == "PlanetEarth" or entity == "PlanetMars" then
		obj:SetState("idle")
		obj:SetScale(mars_star and 20 or 25)
		obj:SetAttachOffset(point(0, 0, mars_star and -20 or 190))
	elseif entity == "Mystery_MirrorSphere" then
		obj:SetState("idle2")
		obj:SetScale(mars_star and 10 or 15)
		obj:SetAttachOffset(point(0, 0, mars_star and -210 or 30))
	elseif entity == "LightSphere" then
		obj:SetState("idle")
		obj:SetScale(mars_star and 90 or 110)
		obj:SetAttachOffset(point(0, 0, mars_star and -30 or 270))
	end
end

-- wall spawner
function ChoGGi_BaseWalls:SpawnWallAttaches(cursor_obj, count)
	if self.spawning_objs then
		return
	end
	self.spawning_objs = true

	local id = (cursor_obj and cursor_obj.template or self).template_name
	local item = wall_types[id] or wall_types.ChoGGi_BaseWall
	self.item_table = item
	self.item_type = "wall"

	-- clear existing length (yeah i'm lazy sue me)
	do (cursor_obj or self):DestroyAttaches() end

	if self.attached_objs then
		table_iclear(self.attached_objs)
	end

	-- not actual entity, but we use it to change skins
	self.entity = self.entity ~= "InvisibleObject" and self.entity or "Passage"

	-- speeds up adding/removing/etc with objects
	SuspendPassEdits("ChoGGi_BaseWalls:SpawnAttaches")

	if id == "ChoGGi_BaseWall" then
		self:SpawnPassages(count or self.spawn_wall_count)
		self.item_type = "wall_adjust"

	-- two pass with a cap
	elseif id == "ChoGGi_BaseWallCap" then
		self:SpawnCap():SetAttachOffset(self.offsets[2])
		self:SpawnPassages(nil,self.offsets[1])
		self:SpawnPassages(nil,self.offsets[3])
	-- just cap
	elseif id == "ChoGGi_BaseWallCapSmall" then
		self:SpawnCap():SetAttachOffset(self.offsets[3])

	-- one hex degree turn
	elseif id == "ChoGGi_BaseTurnWallSmall" then
		local obj
		-- two turns
		self:SpawnTurn(self.offsets[4])
		obj = self:SpawnTurn(point(750, 1300, 0))
		obj:SetAttachAngle(18000)
		-- and a straight, +1 to avoid flicker
		obj = self:SpawnPassages(nil,point(1170, 620, 1), 7200)

		-- somethings to cover up my shame
		obj = self:SpawnBaseObj("InvisibleObject")
		obj:SetScale(125)
		obj:SetAttachOffset(point(-243, -332, -70))
		obj:SetAxisAngle(point(2032, 2393, 2630), 21498)

		-- no clue why this doesn't work but the below does... the magic of SM (if you can figure it out, pray tell)
--~ 		local x, z = 885, 231
--~ 		for _ = 1, 9 do
--~ 			x = x + 25
--~ 			z = z - 1
--~ 			self:SpawnShortTurnCover(point(x, 1360, z), obj)
--~ 		end

		local x, z = 910, 230
		self:SpawnShortTurnCover(point(x, 1360, z), obj)
		x = x + 25
		z = z - 1
		self:SpawnShortTurnCover(point(x, 1320, z), obj)
		x = x + 25
		z = z - 1
		self:SpawnShortTurnCover(point(x, 1280, z), obj)
		x = x + 25
		z = z - 1
		self:SpawnShortTurnCover(point(x, 1240, z), obj)
		x = x + 25
		z = z - 1
		self:SpawnShortTurnCover(point(x, 1200, z), obj)
		x = x + 25
		z = z - 1
		self:SpawnShortTurnCover(point(x, 1160, z), obj)
		x = x + 25
		z = z - 1
		self:SpawnShortTurnCover(point(x, 1120, z), obj)
		x = x + 25
		z = z - 1
		self:SpawnShortTurnCover(point(x, 1080, z), obj)
		x = x + 25
		z = z - 1
		self:SpawnShortTurnCover(point(x, 1040, z), obj)

	-- two hex degree turn
	elseif id == "ChoGGi_BaseTurnWallLarge" then
		self:SpawnPassages(nil,point(-750, 1300, 0), 7200)
		self:SpawnPassages(nil,point(-260, 450, 0), 7200)
		-- +1 to avoid flicker
		self:SpawnTurn(point(0, 0, 1))

		self:SpawnPassages(nil,self.offsets[4])
		self:SpawnPassages(nil,self.offsets[2])
		-- something to cover up my shame
		local shame = OBaseWallClass:new()
		shame:SetAttachOffset(point(-30, -30, -620))
		shame:SetScale(33)
		shame:ChangeEntity("Mystery_MirrorSphere")
		shame:SetColorModifier(0)
		shame:SetState("static")
		self:Attach(shame)

	elseif id == "ChoGGi_BaseWallRamp" then
		self:SpawnBaseObj("PassageRamp")

	end

	-- we don't use attached_objs for the building placement version
	if self.attached_objs then
		local attached = #self.attached_objs
		self.spawn_wall_count = attached / 4
		CreateRealTimeThread(function()
			WaitMsg("OnRender")
			for i = 1, attached do
				self.attached_objs[i]:SetEnumFlags(self.coll_flags)
			end

			self.spawning_objs = false
			ResumePassEdits("ChoGGi_BaseWalls:SpawnAttaches")
		end)
	else
		self.spawning_objs = false
		ResumePassEdits("ChoGGi_BaseWalls:SpawnAttaches")
	end

end
-- corner spawner
function ChoGGi_BaseWalls:SpawnCornerAttaches(cursor_obj)
	local id = (cursor_obj and cursor_obj.template or self).template_name
	local item = corner_types[id] or corner_types.DefenceTurretPlatform
	self.item_table = item
	self.item_type = "corner"

	-- speeds up adding/removing/etc with objects
	SuspendPassEdits("ChoGGi_BaseWalls:SpawnCornerAttaches")

	-- always spawn something
	local obj = self:SpawnBaseObj(item.entity)

	-- Colour, Roughness, Metallic (r/m go from -128 to 127)
	if id == "ChoGGi_CornerJoiner_Eye" then
		obj:SetAngle(1800)
		obj:SetScale(263)
		obj:SetAttachOffset(point(0, 0, -1036))
		obj:SetColorizationMaterial(2, -4692187, 127, -48)

	elseif id == "ChoGGi_CornerJoiner_Stumpy" then
		obj:SetScale(175)
		obj:SetAttachOffset(point(1170, -10, -1908))
		obj:SetAxisAngle(point(0, -4096, 0), 5400)
		obj:SetColorizationMaterial(1, -4692187, 127, -48)

	elseif id == "ChoGGi_CornerJoiner_Holder" then
		obj:SetScale(123)
		obj:SetColorizationMaterial(1, -1, -128, 127)
		obj:SetColorizationMaterial(2, -4692187, 127, -48)
		obj:SetColorizationMaterial(3, -13480117, -128, 48)
		local holdee = table_rand(item.objects)
		obj = self:SpawnBaseObj(holdee, obj)
		self:UpdateHoldee(obj, holdee)
		self.current_holder_object = obj

	-- set pos and such and attach what's needed
	elseif id == "ChoGGi_CornerJoiner_Star" then
		obj:SetScale(200)
		obj:SetState("idle2")
		obj:SetAxisAngle(point(4096, 0, 0), 10700)
		obj:SetAttachOffset(point(0, 0, 395))
		local holdee = table_rand(item.objects)
		obj = self:SpawnBaseObj(holdee, obj)
		self:UpdateHoldee(obj, holdee, true)
		self.current_holder_object = obj

	elseif id == "ChoGGi_CornerJoiner_Umbrella" then
		obj:SetState("idleOpened")
		obj:SetScale(125)
		obj:SetAngle(1800)
		obj:SetAttachOffset(point(0, 0, -928))
		obj:SetColorizationMaterial(1, -13480117, -128, 48)
		obj:SetColorizationMaterial(2, -1, -128, 127)
		obj:SetColorizationMaterial(3, -4692187, 127, -48)

	end

	ResumePassEdits("ChoGGi_BaseWalls:SpawnCornerAttaches")
end

-- swap between stuff for the holder corners
function ChoGGi_BaseWalls:SwapHolder()
	if not (self.current_holder_object or self.item_table.objects) then
		return
	end

	-- grab the next entity
	local idx = table_find(self.item_table.objects, self.current_holder_object.entity)
	local next_ent = self.item_table.objects[idx+1]
	if not next_ent then
		next_ent = self.item_table.objects[1]
	end
	self.current_holder_object:ChangeEntity(next_ent)

	local which_holder = self.current_holder_object:GetParent():GetEntity() ~= "DefenceTurret"
	self:UpdateHoldee(self.current_holder_object, next_ent, which_holder)
end

-- stop showing the no drone commander sign
ChoGGi_BaseWalls.ShouldShowNoCCSign = empty_func
-- round and round she goes, and where she stops BOB knows
function ChoGGi_BaseWalls:Rotate(toggle)
	self:SetAngle((self:GetAngle() or 0) + (toggle and 1 or -1)*60*60)
end

function ChoGGi_BaseWalls:AdjustWallLength(toggle)
	-- true deflate, false engorge
	self:AdjustLength(toggle and -2 or 2, self.spawn_wall_count)
end

local table_lookup = {
	PassageCovered = "pass",
	PassageCoveredFacet = "pass",
	PassageCoveredGeoscape = "pass",
	PassageCoveredPack = "pass",
	PassageCoveredStar = "pass",

	PassageCoveredTurn = "turn",
	PassageCoveredTurnFacet = "turn",
	PassageCoveredTurnGeoscape = "turn",
	PassageCoveredTurnPack = "turn",
	PassageCoveredTurnStar = "turn",

	PassageEntrance = "enter",
	PassageEntranceFacet = "enter",
	PassageEntranceGeoscape = "enter",
	PassageEntrancePack = "enter",
	PassageEntranceStar = "enter",

	PassageRamp = "ramp",
	PassageRampFacet = "ramp",
	PassageRampGeoscape = "ramp",
	PassageRampPack = "ramp",
	PassageRampStar = "ramp",
}
local lookup_skins = {
	Passage = {
		pass = "PassageCovered",
		turn = "PassageCoveredTurn",
		enter = "PassageEntrance",
		ramp = "PassageRamp",
	},
	Facet = {
		pass = "PassageCoveredFacet",
		turn = "PassageCoveredTurnFacet",
		enter = "PassageEntranceFacet",
		ramp = "PassageRampFacet",
	},
	Geoscape = {
		pass = "PassageCoveredGeoscape",
		turn = "PassageCoveredTurnGeoscape",
		enter = "PassageEntranceGeoscape",
		ramp = "PassageRampGeoscape",
	},
	Pack = {
		pass = "PassageCoveredPack",
		turn = "PassageCoveredTurnPack",
		enter = "PassageEntrancePack",
		ramp = "PassageRampPack",
	},
}
local pass_skins = {
	"Passage",
	"Facet",
	"Geoscape",
	"Pack",
}
-- dlc skin
if IsValidEntity("PassageCoveredStar") then
	lookup_skins.Star = {
		pass = "PassageCoveredStar",
		turn = "PassageCoveredTurnStar",
		enter = "PassageEntranceStar",
		ramp = "PassageRampStar",
	}
	pass_skins[#pass_skins+1] = "Star"
end
local pass_skins_c = #pass_skins

function ChoGGi_BaseWalls:ChangeSkin(skin)
	local lookup = lookup_skins[skin]
	SuspendPassEdits("ChoGGi_BaseWalls:ChangeSkin")
	-- we need to change each spawned entity
	for i = 1, #self.attached_objs do
		local obj = self.attached_objs[i]
		obj:ChangeEntity(lookup[table_lookup[obj.entity]])
	end
	ResumePassEdits("ChoGGi_BaseWalls:ChangeSkin")

	local idx = table_find(pass_skins, skin) + 1
	if not pass_skins[idx] then
		idx = 1
	end
	self.entity = pass_skins[idx]
end

function ChoGGi_BaseWalls:GetSkins()
	if self.item_type == "wall" or self.item_type == "wall_adjust" then
		return pass_skins, empty_table
	end
end

-- used below and for build mode
local spawn_wall_count = 1
-- abort if we're already adjusting
local adjusting = false

function ChoGGi_BaseWalls:AdjustLength(size, current_size)
	if adjusting or not IsValid(self) then
		return
	end
	-- so we don't spam the spawn func
	adjusting = true

	spawn_wall_count = current_size + size

	if spawn_wall_count < 1 then
		spawn_wall_count = 1
	elseif spawn_wall_count > 99 then
		-- i could add more, but that's enough unless someone complains for more
		-- i pre-make the list for speed
		-- 202/4
		spawn_wall_count = 100
	end

	-- no need to change if it's the same
	if self.previous_count ~= spawn_wall_count then
		-- speeds up adding/removing/etc with objects
		SuspendPassEdits("ChoGGi_BaseWalls:AdjustLength")
		-- get skin to reset new wall to
		local entity = self.entity or "Passage"
		local idx = table_find(pass_skins, entity) - 1
		if not pass_skins[idx] then
			if idx == 0 then
				idx = pass_skins_c
			else
				idx = 1
			end
		end
		entity = pass_skins[idx]

	-- build menu or placed obj
		if self:IsKindOf("ChoGGi_BaseWalls") then
			self.spawn_wall_count = spawn_wall_count
			self:SpawnWallAttaches()
		else
			-- we use self.spawn_wall_count for the first go
			self.ChoGGi_bs.spawn_wall_count = spawn_wall_count
			self.ChoGGi_bs:SpawnWallAttaches(self, spawn_wall_count)
		end
		self:ChangeSkin(entity)
		ResumePassEdits("ChoGGi_BaseWalls:AdjustLength")

		self.previous_count = spawn_wall_count
	end

	adjusting = false
end

DefineClass.ChoGGi_BaseWallCorner = {
	__parents = {
		"ChoGGi_BaseWalls",
		"ChoGGi_BaseWallClass",
	},
}
function ChoGGi_BaseWallCorner:GameInit()
	self:SpawnCornerAttaches()
end

DefineClass.ChoGGi_BaseWall = {
	__parents = {
		"ChoGGi_BaseWalls",
		"ChoGGi_BaseWallClass",
	},
}

function ChoGGi_BaseWall:GameInit()
	-- scales attaches
	self:SetScale(self.building_scale)

	self:SpawnWallAttaches()
end

function OnMsg.ClassesPostprocess()

	OBaseWallClass = ChoGGi_BaseWallClass

	local bc = BuildCategories
	if not table.find(bc, "id", "ChoGGi_BaseWalls") then
		bc[#bc+1] = {
			id = "ChoGGi_BaseWalls",
			name = T(302535920011039, "Base Walls"),
			image = icon_path .. "bmc_basewalls.png",
--~ 			highlight = "UI/Icons/bmc_placeholder_shine.tga",
		}
	end

	local IsMassUIModifierPressed = IsMassUIModifierPressed
	local XTemplates = XTemplates

	-- added to stuff spawned with object spawner
	if XTemplates.ipChoGGi_BaseWalls then
		XTemplates.ipChoGGi_BaseWalls:delete()
	end

	PlaceObj("XTemplate", {
		group = "Infopanel Sections",
		id = "ipChoGGi_BaseWalls",
		PlaceObj("XTemplateTemplate", {
			"__context_of_kind", "ChoGGi_BaseWalls",
			"__template", "Infopanel",
		}, {

------------------- Rotate
			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelButton",
				"Icon", "UI/Icons/IPButtons/automated_mode_on.tga",
				"RolloverTitle", T(1000077, "Rotate"),
				"RolloverText", T(7519, "<left_click>") .. " "
					.. T(312752058553, "Rotate Building Left").. "\n"
					.. T(7366, "<right_click>") .. " "
					.. T(306325555448, "Rotate Building Right"),
				"RolloverHint", "",
				"RolloverHintGamepad", T(7518, "ButtonA") .. " "
					.. T(312752058553, "Rotate Building Left") .. " "
					.. T(7618, "ButtonX") .. " " .. T(306325555448, "Rotate Building Right"),
				"OnPress", function (self, gamepad)
					self.context:Rotate(not gamepad and IsMassUIModifierPressed())
					ObjModified(self.context)
				end,
				"AltPress", true,
				"OnAltPress", function (self, gamepad)
					if gamepad then
						self.context:Rotate(gamepad)
					else
						self.context:Rotate(not IsMassUIModifierPressed())
					end
					ObjModified(self.context)
				end,
			}),
------------------- Rotate

------------------- Holdee Swap
			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelButton",
				"__condition", function(_, context)
					return context.current_holder_object
				end,
				"Icon", "UI/Icons/IPButtons/pin.tga",
				"RolloverTitle", T(302535920011040, "Holdee Swap"),
				"RolloverText", T(302535920011041, "Different strokes for different folks."),
				"OnPress", function (self)
					self.context:SwapHolder()
					ObjModified(self.context)
				end,
			}),
------------------- Holdee Swap

------------------- Adjust length
			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelButton",
				"__condition", function(_, context)
					return context.item_type == "wall_adjust"
				end,
				"Icon", "UI/Icons/IPButtons/drill.tga",
				"RolloverTitle", T(302535920011042, "Adjust Length"),
				"RolloverText", T(302535920011043, [[Adjust length of placed wall.


<em>Would you care for another schnitzengruben?</em>]]),

				"RolloverHint", T(7519, "<left_click>") .. " " .. T(1000541, "+") .. " "
					.. T(7366, "<right_click>") .. " " .. T(1000540, "-"),
				"RolloverHintGamepad", T(7518, "ButtonA") .. " " .. T(1000541, "+")
					.. " " .. T(7618, "ButtonX") .. " " .. T(1000540, "-"),
				"OnPress", function (self, gamepad)
					self.context:AdjustWallLength(not gamepad and IsMassUIModifierPressed())
					ObjModified(self.context)
				end,
				"AltPress", true,
				"OnAltPress", function (self, gamepad)
					if gamepad then
						self.context:AdjustWallLength(gamepad)
					else
						self.context:AdjustWallLength(not IsMassUIModifierPressed())
					end
					ObjModified(self.context)
				end,

			}),
------------------- Adjust length

------------------- Salvage
			PlaceObj('XTemplateTemplate', {
				'comment', "salvage",
				'__context_of_kind', "Demolishable",
				'__condition', function (_, context) return context:ShouldShowDemolishButton() end,
				'__template', "InfopanelButton",
				'RolloverTitle', T(3973, --[[XTemplate ipBuilding RolloverTitle]] "Salvage"),
				'RolloverHintGamepad', T(7657, --[[XTemplate ipBuilding RolloverHintGamepad]] "<ButtonY> Activate"),
				'Id', "idSalvage",
				'OnContextUpdate', function (self, context, ...)
					local refund = context:GetRefundResources() or empty_table
					local rollover = T(7822, "Destroy this building.")
					if IsKindOf(context, "LandscapeConstructionSiteBase") then
						self:SetRolloverTitle(T(12171, "Cancel Landscaping"))
						rollover = T(12172, "Cancel this landscaping project. The terrain will remain in its current state")
					end
					if #refund > 0 then
						rollover = rollover .. "<newline><newline>" .. T(7823, "<UIRefundRes> will be refunded upon salvage.")
					end
					self:SetRolloverText(rollover)
					context:ToggleDemolish_Update(self)
				end,
				'OnPressParam', "ToggleDemolish",
				'Icon', "UI/Icons/IPButtons/salvage_1.tga",
			}, {
				PlaceObj('XTemplateFunc', {
					'name', "OnXButtonDown(self, button)",
					'func', function (self, button)
						if button == "ButtonY" then
							return self:OnButtonDown(false)
						elseif button == "ButtonX" then
							return self:OnButtonDown(true)
						end
						return (button == "ButtonA") and "break"
					end,
				}),
				PlaceObj('XTemplateFunc', {
					'name', "OnXButtonUp(self, button)",
					'func', function (self, button)
						if button == "ButtonY" then
							return self:OnButtonUp(false)
						elseif button == "ButtonX" then
							return self:OnButtonUp(true)
						end
						return (button == "ButtonA") and "break"
					end,
				}),
				}),
------------------- Salvage


			PlaceObj("XTemplateTemplate", {
				"__template", "sectionCheats",
			}),
		}),
	})

	if BuildingTemplates.ChoGGi_BaseWall then
		return
	end

	-- add our wall build objects
	for id, item in pairs(wall_types) do
		PlaceObj("BuildingTemplate", {
			"Id", id,
			"template_class", "ChoGGi_BaseWall",
--~ 			"construction_cost_Concrete", 1000,
			"instant_build", true,

--~ 			"dome_forbidden", true,
			"display_name", item.display_name,
			"display_name_pl", item.display_name_pl,
			"description", item.description or description,
			"display_icon", item.display_icon,
			"build_pos", item.build_pos,

			-- changed below
--~ 			"entity", "Passage_Open",
			"entity", "InvisibleObject",

			"build_category", "ChoGGi_BaseWalls",
			"Group", "Default",
			"encyclopedia_exclude", true,

			"on_off_button", false,
			"prio_button", false,
			"use_demolished_state", false,
			"auto_clear", true,
		})
	end

	-- and corner joiners
	PlaceObj("BuildMenuSubcategory", {
		build_pos = 1,
		category = "ChoGGi_BaseWalls",
		description = description_corner,
		display_name = T(302535920011038, "Corner Joiners"),
		group = "Default",
		icon = icon_path .. "corner_subcat.png",
		category_name = "ChoGGi_BaseWalls_Joiners",
		id = "ChoGGi_BaseWalls_Joiners",
	})

	for id, item in pairs(corner_types) do
		-- some are DLC
		if IsValidEntity(item.entity) then
			PlaceObj("BuildingTemplate", {

				"Id", id,
				"template_class", "ChoGGi_BaseWallCorner",
	--~ 			"construction_cost_Concrete", 1000,
				"instant_build", true,

--~ 				"dome_forbidden", true,
				"display_name", item.display_name,
				"display_name_pl", item.display_name_pl,
				"description", item.description or description_corner,
				"display_icon", item.display_icon,
				"build_pos", item.build_pos,

				-- needs something
				"entity", "InvisibleObject",

				"build_category", "ChoGGi_BaseWalls_Joiners",
				"Group", "Default",
				"encyclopedia_exclude", true,

				"on_off_button", false,
				"prio_button", false,
				"use_demolished_state", false,
				"auto_clear", true,
			})

		end
	end

end

local Actions = ChoGGi.Temp.Actions
local c = #Actions
c = c + 1
Actions[c] = {ActionName = T(302535920011046, "BaseWalls") .. ": " .. T(302535920011044, "Adjust Longer"),
	ActionId = "ChoGGi.AdjustWalls.Longer",
	OnAction = function(self)
		local ctrl = GetConstructionController()
		if ctrl then
			ChoGGi_BaseWalls.AdjustLength(ctrl.cursor_obj, 2, spawn_wall_count)
		end
	end,
	ActionShortcut = "Shift-E",
	ActionGamepad = "DPadLeft",
	ActionBindable = true,
	ActionMode = "AdjustAdjustWallsLength",
	ActionMouseBindable = false,
}

c = c + 1
Actions[c] = {ActionName = T(302535920011046, "BaseWalls") .. ": " .. T(302535920011045, "Adjust Shorter"),
	ActionId = "ChoGGi.AdjustWalls.Shorter",
	OnAction = function(self)
		local ctrl = GetConstructionController()
		if ctrl then
			ChoGGi_BaseWalls.AdjustLength(ctrl.cursor_obj, -2, spawn_wall_count)
		end
	end,
	ActionShortcut = "Shift-Q",
	ActionGamepad = "DPadRight",
	ActionBindable = true,
	ActionMode = "AdjustAdjustWallsLength",
	ActionMouseBindable = false,
}

-- since we change the mode these don't work
c = c + 1
Actions[c] = {ActionName = T(302535920011046, "BaseWalls") .. ": " .. Translate(312752058553, "Rotate Building Left"),
	ActionId = "ChoGGi.AdjustWalls.actionRotBuildingLeft",
	ActionShortcut = "R",
	ActionShortcut2 = "Shift-R",
	ActionGamepad = "LeftShoulder",
	ActionBindable = true,
	ActionMode = "AdjustAdjustWallsLength",
	ActionMouseBindable = false,
	OnAction = function()
		local obj = GetConstructionController()
		if obj then
			obj:Rotate(-1)
		end
	end,
}

c = c + 1
Actions[c] = {ActionName = "BaseWalls: " .. Translate(694856081085, "Rotate Building Right"),
	ActionId = "ChoGGi.AdjustWalls.actionRotBuildingRight",
	ActionShortcut = "T",
	ActionShortcut2 = "Shift-T",
	ActionGamepad = "RightShoulder",
	ActionBindable = true,
	ActionMode = "AdjustAdjustWallsLength",
	ActionMouseBindable = false,
	OnAction = function()
		local obj = GetConstructionController()
		if obj then
			obj:Rotate(1)
		end
	end,
}

local shortcuts_mode
local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding:GameInit(...)
	local id = self.template and self.template.template_name
	-- skip not ours
	if not (wall_types[id] or corner_types[id]) then
		return orig_CursorBuilding_GameInit(self, ...)
	end

	local bs = ChoGGi_BaseWall
	self.ChoGGi_bs = bs

	-- set this so spawn funcs use it as parent
	cursor_building = self

	-- use keys to adjust length
	if id == "ChoGGi_BaseWall" then
		shortcuts_mode = XShortcutsTarget and XShortcutsTarget:GetActionsMode()
		XShortcutsSetMode("AdjustAdjustWallsLength")
	end

--~ 	local dlg = ChoGGi.ComFuncs.OpenInExamineDlg(self)
--~ 	dlg:EnableAutoRefresh()
--~ 	CreateRealTimeThread(function()
--~ 		Sleep(1000)
--~ 	local dlg = ChoGGi.ComFuncs.OpenInExamineDlg(self.template)
--~ 	dlg:EnableAutoRefresh()
--~ 	end)

	-- always spawn whatever
	if self.template.build_category == "ChoGGi_BaseWalls" then
		self:SetScale(bs.building_scale)
		bs:SpawnWallAttaches(self)
	else
		bs:SpawnCornerAttaches(self)
	end

	return orig_CursorBuilding_GameInit(self, ...)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding:Done(...)
	cursor_building = false
	if shortcuts_mode then
		XShortcutsSetMode(shortcuts_mode)
		shortcuts_mode = false
	end
--~ 	self.ChoGGi_bs_mode = nil
	return orig_CursorBuilding_Done(self, ...)
end

-- skip the Missing spot 'Top' in 'ConstructionSite' state 'idle' msg
local orig_AttachToObject = AttachToObject
function AttachToObject(to, childclass, spot_type, ...)
	return orig_AttachToObject(
		to, childclass, to:HasSpot(spot_type) and spot_type, ...
	)
end
local orig_AttachPartToObject = AttachPartToObject
function AttachPartToObject(to, part, spot_type, ...)
	return orig_AttachPartToObject(
		to, part, to:HasSpot(spot_type) and spot_type, ...
	)
end
