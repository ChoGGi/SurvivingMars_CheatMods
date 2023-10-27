-- See LICENSE for terms

-- Entity Size button shows gamepad/mouse clicks

local testing = ChoGGi.testing
local what_game = ChoGGi.what_game

local T = T
local AveragePoint2D = AveragePoint2D
local RetName = ChoGGi.ComFuncs.RetName
local PolylineSetParabola = ChoGGi.ComFuncs.PolylineSetParabola
local Translate = ChoGGi.ComFuncs.Translate

-- blank CObject (could use Object, but has more parents) class we add to all the objects below for easier deleting
DefineClass.ChoGGi_ODeleteObjs = {
	__parents = {"CObject"},
}

-- simplest entity object possible for hexgrids (it went from being laggy with 100 to usable, though that includes some use of local, so who knows)
DefineClass.ChoGGi_OHexSpot = {
	__parents = {"ChoGGi_ODeleteObjs"},
	entity = "GridTile",
}

-- re-define objects for ease of deleting later on
DefineClass.ChoGGi_OVector = {
	__parents = {"ChoGGi_ODeleteObjs","Vector"},
}
DefineClass.ChoGGi_OSphere = {
	__parents = {"ChoGGi_ODeleteObjs","Sphere"},
}
DefineClass.ChoGGi_OPolyline = {
	__parents = {"ChoGGi_ODeleteObjs","Polyline"},
}
function ChoGGi_OPolyline:SetParabola(a, b)
	PolylineSetParabola(self, a, b)
	self:SetPos(AveragePoint2D(self.vertices))
end
local line_points = {}
function ChoGGi_OPolyline:SetLine(a, b)
	line_points[1] = a
	line_points[2] = b
--~ 	self.vertices = line_points
	self.max_vertices = #line_points
	self:SetMesh(line_points)
	self:SetPos(AveragePoint2D(line_points))
end

--~ SetZOffsetInterpolation, SetOpacityInterpolation
DefineClass.ChoGGi_OText = {
	__parents = {"ChoGGi_ODeleteObjs","Text"},
	text_style = "Action",
}
DefineClass.ChoGGi_OOrientation = {
	__parents = {"ChoGGi_ODeleteObjs","Orientation"},
}
DefineClass.ChoGGi_OCircle = {
	__parents = {"ChoGGi_ODeleteObjs","Circle"},
}

DefineClass.ChoGGi_OBuildingEntityClass_Generic = {
	__parents = {
		"Demolishable",
		"BaseBuilding",
		"BuildingEntityClass",
		-- so we can have a selection panel for spawned entity objects
		"InfopanelObj",
	},
	-- defined in ECM OnMsgs
	ip_template = "ipChoGGi_Entity",
}
-- add some info/functionality to spawned entity objects
ChoGGi_OBuildingEntityClass_Generic.GetDisplayName = CObject.GetEntity
function ChoGGi_OBuildingEntityClass_Generic.GetIPDescription()
	return T(302535920001110--[[Spawned entity object]])
end
if what_game == "Mars" then
	-- circle or hex thingy?
	ChoGGi_OBuildingEntityClass_Generic.OnSelected = AddSelectionParticlesToObj
end
-- prevent an error msg in log
ChoGGi_OBuildingEntityClass_Generic.BuildWaypointChains = empty_func
-- round and round she goes, and where she stops BOB knows
ChoGGi_OBuildingEntityClass_Generic.Rotate = ChoGGi.ComFuncs.RotateBuilding

