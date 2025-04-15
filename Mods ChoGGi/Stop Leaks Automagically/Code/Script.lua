-- See LICENSE for terms

local table = table

-- Add ignore button if library installed
local RemoveXTemplateSections
local RetName
if rawget(_G, "ChoGGi_Funcs") then
	RemoveXTemplateSections = ChoGGi_Funcs.Common.RemoveXTemplateSections
	RetName = ChoGGi_Funcs.Common.RetName
end

local mod_EnableMod
local mod_ReconnectGrids
local mod_PipeValves
local mod_CableSwitches

-- Do mod options allow us to turn on/off switches
local function IsToggleAllowed(obj)
	-- I'm using .fx_actor_class since the entity changes for chrome pipe skins (otherwise I'd usually use that)
	local sw_type = obj.supply_resource == "electricity" and "CableSwitch"
		or "PipeValve"

	if (sw_type == "PipeValve" and not mod_PipeValves)
		or (sw_type == "CableSwitch" and not mod_CableSwitches)
	then
		return
	end

	return true, sw_type
end

-- Checking for a leaky grid
local function LeakyGrid(grid)
	-- Look in grid.consumers for leaky pipes/cables
	for i = 1, #(grid.consumers or "") do
		local el = grid.consumers[i]
		if el and el.is_cable_or_pipe and el.variable_consumption then
			-- .variable_consumption == leaking
			return true
		end
	end
end

local last_opened_switches = {}
local function OpenSwitches(grid, sw_type)
	-- PlaceholderSupplyGrid is used for a singular turned off switch grid
	-- PlaceholderSupplyGrid only has .elements but if there's any pipes then we can use .connectors
	local connection = "elements"
	if grid.connectors then
		-- .connectors doesn't include regular buildings (tanks/batteries/domes/etc) so it'll be slightly faster to idx
		connection = "connectors"
	end

	table.iclear(last_opened_switches)
	local c = 0

	-- Open all switches
	for i = 1, #grid[connection] do
		local el = grid[connection][i]
		-- Is the grid element a switch?
		if el and el.building and el.building.fx_actor_class == sw_type
			-- .switched_state is true if switch is turned off, so skip any already turned on as devs didn't make on/off funcs
			and el.building.switched_state
			-- Are we ignoring this switch?
			and not el.building.ChoGGi_StopLeaksAutomagically_ToggleIgnore
		then
			c = c + 1
			last_opened_switches[c] = el.building
			el.building:Switch()
		end
	end
end

local function ReconnectGrids(obj)
	local result, sw_type = IsToggleAllowed(obj)
	if not result then
		return
	end

	local grid = obj[obj.supply_resource].grid
	-- No point in doing anything if this grid leaks
	if LeakyGrid(grid) then
		return
	end

	-- Find any .grid_to_grid_connections and check if they're leaky
	-- .elements has everything in the grid in it
	for i = 1, #(grid.elements or "") do
		-- I'd hope that any grid has an elements table, but I'm not taking that bet.
		local el = grid.elements[i]
		if el and el.grid_to_grid_connections then
			for j = 1, #el.grid_to_grid_connections do
				local grid_connection = el.grid_to_grid_connections[j]
				for k = 1, #(grid_connection or "") do
					local grid_el = grid_connection[k]
					--
					if grid_el.grid ~= grid and not LeakyGrid(grid_el.grid) then
						-- No leaks in connected grid so we can turn on any switches in it
						OpenSwitches(grid_el.grid, sw_type)
						-- If it opens a leaky grid then close them
						if LeakyGrid(grid_el.grid) then
							for i = 1, #last_opened_switches do
								last_opened_switches[i]:Switch()
							end
						end
						-- But don't abort and keep trying other grids

					end
					--
				end
			end
		end
	end

end

