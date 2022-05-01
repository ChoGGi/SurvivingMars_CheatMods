-- See LICENSE for terms

local WaitMsg = WaitMsg

local mod_ClearOnLaunch

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_ClearOnLaunch = CurrentModOptions:GetProperty("ClearOnLaunch")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- temp cargo stored here
local saved_cargo = {
	rocket = {},
	pod = {},
	elevator = {},
}

-- set from LaunchCargoRocket to stop ResetCargo from updating cargo
local launch_skip = false

local ChoOrig_ResetCargo = ResetCargo
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
				-- If there's already a table then use it
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
	return ChoOrig_ResetCargo(...)
end

local function ClearCargo()
	local mode = UICity.launch_mode or "rocket"
	table.iclear(saved_cargo[mode])
	launch_skip = true
end

local fivers
local ChoOrig_ClearRocketCargo = ClearRocketCargo
function ClearRocketCargo(...)
	local ret = ChoOrig_ClearRocketCargo(...)

	-- build list of resources to use for / 5
	if not fivers then
		fivers = {}
		local Resources = Resources
		for key in pairs(Resources) do
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
		end -- for

		WaitMsg("OnRender")

		-- add a clear cargo button
		local toolbar = Dialogs.Resupply.idTemplate.idPayload.idToolBar
		toolbar.idChoGGi_ClearButton = XTextButton:new({
			Id = "idChoGGi_ClearButton",
			Text = T(5448, "CLEAR"),
			FXMouseIn = "ActionButtonHover",
			FXPress = "ActionButtonClick",
			FXPressDisabled = "UIDisabledButtonPressed",
			HAlign = "center",
			Background = 0,
			FocusedBackground = 0,
			RolloverBackground = 0,
			PressedBackground = 0,
			RolloverZoom = 1100,
			TextStyle = "Action",
			MouseCursor = "UI/Cursors/Rollover.tga",
			RolloverTemplate = "Rollover",
			RolloverTitle = T(126095410863, "Info"),
			RolloverText = T(302535920011470,[[Clear saved cargo list.
My list not the game list (reopen dialog to see changes).]]),
			OnPress = ClearCargo,
		}, toolbar)

	end)

	return ret
end

local ChoOrig_LaunchCargoRocket = LaunchCargoRocket
function LaunchCargoRocket(...)
	if mod_ClearOnLaunch then
		local mode = UICity and UICity.launch_mode or "rocket"
		table.iclear(saved_cargo[mode])
		launch_skip = true
	end
	return ChoOrig_LaunchCargoRocket(...)
end
