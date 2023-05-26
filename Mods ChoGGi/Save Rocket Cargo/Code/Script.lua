-- See LICENSE for terms

local WaitMsg = WaitMsg

local mod_EnableMod
local mod_ClearOnLaunch

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_ClearOnLaunch = CurrentModOptions:GetProperty("ClearOnLaunch")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- Temp cargo stored here
local saved_cargo = {
	rocket = {},
	pod = {},
	elevator = {},
	lander = {},
}

-- Set from LaunchCargoRocket to stop ResetCargo from updating cargo
local launch_skip = false

local ChoOrig_ResetCargo = ResetCargo
function ResetCargo(...)
	if not mod_EnableMod then
		return ChoOrig_ResetCargo(...)
	end

	if not launch_skip then
		local g_RocketCargo = g_RocketCargo
		local g_CargoMode = g_CargoMode
		if g_RocketCargo and g_CargoMode then
			-- Save cargo before it's cleared
			local list = saved_cargo[g_CargoMode] or ""
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

--~ local fivers
local ChoOrig_ClearRocketCargo = ClearRocketCargo
function ClearRocketCargo(...)
	if not mod_EnableMod then
		return ChoOrig_ClearRocketCargo(...)
	end

	local ret = ChoOrig_ClearRocketCargo(...)

--~ 	-- Build list of resources to use for / 5
--~ 	if not fivers then
--~ 		fivers = {}
--~ 		local Resources = Resources
--~ 		for key in pairs(Resources) do
--~ 			fivers[key] = true
--~ 		end
--~ 	end

	local Dialogs = Dialogs
	CreateRealTimeThread(function()
		-- Wait till the dialog is ready
		WaitMsg("OnRender")
		while not Dialogs.Resupply do
			WaitMsg("OnRender")
		end

		-- And add saved cargo
		local payload = Dialogs.Resupply.context
		local list = saved_cargo[UICity.launch_mode] or ""
		for i = 1, #list do
			local item = list[i]

			local amount = item.amount

			-- Why did I have this in here...
--~ 			-- make res use 5 less
--~ 			if fivers[item.class] then
--~ 				amount = amount / 5
--~ 			end

			for _ = 1, amount do
				payload:AddItem(item.class)
			end
		end -- for
	end)

	return ret
end

-- ClearOnLaunch
local ChoOrig_LaunchCargoRocket = LaunchCargoRocket
function LaunchCargoRocket(...)
	if not mod_EnableMod then
		return ChoOrig_LaunchCargoRocket(...)
	end

	if mod_ClearOnLaunch then
		local mode = UICity and UICity.launch_mode or "rocket"
		table.iclear(saved_cargo[mode])
		launch_skip = true
	end
	return ChoOrig_LaunchCargoRocket(...)
end

-- Clear button
function OnMsg.ClassesPostprocess()
	if XTemplates.ResupplyCategories.ChoGGi_SaveRocketCargo_AddedClearButton then
		return
	end

	-- [1] [3]Id = "idContent" [4]Margins = box(0, 25, 0, 20) [2]Id = "idList"
	local template = XTemplates.ResupplyCategories[1][3][4][2]

	template[#template+1] = PlaceObj("XTemplateAction", {
		"ActionId", "idChoGGi_ClearButton",
		"ActionName", T(5448, "CLEAR"),
		"ActionToolbar", "ActionBar",
		"ActionGamepad", "ButtonX",
		"OnAction", function()
			ClearCargo()
		end,
		"ActionState", function()
			if not mod_EnableMod then
				return "disabled"
			end
		end,
	})
	-- As for why you can't just add these to the XTemplateAction...
	template = template[#template]
	template:SetRolloverTemplate("Rollover")
	template:SetRolloverTitle(T(126095410863, "Info"))
	template:SetRolloverText(T(302535920011470, [[Clear saved cargo list.
My list not the game list (reopen dialog to see changes).]]))

	XTemplates.ResupplyCategories.ChoGGi_SaveRocketCargo_AddedClearButton = true
end