local opened_switches_list = {}
local function GetOpenGridSwitches(obj)
	local result, sw_type = IsToggleAllowed(obj)
	if not result then
		return
	end

	local grid = obj[obj.supply_resource].grid

	-- We store a list of switches then turn them all off as the grid will change when calling :Switch()
	table.iclear(opened_switches_list)
	local c = 0

	-- Look in grid.connectors for valves/switches
	for i = 1, #(grid.connectors or "") do
		local el = grid.connectors[i]
		if el and el.building and el.building.fx_actor_class == sw_type
			-- .switched_state is true if switch is turned off, so skip any already turned off as devs didn't make on/off funcs
			and not el.building.switched_state
			-- Are we ignoring this switch?
			and not el.building.ChoGGi_StopLeaksAutomagically_ToggleIgnore
		then
			c = c + 1
			opened_switches_list[c] = el.building
		end
	end

	return opened_switches_list
end

local function CloseSwitches(obj, switches)
	if not switches and obj then
		switches = GetOpenGridSwitches(obj)
	end

	for i = 1, #(switches or "") do
		switches[i]:Switch()
	end

end

local function CloseLeakyGrid(obj)
	if LeakyGrid(obj[obj.supply_resource].grid) then
		CloseSwitches(obj)
	end
end

local function TryOpeningSwitches(switches)
	-- After closing switches try each switch and see if leaks happen
	for i = 1, #(switches or "") do
		local switch = switches[i]
		-- Turn on switch for now
		switch:Switch()
		-- If leaks then close that switch and try the next one
		if LeakyGrid(switch[switch.supply_resource].grid) then
			switch:Switch()
		end
	end

end

local ChoOrig_BreakableSupplyGridElement_Break = BreakableSupplyGridElement.Break
function BreakableSupplyGridElement:Break(...)
	if not mod_EnableMod then
		return ChoOrig_BreakableSupplyGridElement_Break(self, ...)
	end

	-- Check before calling :Break() or it'll be false as it's already broken
	local breakable = self:CanBreak()
	-- There's no return in the func
	ChoOrig_BreakableSupplyGridElement_Break(self, ...)

	if breakable then
		-- First get list of all switches in grid
		local switches = GetOpenGridSwitches(self)
		-- If there's no switches then no point
		if #switches > 0 then
			CloseSwitches(nil, switches)

			if mod_ReconnectGrids then
				TryOpeningSwitches(switches)
				-- Finally do a final check for leaks and give up and close grid if needed
				CloseLeakyGrid(self)
			end -- mod_ReconnectGrids
		end
	end

end

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_ReconnectGrids = CurrentModOptions:GetProperty("ReconnectGrids")
	mod_PipeValves = CurrentModOptions:GetProperty("PipeValves")
	mod_CableSwitches = CurrentModOptions:GetProperty("CableSwitches")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

function OnMsg.Repaired(obj)
	if not mod_EnableMod or not mod_ReconnectGrids
		or not obj:IsKindOf("BreakableSupplyGridElement")
	then
		return
	end

	local grid = obj[obj.supply_resource].grid
	local orig_grid_count = #grid.elements
	local new_grid_count = 0

	-- Grids get reconnected after switches are turned on, so loop till all non-leaky ones found
	while true do
		-- If grid is leak free then this will turn on any switches in elements .grid_to_grid_connections
		ReconnectGrids(obj)

		-- I should check how grids are merged, but this will work for now
		grid = obj[obj.supply_resource].grid

		-- If it's a different number then we don't want to count them twice to update number below
		new_grid_count = #grid.elements

		if orig_grid_count == new_grid_count then
			-- Nothing new added so we can stop checking
			break
		else
			-- Count has changed from new grid being merged, so update count to use against loop count
			orig_grid_count = new_grid_count
		end
	end

	-- Check if reconnected grid has a leak and turn switches back off
	-- Bit ugly but it seems to work better than I expected
	CloseLeakyGrid(obj)

end


