-- See LICENSE for terms

local Translate = ChoGGi.ComFuncs.Translate
local RetName = ChoGGi.ComFuncs.RetName
local PopupToggle = ChoGGi.ComFuncs.PopupToggle
local IsControlPressed = ChoGGi.ComFuncs.IsControlPressed

local str_dome = Translate(1234--[[Dome]])
local str_drones = Translate(71--[[Commanding Drones]])
local str_state = Translate(3722--[[State]])
local str_Overpopulated = Translate(10460--[[<em>Overpopulated Dome</em>]])
local str_NotWorking = Translate(7326--[[Not Working]])
local str_Power = Translate(79--[[Power]])
local str_Water = Translate(681--[[Water]])
local str_Oxygen = Translate(682--[[Oxygen]])

local T = T
local IsT = IsT
local CmpLower = CmpLower
local getmetatable = getmetatable
local type = type
local table_find = table.find

local IsKeyPressed = terminal.IsKeyPressed

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

local orig_PinsDlg_InitPinButton = PinsDlg.InitPinButton
function PinsDlg:InitPinButton(button, ...)
	-- fire off the orig func so we have a button to work with
	orig_PinsDlg_InitPinButton(self, button, ...)

	-- block orig func unless ctrl
	local orig_button_OnPress = button.OnPress
	function button.OnPress(button_obj, gamepad, ...)
		-- if pressing ctrl then abort
		if IsControlPressed() then
			return orig_button_OnPress(button_obj, gamepad, ...)
		end
--~		local varargs = ...

		local objs
		local object = button_obj.context

		local meta = getmetatable(object)
		local build_category = meta.build_category
		local wonder = meta.wonder

		local labels = UICity.labels

		if build_category == "Domes" then
			objs = labels.Dome
		elseif wonder then
			objs = labels.Wonders
		elseif object:IsKindOf("BaseRover") then
			objs = labels.Rover
		elseif object.class == "Colonist" then
			if IsKeyPressed(const.vkShift) or #labels.Colonist < 5001 then
				objs = labels.Colonist
			else
				-- get all in dome or all without a dome
				objs = object.dome and object.dome.labels.Colonist or MapGet("map", "Colonist", function(o)
					if not o.dome then
						return true
					end
				end)
			end
		else
			objs = labels[object.class]
		end

		if (not objs or #objs < 50) and build_category then
			if build_category then
				objs = labels[build_category]
			else
				objs = MapGet("map", meta.class)
			end
		end

		-- just in case
		objs = objs or ""

		local items = {clear_objs = true}
		for i = 1, #objs do
			local obj = objs[i]

			-- add rollover text
			local pinbutton = self[table_find(self, "context", obj)]
			local hint
			local hint_title = ""

			-- hinty
			if pinbutton then
				hint = pinbutton.RolloverText
				hint_title = pinbutton.RolloverTitle
			else
				hint_title = T{8108, "<Title>", Title = RetName(obj)}
				local rollover = obj.pin_rollover
				if rollover == "" then
					hint = (obj.description ~= "" and T(obj.description, obj)) or obj:GetProperty("description") or ""
				elseif IsT(rollover) or type(rollover) == "string" then
					hint = T(rollover, obj)
				end
			end

			hint = Translate(hint)

			-- add status image
			local image = self:GetPinConditionImage(obj)
			local state_text

			if obj.class == "Colonist" or obj.class == "Drone" then
				state_text = obj:GetStateText()
				image = state_table[state_text]
			elseif build_category == "Domes" or obj:IsKindOf("BaseBuilding") and not obj:IsKindOf("BaseRover") then
				if obj.overpopulated then
					state_text = str_Overpopulated
					image = image or "UI/Icons/pin_overpopulated.tga"
				elseif not obj.ui_working and not obj.working and not obj.fx_working then
					state_text = str_NotWorking
					image = image or "UI/Icons/pin_not_working.tga"
				elseif obj.fractures and #obj.fractures > 0 then
					state_text = Translate(5626--[[Fractures: <count>]]):gsub("<count>", #obj.fractures)
					image = image or "UI/Icons/pin_attack.tga"
				elseif obj.electricity and obj:IsKindOf("ElectricityConsumer") and obj.electricity.consumption > obj.electricity.current_consumption then
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
				hint = "<color 203 120 30>" .. str_dome .. ":</color> <color 255 200 200>" .. RetName(obj.dome or obj.parent_dome) .. "</color>\n\n" .. hint
			elseif obj.command_center then
				hint = "<color 203 120 30>" .. str_drones .. ":</color> <color 255 200 200>" .. RetName(obj.command_center) .. "</color>\n\n" .. hint
			else
				hint = "\n" .. hint
			end
			-- then state text with two \n
			hint = "<color 203 120 30>" .. str_state .. ":</color> <color 255 200 200>" .. state_text .. "</color>\n" .. hint

			if obj.class ~= "SupplyRocket" or obj.class == "SupplyRocket" and obj.name ~= "" then
				items[i] = {
					name = RetName(obj),
					showobj = obj,
					image = image,
					hint = hint,
					hint_title = hint_title,
					hint_bottom = T(0, "<left_click> Select <right_click> View"),
					mouseup = function(_, _, _, button)
						if obj.class == "SupplyRocket" then
							orig_button_OnPress(button_obj, gamepad)
						else
							ViewObjectMars(obj)
							if button == "L" then
								SelectObj(obj)
							end
						end
						PopupToggle(button_obj.idCondition, "idPinPopup", items, nil, true)
					end,
				}
			end
		end

		-- sort by image then name
		table.sort(items, function(a, b)
			return CmpLower(a.image .. a.name, b.image .. b.name)
		end)

		-- personal touch
		local count = Translate(298035641454--[[Object]]) .. " #: " .. #items
		if #items > 1 then
			table.insert(items, 1, {
				name = count,
				image = "UI/Icons/res_theoretical_research.tga",
				hint = count,
				hint_title = Translate(126095410863--[[Info]]),
			})
		end

--~ ex(items)
		PopupToggle(button_obj.idCondition, "idPinPopup", items, "top", true)
	end

end

