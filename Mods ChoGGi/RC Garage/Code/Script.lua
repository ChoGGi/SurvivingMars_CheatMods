-- See LICENSE for terms

local Sleep = Sleep

-- stores rovers
GlobalVar("g_ChoGGi_RCGarageRovers", {})

local map_centre = point(300000, 300000)
-- stores all garages and power used
GlobalVar("g_ChoGGi_RCGarages", {
	power_per_rover = 500,
	power_per_garage = 1000,
	last_pass = map_centre,
})

DefineClass.RCGarage = {
	__parents = {
		"Building",
		"Holder",
		"ElectricityConsumer",
	},
	-- they're not "that" tall (and it was in Tunnel so screw you for questioning my authority)
	is_tall = false,
	-- holds list of rovers
	stored_rovers = false,
	-- list of garages and power
	garages = false,
	-- keeps a modifier obj to change power use
	power_modifier = false,
	-- show the pin info
	pin_rollover = T(51, "<ui_command>"),
	-- power for main
	main_power_usage = 5000,
}

function RCGarage:GameInit()
	-- add a ref to global var for easy access
	self.stored_rovers = g_ChoGGi_RCGarageRovers
	self.garages = g_ChoGGi_RCGarages

	-- add new main if needed
	self:CheckMainGarage()

	if self ~= self.garages.main then
		self.garages[#self.garages+1] = self
	end

	self:ForEachAttach("TunnelEntranceDoor", function(a)
		a:SetColorModifier(-15198184)
		-- easy access for later
		self.door = a
	end)
end

function RCGarage:SetPalette()
	-- Colour #, Colour, Roughness, Metallic (r/m go from -128 to 127) (r/m go from -128 to 127)
	-- bottom bars
	self:SetColorizationMaterial(1, -9175040, -100, 120)
	-- body
	self:SetColorizationMaterial(2, -9013642, 120, 20)
	-- stripes
	self:SetColorizationMaterial(3, -5694693, -128, 48)
end

function RCGarage:Getui_command()
	if self:CheckMainGarage() and self.garages.main.working and self.working then
		local amount = #self.stored_rovers
		if amount > 0 then
			self.status_text = T(5438, "Rovers") .. ": " .. amount
		else
			self.status_text = T(302535920011184, "Main Garage") .. ": " .. T(6939, "Idle")
		end
	else
		self.status_text = T(302535920011184, "Main Garage") .. ": " .. T(847439380056, "Disabled")
	end

	return self.status_text .. "<newline><left>"
end
function RCGarage:GetStatusText()
	return self.status_text .. "<newline><left>"
end

local DustMaterialExterior = const.DustMaterialExterior
function RCGarage:StickInGarage(unit)
	local unit_idx = table.find(self.stored_rovers, "handle", unit.handle)

	if not IsValid(self) or unit_idx then
		return
	end

	if not IsValid(self) then
		return
	end
	self:LeadIn(unit, self:GetEntrance(self, "tunnel_entrance"))

	if not IsValid(unit) then
		return
	end
	-- update list of stored
	self.stored_rovers[#self.stored_rovers+1] = unit
	-- used to block user from issuing certain commands
	unit.ChoGGi_InGarage = true

	-- power needed
	self:UpdateGaragePower()

	-- wait for door to close before the rover blinks from existance
	Sleep(self.door:TimeToOpen())
	unit:DetachFromMap()

	-- remove selection
	if SelectedObj == unit then
		SelectionRemove(unit)
	end

	-- if user doesn't try to move it this keeps the status good (bother with adding an override to actual status?)
	unit.command = "ChoGGi_InGarage"

	-- remove any dust and make it not collect dust
	unit:SetDust(0, DustMaterialExterior)
	unit.dust = 0
	unit.accumulate_dust = false

	-- stop holder from removing units when a garage is removed
	table.clear(self.units)
	unit.ChoGGi_RemHolderPos = unit.holder:GetVisualPos()
	unit.holder = false
end

function RCGarage:RemoveFromGarage(unit)
	if not IsValid(unit) then
		return
	end

	-- restore my changes to rover
	unit.ChoGGi_InGarage = nil
	unit.accumulate_dust = true
	-- update list
	local unit_idx = table.find(self.stored_rovers, "handle", unit.handle)
	if unit_idx then
		table.remove(self.stored_rovers, unit_idx)
	end

	CreateGameTimeThread(function()
		-- rovers aren't good at waiting (rover clips through door, might wanna fix that devs)
		if IsValid(self and self.door) then
			self.door:Open()
			Sleep(self.door:TimeToOpen())
		end
		-- Get the fuck outta here!
		unit:SetCommand("ExitBuilding", self, nil, "tunnel_entrance")
		-- get door opening anim and use it here
		while unit.command == "ExitBuilding" do
			Sleep(250)
		end
		if IsValid(self and self.door) then
			self.door:Close()
		end
		-- try for rolled out pos, then saved pos from orig holder
		local pt = unit:GetPos()
		local InvalidPos = InvalidPos()
		local rem = unit.ChoGGi_RemHolderPos ~= InvalidPos and unit.ChoGGi_RemHolderPos
		-- get nearby pass area
		unit:SetCommand("Goto", GetRandomPassableAround(pt ~= InvalidPos and pt or rem, 10000)
			or GetRandomPassable()
		)
		Sleep(2500)

		-- last ditch effort (should only happen when you cheat delete building)
		if pt == InvalidPos then
			local last = g_ChoGGi_RCGarages.last_pass
			pt = GetRandomPassableAround(
				rem or last ~= InvalidPos and last or map_centre:SetTerrainZ(), 10000)
				or GetRandomPassable()
			unit:SetPos(pt)
		end

		-- drop some drones
		if unit:IsKindOf("RCRover") and not unit.sieged_state then
			unit:ToggleSiegeMode()
		end

		unit.ChoGGi_RemHolderPos = nil
	end)

	self:UpdateGaragePower()
end

-- when last garage is done
function RCGarage:DumpAllRovers()
	for i = #self.stored_rovers, 1, -1 do
		self:RemoveFromGarage(self.stored_rovers[i])
	end
end

-- when demo'd or destroyed
function RCGarage:RemoveGarage()
	-- we need a new master controller?
	if self == self.garages.main then
		-- if there's no valid garages left (or this is the last one)
		if not self:CheckMainGarage(self.garages.main) then
			self:DumpAllRovers()
		end
	end

	-- if last garage removed dump out all rovers
	if not self:CheckMainGarage() then
		self:DumpAllRovers()
	end

	self:UpdateGaragePower()
end

-- assign one if we need to, skip is from RemoveGarage when we're removing main
function RCGarage:CheckMainGarage(skip)
	local main
	local garages = self.garages

	-- skip is from RemoveGarage when old main is removed (skip is a ref to .main)
	if not skip then
		if IsValid(garages.main) and not garages.main.destroyed then
			main = garages.main
		end
	end

	if not main then
		for i = 1, #garages do
			local obj = garages[i]
			if obj ~= skip and IsValid(obj) and not obj.destroyed then
				-- add as main and remove it's regular ref
				main = obj
				table.remove(garages, i)
				break
			end
		end
	end
	-- only update if changed
	if main and main ~= garages.main then
		-- update ref and POWAH
		garages.main = main
		main:UpdateGaragePower(true)
	end

	return main
end

function RCGarage:SetMainGarage(garage)
	local garages = self.garages

	if IsValid(garage) and not garage.destroyed then
		-- clean up old main
		local old_main = garages.main
		if IsValid(old_main) then
			-- add old main to garages list
			garages[#garages+1] = old_main
			-- remove power from existing main
			local elec = old_main.modifications and old_main.modifications.electricity_consumption
			if elec then
				for i = #elec, 1, -1 do
					elec[i]:delete()
				end
			end
			old_main.power_modifier = nil
		end

		-- and add new
		garages.main = garage
		-- remove from list of garages (so it doesn't count for powah)
		local idx = table.find(garage)
		if idx then
			table.remove(garages, idx)
		end
		-- powah!
		garage:UpdateGaragePower(true)
	else
		-- stick with old main or randomly pick a main
		self:CheckMainGarage()
	end
end

function RCGarage:CountPower(power, list, amount, rover)
	for i = #list, 1, -1 do
		local item = list[i]
		if IsValid(item) then
			-- working is for buildings, some rovers will have .working = false
			if rover or item.working then
				power = power + amount
			end
		else
			-- good as any place to clean out missing objs
			table.remove(list, i)
		end
	end
	return power
end

-- the main garage is getting two power mods on spawn for some reason
function RCGarage:CleanUpPower(main)
	-- make sure there's only one elec mod
	local elec = main.modifications and main.modifications.electricity_consumption
	if elec then
		local powah = main.power_modifier
		for i = #elec, 1, -1 do
			local item = elec[i]
			if item ~= powah then
				item:delete()
			end
		end
	end
end

function RCGarage:UpdateGaragePower(skip_check)
	if skip_check or self:CheckMainGarage() then
		-- main always uses 5
		local power = self.main_power_usage or 5000
		-- add the rest
		power = self:CountPower(power, self.garages, self.garages.power_per_garage)
		power = self:CountPower(power, self.stored_rovers, self.garages.power_per_rover, true)
		-- and update our modifier
		local main = self.garages.main

		if main.power_modifier then
			main.power_modifier:Change(power)
			main:CleanUpPower(main)
		else
			main.power_modifier = ObjectModifier:new{
				target = self,
				prop = "electricity_consumption",
				amount = power,
				percent = 0,
			}
			main:CleanUpPower(main)
		end
	end
end

-- we just update power use here (if main is down rovers are blocked), need to add some status text when main isn't working
function RCGarage:OnSetWorking(...)
	Building.OnSetWorking(self, ...)
	self:UpdateGaragePower()
end

function RCGarage:OnDemolish(...)
	self.garages.last_pass = self:GetPos()
	Building.OnDemolish(self, ...)
	self:RemoveGarage()
end

function OnMsg.OnSetWorking(obj, working)
	local garages = g_ChoGGi_RCGarages
	if obj == garages.main then
		for obj in pairs(garages) do
			-- skip ones that are already off
			if IsValid(obj) and not obj:GetNotWorkingReason() then
				obj:SetWorking(working)
			end
		end
	end
end

function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.RCGarage then
		PlaceObj("BuildingTemplate", {
			"Id", "RCGarage",
			"template_class", "RCGarage",
			-- pricey?
			"construction_cost_Metals", 40000,
			"construction_cost_MachineParts", 40000,
			"construction_cost_Electronics", 20000,

			"dome_forbidden", true,
			"display_name", T(302535920011185, [[RC Garage]]),
			"display_name_pl", T(302535920011185, [[RC Garage]]),
			"description", T(302535920011186, [[Stores rovers in a massive underground parking garage (where all the cool kids hang out).]]),
			"build_category", "ChoGGi",
			"Group", "ChoGGi",
			"display_icon", CurrentModPath .. "UI/garage.png",
			"encyclopedia_exclude", true,
			"entity", "TunnelEntrance",
			-- add a bit of pallor to the skeleton
			"palette_color1", "pipes_metal",
			"palette_color2", "mining_base",
			"palette_color3", "outside_base",
			"electricity_consumption", 0,
			"maintenance_resource_type", "Metals",
			"maintenance_resource_amount", 1000,
		})
	end

	local building = XTemplates.ipBuilding[1]
	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(building, "ChoGGi_Template_SetMainGarage", true)

	building[#building+1] = PlaceObj('XTemplateTemplate', {
		"ChoGGi_Template_SetMainGarage", true,
		"__context_of_kind", "RCGarage",
		"__condition", function (_, context)
			-- only show button if this isn't the main
			return context.garages.main ~= context
		end,
		"__template", "InfopanelButton",
		"Icon", "UI/Icons/IPButtons/drill.tga",
		"RolloverTitle", T(302535920011555, "Set Main Garage"),
		"RolloverText", T(302535920011554, "Set this garage as main garage."),
		"OnPress", function (self)
			local context = self.context

			context:SetMainGarage(context)
			-- update button vis
			if context.garages.main == context then
				self:SetVisible(false)
			else
				self:SetVisible(true)
			end
		end,
	})

	-- add some prod info to selection panel
	building = XTemplates.ipBuilding[1][1]

	-- check for and remove existing template
	local idx = table.find(building, "ChoGGi_Template_RCGarage", true)
	if idx then
		building[idx]:delete()
		-- we need to remove for insert
		table.remove(building, idx)
	else
		-- insert above consumption
		idx = table.find(building, "__template", "sectionConsumption")
	end

	-- hopefully this fixes the issue for people that don't have the buttons...
	if type(idx) ~= "number" then
		idx = #(building or "0")
	end

	table.insert(
		building,
		idx,

		PlaceObj('XTemplateTemplate', {
			"ChoGGi_Template_RCGarage", true,
			"__context_of_kind", "RCGarage",
			"__template", "InfopanelSection",
			"Icon", "UI/Icons/Sections/basic.tga",
		}, {

			-- show link to main garage on other garages
			PlaceObj('XTemplateTemplate', {
				"__template", "InfopanelActiveSection",
				"Icon", "UI/Icons/ColonyControlCenter/outside_buildings_on.tga",
				"RolloverText", T(302535920011187, [[View Main Garage
(The one that needs power).]]),
				"OnContextUpdate", function(self, context)
					---
					context:CheckMainGarage()
					-- hide if this is main garage
					if context.garages.main == context then
						self:SetVisible(false)
						self:SetMaxHeight(0)
						self:SetTitle(T(302535920011184, [[Main Garage]]))
					else
						self:SetVisible(true)
						self:SetMaxHeight()
						self:SetTitle(context.pin_rollover)
					end
					ObjModified(context)
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
						if context:CheckMainGarage() then
							ViewObjectMars(context.garages.main)
						end
						---
					end,
				}),
			}),

			-- add an eject all rovers to main garage
			PlaceObj('XTemplateTemplate', {
				"__template", "InfopanelActiveSection",
				"Icon", "UI/Icons/ColonyControlCenter/homeless_off.tga",
				"Title", T(302535920011188, [[Eject All]]),
				"RolloverText", T(302535920011189, [[Forces out all rovers to main garage area.]]),
				"OnContextUpdate", function(self, context)
					-- hide if this isn't main garage
					if context:CheckMainGarage() then
						if context.garages.main == context then
							self:SetVisible(true)
							self:SetMaxHeight()
						else
							self:SetVisible(false)
							self:SetMaxHeight(0)
						end
					end
				end,
			}, {
				PlaceObj("XTemplateFunc", {
					"name", "OnActivate(self, context)",
					"parent", function(self)
						return self.parent
					end,
					"func", function(self, context)
						---
						ChoGGi.ComFuncs.QuestionBox(
							T(302535920011190, [[Are you sure you want to eject all rovers?]]),
							function(answer)
								if answer then
									local GetRandomPassableAround = GetRandomPassableAround
									local GetRandomPassable = GetRandomPassable
									local rovers = context.stored_rovers or g_ChoGGi_RCGarageRovers
									for i = #rovers, 1, -1 do
										local unit = rovers[i]
										unit.ChoGGi_InGarage = nil
										unit.accumulate_dust = true
										unit:SetPos(context:GetPos())
										unit:SetCommand("Goto",
											GetRandomPassableAround(unit:GetPos(), 10000)
											or GetRandomPassable()
										)
									end
									table.iclear(rovers)
									context:UpdateGaragePower()
								end
							end,
							T(302535920011188, [[Eject All]])
						)
						---
					end,
				}),
			}),

			-- list stored rovers
			PlaceObj('XTemplateTemplate', {
				"__template", "InfopanelActiveSection",
				"Icon", "UI/Icons/Sections/accept_colonists_on.tga",
				"RolloverText", T(302535920011191, [[Click to show a list of stored rovers.
Click in list to eject a rover.]]),
				"OnContextUpdate", function(self, context)
					---
					if context:CheckMainGarage() then
						self:SetTitle(T(5438, "Rovers") .. ": " .. #context.stored_rovers)
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

						-- don't show list unless main and this garage are working
						if not (context:CheckMainGarage() and context.garages.main.working and context.working and #context.stored_rovers > 0) then
							return
						end

						local RetName = ChoGGi.ComFuncs.RetName
						-- build a list of all rovers inside
						local item_list = {}
						local c = 0
						for i = 1, #context.stored_rovers do
							local obj = context.stored_rovers[i]
							if IsValid(obj) then
								local name = RetName(obj)
								c = c + 1
								item_list[c] = {
									name = name,
									hint = T{302535920011192, "Eject <name> from garage", name = name},
									clicked = function()
										context:RemoveFromGarage(obj)
									end,
								}
							end
						end

						-- and show it
						ChoGGi.ComFuncs.PopupToggle(self, "idRCGarageMenu", item_list, "left")

						ObjModified(context)
						---
					end,
				}),
			}),

		}) -- PlaceObj
	)
end

