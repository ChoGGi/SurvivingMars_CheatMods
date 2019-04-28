-- See LICENSE for terms

local IsValid = IsValid
local Sleep = Sleep
local GetPassablePointNearby = GetPassablePointNearby

local table_clear = table.clear
local table_find = table.find
local table_remove = table.remove

local TableConcat = ChoGGi.ComFuncs.TableConcat
local PopupToggle = ChoGGi.ComFuncs.PopupToggle
local RetName = ChoGGi.ComFuncs.RetName
local Random = ChoGGi.ComFuncs.Random
local ToggleWorking = ChoGGi.ComFuncs.ToggleWorking
local InvalidPos = ChoGGi.Consts.InvalidPos

local text_disabled = "Main Garage: " .. ChoGGi.ComFuncs.Translate(847439380056--[[Disabled--]])
local text_idle = "Main Garage: " .. ChoGGi.ComFuncs.Translate(6939--[[Idle--]])
local text_rovers = ChoGGi.ComFuncs.Translate(5438--[[Rovers--]]) .. ": "

-- stores rovers
GlobalVar("g_ChoGGi_RCGarageRovers", {})
-- stores all garages and power used
local map_center = point(0,0)
GlobalVar("g_ChoGGi_RCGarages", {
	power_per_rover = 500,
	power_per_garage = 1000,
	last_pass = map_center,
})

local name = [[RC Garage]]
local description = [[Stores rovers in a massive underground parking garage (where all the cool kids hang out).]]
local display_icon = CurrentModPath .. "UI/garage.png"

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
	pin_rollover = T(0,"<ui_command>"),
}

