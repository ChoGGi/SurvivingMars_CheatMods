-- See LICENSE for terms

local RetName = ChoGGi.ComFuncs.RetName
local PopupToggle = ChoGGi.ComFuncs.PopupToggle
local IsControlPressed = ChoGGi.ComFuncs.IsControlPressed
local IsShiftPressed = ChoGGi.ComFuncs.IsShiftPressed

local T = T
local IsT = IsT
local CmpLower = CmpLower
local type = type
local table_find = table.find

local pin_state_table = {
	["UI/Icons/pin_attack.tga"] = "pin_attack",
	["UI/Icons/pin_drone.tga"] = "pin_drone",
	["UI/Icons/pin_full.tga"] = "pin_full",
	["UI/Icons/pin_idle.tga"] = "pin_idle",
	["UI/Icons/pin_load.tga"] = "pin_load",
	["UI/Icons/pin_malfunction.tga"] = "pin_malfunction",
	["UI/Icons/pin_moving.tga"] = "pin_moving",
	["UI/Icons/pin_not_working.tga"] = "pin_not_working",
	["UI/Icons/pin_overpopulated.tga"] = "pin_overpopulated",
	["UI/Icons/pin_oxygen.tga"] = "pin_oxygen",
	["UI/Icons/pin_power.tga"] = "pin_power",
	["UI/Icons/pin_rocket_incoming.tga"] = "pin_rocket_incoming",
	["UI/Icons/pin_rocket_orbiting.tga"] = "pin_rocket_orbiting",
	["UI/Icons/pin_rocket_outgoing.tga"] = "pin_rocket_outgoing",
	["UI/Icons/pin_salvage.tga"] = "pin_salvage",
	["UI/Icons/pin_scan.tga"] = "pin_scan",
	["UI/Icons/pin_turn_off.tga"] = "pin_turn_off",
	["UI/Icons/pin_unload.tga"] = "pin_unload",
	["UI/Icons/pin_water.tga"] = "pin_water",
}

