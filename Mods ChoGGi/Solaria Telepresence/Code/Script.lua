-- See LICENSE for terms

local PopupToggle = ChoGGi.ComFuncs.PopupToggle
local RetName = ChoGGi.ComFuncs.RetName
local FilterFromTable = ChoGGi.ComFuncs.FilterFromTable
local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local AddXTemplate = ChoGGi.ComFuncs.AddXTemplate

local OnMsg = OnMsg
local IsValid = IsValid
local RebuildInfopanel = RebuildInfopanel
local ObjModified = ObjModified
local PlaceObj = PlaceObj
local ViewPos = ViewPos
local table = table

DefineClass.Solaria = {
	__parents = {
		"ElectricityConsumer",
		"Workplace",
		"InteriorAmbientLife",
	},
	-- anim inside
	interior = {"ResearchLabInterior"},
	spots = {"Terminal"},
	anims = {{anim = "terminal", all = true}},

	-- production is workers * (prod:GetClassValue("production_per_day") / 4)
	-- how much performance does each worker add? this'll add bonus prod on top
	perf_per_viewer = 12.5,

	-- stores table of controlled obj, handle and worker amount
	SolariaTelepresence_Remote_Controller = false,
}

function Solaria:GameInit()
	-- always leave it turned off, so it doesn't use resources till user turns it on
	self:ToggleWorking()
--~ 	-- brown/yellow seems a good choice for a vr workplace
--~ 	self:SetColorizationMaterial(1, -10991554, -100, 120)
--~ 	self:SetColorizationMaterial(2, -7963804, 120, 20)
--~ 	self:SetColorizationMaterial(3, -10263981, -128, 48)

	-- It's a workplace after all (bland ftw)
	self:DestroyAttaches{"VRWorkshopHologram", "DecorInt_02"}
	self:ForEachAttach(function(a)
		if a.class:find("Door") then
			a:SetColorModifier(1)
		end
	end)
end

-- build and show a list of viable buildings
local filter_table = {
	DroneFactory = true,
	FungalFarm = true,
	FusionReactor = true,
	MetalsExtractor = true,
	PreciousMetalsExtractor = true,
}

local function ClickObj(self, obj, button, which)
	if button == "R" then
		ViewPos(obj:GetPos())
	else
		if obj.handle ~= self.handle and IsValid(obj) then
			if which == "activate" then
				self:AttachBuilding(obj)
			elseif which == "remove" then
				self:RemoveBuilding(obj)
			end
		end
	end
end