function RCGarage:GameInit(...)
--~ 	Building.GameInit(self,...)
--~ 	-- from Holder class
--~ 	WaypointsObj.GameInit(self,...)

	-- add a ref to global var for easy access
	self.stored_rovers = g_ChoGGi_RCGarageRovers
	self.garages = g_ChoGGi_RCGarages

	-- add new main if needed
	self:CheckMainGarage()

	if self ~= self.garages.main then
		self.garages[#self.garages+1] = self
	end

	self:ForEachAttach("TunnelEntranceDoor",function(a)
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
			self.status_text = text_rovers .. amount
		else
			self.status_text = text_idle
		end
	else
		self.status_text = text_disabled
	end

	return TableConcat({self.status_text}, "<newline><left>")
end
function RCGarage:GetStatusText()
	return TableConcat({self.status_text}, "<newline><left>")
end

local DustMaterialExterior = const.DustMaterialExterior
function RCGarage:StickInGarage(unit)
	local unit_idx = table_find(self.stored_rovers,"handle",unit.handle)

  if not IsValid(self) or unit_idx then
    return
  end

	local linked_obj = self.linked_obj
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
	table_clear(self.units)
	unit.ChoGGi_RemHolderPos = unit.holder:GetVisualPos()
	unit.holder = false
end

-- gagarin and pre-gagarin
local IsValidPos = point20.IsValidPos or point20.IsValid

function RCGarage:RemoveFromGarage(unit)
	if not IsValid(unit) then
		return
	end

	-- restore my changes to rover
	unit.ChoGGi_InGarage = nil
	unit.accumulate_dust = true
	-- update list
	local unit_idx = table_find(self.stored_rovers,"handle",unit.handle)
	if unit_idx then
		table_remove(self.stored_rovers,unit_idx)
	end

	CreateGameTimeThread(function()
		-- rovers aren't good at waiting (rover clips through door, might wanna fix that devs)
		if IsValid(self and self.door) then
			self.door:Open()
			Sleep(self.door:TimeToOpen())
		end
		-- Get the fuck outta here!
		unit:SetCommand("ExitBuilding",self, nil, "tunnel_entrance")
		-- get door opening anim and use it here
		while unit.command == "ExitBuilding" do
			Sleep(250)
		end
		if IsValid(self and self.door) then
			self.door:Close()
		end
		-- try for rolled out pos, then saved pos from orig holder
		local pt = unit:GetPos()
		local rem = unit.ChoGGi_RemHolderPos ~= InvalidPos and unit.ChoGGi_RemHolderPos
		-- get nearby pass area
		unit:SetCommand("Goto",GetPassablePointNearby(pt ~= InvalidPos and pt or rem))
		Sleep(2500)

		-- last ditch effort (should only happen when you cheat delete building)
		if not IsValidPos(pt) then
			local last = g_ChoGGi_RCGarages.last_pass
			pt = rem or last ~= InvalidPos and last or point(0,0,terrain.GetHeight(map_center))
			unit:SetPos(pt)
			unit:SetCommand("Goto",GetPassablePointNearby(unit:GetPos()))
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
	-- skip is from RemoveGarage when old main is removed (skip is a ref to .main)
	if not skip then
		if IsValid(self.garages.main) and not self.garages.main.destroyed then
			main = self.garages.main
		end
	end

	if not main then
		for i = 1, #self.garages do
			local obj = self.garages[i]
			if obj ~= skip and IsValid(obj) and not obj.destroyed then
				-- add as main and remove it's regular ref
				main = obj
				table_remove(self.garages,i)
				break
			end
		end
	end
	-- only update if changed
	if main and main ~= self.garages.main then
		-- update ref and POWAH
		self.garages.main = main
		main:UpdateGaragePower(true)
	end

	return main
end

local function CountPower(power,list,amount)
	for i = #list, 1, -1 do
		if IsValid(list[i]) then
			if list[i].working then
				power = power + amount
			end
		else
			-- good as any place to clean out missing objs
			table_remove(list,i)
		end
	end
	return power
end
function RCGarage:UpdateGaragePower(skip_check)
	if skip_check or self:CheckMainGarage() then
		-- main always uses 5
		local power = 5000
		-- add the rest
		power = CountPower(power,self.garages,self.garages.power_per_garage)
		power = CountPower(power,self.stored_rovers,self.garages.power_per_rover)
		-- and update our modifier
		if self.garages.main.power_modifier then
			self.garages.main.power_modifier:Change(power)
		else
			self.garages.main.power_modifier = ObjectModifier:new{
				target = self,
				prop = "electricity_consumption",
				amount = power,
				percent = 0,
			}
		end
	end
end

-- we just update power use here (if main is down rovers are blocked), need to add some status text when main isn't working
function RCGarage:OnSetWorking(working,...)
	Building.OnSetWorking(self,working,...)
	self:UpdateGaragePower()
end

function RCGarage:OnDemolish(...)
	self.garages.last_pass = self:GetPos()
	Building.OnDemolish(self,...)
	self:RemoveGarage()
end

function OnMsg.OnSetWorking(obj,working)
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
		PlaceObj("BuildingTemplate",{
			"Id","RCGarage",
			"template_class","RCGarage",
			-- pricey?
			"construction_cost_Metals",40000,
			"construction_cost_MachineParts",40000,
			"construction_cost_Electronics",20000,

			"dome_forbidden",true,
			"display_name",name,
			"display_name_pl",name,
			"description",description,
			"build_category","ChoGGi",
			"Group", "ChoGGi",
			"display_icon", display_icon,
			"encyclopedia_exclude",true,
			"entity","TunnelEntrance",
			-- add a bit of pallor to the skeleton
			"palette_color1", "pipes_metal",
			"palette_color2", "mining_base",
			"palette_color3", "outside_base",
			"electricity_consumption", 0,
			"maintenance_resource_type", "Metals",
			"maintenance_resource_amount", 1000,
		})
	end
end

function OnMsg.ClassesBuilt()
	-- add some prod info to selection panel
	local building = XTemplates.ipBuilding[1][1]

	-- check for and remove existing template
	local idx = table_find(building, "ChoGGi_Template_RCGarage", true)
	if idx then
		building[idx]:delete()
		-- we need to remove for insert
		table_remove(building,idx)
	else
		-- insert above consumption
		idx = table_find(building, "__template", "sectionConsumption")
	end

	-- hopefully this fixes the issue for people that don't have the buttons...
	if type(idx) ~= "number" then
		idx = #(building or "1")
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
				"RolloverText", [[View main garage]],
				"OnContextUpdate", function(self, context)
					---

					-- hide if this is main garage
					if context:CheckMainGarage() then
						if context.garages.main == context then
							self:SetVisible(false)
							self:SetMaxHeight(0)
						else
							self:SetVisible(true)
							self:SetMaxHeight()
						end
					end

					if text_rovers .. #context.stored_rovers == context.status_text then
						self:SetTitle([[Main Garage]])
					else
						self:SetTitle(T(0,"<ui_command>"))
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
				"Title",[[Eject All]],
				"RolloverText", [[Forces out all rovers to main garage area]],
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

						local function CallBackFunc(answer)
							if answer then
								local rovers = g_ChoGGi_RCGarageRovers
								for i = #rovers, 1, -1 do
									local unit = rovers[i]
									unit.ChoGGi_InGarage = nil
									unit.accumulate_dust = true
									unit:SetPos(context:GetPos())
									unit:SetCommand("Goto",GetPassablePointNearby(unit:GetPos()+point(Random(-5000,5000),Random(-5000,5000))))
								end
								table_clear(g_ChoGGi_RCGarageRovers)
								context:UpdateGaragePower()
							end
						end
						ChoGGi.ComFuncs.QuestionBox(
							[[Are you sure you want to eject all rovers?]],
							CallBackFunc,
							[[Eject]]
						)
						---
					end,
				}),
			}),

			-- list stored rovers
			PlaceObj('XTemplateTemplate', {
				"__template", "InfopanelActiveSection",
				"Icon", "UI/Icons/Sections/accept_colonists_on.tga",
				"RolloverText", [[Show list of stored rovers]],
				"OnContextUpdate", function(self, context)
					---
					if context:CheckMainGarage() then
						self:SetTitle(text_rovers .. #context.stored_rovers)
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
									hint = "Eject " .. name .. " from garage",
									clicked = function()
										context:RemoveFromGarage(obj)
									end,
								}
							end
						end

						-- and show it
						PopupToggle(self,"idRCGarageMenu",item_list,"left")

						ObjModified(context)
						---
					end,
				}),
			}),

		}) -- PlaceObj
	)
end