local state_table = {
	idle = "UI/Icons/pin_idle.tga",
	_mesh = "UI/Icons/pin_idle.tga",

-- Rovers
	destroyed = "UI/Icons/pin_salvage.tga",
	destroyedIdle = "UI/Icons/pin_salvage.tga",
	moveWalk = "UI/Icons/pin_moving.tga",

	malfunction = "UI/Icons/pin_not_working.tga",
	malfunctionEnd = "UI/Icons/pin_not_working.tga",
	malfunctionIdle = "UI/Icons/pin_not_working.tga",

	gatherEnd = "UI/Icons/pin_malfunction.tga",
	gatherIdle = "UI/Icons/pin_malfunction.tga",
	gatherStart = "UI/Icons/pin_malfunction.tga",

	disembarkLoad = "UI/Icons/pin_load.tga",
	disembarkLoad2 = "UI/Icons/pin_load.tga",

	disembarkUnload = "UI/Icons/pin_unload.tga",
	disembarkUnload2 = "UI/Icons/pin_unload.tga",

-- Drones

	rotate = "UI/Icons/pin_idle.tga",
	_mesh2 = "UI/Icons/pin_idle.tga",

	death = "UI/Icons/pin_salvage.tga",
	interact = "UI/Icons/pin_rocket_outgoing.tga",

	moveWalk = "UI/Icons/pin_moving.tga",
	roverEnter = "UI/Icons/pin_moving.tga",
	roverEnter2 = "UI/Icons/pin_moving.tga",
	roverExit = "UI/Icons/pin_moving.tga",
	roverExit2 = "UI/Icons/pin_moving.tga",

	breakDown = "UI/Icons/pin_not_working.tga",
	breakDownIdle = "UI/Icons/pin_not_working.tga",
	breakDownFixed = "UI/Icons/pin_not_working.tga",

	noBattery = "UI/Icons/pin_turn_off.tga",
	noBatteryFixed = "UI/Icons/pin_turn_off.tga",
	noBatteryIdle = "UI/Icons/pin_turn_off.tga",

	chargingStationAttach = "UI/Icons/pin_power.tga",
	chargingStationDetach = "UI/Icons/pin_power.tga",
	chargingStationEnter = "UI/Icons/pin_power.tga",
	chargingStationExit = "UI/Icons/pin_power.tga",
	chargingStationIdle = "UI/Icons/pin_power.tga",
	rechargeDroneEnd = "UI/Icons/pin_power.tga",
	rechargeDroneIdle = "UI/Icons/pin_power.tga",
	rechargeDroneStart = "UI/Icons/pin_power.tga",

	cleanBuildingEnd = "UI/Icons/pin_malfunction.tga",
	cleanBuildingIdle = "UI/Icons/pin_malfunction.tga",
	cleanBuildingStart = "UI/Icons/pin_malfunction.tga",
	constructEnd = "UI/Icons/pin_malfunction.tga",
	constructIdle = "UI/Icons/pin_malfunction.tga",
	constructStart = "UI/Icons/pin_malfunction.tga",
	cleanBuildingEnd = "UI/Icons/pin_malfunction.tga",
	repairBuildingEnd = "UI/Icons/pin_malfunction.tga",
	repairBuildingIdle = "UI/Icons/pin_malfunction.tga",
	repairBuildingStart = "UI/Icons/pin_malfunction.tga",
	repairDroneEnd = "UI/Icons/pin_malfunction.tga",
	repairDroneIdle = "UI/Icons/pin_malfunction.tga",
	repairDroneStart = "UI/Icons/pin_malfunction.tga",

	gather2 = "UI/Icons/pin_load.tga",
	gatherEnd = "UI/Icons/pin_load.tga",
	gatherIdle = "UI/Icons/pin_load.tga",
	gatherStart = "UI/Icons/pin_load.tga",
	metalMineEnter = "UI/Icons/pin_load.tga",
	metalMineExit = "UI/Icons/pin_load.tga",
	metalMineIdle = "UI/Icons/pin_load.tga",

	rogueAttack = "UI/Icons/pin_attack.tga",
	rogueIdle = "UI/Icons/pin_overpopulated.tga",
	rogueRotate = "UI/Icons/pin_overpopulated.tga",
	rogueWalk = "UI/Icons/pin_overpopulated.tga",

-- Colonists

	playBasketball = "UI/Icons/pin_rocket_orbiting.tga",
	playTaiChi = "UI/Icons/pin_rocket_orbiting.tga",

	disembarkArcPod = "UI/Icons/pin_moving.tga",
	disembarkRocket = "UI/Icons/pin_moving.tga",
	moveEvade = "UI/Icons/pin_moving.tga",
	movePlanet = "UI/Icons/pin_moving.tga",
	movePlanetWalk = "UI/Icons/pin_moving.tga",
	moveRun = "UI/Icons/pin_moving.tga",
	moveWalk = "UI/Icons/pin_moving.tga",
	moveJog = "UI/Icons/pin_moving.tga",
	movePDA = "UI/Icons/pin_moving.tga",
	moveVR = "UI/Icons/pin_moving.tga",
	moveVR2 = "UI/Icons/pin_moving.tga",
	moveVR3 = "UI/Icons/pin_moving.tga",
	moveWalkElder = "UI/Icons/pin_moving.tga",
	moveWalkSlow = "UI/Icons/pin_moving.tga",

	layInjuredEnd = "UI/Icons/pin_not_working.tga",
	layInjuredIdle = "UI/Icons/pin_not_working.tga",
	layInjuredStart = "UI/Icons/pin_not_working.tga",

	fallGround = "UI/Icons/pin_rocket_incoming.tga",

	playCubes = "UI/Icons/pin_scan.tga",
	playGround1End = "UI/Icons/pin_scan.tga",
	playDance = "UI/Icons/pin_scan.tga",
	playGround1Idle = "UI/Icons/pin_scan.tga",
	playGround1Start = "UI/Icons/pin_scan.tga",
	playGround2End = "UI/Icons/pin_scan.tga",
	playGround2Idle = "UI/Icons/pin_scan.tga",
	playGround2Start = "UI/Icons/pin_scan.tga",
	playSlideDown = "UI/Icons/pin_scan.tga",
	playTwist = "UI/Icons/pin_scan.tga",
	playSlideUp = "UI/Icons/pin_scan.tga",
	playVideoGames = "UI/Icons/pin_scan.tga",

	riseGround = "UI/Icons/pin_rocket_outgoing.tga",
	standPullUpEnd = "UI/Icons/pin_rocket_outgoing.tga",
	standPullUpIdle = "UI/Icons/pin_rocket_outgoing.tga",
	standPullUpStart = "UI/Icons/pin_rocket_outgoing.tga",

	layBedEnd = "UI/Icons/pin_idle.tga",
	layBedIdle = "UI/Icons/pin_idle.tga",
	layBedStart = "UI/Icons/pin_idle.tga",
	layGrassEnd = "UI/Icons/pin_idle.tga",
	layGrassIdle = "UI/Icons/pin_idle.tga",
	layGrassStart = "UI/Icons/pin_idle.tga",
	layLoungeEnd = "UI/Icons/pin_idle.tga",
	layLoungeIdle = "UI/Icons/pin_idle.tga",
	layLoungeStart = "UI/Icons/pin_idle.tga",
	sleepEnd = "UI/Icons/pin_idle.tga",
	sleepIdle = "UI/Icons/pin_idle.tga",
	sleepStart = "UI/Icons/pin_idle.tga",
	sitDeskEnd = "UI/Icons/pin_idle.tga",
	sitDeskIdle = "UI/Icons/pin_idle.tga",
	sitDeskStart = "UI/Icons/pin_idle.tga",
	sitEatEnd = "UI/Icons/pin_idle.tga",
	sitEatIdle = "UI/Icons/pin_idle.tga",
	sitEatStart = "UI/Icons/pin_idle.tga",
	sitRelaxEnd = "UI/Icons/pin_idle.tga",
	sitRelaxIdle = "UI/Icons/pin_idle.tga",
	sitRelaxStart = "UI/Icons/pin_idle.tga",
	sitSoftChairEnd = "UI/Icons/pin_idle.tga",
	sitSoftChairIdle = "UI/Icons/pin_idle.tga",
	sitSoftChairStart = "UI/Icons/pin_idle.tga",
	standIdle = "UI/Icons/pin_idle.tga",
	sitPianoEnd = "UI/Icons/pin_idle.tga",
	sitPianoIdle = "UI/Icons/pin_idle.tga",
	sitPianoStart = "UI/Icons/pin_idle.tga",
	sitVehicle = "UI/Icons/pin_idle.tga",
	standBar = "UI/Icons/pin_idle.tga",
	standCatchBreath = "UI/Icons/pin_idle.tga",
	standDrawEnd = "UI/Icons/pin_idle.tga",
	standDrawIdle = "UI/Icons/pin_idle.tga",
	standDrawStart = "UI/Icons/pin_idle.tga",
	standEnjoySurfaceEnd = "UI/Icons/pin_idle.tga",
	standEnjoySurfaceIdle = "UI/Icons/pin_idle.tga",
	standEnjoySurfaceStart = "UI/Icons/pin_idle.tga",
	standTakeNotes = "UI/Icons/pin_idle.tga",
	spacebarSitDrinkEnd = "UI/Icons/pin_idle.tga",
	spacebarSitDrinkIdle = "UI/Icons/pin_idle.tga",
	spacebarSitDrinkStart = "UI/Icons/pin_idle.tga",
	spacebarSitEnd = "UI/Icons/pin_idle.tga",
	spacebarSitIdle = "UI/Icons/pin_idle.tga",
	spacebarSitStart = "UI/Icons/pin_idle.tga",
	talk = "UI/Icons/pin_idle.tga",

	standShop = "UI/Icons/pin_malfunction.tga",
	standButton = "UI/Icons/pin_malfunction.tga",
	standWarmUp = "UI/Icons/pin_malfunction.tga",
	standRepair = "UI/Icons/pin_malfunction.tga",
	standPDA = "UI/Icons/pin_malfunction.tga",
	standCrops = "UI/Icons/pin_malfunction.tga",
	infirmarySitEnd = "UI/Icons/pin_malfunction.tga",
	infirmarySitIdle = "UI/Icons/pin_malfunction.tga",
	infirmarySitStart = "UI/Icons/pin_malfunction.tga",
	spacebarOperate = "UI/Icons/pin_malfunction.tga",
	standScan = "UI/Icons/pin_malfunction.tga",
	terminal = "UI/Icons/pin_malfunction.tga",
	standTerminal = "UI/Icons/pin_malfunction.tga",
	standTerminal2 = "UI/Icons/pin_malfunction.tga",
	standGuard = "UI/Icons/pin_malfunction.tga",

	standPanicEnd = "UI/Icons/pin_power.tga",
	standPanicIdle = "UI/Icons/pin_power.tga",
	standPanicStart = "UI/Icons/pin_power.tga",
	moveDepressed = "UI/Icons/pin_power.tga",

	attackEnd = "UI/Icons/pin_attack.tga",
	attackIdle = "UI/Icons/pin_attack.tga",
	attackStart = "UI/Icons/pin_attack.tga",

	layDying = "UI/Icons/pin_overpopulated.tga",
	standSabotage = "UI/Icons/pin_overpopulated.tga",
	standSuicide = "UI/Icons/pin_overpopulated.tga",
	standCrazy = "UI/Icons/pin_overpopulated.tga",
	moveCrazy = "UI/Icons/pin_overpopulated.tga",
	moveSuffocation = "UI/Icons/pin_overpopulated.tga",
	moveFreezing = "UI/Icons/pin_overpopulated.tga",
}