function Solaria:ListBuildings(which, parent)
	local list = table.copy(UICity.labels.OutsideBuildings)
	local hint
	local item_list = {}

	-- show list to add controller
	if which == "activate" then
		hint = T(302535920011267, [[Click to remotely control building.

Right click to view selected list item building.]])
		-- remove any we already control
		list = GetRealm(self):MapFilter(list, function(o)
			if not o.SolariaTelepresence_Remote_Controlled then
				return true
			end
		end)

		-- filter list to the types we want
		list = FilterFromTable(
			list,
			nil,
			filter_table,
			"class"
		)
	-- show controlled for remove list
	elseif which == "remove" then
		hint = T(302535920011268, [[Click to remove control of building.

Right click to view selected list item building.]])
		list = GetRealm(self):MapFilter(list, function(o)
			if o.SolariaTelepresence_Remote_Controlled then
				return true
			end
		end)

	else
		hint = T(302535920011269, [[

Right click to view selected list item building.]])
	end

	-- make it pretty
	for i = 1, #list do
		local obj = list[i]
		item_list[i] = {
			name = RetName(obj),
			-- provide a slight reference
			hint = hint,
			mouseup = function(_, _, _, button)
				ClickObj(self, obj, button, which)
			end,
		}
	end

	-- If list is empty that means no controlled/able buildings so return
	if #item_list == 0 then
		MsgPopup(
			T(302535920011270, [[Nothing to control.]]),
			T(302535920011271, [[Solaria]])
		)
		return
	end

	-- add controller for ease of movement
	table.insert(item_list, 1, {
		name = T(302535920011272, [[Solaria Controller]]),
		hint = T(302535920011273, [[Solaria control building.
You can't remove... Only view (or maybe See would be a better term).]]),
		mouseup = function(_, _, _, button)
			ClickObj(self, obj, button, which)
		end,
	})

	PopupToggle(parent, "idSolariaTelepresenceMenu", item_list, "left")
end

function Solaria:AttachBuilding(obj)
	if not IsValid(obj) or obj.handle == self.handle then
		return
	end
	local UICity = UICity
	UICity.SolariaTelepresence_RemoteControlledBuildings = UICity.SolariaTelepresence_RemoteControlledBuildings + 1

	-- setup controller
	self.SolariaTelepresence_Remote_Controller = {
		building = obj,
		handle = obj.handle,
		workers = obj.max_workers
	}
	self.max_workers = obj.max_workers

	-- controlled
	obj.SolariaTelepresence_Remote_Controlled = self
	-- needed for not needing any workers
	obj.max_workers = 0
	obj.automation = 1

	-- lower base prod to 0 (no workers no prod)
	if obj.GetProducerObj then
		obj:GetProducerObj().production_per_day = 0
	elseif obj.electricity.production then
		obj.electricity.production = 0
	end

	-- toggle Solaria shift based on controlled building
	self.closed_shifts = obj.closed_shifts

	-- turn them on if off
	RebuildInfopanel(self)
	self:SetUIWorking(true)
	obj:SetUIWorking(true)

	MsgPopup(
		T{302535920011274, "Viewing: <name> Pos: <pos>",
			name = RetName(obj),
			pos = tostring(obj:GetPos()),
		},
		T(302535920011271, [[Solaria]])
	)
end

function Solaria:RemoveBuilding(obj)
	if obj.handle == self.handle then
		return
	end

	local UICity = UICity

	obj = obj or self.SolariaTelepresence_Remote_Controller.building
	-- update Solaria
	self.SolariaTelepresence_Remote_Controller = false
	self.max_workers = nil
	if not self.suspended then
		RebuildInfopanel(self)
		self:SetUIWorking(false)
	end

	if not obj then
		-- this shouldn't happen as RemoveBuilding gets called when buildings are removed
		print([[Solaria Telepresence Error: Controlled building was removed without removing control.]])
	else
		-- update controlled building
		obj.SolariaTelepresence_Remote_Controlled = nil
		obj.production_per_day = nil

		if obj.GetProducerObj then
			local prod = obj:GetProducerObj()
			prod.production_per_day = prod:GetClassValue("production_per_day")
		elseif obj.electricity.production then
			obj.electricity.production = obj:GetClassValue("electricity_production")
		end

		obj.max_workers = nil
		obj.automation = nil
		obj.auto_performance = nil

		if not obj.suspended then
			RebuildInfopanel(obj)
			obj:SetUIWorking(false)
		end

		UICity.SolariaTelepresence_RemoteControlledBuildings = UICity.SolariaTelepresence_RemoteControlledBuildings - 1

		MsgPopup(
			T{302535920011275, "Removed: <name> Pos: <pos>",
				name = RetName(obj),
				pos = tostring(obj:GetPos()),
			},
			T(302535920011271, [[Solaria]])
		)
	end
end

-- update performance on controlled building (fires when worker starts work)
function Solaria:StartWorkCycle(unit)
	Workplace.StartWorkCycle(self, unit)
	-- only update if Solaria is controlling a building
	if self.SolariaTelepresence_Remote_Controller then
		local obj = self.SolariaTelepresence_Remote_Controller.building
		-- controlled building was removed
		if not IsValid(obj) then
			self.SolariaTelepresence_Remote_Controller = false
			self.max_workers = nil
			if not self.suspended then
				RebuildInfopanel(self)
				self:SetUIWorking(false)
			end
			return
		end

		-- get amount of workers for shifts
		local shift = self.current_shift
		-- If shift is closed then 0
		local workers = 0
		-- set Solaria shifts based on controlled building
		self.closed_shifts = obj.closed_shifts
		-- update perf for controlled
		if not self.closed_shifts[shift] then
			workers = #self.workers[shift]
			-- amount of workers * perf_per_viewer = amount of perf (even idiots can do this job, make a filter for only idiots?)
			obj.auto_performance = workers * self.perf_per_viewer
		else
			-- no workers no perf
			obj.auto_performance = 0
		end
		-- update prod
		if obj.GetProducerObj then
			local prod = obj:GetProducerObj()
			prod.production_per_day = workers * (prod:GetClassValue("production_per_day") / 4)
		elseif obj.electricity.production then
			obj.electricity.production = workers * (obj:GetClassValue("electricity_production") / 4)
		end

	-- turn off Solaria if it isn't controlling
	elseif self.working then
		if not self.suspended then
			RebuildInfopanel(self)
			self:SetUIWorking(false)
		end
	end
end

local ChoOrig_Workplace_OnDestroyed = Workplace.OnDestroyed
function Workplace:OnDestroyed()
	if self.SolariaTelepresence_Remote_Controlled then
		self:RemoveBuilding()
	end
	ChoOrig_Workplace_OnDestroyed(self)
end

function OnMsg.ClassesPostprocess()
	local template = XTemplates.sectionWorkplace
	AddXTemplate(template, "SolariaTelepresence_sectionWorkplace1", nil, {
		__context_of_kind = "Solaria",
		RolloverTitle = T(302535920011281, [[Telepresence]]),
		RolloverHint = T(302535920011282, [[Change to Pickup and select resource pile you've previously marked for pickup.
Toggle it back to "Drop Item" and select an object: it'll drop it (somewhat) next to it.]]),
		OnContextUpdate = function(self, context)
			---
			if context.SolariaTelepresence_Remote_Controller then
				self:SetRolloverText(T(302535920011283, [[Remove the control of outside building from this building.]]))
				self:SetTitle(T(302535920011284, [[Remove Remote Control]]))
				self:SetIcon("UI/Icons/Upgrades/factory_ai_03.tga")
			else
				self:SetRolloverText(T(302535920011285, [[Shows list of buildings for telepresence control.

Right click in list to view (closes menu).]]))
				self:SetTitle(T(302535920011286, [[Remote Control Building]]))
				self:SetIcon("UI/Icons/Upgrades/factory_ai_01.tga")
			end
			---
		end,
		func = function(self, context)
			---
			if not context.SolariaTelepresence_Remote_Controller then
				context:ListBuildings("activate", self)
			else
				local building = context.SolariaTelepresence_Remote_Controller.building
				local CallBackFunc = function(answer)
					if answer then
						context:RemoveBuilding(building)
					end
				end
				ChoGGi.ComFuncs.QuestionBox(
					T{302535920011287, "Are you sure you want to remove telepresence viewing from <name> located at <pos>?",
						name = RetName(building),
						pos = tostring(building:GetPos()),
					},
					CallBackFunc,
					T(302535920011276, [[Solaria Telepresence]])
				)
			end
			---
			ObjModified(context)
		end,
	})

	-- list controlled buildings
	AddXTemplate(template, "SolariaTelepresence_sectionWorkplace2", nil, {
		__context_of_kind = "Solaria",
		Icon = "UI/Icons/Upgrades/build_2.tga",
		Title = T(302535920011288, [[All Attached Buildings]]),
		RolloverTitle = T(302535920011281, [[Telepresence]]),
		RolloverHint = T(302535920011289, [[<left_click> Remove Telepresence <right_click> View Building]]),
		RolloverText = T(302535920011290, [[Shows list of all controlled buildings (for removal of telepresence control).]]),
		OnContextUpdate = function(self)
			if UICity.SolariaTelepresence_RemoteControlledBuildings > 0 then
				self:SetVisible(true)
				self:SetMaxHeight()
			else
				self:SetVisible(false)
				self:SetMaxHeight(0)
			end
		end,
		func = function(self, context)
			context:ListBuildings("remove", self)
			ObjModified(context)
		end,
	})

	-- go to controlled/controller building
	AddXTemplate(template, "SolariaTelepresence_sectionWorkplace3", nil, {
		__context_of_kind = "Workplace",
		Icon = "UI/Icons/Anomaly_Event.tga",
		RolloverTitle = T(302535920011281, [[Telepresence]]),
		RolloverHint = T(302535920011291, [[<left_click> Viewing]]),
		OnContextUpdate = function(self, context)
			-- only show if on correct building and remote control is enabled
			if context.SolariaTelepresence_Remote_Controller or context.SolariaTelepresence_Remote_Controlled then
				if context.SolariaTelepresence_Remote_Controller then
					self:SetTitle(RetName(context.SolariaTelepresence_Remote_Controller.building))
					self:SetRolloverText(T(302535920011292, [[Select and view controlled building.]]))
				elseif context.SolariaTelepresence_Remote_Controlled then
					self:SetTitle(T(302535920011276, [[Solaria Telepresence]]))
					self:SetRolloverText(T(302535920011293, [[Select and view Solaria controller.]]))
				end
				self:SetVisible(true)
				self:SetMaxHeight()
			else
				self:SetVisible(false)
				self:SetMaxHeight(0)
			end
		end,
		func = function(self, context)
			if context.SolariaTelepresence_Remote_Controller then
				ViewAndSelectObject(context.SolariaTelepresence_Remote_Controller.building)
			elseif context.SolariaTelepresence_Remote_Controlled then
				ViewAndSelectObject(context.SolariaTelepresence_Remote_Controlled)
			end
		end,
	})

	-- so we can build without NoNearbyWorkers limit
	local NoNearbyWorkers = ConstructionStatus.NoNearbyWorkers
	local ChoOrig_ConstructionController_UpdateConstructionStatuses = ConstructionController.UpdateConstructionStatuses
	function ConstructionController:UpdateConstructionStatuses(...)
		local ret = ChoOrig_ConstructionController_UpdateConstructionStatuses(self, ...)

		local statuses = self.construction_statuses or ""
		for i = 1, #statuses do
			local status = statuses[i]
			if status == NoNearbyWorkers then
				status.type = "warning"
			end
		end

		return ret
	end -- ConstructionController:UpdateConstructionStatuses

	if BuildingTemplates.Solaria then
		return
	end

	PlaceObj("BuildingTemplate", {
		"Id", "Solaria",
		"template_class", "Solaria",
		"construction_cost_Concrete", 40000,
		"construction_cost_Electronics", 10000,
		"build_points", 10000,
		"dome_required", true,
		"maintenance_resource_type", "Concrete",
		"consumption_resource_type", "Electronics",
		"consumption_max_storage", 6000,
		"consumption_amount", 1500,
		"consumption_type", 4,
		"display_name", T(302535920011276, [[Solaria Telepresence]]),
		"display_name_pl", T(302535920011277, [[Solaria Telepresences]]),
		"description", T(302535920011278, [[A telepresence VR building, remote control factories and mines (with reduced production).
Worker amount is dependent on controlled building.

Telepresence control may take up to a shift to propagate to controlled building.]]),
		"build_category", "ChoGGi",
		"Group", "ChoGGi",
		"display_icon", CurrentModPath .. "UI/TheIncal.png",
		"build_pos", 12,
		"label1", "InsideBuildings",
		"label2", "Workshop",
		"entity", "VRWorkshop",
--~ 			"palettes", "VRWorkshop",
		"palette_color1","inside_accent_2",
		"palette_color2","inside_base",
		"palette_color3","inside_accent_service",

		"demolish_sinking", range(5, 10),
		"demolish_debris", 80,
		"electricity_consumption", 15000,
		"max_workers", 0, -- changed when controlling
	})

	PlaceObj("TechPreset", {
		SortKey = 11,
		description = T(302535920011279, [[New Building: <em>Solaria</em> (<buildinginfo('Solaria')>) - a building that allows colonists to remote control production buildings. Consumes Electronics.

<grey>"How do you know it's Sci-Fi? VR is commercially viable."
<right>Shams Jorjani</grey><left>]]),
		display_name = T(302535920011280, [[Creative Realities Solaria]]),
		group = "Physics",
		icon = "UI/Icons/Research/creative_realities.tga",
		id = "CreativeRealitiesSolaria",
		position = range(11, 14),
		PlaceObj("Effect_TechUnlockBuilding", {
			Building = "Solaria",
		}),
	})
end

local function StartupCode()
	-- store amount of controlled buildings for toggling visiblity of "All Attached Buildings" button
	if not UICity.SolariaTelepresence_RemoteControlledBuildings then
		UICity.SolariaTelepresence_RemoteControlledBuildings = 0
	end
	if not IsTechResearched("CreativeRealitiesSolaria") then
		LockBuilding("Solaria")
	end
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

function OnMsg.TechResearched(tech_id)
	if tech_id == "CreativeRealitiesSolaria" then
		UnlockBuilding("Solaria")
	end
end
