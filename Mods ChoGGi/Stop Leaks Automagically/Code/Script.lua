-- See LICENSE for terms

local mod_EnableMod
local mod_ReconnectGrids
local mod_PipeValves
local mod_CableSwitches

-- Do mod options allow us to turn on/off switches
local function IsToggleAllowed(obj)
	-- I'm using fx_actor_class since the entity changes for chrome pipe skins (otherwise I'd usually use that)
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

local function OpenSwitches(grid, sw_type)
	-- PlaceholderSupplyGrid is used for a singular turned off switch grid
	-- PlaceholderSupplyGrid only has .elements but if there's any pipes then we can use .connectors
	local connection = "elements"
	if grid.connectors then
		-- .connectors doesn't include regular buildings (tanks/batteries/domes/etc) so it'll be slightly faster to idx
		connection = "connectors"
	end

	-- Open all switches
	for i = 1, #grid[connection] do
		local el = grid[connection][i]
		if el and el.building and el.building.fx_actor_class == sw_type
			-- .switched_state is true if switch is turned off, so skip any already turned on as devs didn't make on/off funcs
			and el.building.switched_state
		then
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
					end
					--
				end
			end
		end
	end

end

local function CloseSwitches(obj)
	local result, sw_type = IsToggleAllowed(obj)
	if not result then
		return
	end

	local grid = obj[obj.supply_resource].grid

	-- We store a list of switches then turn them all off as the grid will change when calling :Switch()
	local switches = {}
	local c = 0

	-- look in grid.connectors for valves/switches
	for i = 1, #grid.connectors do
		local el = grid.connectors[i]
		if el and el.building and el.building.fx_actor_class == sw_type
			-- switched_state is true if switch is turned off, so skip any already turned off as devs didn't make on/off funcs
			and not el.building.switched_state
		then
			c = c + 1
			switches[c] = el.building
		end
	end

	for i = 1, c do
		switches[i]:Switch()
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
		CloseSwitches(self)
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
			break
		else
			-- Count has changed from new grid being merged, so update count to use against loop count
			orig_grid_count = new_grid_count
		end
	end

	-- Check if reconnected grid has a leak and turn switches back off
	-- Bit ugly but it seems to work better than I expected
	if LeakyGrid(obj[obj.supply_resource].grid) then
		CloseSwitches(obj)
	end

end