local items = {}
local c = 0
local function OnPress(pins_obj, button_func, button_obj, gamepad, ...)
	local varargs = ...

	local objs
	local obj = button_obj.context

	local meta = getmetatable(obj)
	local build_category = meta.build_category
	local wonder = meta.wonder

	local labels = UICity.labels

	if build_category == "Domes" then
		objs = labels.Dome
	elseif wonder then
		objs = labels.Wonders
	elseif obj:IsKindOf("BaseRover") then
		objs = labels.Rover
	elseif obj:IsKindOf("Colonist") then
		if IsShiftPressed() or #labels.Colonist < 5001 then
			objs = labels.Colonist
		else
			-- get all in dome or all without a dome
			objs = obj.dome and obj.dome.labels.Colonist
				or MapGet("map", "Colonist", function(o)
					if not o.dome then
						return true
					end
				end)
		end
	else
		objs = labels[obj.class]
	end

	if not objs then
		objs = MapGet("map", obj.class)
	end

	if #objs == 0 then
		objs = MapGet("map", meta.class)
	end

	local str_dome = T(1234, "Dome")
	local str_drones = T(71, "Commanding Drones")
	local str_state = T(3722, "State")
	local str_Overpopulated = T(10460, "<em>Overpopulated Dome</em>")
	local str_NotWorking = T(7326, "Not Working")
	local str_Power = T(79, "Power")
	local str_Water = T(681, "Water")
	local str_Oxygen = T(682, "Oxygen")

	table.clear(items)
	c = 0
	for i = 1, #objs do
		obj = objs[i]

		-- add rollover text
		local pinbutton = pins_obj[table_find(pins_obj, "context", obj)]
		local hint
		local hint_title = ""

		-- hinty
		if pinbutton then
			hint = pinbutton.RolloverText
			hint_title = pinbutton.RolloverTitle
		else
			hint_title = RetName(obj)
			local rollover = obj.pin_rollover
			if rollover == "" then
				hint = (obj.description ~= "" and T{obj.description, obj})
					or obj:GetProperty("description") or ""
			elseif IsT(rollover) or type(rollover) == "string" then
				hint = T{rollover, obj}
			end
		end

		hint = T(hint)

		-- add status image
		local image = pins_obj:GetPinConditionImage(obj)
		local state_text

		if obj:IsKindOf("Colonist") or obj:IsKindOf("Drone") then
			state_text = obj:GetStateText()
			image = state_table[state_text]
		elseif build_category == "Domes" or obj:IsKindOf("BaseBuilding")
				and not obj:IsKindOf("BaseRover") then
			if obj.overpopulated then
				state_text = str_Overpopulated
				image = image or "UI/Icons/pin_overpopulated.tga"
			elseif not obj.ui_working and not obj.working and not obj.fx_working then
				state_text = str_NotWorking
				image = image or "UI/Icons/pin_not_working.tga"
			elseif obj.fractures and #obj.fractures > 0 then
				state_text = T{5626, "Fractures: <count>", count = #obj.fractures}
				image = image or "UI/Icons/pin_attack.tga"
			elseif obj.electricity and obj:IsKindOf("ElectricityConsumer")
					and obj.electricity.consumption > obj.electricity.current_consumption then
				state_text = str_Power
				image = image or "UI/Icons/pin_power.tga"
			elseif (obj.air or obj.water) and obj:IsKindOf("LifeSupportConsumer") then
				if obj.air and obj.air.consumption > obj.air.current_consumption then
					state_text = str_Oxygen
					image = image or "UI/Icons/pin_oxygen.tga"
				elseif obj.water and obj.water.consumption > obj.water.current_consumption then
					state_text = str_Water
					image = image or "UI/Icons/pin_water.tga"
				end
			end
		end

		if not image then
			image = "UI/Icons/pin_idle.tga"
		end

		-- generic string it is
		if not state_text then
			state_text = pin_state_table[image]
		end

		-- add dome text if any
		if obj.dome or obj.parent_dome then
			hint = "<color 203 120 30>" .. str_dome
				.. ":</color> <color 255 200 200>"
				.. RetName(obj.dome or obj.parent_dome)
				.. "</color>\n\n" .. hint
		elseif obj.command_center then
			hint = "<color 203 120 30>" .. str_drones
				.. ":</color> <color 255 200 200>"
				.. RetName(obj.command_center) .. "</color>\n\n" .. hint
		else
			hint = "\n" .. hint
		end
		-- then state text with two \n
		hint = "<color 203 120 30>" .. str_state
			.. ":</color> <color 255 200 200>" .. state_text .. "</color>\n" .. hint

		local is_rocket = obj:IsKindOf("SupplyRocket")
		if not is_rocket or is_rocket and obj.name ~= "" then
			c = c + 1
			local name = RetName(obj)
			items[c] = {
				sort_idx = image .. name,
				name = name,
				showobj = obj,
				image = image,
				hint = hint,
				hint_title = hint_title,
				hint_bottom = T(302535920011154, "<left_click> Select <right_click> View"),
				mouseup = function(item, _, _, button)
					if is_rocket then
						button_func(button_obj, gamepad, varargs)
					else
						-- not sure why obj in this func always the last obj in items list?
						obj = item.showobj

						ViewObjectMars(obj)
						if button == "L" then
							SelectObj(obj)
						end
					end
					ChoGGi.ComFuncs.ClearShowObj(true)
					-- only reopen if shift is held down
					if IsShiftPressed() then
						PopupToggle(button_obj.idCondition, "idPinPopup", items, "top", true)
					end
				end,
			}
		end
	end

	-- sort by image then name
	table.sort(items, function(a, b)
		return CmpLower(a.sort_idx, b.sort_idx)
	end)

	-- personal touch
	local count = T(298035641454, "Object") .. " " .. T(3732, "Count") .. ": "
		.. c

	if c > 1 then
		table.insert(items, 1, {
			name = count,
			image = "UI/Icons/res_theoretical_research.tga",
			hint = count .. "\n\n" .. T(4239, "Close / Cancel"),
			hint_title = T(126095410863, "Info"),
			clicked = function()
				ChoGGi.ComFuncs.ClearShowObj(true)
			end,
		})
	end

--~ 	ex(items)
--~ 	ex(objs)
	PopupToggle(button_obj.idCondition, "idPinPopup", items, "top", true)
end

local skip_menu_classes = {
	"OrbitalProbe",
}

local orig_PinsDlg_InitPinButton = PinsDlg.InitPinButton
function PinsDlg:InitPinButton(button, ...)
	-- fire off the orig func so we have a button to work with
	orig_PinsDlg_InitPinButton(self, button, ...)

	-- block orig func unless ctrl
	local orig_button_OnPress = button.OnPress
	function button.OnPress(button_obj, gamepad, ...)
		-- If pressing ctrl then abort
		if IsControlPressed() or button_obj:IsKindOfClasses(skip_menu_classes) then
			return orig_button_OnPress(button_obj, gamepad, ...)
		end
		return OnPress(self, orig_button_OnPress, button_obj, gamepad, ...)
	end

end

