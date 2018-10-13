-- See LICENSE for terms

-- tell people know how to get the library
function OnMsg.ModsReloaded()
	local min_version = 22

	local ModsLoaded = ModsLoaded
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
			local Sleep = Sleep
			while not UICity do
				Sleep(2500)
			end
			if WaitMarsQuestion(nil,nil,string.format([[Error: Solaria requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()

	local PopupToggle = ChoGGi.ComFuncs.PopupToggle
	local RetName = ChoGGi.ComFuncs.RetName
	local FilterFromTable = ChoGGi.ComFuncs.FilterFromTable
	local MsgPopup = ChoGGi.ComFuncs.MsgPopup

	local type,tostring,pcall,string = type,tostring,pcall,string

	local DebugPrint = DebugPrint
	local OnMsg = OnMsg
	local FilterObjects = FilterObjects
	local IsValid = IsValid
	local RebuildInfopanel = RebuildInfopanel
	local XTemplates = XTemplates
	local ObjModified = ObjModified
	local PlaceObj = PlaceObj
	local ViewPos = ViewPos
	local SelectObj = SelectObj

	DefineClass.Solaria = {
		__parents = {
			"ElectricityConsumer",
			"Workplace",
			"InteriorAmbientLife",
		},
		-- anim inside
		interior = {"ResearchLabInterior"},
		spots = {"Terminal"},
		anims = {{anim = "terminal",all = true}},

		-- production is workers * (prod.base_production_per_day / 4)
		-- how much performance does each worker add? this'll add bonus prod on top
		perf_per_viewer = 12.5,

		-- stores table of controlled obj, handle and worker amount
		SolariaTelepresence_Remote_Controller = false,
	}

	local g_Classes = g_Classes

	function Solaria:GameInit()
		g_Classes.Workplace.GameInit(self)
		-- always leave it turned off, so it doesn't use resources till user turns it on
		self:ToggleWorking()
		-- brown/yellow seems a good choice for a vr workplace
		self:SetColor1(-10991554)
		self:SetColor2(-7963804)
		self:SetColor3(-10263981)
		-- it's a workplace after all
		self:DestroyAttaches("VRWorkshopHologram")
		self:DestroyAttaches("DecorInt_02")
		local att = self:GetAttaches()
		for i = 1, #att do
			if att[i].class:find("Door") then
				att[i]:SetColorModifier(1)
			end
		end
	end

	-- build and show a list of viable buildings
	local filter_table = {DroneFactory=true,FungalFarm=true,FusionReactor=true,MetalsExtractor=true,PreciousMetalsExtractor=true}
	local function ClickObj(self,obj,button,which)
		if button == "R" then
			ViewPos(obj:GetVisualPos())
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

	function Solaria:ListBuildings(which,parent)
		local Table = UICity.labels.OutsideBuildings or empty_table
		local hint = [[

Right click to view selected list item building.]]
		local ItemList = {}

		-- show list to add controller
		if which == "activate" then
			hint = [[Click to remotely control building.

Right click to view selected list item building.]]
			-- remove any we already control
			Table = FilterObjects({
				filter = function(o)
					if not o.SolariaTelepresence_Remote_Controlled then
						return o
					end
				end
			},Table)

			-- filter list to the types we want
			Table = FilterFromTable(
				Table,
				nil,
				filter_table,
				"class"
			)
		-- show controlled for remove list
		elseif which == "remove" then
			hint = [[Click to remove control of building.%s

Right click to view selected list item building.]]
			Table = FilterObjects({
				filter = function(o)
					if o.SolariaTelepresence_Remote_Controlled then
						return o
					end
				end
			},Table)
		end

		-- make it pretty
		for i = 1, #Table do
			local obj = Table[i]
			local pos = obj:GetVisualPos()
			ItemList[#ItemList+1] = {
				pos = pos,
				name = RetName(obj),
				hint = string.format("%s at pos: %s",hint,pos), -- something to provide a slight reference
				clicked = function(_,_,button)
					ClickObj(self,obj,button,which)
				end,
			}
		end

		-- if list is empty that means no controlled/able buildings so return
		if #ItemList == 0 then
			MsgPopup(
				[[Nothing to control.]],
				[[Solaria]],
				"UI/Icons/Upgrades/holographic_scanner_04.tga"
			)
			return
		end

		-- add controller for ease of movement
		table.insert(ItemList,1,{
			name = [[ Solaria Controller]],
			pos = self:GetVisualPos(),
			hint = [[Solaria control building.
You can't remove... Only view (or maybe See would be a better term).]],
			clicked = function(_,_,button)
				ClickObj(self,obj,button,which)
			end,
		})

		PopupToggle(parent,"idSolariaTelepresenceMenu",ItemList,"left")
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

		-- lower base prod to 0 (no workers no prod
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
			string.format([[Viewing: %s Pos: %s]],RetName(obj),obj:GetVisualPos()),
			[[Solaria]],
			"UI/Icons/Upgrades/holographic_scanner_04.tga"
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
				prod.production_per_day = prod.base_production_per_day
			elseif obj.electricity.production then
				obj.electricity.production = obj.base_electricity_production
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
				string.format([[Removed: %s Pos: %s]],RetName(obj),obj:GetVisualPos()),
				[[Solaria]],
				"UI/Icons/Upgrades/holographic_scanner_03.tga"
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
			-- if shift is closed then 0
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
				prod.production_per_day = workers * (prod.base_production_per_day / 4)
			elseif obj.electricity.production then
				obj.electricity.production = workers * (obj.base_electricity_production / 4)
			end

		-- turn off Solaria if it isn't controlling
		elseif self.working then
			if not self.suspended then
				RebuildInfopanel(self)
				self:SetUIWorking(false)
			end
		end
	end

	local orig_Workplace_OnDestroyed = Workplace.OnDestroyed
	function Workplace:OnDestroyed()
		if self.SolariaTelepresence_Remote_Controlled then
			self:RemoveBuilding()
		end
		orig_Workplace_OnDestroyed(self)
	end

	function OnMsg.ClassesPostprocess()
		-- add building to building template list
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
			"display_name", [[Solaria Telepresence]],
			"display_name_pl", [[Solaria Telepresence]],
			"description", [[A telepresence VR building, remote control factories and mines (with reduced production).
Worker amount is dependent on controlled building.

Telepresence control may take up to a shift to propagate to controlled building.]],
			"Group", "Dome Services",
			"build_category", "Dome Services",
			"display_icon", string.format("%sUI/TheIncal.png",CurrentModPath),
			"build_pos", 12,
			"label1", "InsideBuildings",
			"label2", "Workshop",
			"entity", "VRWorkshop",
			"palettes", "VRWorkshop",
			"demolish_sinking", range(5, 10),
			"demolish_debris", 80,
			"electricity_consumption", 15000,
			"max_workers", 0, -- changed when controlling
		})

		PlaceObj("TechPreset", {
			SortKey = 11,
			description = T{0,[[New Building: <em>Solaria</em> (<buildinginfo('Solaria')>) - a building that allows colonists to remote control production buildings. Consumes Electronics.

<grey>"How do you know it's Sci-Fi? VR is commercially viable."
<right>Shams Jorjani</grey><left>]]},
			display_name = [[Creative Realities Solaria]],
			group = "Physics",
			icon = "UI/Icons/Research/creative_realities.tga",
			id = "CreativeRealitiesSolaria",
			position = range(11, 14),
			PlaceObj("Effect_TechUnlockBuilding", {
				Building = "Solaria",
			}),
		})

	end -- ClassesPostprocess

	function OnMsg.ClassesBuilt()
		ChoGGi.ComFuncs.RemoveXTemplateSections(XTemplates.sectionWorkplace[1],"SolariaTelepresence_sectionWorkplace1")
		ChoGGi.ComFuncs.RemoveXTemplateSections(XTemplates.sectionWorkplace[1],"SolariaTelepresence_sectionWorkplace2")
		ChoGGi.ComFuncs.RemoveXTemplateSections(XTemplates.sectionWorkplace[1],"SolariaTelepresence_sectionWorkplace3")

		ChoGGi.ComFuncs.AddXTemplate("SolariaTelepresence_sectionWorkplace1","sectionWorkplace",{
			__context_of_kind = "Solaria",
			RolloverTitle = [[Telepresence]],
			RolloverHint = [[Change to Pickup and select resource pile you've previously marked for pickup.
Toggle it back to "Drop Item" and select an object: it'll drop it (somewhat) next to it.]],
			OnContextUpdate = function(self, context)
				---
				if context.SolariaTelepresence_Remote_Controller then
					self:SetRolloverText([[Remove the control of outside building from this building.]])
					self:SetTitle([[Remove Remote Control]])
					self:SetIcon("UI/Icons/Upgrades/factory_ai_03.tga")
				else
					self:SetRolloverText([[Shows list of buildings for telepresence control.

Right click in list to view (closes menu).]])
					self:SetTitle([[Remote Control Building]])
					self:SetIcon("UI/Icons/Upgrades/factory_ai_01.tga")
				end
				---
			end,
			func = function(self, context)
				---
				if not context.SolariaTelepresence_Remote_Controller then
					context:ListBuildings("activate",self)
				else
					local building = context.SolariaTelepresence_Remote_Controller.building
					local CallBackFunc = function(answer)
						if answer then
							context:RemoveBuilding(building)
						end
					end
					ChoGGi.ComFuncs.QuestionBox(
						string.format([[Are you sure you want to remove telepresence viewing from %s located at %s]],RetName(building),building:GetVisualPos()),
						CallBackFunc,
						[[Solaria Telepresence]]
					)
				end
				---
				ObjModified(context)
			end,
		})

		-- list controlled buildings
		ChoGGi.ComFuncs.AddXTemplate("SolariaTelepresence_sectionWorkplace2","sectionWorkplace",{
			__context_of_kind = "Solaria",
			Icon = "UI/Icons/Upgrades/build_2.tga",
			Title = [[All Attached Buildings]],
			RolloverTitle = [[Telepresence]],
			RolloverHint = [[<left_click> Remove telepresence]],
			RolloverText = [[Shows list of all controlled buildings (for removal of telepresence control).

Right click list item to view (closes menu).]],
			OnContextUpdate = function(self, context)
				if UICity.SolariaTelepresence_RemoteControlledBuildings > 0 then
					self:SetVisible(true)
					self:SetMaxHeight()
				else
					self:SetVisible(false)
					self:SetMaxHeight(0)
				end
			end,
			func = function(self, context)
				context:ListBuildings("remove",self)
				ObjModified(context)
			end,
		})

		-- go to controlled/controller building
		ChoGGi.ComFuncs.AddXTemplate("SolariaTelepresence_sectionWorkplace3","sectionWorkplace",{
			__context_of_kind = "Workplace",
			Icon = "UI/Icons/Anomaly_Event.tga",
			RolloverTitle = [[Telepresence]],
			RolloverHint = [[<left_click> Viewing]],
			OnContextUpdate = function(self, context)
			-- only show if on correct building and remote control is enabled
			if context.SolariaTelepresence_Remote_Controller or context.SolariaTelepresence_Remote_Controlled then
				if context.SolariaTelepresence_Remote_Controller then
					self:SetTitle(RetName(context.SolariaTelepresence_Remote_Controller.building))
					self:SetRolloverText([[Select and view controlled building.]])
				elseif context.SolariaTelepresence_Remote_Controlled then
					self:SetTitle([[Solaria Telepresence]])
					self:SetRolloverText([[Select and view Solaria controller.]])
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

		local rawget,setmetatable,type = rawget,setmetatable,type

		--so we can build without NoNearbyWorkers limit
		ChoGGi.ComFuncs.SaveOrigFunc("ConstructionController","UpdateConstructionStatuses")
		local ChoGGi_OrigFuncs = ChoGGi.OrigFuncs
		function ConstructionController:UpdateConstructionStatuses(dont_finalize)
			--send "dont_finalize" so it comes back here without doing FinalizeStatusGathering
			ChoGGi_OrigFuncs.ConstructionController_UpdateConstructionStatuses(self,"dont_finalize")

			local status = self.construction_statuses

			if self.is_template then
				local cobj = rawget(self.cursor_obj, true)
				local tobj = setmetatable({
					[true] = cobj,
					["city"] = UICity
				}, {
					__index = self.template_obj
				})
				tobj:GatherConstructionStatuses(self.construction_statuses)
			end

			--remove errors we want to remove
			local statusNew = {}
			local ConstructionStatus = ConstructionStatus
			if type(status) == "table" and #status > 0 then
				for i = 1, #status do

					if status[i] ~= ConstructionStatus.NoNearbyWorkers then
						statusNew[#statusNew+1] = status[i]
					end

				end
			end
			--make sure we don't get errors down the line
			if type(statusNew) == "boolean" then
				statusNew = {}
			end

			self.construction_statuses = statusNew
			status = self.construction_statuses

			if not dont_finalize then
				self:FinalizeStatusGathering(status)
			else
				return status
			end
		end


	end -- ClassesBuilt

	local function SomeCode()
		-- store amount of controlled buildings for toggling visiblity of "All Attached Buildings" button
		local UICity = UICity
		if UICity then
			if not UICity.SolariaTelepresence_RemoteControlledBuildings then
				UICity.SolariaTelepresence_RemoteControlledBuildings = 0
			end
			if not IsTechResearched("CreativeRealitiesSolaria") then
				LockBuilding("Solaria")
			end
		end
	end

	function OnMsg.CityStart()
		SomeCode()
	end

	function OnMsg.LoadGame()
		SomeCode()
	end

	function OnMsg.TechResearched(tech_id)
		if tech_id == "CreativeRealitiesSolaria" then
			UnlockBuilding("Solaria")
		end
	end

end
