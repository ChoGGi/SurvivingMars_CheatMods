-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
local fire_once
function OnMsg.ModsReloaded()
	if fire_once then
		return
	end
	fire_once = true
	local min_version = 24

	local ModsLoaded = ModsLoaded
	-- we need a version check to remind Nexus/GoG users
	local not_found_or_wrong_version
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	if idx then
		-- steam updates automatically
		if not Platform.steam and min_version > ModsLoaded[idx].version then
			not_found_or_wrong_version = true
		end
	else
		not_found_or_wrong_version = true
	end

	if not_found_or_wrong_version then
		CreateRealTimeThread(function()
			WaitMsg("InGameInterfaceCreated")
			if WaitMarsQuestion(nil,nil,string.format([[Error: RC Bulldozer requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

-- local funcs
local ToggleCollisions

local StringFormat = string.format
local TableConcat = rawget(_G, "oldTableConcat") or table.concat
local GetHeight = terrain.GetHeight
local SetHeightCircle = terrain.SetHeightCircle
local SetTypeCircle = terrain.SetTypeCircle
local Sleep = Sleep
local DeleteThread = DeleteThread
local IsValidThread = IsValidThread
local CreateRealTimeThread = CreateRealTimeThread
local RecalcBuildableGrid = RecalcBuildableGrid
local MovePointAway = MovePointAway
local FlattenTerrainInBuildShape = FlattenTerrainInBuildShape
local MapDelete = MapDelete

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()
	ToggleCollisions = ChoGGi.ComFuncs.ToggleCollisions
end

local name = [[RC Bulldozer]]
local description = [[Crush, Kill, Destroy]] -- Sarcófago not lost in space...
local display_icon = StringFormat("%sUI/rover_combat.png",CurrentModPath)
local function Trans(...)
	return _InternalTranslate(T{...})
end

local idle_text = StringFormat([[Radius: %s, %s: %s]],"%s",Trans(49--[[Status--]]),Trans(949--[[Idle--]]))
local travel_text = StringFormat([[Radius: %s, %s: %s]],"%s",Trans(49--[[Status--]]),Trans(63--[[Travelling--]]))
local flatten_text = StringFormat([[Radius: %s, %s: %s]],"%s",Trans(49--[[Status--]]),Trans(76--[[Performing maintenance--]]))

DefineClass.RCBulldozer = {
	__parents = {
		"BaseRover",
		"ComponentAttach",
	},
  name = name,
	description = description,
	display_icon = display_icon,
	display_name = name,

	entity = "CombatRover",
	accumulate_dust = false,
	status_text = idle_text:format(1000 * guic),
	-- flatten area
	radius = 1000 * guic,
	-- refund res
	on_demolish_resource_refund = { Metals = 20 * const.ResourceScale, MachineParts = 20 * const.ResourceScale , Electronics = 10 * const.ResourceScale },
	-- stores the flatten thread
	are_we_flattening = false,
	-- ground texture after dozing
	terrain_type_idx = table.find(TerrainTextures, "name", "Dig"),
	-- store ref to circle obj
	visual_circle = false,
	-- show a circle where we doze
	visual_circle_toggle = true,
	-- store radius here, so we're not updating it all the time
	visual_circle_size = false,
--~ 	-- likely useless...
--~ 	orient_mode = "terrain",
	-- change texture when dozing
	texture_terrain = true,
--~ 	-- need something to update driveable area
--~ 	shape_obj = false,
}

DefineClass.RCBulldozerBuilding = {
	__parents = {"BaseRoverBuilding"},
	rover_class = "RCBulldozer",
}

function RCBulldozer:GameInit()

	-- colour #, Color, Roughness, Metallic
	-- middle area
	self:SetColorizationMaterial(1, -15005149, -128, 120)
	-- body
	self:SetColorizationMaterial(2, -11845311, 120, 20)
	-- color of bands
	self:SetColorizationMaterial(3, -16244680, -128, 48)

	-- show the pin info
	self.pin_rollover = T{0,"<StatusUpdate>"}

--~ 	-- have to wait for HexOutlineShapes to be built, this one is about as big as the largest we can make the hex
--~ 	self.shape_obj = HexOutlineShapes.DomeMega
end

function RCBulldozer:GetStatusUpdate()
	return TableConcat({self.status_text}, "<newline><left>")
end

function RCBulldozer:ReturnDozPos()
	return MovePointAway(
		self:GetVisualPos(),
		self:GetSpotLoc(self:GetSpotBeginIndex("Droneentrance")),
		self.radius + 500
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
			self.visual_circle:SetRadius(self.radius / guic)
		end
		-- always update pos of circle
		self.visual_circle:SetPos(self:ReturnDozPos())
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

function RCBulldozer:UpdateBuildable()
	if self.bulldozing and IsValidThread(self.are_we_flattening) then
		DeleteThread(self.are_we_flattening)
		-- we set it to self just in case there's another another thread running
		self.are_we_flattening = false
		-- disable collisions on pipes beforehand, so they don't get marked as uneven terrain
		ToggleCollisions()
		-- update uneven terrain checker thingy
		RecalcBuildableGrid()
		-- and back on when we're done
		ToggleCollisions()
	end
end

local guic = guic
local efRemoveUnderConstruction = const.efRemoveUnderConstruction
function RCBulldozer:GotoFromUser(...)
	if self.bulldozing then
		self.status_text = flatten_text:format(self.radius)

		-- kill off old thread if it's running
		if IsValidThread(self.are_we_flattening) then
			DeleteThread(self.are_we_flattening)
		end

		-- store this thread so we can stop it
		self.are_we_flattening = CreateRealTimeThread(function()
			-- thread gets deleted, but just in case
			while self.are_we_flattening do
				if self.command == "Idle" then
					Sleep(250)
				else
					if self.visual_circle_toggle and self.visual_circle_size ~= self.radius then
						self.visual_circle_size = self.radius
						self.visual_circle:SetRadius(self.radius / guic)
					end
					-- stick it in front of dozer
					local pos = self:ReturnDozPos()
					if self.visual_circle_toggle then
						self.visual_circle:SetPos(pos)
					end
					-- flatten func
					SetHeightCircle(pos, self.radius, self.radius, GetHeight(self:GetVisualPos()))
					-- remove any rocks in the way
					MapDelete(pos, self.radius, efRemoveUnderConstruction)
					-- update driveable?
--~ 					FlattenTerrainInBuildShape(self.shape_obj, self)
					-- change ground texture?
					if self.texture_terrain then
						SetTypeCircle(pos, self.radius, self.terrain_type_idx)
					end
					Sleep(25)
				end
			end
		end)

	else
		self.status_text = travel_text:format(self.radius)
	end
	return BaseRover.GotoFromUser(self,...)
end

function RCBulldozer:Idle()
	-- run the buildable ground script
	self:UpdateBuildable()
	-- selection pane info
	self.status_text = idle_text:format(self.radius)

	self:SetStateText("idle")
	self:Gossip("Idle")

	Sleep(1000)
	Halt()
end

function OnMsg.ClassesPostprocess()

  PlaceObj("BuildingTemplate",{
    "Id","RCBulldozerBuilding",
    "template_class","RCBulldozerBuilding",
    -- pricey?
    "construction_cost_Metals",40000,
    "construction_cost_MachineParts",40000,
    "construction_cost_Electronics",20000,

    "dome_forbidden",true,
    "display_name",name,
    "display_name_pl",name,
    "description",description,
    "build_category","Infrastructure",
    "Group", "Infrastructure",
    "display_icon", display_icon,
    "encyclopedia_exclude",true,
    "on_off_button",false,
    "entity","CombatRover",
    "palettes","AttackRoverBlue"
  })

end

function OnMsg.ClassesBuilt()
	local S = ChoGGi.Strings

	-- add some prod info to selection panel
	local rover = XTemplates.ipRover[1]
	-- check for and remove existing templates
	local idx = table.find(rover, "ChoGGi_Template_RCBulldozer_Status", true)
	if idx then
		rover[idx]:delete()
		table.remove(rover,idx)
	end
	idx = table.find(rover, "ChoGGi_Template_RCBulldozer_Dozer", true)
	if idx then
		rover[idx]:delete()
		table.remove(rover,idx)
	end
	idx = table.find(rover, "ChoGGi_Template_RCBulldozer_Texture", true)
	if idx then
		rover[idx]:delete()
		table.remove(rover,idx)
	end
	idx = table.find(rover, "ChoGGi_Template_RCBulldozer_Circle", true)
	if idx then
		rover[idx]:delete()
		table.remove(rover,idx)
	end

	-- we want to insert below status
	local status = table.find(rover, "Icon", "UI/Icons/Sections/sensor.tga")
	if status then
		status = status
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
			"Title", T{49, "Status"},
			"Icon", "UI/Icons/Sections/facility.tga",
		}, {
			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelText",
				"Text", T{0,"<StatusUpdate>"},
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
				end
			}),
		})
	)

	-- Texture toggle
	table.insert(
		rover,
		status+1,
		PlaceObj("XTemplateTemplate", {
			"ChoGGi_Template_RCBulldozer_Texture", true,
			"__context_of_kind", "RCBulldozer",
			"__template", "InfopanelSection",
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
					context.texture_terrain = not context.texture_terrain
					ObjModified(context)
					---
				end
			})
		})
	)

	-- see circle toggle
	table.insert(
		rover,
		status+1,
		PlaceObj("XTemplateTemplate", {
			"ChoGGi_Template_RCBulldozer_Circle", true,
			"__context_of_kind", "RCBulldozer",
			"__template", "InfopanelSection",
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
				local context = self.context
				if context.bulldozing then
					if context.command ~= "Idle" then
						context:UpdateBuildable()
					end
					context.bulldozing = false
					if IsValidThread(context.are_we_flattening) then
						DeleteThread(context.are_we_flattening)
					end
					if context.visual_circle then
						context.visual_circle:SetVisible(false)
					end
				else
					context.bulldozing = true
					-- easy way to make sure dozing is activated
					context:SetCommand("Idle")
					-- add a circle for radius vis
					context:UpdateCircle()
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