local attach_parents = {
	"ChoGGi_OBuildingEntityClass_Generic",
}
if not testing then
	attach_parents[#attach_parents+1] = "ChoGGi_ODeleteObjs"
end
DefineClass.ChoGGi_OBuildingEntityClass = {
	__parents = {
		"ChoGGi_OBuildingEntityClass_Generic",
	},
}
DefineClass.ChoGGi_OBuildingEntityClass_Perm = {
	__parents = {
		"ChoGGi_OBuildingEntityClass_Generic",
	},
}

-- add any auto-attach items
attach_parents = {
	"ChoGGi_OBuildingEntityClass_Generic",
	"AutoAttachObject",
}
if not testing then
	attach_parents[#attach_parents+1] = "ChoGGi_ODeleteObjs"
end
DefineClass.ChoGGi_OBuildingEntityClassAttach = {
	__parents = attach_parents,
	auto_attach_at_init = true,
}

ChoGGi_OBuildingEntityClassAttach.GameInit = AutoAttachObject.Init

function OnMsg.ClassesPostprocess()
	-- added to stuff spawned with object spawner
	if XTemplates.ipChoGGi_Entity then
		XTemplates.ipChoGGi_Entity:delete()
	end

	PlaceObj("XTemplate", {
		group = "Infopanel Sections",
		id = "ipChoGGi_Entity",
		PlaceObj("XTemplateTemplate", {
			"__context_of_kind", "ChoGGi_OBuildingEntityClass_Generic",
			"__template", "Infopanel",
		}, {

			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelButton",
				"RolloverTitle", T(302535920000682--[[Change Entity]]),
				"RolloverHint", T(608042494285--[[<left_click> Activate]]),
				"ContextUpdateOnOpen", true,
				"OnContextUpdate", function(self)
					self:SetRolloverText(T{302535920001151--[[Set Entity For <entity>]],
						entity = RetName(self.context),
					})
				end,
				"OnPress", function(self)
					ChoGGi.ComFuncs.EntitySpawner(self.context, {
						skip_msg = true,
						list_type = 7,
						planning = self.context.planning and true,
						title_postfix = RetName(self.context),
					})
				end,
				"Icon", "UI/Icons/IPButtons/shuttle.tga",
			}),

			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelButton",
				"Icon", "UI/Icons/IPButtons/automated_mode_on.tga",
				"RolloverTitle", T(1000077--[[Rotate]]),
				"RolloverText", T("<left_click>") .. " "
					.. T(312752058553--[[Rotate Building Left]]).. "\n"
					.. T("<right_click>") .. " "
					.. T(694856081085--[[Rotate Building Right]]),
				"RolloverHint", "",
				"RolloverHintGamepad", T(7518--[[ButtonA]]) .. " "
					.. T(312752058553--[[Rotate Building Left]]) .. " "
					.. T(7618--[[ButtonX]]) .. " " .. T(694856081085--[[Rotate Building Right]]),
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

			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelButton",
				"RolloverTitle", T(302535920001677--[[Entity Size]]),
				"RolloverHint", T(608042494285--[[<left_click> Activate]]),
				"RolloverText", T(302535920001678--[[Change size of Entity.
Starts at 100% and goes up by 5 (max is 2047), <right_click> to reset to 5% (hold ctrl to go up by 25/50).]]),
				"OnPress", function (self, gamepad)
					local context = self.context
					local but_state = not gamepad and IsMassUIModifierPressed()
					local scale = context:GetScale() or 5
					if but_state then
						-- ctrl + left click
						context:SetScale(scale + 25)
					else
						-- left click / gamepad a
						context:SetScale(scale + 5)
					end

					ObjModified(context)
				end,
				"AltPress", true,
				"OnAltPress", function (self, gamepad)
					local context = self.context
					if gamepad or not IsMassUIModifierPressed() then
						-- right click / gamepad x
						context:SetScale(5)
					else
						-- ctrl + right click
						local scale = context:GetScale() or 5
						context:SetScale(scale + 50)
					end

					ObjModified(context)
				end,

				"Icon", "UI/Icons/IPButtons/load.tga",
			}),


			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelButton",
				"RolloverTitle", T(302535920000457--[[Anim State Set]]),
				"RolloverHint", T(608042494285--[[<left_click> Activate]]),
				"RolloverText", T(302535920000458--[[Make object dance on command.]]),
				"OnPress", function(self)
					ChoGGi.ComFuncs.SetAnimState(self.context)
				end,
				"Icon", "UI/Icons/IPButtons/expedition.tga",
			}),

			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelButton",
				"RolloverTitle", T(302535920000129--[[Set]]) .. " " .. T(302535920001184--[[Particles]]),
				"RolloverHint", T(608042494285--[[<left_click> Activate]]),
				"RolloverText", T(302535920001421--[[Shows a list of particles you can use on the selected obj.]]),
				"OnPress", function(self)
					ChoGGi.ComFuncs.SetParticles(self.context)
				end,
				"Icon", "UI/Icons/IPButtons/status_effects.tga",
			}),

------------------- Salvage
-- last checked 1011166
		PlaceObj('XTemplateTemplate', {
			'comment', "salvage",
			'__context_of_kind', "Demolishable",
			'__condition', function (_, context) return context:ShouldShowDemolishButton() end,
			'__template', "InfopanelButton",
			'RolloverTitle', T(3973--[[Salvage]]),
			'RolloverHintGamepad', T(7657--[[<ButtonY> Activate]]),
			'OnContextUpdate', function (self, context, ...)
				local refund = context:GetRefundResources() or empty_table
				local rollover = T(7822--[[Destroy this building.]])
				if IsKindOf(context, "LandscapeConstructionSiteBase") then
					self:SetRolloverTitle(T(12171--[[Cancel Landscaping]]))
					rollover = T(12172--[[Cancel this landscaping project. The terrain will remain in its current state]])
				end
				if refund[1] then
					rollover = rollover .. "<newline><newline>" .. T(7823--[[<UIRefundRes> will be refunded upon salvage."]])
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
end
