-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
local fire_once
function OnMsg.ModsReloaded()
	if fire_once then
		return
	end
	fire_once = true

	-- version to version check with
	local min_version = 37
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	-- if we can't find mod or mod is less then min_version (we skip steam since it updates automatically)
	if not idx or idx and not Platform.steam and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[RC Bulldozer requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

-- local funcs for that small bit o' speed
local StringFormat = string.format
local TableConcat = rawget(_G, "oldTableConcat") or table.concat
local type = type

local GetHeight = terrain.GetHeight
local SetHeightCircle = terrain.SetHeightCircle
local SetTypeCircle = terrain.SetTypeCircle
local Sleep = Sleep
local DeleteThread = DeleteThread
local IsValidThread = IsValidThread
local CreateRealTimeThread = CreateRealTimeThread
local IsValid = IsValid
local RecalcBuildableGrid = RecalcBuildableGrid
local MovePointAway = MovePointAway
local MapDelete = MapDelete
local engineSuspendPassEdits = engineSuspendPassEdits
local engineResumePassEdits = engineResumePassEdits
local PlaceObject = PlaceObject

local ToggleCollisions
local MovePointAwayXY
-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()
	ToggleCollisions = ChoGGi.ComFuncs.ToggleCollisions
	MovePointAwayXY = ChoGGi.ComFuncs.MovePointAwayXY
end

local name = [[RC Bulldozer]]
local description = [[Crush, Kill, Destroy]] -- Sarcófago not lost in space...
local display_icon = StringFormat("%sUI/rover_combat.png",CurrentModPath)

local entity1 = "CombatRover"
local entity2 = "CombatRover"
local away_spot = "Particle1"
local colour1 = -15005149
local colour2 = -5000269
local colour3 = -16244680
local colour4
local fx_actor_class = "AttackRover"

if BuildingTemplates.RCHarvesterBuilding then
	entity1 = "RoverBlueSunHarvester"
	entity2 = "RoverBlueSunHarvesterBuilding"
	away_spot = "Particle"
--~ 	colour1 = -15005149
	colour2 = -3421237
--~ 	colour3 = -16244680
	colour4 = -9408400
	fx_actor_class = "RCHarvester"
end

local function Trans(...)
	return _InternalTranslate(T(...))
end

local idle_text = StringFormat([[Radius: %s, %s: %s]],"%s",Trans(49--[[Status--]]),Trans(949--[[Idle--]]))
local travel_text = StringFormat([[Radius: %s, %s: %s]],"%s",Trans(49--[[Status--]]),Trans(63--[[Travelling--]]))
local flatten_text = StringFormat([[Radius: %s, %s: %s]],"%s",Trans(49--[[Status--]]),Trans(76--[[Performing maintenance--]]))

DefineClass.RCBulldozer = {
	__parents = {
		"BaseRover",
--~ 		"ComponentAttach",
	},
  name = name,
	description = description,
	display_icon = display_icon,
	display_name = name,
	fx_actor_class = fx_actor_class,

	entity = entity1,
	accumulate_dust = false,
	status_text = idle_text:format(1000),
	-- flatten area
	radius = 1000,
	-- refund res
	on_demolish_resource_refund = { Metals = 20 * const.ResourceScale, MachineParts = 20 * const.ResourceScale , Electronics = 10 * const.ResourceScale },
	-- stores the flatten thread
	flatten_thread = false,
	-- store ref to circle obj
	visual_circle = false,
	-- show a circle where we doze
	visual_circle_toggle = true,
	-- store radius here, so we're not updating it all the time
	visual_circle_size = false,
	-- show the pin info
	pin_rollover = T(0,"<StatusUpdate>"),
	-- change texture when dozing
	texture_terrain = table.find(TerrainTextures, "name", "Dig"),
	-- used to place the circle
	away_spot = false,

--~ 	-- likely useless...
--~ 	orient_mode = "terrain",
--~ 	-- need something to update driveable area
--~ 	shape_obj = false,
}

DefineClass.RCBulldozerBuilding = {
	__parents = {"BaseRoverBuilding"},
	rover_class = "RCBulldozer",
}

function RCBulldozer:GameInit()
	BaseRover.GameInit(self)

	self.away_spot = self:GetSpotBeginIndex(away_spot)
	-- colour #, Color, Roughness, Metallic
	-- middle area
	self:SetColorizationMaterial(1, colour1, -128, 120)
	-- body
	self:SetColorizationMaterial(2, colour2, 120, 20)
	-- color of bands
	self:SetColorizationMaterial(3, colour3, -128, 48)
	if colour4 then
		self:SetColorizationMaterial(4, colour3, -128, 48)
	end

--~ 	-- have to wait for HexOutlineShapes to be built, this one is about as big as the largest we can make the hex
--~ 	self.shape_obj = HexOutlineShapes.DomeMega
end

function RCBulldozer:GetStatusUpdate()
	return TableConcat({self.status_text}, "<newline><left>")
end

function RCBulldozer:ReturnDozeArea()
	return MovePointAwayXY(
		self:GetVisualPos(),
		self:GetSpotLoc(self.away_spot),
		-(self.radius + 1000)
	)
end

function RCBulldozer:UpdateCircle()
	if self.visual_circle_toggle then
		if not self.visual_circle then
			self.visual_circle = Circle:new()
			self.visual_circle:SetColor(white)
		end
		-- only update radius if radius is changed
		if self.visual_circle_size ~= self.radius then
			self.visual_circle_size = self.radius
			self.visual_circle:SetRadius(self.radius)
		end
		-- always update pos of circle
		self.visual_circle:SetPos(self:ReturnDozeArea())
	end

	-- it should be created by now, but just in case
	if self.visual_circle then
		if self.bulldozing and self.visual_circle_toggle then
			self.visual_circle:SetVisible(true)
		else
			self.visual_circle:SetVisible(false)
		end
	end
end

-- RecalcBuildableGrid is an expensive cmd so we don't want to fire often
function RCBulldozer:UpdateBuildable()
	-- disable collisions on pipes beforehand, so they don't get marked as uneven terrain
	ToggleCollisions()
	-- update uneven terrain checker thingy
	RecalcBuildableGrid()
	-- and back on when we're done
	ToggleCollisions()
end

local efRemoveUnderConstruction = const.efRemoveUnderConstruction
function RCBulldozer:GotoFromUser(...)
	if self.bulldozing then
		self.status_text = flatten_text:format(self.radius)
	else
		self.status_text = travel_text:format(self.radius)
	end
	return BaseRover.GotoFromUser(self,...)
end

function RCBulldozer:StopDozer()
	-- kill off old thread if it's running
	DeleteThread(self.flatten_thread)
	-- visual cue for anyone in examine
	self.flatten_thread = false
	-- boolean toggle
	self.bulldozing = false
	-- back to normal colour
	self:SetColorizationMaterial(2, colour2, 120, 20)
	-- hide circle if visible
	self:UpdateCircle()

	if entity1 == "RoverBlueSunHarvester" then
		PlayFX("Harvest", "end", self)
		self:SetMoveAnim("moveWalk")
	end

	if IsValid(self.site) then
		self.site:delete()
		self.site = false
	end

	-- update buildable ground (expensive call)
	self:UpdateBuildable()
end

-- we're using a realtime loop, so we use this to pause the flatten thread
local game_paused
if UISpeedState == "pause" then
	game_paused = true
else
	game_paused = false
end
function OnMsg.MarsPause()
	game_paused = true
end

local efCollision = const.efCollision + const.efApplyToGrids
local efSelectable = const.efSelectable
-- a very ugly hack to update driveable area
function RCBulldozer:AddDriveable()
	self.site = PlaceObject("ConstructionSite", {})
	self.site:SetBuildingClass("DomeBasic")
	self.site:SetVisible()
	-- so dozer doesn't get scared of itself
	self.site:ClearHierarchyEnumFlags(efCollision + efSelectable)
	self.site:InvalidateSurfaces()

	self:Attach(self.site)
	-- we don't want drones to bother with this site
	CreateRealTimeThread(function()
		Sleep(100)
		self.site:DisconnectFromCommandCenters()
		self.site.auto_connect = false
		self.site.resource_stockpile:delete()
		self.site.resource_stockpile = nil
	end)
end

function RCBulldozer:StartDozer()
	self.bulldozing = true
	-- make it noticeable so people (hopefully) remember to turn it off
	self:SetColorizationMaterial(2, -15464440, 120, 20)
	-- add a circle for radius vis
	self:UpdateCircle()
	-- sigh
	if not IsValid(self.site) then
		self:AddDriveable()
	end
	-- set work anim
	if entity1 == "RoverBlueSunHarvester" then
		PlayFX("Harvest", "start", self)
		self:SetMoveAnim("workIdle")
	end

	-- it shouldn't already be running, but fuck it
	if not IsValidThread(self.flatten_thread) then
		-- store this thread so we can stop it
		self.flatten_thread = CreateRealTimeThread(function()
			-- thread gets deleted, but just in case
			while self.bulldozing do
				-- no sense in doing anything when the game is paused
				if game_paused then
					WaitMsg("MarsResume")
					game_paused = false
				end

				-- if we're idle then we're not moving
				if self.command == "Idle" then
					while self.command == "Idle" do
						Sleep(100)
					end
				else
					-- we want to doze in front of the dozer
					local pos = self:ReturnDozeArea()

					if self.visual_circle_toggle then
						-- only call SetRadius if it's different
						if self.visual_circle_size ~= self.radius then
							self.visual_circle_size = self.radius
							self.visual_circle:SetRadius(self.radius)
						end
						self.visual_circle:SetPos(pos)
					end

					-- flatten func
					SetHeightCircle(pos, self.radius, self.radius, GetHeight(self:GetVisualPos()))
					-- speed and needed for my ugly hack
					engineSuspendPassEdits()
					-- remove any pebbles in the way
					MapDelete(pos, self.radius, efRemoveUnderConstruction)
					-- add some dust
--~ 					PlayFX("Dust", "start", self)
--~ PlayFX(actionFXClass, actionFXMoment, actor, target, action_pos, action_dir)
--~ PlayFX("MeteorDomeExplosion", "start", obj, nil, p2, p2 - p1)
--~ PlayFX("MeteorHitDome", "start", dome, obj, hit, normal)
					-- part of a very ugly hack to update driveable area
					if not IsValid(self.site) then
						self:AddDriveable()
					end
					self.site:SetEnumFlags(efCollision)
					self.site:ClearHierarchyEnumFlags(efCollision)
					-- are we changing ground texture
					if type(self.texture_terrain) == "number" then
						SetTypeCircle(pos, self.radius, self.texture_terrain)
					end
					engineResumePassEdits()
					-- rest your weary soul
					Sleep(25)
				end
			end
		end)
		self.site:ClearHierarchyEnumFlags(efCollision)
	end
end

function RCBulldozer:Idle()
	-- selection pane info
	self.status_text = idle_text:format(self.radius)

	self:Gossip("Idle")
	self:SetState("idle")

--~ 	Halt()
	DeleteThread(self.command_thread,true)
	self.command_thread = false
end

function OnMsg.SaveGame()
	-- kill off the threads (spews c func persist errors in log)
	local dozers = UICity.labels.RCBulldozer or ""
	for i = 1, #dozers do
		if dozers[i].bulldozing then
			dozers[i]:StopDozer()
		end
		if dozers[i].command ~= "Idle" then
			dozers[i]:Idle()
		end
	end
end

function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.RCBulldozerBuilding then
		PlaceObj("BuildingTemplate",{
			"Id","RCBulldozerBuilding",
			"template_class","RCBulldozerBuilding",
			-- pricey?
			"construction_cost_Metals",40000,
			"construction_cost_MachineParts",40000,
			"construction_cost_Electronics",20000,
			-- add a bit of pallor to the skeleton
			"palette_color1", "rover_base",

			"dome_forbidden",true,
			"display_name",name,
			"display_name_pl",name,
			"description",description,
			"build_category","ChoGGi",
			"Group", "ChoGGi",
			"display_icon", display_icon,
			"encyclopedia_exclude",true,
			"on_off_button",false,
			"count_as_building",false,
			"prio_button",false,

			"entity",entity2,
		})
	end
end

-- build list of textures for popup menu below
local texture_list
function OnMsg.InGameInterfaceCreated()
	local smallest = point(1,1)
	texture_list = {}
	local TerrainTextures = TerrainTextures
	local image = "<image %s>"

	for i = 0, #TerrainTextures do
		local hint
		if TerrainTextures[i].name == "Dig" then
			hint = string.format("Texture from original version\n%s",image:format(TerrainTextures[i].texture))
		else
			hint = image:format(TerrainTextures[i].texture)
		end
		texture_list[i] = {
			name = TerrainTextures[i].name,
			hint = hint,
			-- this is just so the image loads (otherwise the tooltip image will be borked)
			image = TerrainTextures[i].texture,
			-- which is why I make it invisible
			image_scale = smallest,
			clicked = function()
				local info = Dialogs.Infopanel
				if info then
					local dozer = info.context
					dozer.texture_terrain = i
					ObjModified(dozer)
				end
			end,
		}
	end
	-- sort by name
	table.sort(texture_list,function(a,b)
			return CmpLower(a.name,b.name)
	end)
	-- and add the no change one
	table.insert(texture_list,1,{
		name = [[No Change]],
		hint = [[Don't change ground texture when dozing.]],
		clicked = function()
			local info = Dialogs.Infopanel
			if info then
				local dozer = info.context
				dozer.texture_terrain = false
				ObjModified(dozer)
			end
		end,
	})
end

function OnMsg.ClassesBuilt()
	local S = ChoGGi.Strings
	local PopupToggle = ChoGGi.ComFuncs.PopupToggle

	-- add some prod info to selection panel
	local rover = XTemplates.ipRover[1]
	-- check for and remove existing templates
	ChoGGi.ComFuncs.RemoveXTemplateSections(rover,"ChoGGi_Template_RCBulldozer_Status")
	ChoGGi.ComFuncs.RemoveXTemplateSections(rover,"ChoGGi_Template_RCBulldozer_Dozer")
	ChoGGi.ComFuncs.RemoveXTemplateSections(rover,"ChoGGi_Template_RCBulldozer_Texture")
	ChoGGi.ComFuncs.RemoveXTemplateSections(rover,"ChoGGi_Template_RCBulldozer_Circle")

	-- replace status
	local status = table.find(rover, "Icon", "UI/Icons/Sections/sensor.tga")
	if status then
		rover[status]:delete()
		table.remove(rover,status)
	else
		-- fuck it stick it at the end
		status = #rover
	end

	-- status updates/radius slider
	table.insert(
		rover,
		status,
		PlaceObj('XTemplateTemplate', {
			"ChoGGi_Template_RCBulldozer_Status", true,
			"__context_of_kind", "RCBulldozer",
			"__template", "InfopanelSection",
			"Title", T(49, "Status"),
			"Icon", "UI/Icons/Sections/facility.tga",
		}, {
			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelText",
				"Text", T(0,"<StatusUpdate>"),
			}),
			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelSlider",
				"BindTo", "radius",
				-- about the size of mega dome
				"Max", 11000,
				"Min", 500,
				"StepSize", 500,
				"OnContextUpdate", function(self, context)
					-- make the slider scroll to current amount
					self.Scroll = context.radius
					-- add radius to status text
					if context.command == "Idle" then
						context.status_text = idle_text:format(context.radius)
					else
						if context.bulldozing then
							context.status_text = flatten_text:format(context.radius)
						else
							context.status_text = travel_text:format(context.radius)
						end
					end
					-- update vis
					context:UpdateCircle()
				end,
			}),
		})
	)

	-- texture toggle
	table.insert(
		rover,
		status+1,
		PlaceObj("XTemplateTemplate", {
			"ChoGGi_Template_RCBulldozer_Texture", true,
			"__context_of_kind", "RCBulldozer",
			"__template", "InfopanelActiveSection",
			"RolloverTitle", [[Ground Texture]],
			"OnContextUpdate", function(self, context)
				-- context is the object selected
				if context.texture_terrain then
					self:SetRolloverText([[Change texture of dozed ground.]])
					self:SetTitle([[Texture]])
					self:SetIcon("UI/Icons/Upgrades/hygroscopic_coating_04.tga")
				else
					self:SetRolloverText([[Keep same ground texture.]])
					self:SetTitle([[Texture Skip]])
					self:SetIcon("UI/Icons/Upgrades/hygroscopic_coating_01.tga")
				end
				---
			end,
		}, {
			PlaceObj("XTemplateFunc", {
				"name", "OnActivate(self, context)",
				"parent", function(self)
					return self.parent
				end,
				"func", function(self, context)
					---
--~ 					ex(texture_list)
					PopupToggle(self,"idBullDozerMenuPopup",texture_list,"left")
					---
				end
			})
		})
	)

	-- circle toggle
	table.insert(
		rover,
		status+1,
		PlaceObj("XTemplateTemplate", {
			"ChoGGi_Template_RCBulldozer_Circle", true,
			"__context_of_kind", "RCBulldozer",
			"__template", "InfopanelActiveSection",
			"RolloverTitle", [[Visual Circle]],
			"OnContextUpdate", function(self, context)
				-- context is the object selected
				if context.visual_circle_toggle then
					self:SetRolloverText([[Shows white circle while dozing.]])
					self:SetTitle([[Circle]])
					self:SetIcon("UI/Icons/Upgrades/holographic_scanner_04.tga")
				else
					self:SetRolloverText([[Hide circle while dozing.]])
					self:SetTitle([[Circle Skip]])
					self:SetIcon("UI/Icons/Upgrades/holographic_scanner_01.tga")
				end
				---
			end,
		}, {
			PlaceObj("XTemplateFunc", {
				"name", "OnActivate(self, context)",
				"parent", function(self)
					return self.parent
				end,
				"func", function(_, context)
					---
					context.visual_circle_toggle = not context.visual_circle_toggle
					context:UpdateCircle()
					ObjModified(context)
					---
				end
			})
		})
	)

	-- toggle button
	table.insert(
		rover,
		-- after the salvage button
		table.find(rover, "Icon", "UI/Icons/IPButtons/salvage_1.tga") + 1,
		PlaceObj("XTemplateTemplate", {
			"ChoGGi_Template_RCBulldozer_Dozer", true,
			"__context_of_kind", "RCBulldozer",
			"__template", "InfopanelButton",
			"OnPress", function(self)
				---
				self = self.context
				if self.bulldozing then
					self:StopDozer()
				else
					self:StartDozer()
				end
				---
			end,

			"RolloverTitle", [[Dozer Toggle]],
			"OnContextUpdate", function(self, context)
				---
				if context.bulldozing then
					self:SetRolloverText([[Flatten ground in front of bulldozer.]])
					self:SetIcon("UI/Icons/Sections/Concrete_4.tga")
				else
					self:SetRolloverText([[Move without flattening ground.]])
					self:SetIcon("UI/Icons/Sections/accept_colonists_on.tga")
				end
				---
			end,
		})
	)

end