-- Add toggle ignore button to switches
function OnMsg.ClassesPostprocess()

	if not RemoveXTemplateSections then
		return
	end

	local xtemplate = XTemplates.ipSwitch[1]

	-- Check for and remove existing template
	ChoGGi_Funcs.Common.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_StopLeaksAutomagically_ToggleIgnore", true)

	table.insert(xtemplate, 2,
		PlaceObj("XTemplateTemplate", {
			"Id" , "ChoGGi_Template_StopLeaksAutomagically_ToggleIgnore",
			-- No need to add this (I use it for my RemoveXTemplateSections func)
			"ChoGGi_Template_StopLeaksAutomagically_ToggleIgnore", true,
			-- The button only shows when the class object is selected
			"__context_of_kind", "SupplyGridSwitch",
			-- Main button
			"__template", "InfopanelButton",
			-- Only show button when it meets the req
			"__condition", function(self, context)
				return mod_EnableMod and context.is_switch
			end,
			-- Updates every sec (or so) when object selection panel is shown
			"OnContextUpdate", function(self, context)
				local name = RetName(context)
				if context.ChoGGi_StopLeaksAutomagically_ToggleIgnore then
					self:SetRolloverText(T{0000, "This <name> will be ignored when automagically toggling for leaks.", name = name})
					self:SetRolloverTitle(T(0000, "Ignore Switch"))
					self:SetIcon("UI/Icons/ColonyControlCenter/oxygen_off.tga")
				else
					self:SetRolloverText(T{0000, "This <name> will be included when automagically toggling for leaks.", name = name})
					self:SetRolloverTitle(T(0000, "Include Switch"))
					self:SetIcon("UI/Icons/ColonyControlCenter/oxygen_on.tga")
				end
			end,
			--
--~ 			"Title", T(0000, "Include Switch"),
			"RolloverTitle", T(0000, "Include Switch"),
			"RolloverText", T(0000, "This switch will be included when automagically toggling for leaks."),
			"Icon", "UI/Icons/ColonyControlCenter/oxygen_on.tga",
			--
			"OnPress", function(self, gamepad)
				self.context.ChoGGi_StopLeaksAutomagically_ToggleIgnore = not self.context.ChoGGi_StopLeaksAutomagically_ToggleIgnore
				ObjModified(self.context)
			end,
		})
	)


end


-- Add grid info to each section of pipe/cable
do return end



local function UpdateTemplate(template)
	local ChoOrig_context = template.__context
	template.__context = function(parent, context)
		return ChoOrig_context(parent, context)
			or context:IsKindOf("LifeSupportGridElement") and not context:IsKindOf("ConstructionSite") and context.water
	end

--~ 	-- Fix log spam from grid not having air
--~ 	local ChoOrig_OnContextUpdate = template.OnContextUpdate
--~ 	template.OnContextUpdate = function(self, context, ...)
--~ 		local building = context.building
--~ 		local grid = building:IsKindOfClasses("AirProducer", "AirStorage") and building.air and building.air.grid
--~ 			or building:IsKindOf("LifeSupportGridElement") and building.water and building.water.grid and building.water.grid.air_grid

--~ 		if grid then
--~ 		ex(grid)
--~ 			return ChoOrig_OnContextUpdate(self, context, ...)
--~ 		end
--~ 	end
end

function OnMsg.ClassesPostprocess()
	UpdateTemplate(XTemplates.sectionWaterGrid[1])
	-- OnContextUpdate has issues when there's no air grid, so water for now
--~ 	UpdateTemplate(XTemplates.sectionAirGrid[1])
end

-- Add grid info to pipes
local ChoOrig_LifeSupportGridObject_ShowUISectionLifeSupportGrid = LifeSupportGridObject.ShowUISectionLifeSupportGrid
function LifeSupportGridObject:ShowUISectionLifeSupportGrid(...)
	if not mod_EnableMod then
		return ChoOrig_LifeSupportGridObject_ShowUISectionLifeSupportGrid(self, ...)
	end

	return ChoOrig_LifeSupportGridObject_ShowUISectionLifeSupportGrid(self, ...)
		or self:IsKindOf("LifeSupportGridElement") and not self:IsKindOf("ConstructionSite") and self.water
end

local ChoOrig_LifeSupportGridElement_GetInfopanelTemplate = LifeSupportGridElement.GetInfopanelTemplate
function LifeSupportGridElement:GetInfopanelTemplate(...)
	if not mod_EnableMod then
		return ChoOrig_LifeSupportGridElement_GetInfopanelTemplate(self, ...)
	end

	return ChoOrig_LifeSupportGridElement_GetInfopanelTemplate(self, ...)
		or "ipPillaredPipe"
end

