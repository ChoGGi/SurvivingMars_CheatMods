-- See LICENSE for terms

local mod_id = "ChoGGi_SaveRocketCargo"
local mod = Mods[mod_id]
local mod_ClearOnLaunch = mod.options and mod.options.ClearOnLaunch or true

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end

	mod_ClearOnLaunch = mod.options.ClearOnLaunch
end

-- for some reason mod options aren't retrieved before this script is loaded...
local function StartupCode()
	mod_ClearOnLaunch = mod.options.ClearOnLaunch
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

local WaitMsg = WaitMsg

-- temp cargo stored here
local saved_cargo = {
	rocket = {},
	pod = {},
	elevator = {},
}

-- set from LaunchCargoRocket to stop ResetCargo from updating cargo
local launch_skip = false

local orig_ResetCargo = ResetCargo
function ResetCargo(...)
	if not launch_skip then
		local g_RocketCargo = g_RocketCargo
		local g_CargoMode = g_CargoMode
		if g_RocketCargo and g_CargoMode then
			-- save cargo before it's cleared
			local list = saved_cargo[g_CargoMode]
			for i = 1, #g_RocketCargo do
				local cargo = g_RocketCargo[i]
				local saved = list[i]
				-- if there's already a table then use it
				if saved then
					saved.amount = cargo.amount
					saved.class = cargo.class
				else
					list[i] = {
						amount = cargo.amount,
						class = cargo.class,
					}
				end
			end
		end
	end
	launch_skip = false
	return orig_ResetCargo(...)
end

local fivers

local orig_ClearRocketCargo = ClearRocketCargo
function ClearRocketCargo(...)
	local ret = orig_ClearRocketCargo(...)

	-- build list of resources to use for / 5
	if not fivers then
		fivers = {}
		local r = Resources
		for key in pairs(r) do
			fivers[key] = true
		end
	end

	local Dialogs = Dialogs
	CreateRealTimeThread(function()
		-- wait till the dialog is ready
		WaitMsg("OnRender")
		while not Dialogs.Resupply do
			WaitMsg("OnRender")
		end
		-- and add saved cargo
		local payload = Dialogs.Resupply.context
		local list = saved_cargo[UICity.launch_mode]
		for i = 1, #list do
			local item = list[i]

			local amount = item.amount
			-- make res use 5 less
			if fivers[item.class] then
				amount = amount / 5
			end

			for _ = 1, amount do
				payload:AddItem(item.class)
			end
		end

	end)

	return ret
end

local orig_LaunchCargoRocket = LaunchCargoRocket
function LaunchCargoRocket(...)
	if mod_ClearOnLaunch then
		local mode = UICity and UICity.launch_mode or "rocket"
		table.iclear(saved_cargo[mode])
		launch_skip = true
	end
	return orig_LaunchCargoRocket(...)
end
