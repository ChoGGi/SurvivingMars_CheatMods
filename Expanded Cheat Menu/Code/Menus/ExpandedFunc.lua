-- See LICENSE for terms

local type, tostring = type, tostring
local table = table

local TableConcat = ChoGGi.ComFuncs.TableConcat
local RetName = ChoGGi.ComFuncs.RetName
local Strings = ChoGGi.Strings
local Translate = ChoGGi.ComFuncs.Translate
local MsgPopup = ChoGGi.ComFuncs.MsgPopup

do -- BuildGridList
	local IsValid = IsValid
	local function BuildGrid(grid, list)
		local g_str = Translate(11629--[[GRID <i>]])
		for i = 1, #grid do
			for j = 1, #grid[i].elements do
				local bld = grid[i].elements[j].building
				local name, display_name = RetName(bld), Translate(bld.display_name)

				if name == display_name then
					list[g_str:gsub("<i>", i) .. " - " .. name .. " h: " .. bld.handle] = bld
				else
					list[g_str:gsub("<i>", i) .. " - " .. display_name .. " " .. name .. " h: " .. bld.handle] = bld
				end
			end
		end
	end
	local function FilterExamineList(ex_dlg, class)
		-- loop through and remove any matching objects, as well as the hyperlink table
		local obj_ref = ex_dlg.obj_ref
		for key, value in pairs(obj_ref) do
			if value.ChoGGi_AddHyperLink then
				obj_ref[key] = nil
			elseif IsValid(value) and value.class == class then
				obj_ref[key] = nil
			end
		end
		ex_dlg:RefreshExamine()
	end

	function ChoGGi.MenuFuncs.BuildGridList()
		local UICity = UICity
		local grid_list = {
			air = objlist:new(),
			water = objlist:new(),
			electricity = objlist:new(),
		}
		grid_list.air.name = Translate(891--[[Air]])
		grid_list.electricity.name = Translate(79--[[Power]])
		grid_list.electricity.__HideCables = {
			ChoGGi_AddHyperLink = true,
			name = Strings[302535920000142--[[Hide]]] .. " " .. Translate(881--[[Power Cables]]),
			func = function(ex_dlg)
				FilterExamineList(ex_dlg, "ElectricityGridElement")
			end,
		}
		grid_list.water.name = Translate(681--[[Water]])
		grid_list.water.__HidePipes = {
			ChoGGi_AddHyperLink = true,
			name = Strings[302535920000142--[[Hide]]] .. " " .. Translate(882--[[Pipes]]),
			func = function(ex_dlg)
				FilterExamineList(ex_dlg, "LifeSupportGridElement")
			end,
		}

		BuildGrid(UICity.air, grid_list.air)
		BuildGrid(UICity.electricity, grid_list.electricity)
		BuildGrid(UICity.water, grid_list.water)
		ChoGGi.ComFuncs.OpenInExamineDlg(grid_list, nil, Strings[302535920001307--[[Grid Info]]])
	end
end -- do

do -- ViewObjInfo_Toggle
	local GetStateName = GetStateName
	local IsValid = IsValid
	local r = const.ResearchPointsScale
	local MapGet = ChoGGi.ComFuncs.MapGet
	local RandomColourLimited = ChoGGi.ComFuncs.RandomColourLimited
	local update_info_thread = {}
	local viewing_obj_info = {}
	local OText

	local function Dome_GetWorkingSpace(obj)
		local max_workers = 0
		local objs = obj.labels.Workplaces or ""
		for i = 1, #objs do
			local o = objs[i]
			if not o.destroyed then
				max_workers = max_workers + o.max_workers
			end
		end
		return max_workers
	end

	local function GetService(dome, label)
		local use, max, handles = 0, 0, {}
		local services = dome.labels[label] or ""
		for i = 1, #services do
			use = use + #services[i].visitors
			max = max + services[i].max_visitors
			handles[services[i].handle] = true
		end
		return use, max, handles
	end

	local GetInfo = {
--~ 		Colonist = function(obj)
--~ 		end,
--~ 		Power = function(obj)
--~ 		end,
--~ 		["Life-Support"] = function(obj)
--~ 		end,
--~ 			OutsideBuildings = function(obj)
--~ 				print("OutsideBuildings")
--~ 				return "- " .. RetName(obj) .. " -\n" .. Strings[302535920000035--[[Grids]]]
--~ 					.. ": " .. Translate(682--[[Oxygen]])
--~ 					.. "(" .. (table.find(UICity.air, obj.air.grid) or Translate(6774--[[Error]])) .. ") "
--~ 					.. Translate(681--[[Water]]) .. "("
--~ 					.. tostring(obj.water and obj.water.grid.ChoGGi_GridHandle) .. ") "
--~ 					.. Translate(79--[[Power]]) .. "("
--~ 					.. tostring(obj.electricity and obj.electricity.grid.ChoGGi_GridHandle) .. ")"
--~ 			end,
		Deposit = function(obj)
			if not obj:IsKindOfClasses{"SubsurfaceDeposit", "TerrainDeposit"} then
				return ""
			end
			return "- " .. RetName(obj) .. " -\n" .. Translate(6--[[Depth Layer]])
				.. ": " .. obj.depth_layer .. ", " .. Translate(7--[[Is Revealed]])
				.. ": " .. tostring(obj.revealed) .. "\n" .. Translate(16--[[Grade]]) .. ": "
				.. obj.grade .. ", " .. Translate(1000100--[[Amount]]) .. ": "
				.. ((obj.amount or obj.max_amount) / r) .. "/" .. (obj.max_amount / r)
		end,
		DroneControl = function(obj)
			return "- " .. RetName(obj) .. " -\n" .. Translate(517--[[Drones]])
				.. ": " .. #(obj.drones or "") .. "/" .. obj:GetMaxDronesCount()
				.. "\n"
				.. Translate(295--[[Idle <right>]]):gsub("<right>", ": " .. obj:GetIdleDronesCount())
				.. ", " .. Strings[302535920000081--[[Workers]]] .. ": " .. obj:GetMiningDronesCount()
				.. ", " .. Translate(293--[[Broken <right>]]):gsub("<right>", ": " .. obj:GetBrokenDronesCount())
				.. ", " .. Translate(294--[[Discharged <right>]]):gsub("<right>", ": " .. obj:GetDischargedDronesCount())
		end,
		Drone = function(obj)
			local amount = obj.amount and obj.amount / r or 0
			local res = obj.resource
			return "- " .. RetName(obj) .. " -\n"
				.. Translate(584248706535--[[Carrying<right><ResourceAmount>]]):gsub("<right><ResourceAmount>", ": " .. amount) .. (res and " (" .. res .. "), " or ", ")
				.. Translate(3722--[[State]]) .. ": " .. GetStateName(obj:GetState()) .. ", "
				.. "\n" .. Translate(4448--[[Dust]]) .. ": " .. (obj.dust / r) .. "/" .. (obj.dust_max / r)
				.. ", " .. Strings[302535920001532--[[Battery]]] .. ": " .. (obj.battery / r) .. "/" .. (obj.battery_max / r)
		end,
		Production = function(obj)
			local prod = type(obj.GetProducerObj) == "function" and obj:GetProducerObj()
			if not prod then
				return ""
			end

			local predprod
			local prefix
			local waste = obj.wasterock_producer or ""
			if waste ~= "" then
				predprod = tostring(waste:GetPredictedProduction())
				prefix = "0."
				if #predprod > 3 or predprod == "0" then
					prefix = ""
					predprod = prod:GetPredictedProduction() / r
				end
				waste = "- " .. Translate(4518--[[Waste Rock]]) .. " -\n"
				.. Translate(80--[[Production]]) .. ": " .. prefix .. " " .. predprod .. ", "
				.. Translate(6729--[[Daily Production <n>]]):gsub("<n>", ": " .. (waste:GetPredictedDailyProduction() / r))
				.. ", "
				.. Translate(434--[[Lifetime<right><lifetime>]]):gsub("<right><lifetime>", ": " .. (waste.lifetime_production / r))
				.. "\n" .. Translate(519--[[Storage]]) .. ": "
				.. (waste:GetAmountStored() / r) .. "/" .. (waste.max_storage / r)
			end
			predprod = tostring(prod:GetPredictedProduction())
			prefix = "0."
			if #predprod > 3 or predprod == "0" then
				prefix = ""
				predprod = prod:GetPredictedProduction() / r
			end

			return TableConcat({"- " .. RetName(obj) .. " -\n" .. Translate(80--[[Production]])
				.. ": " .. prefix .. predprod .. ", "
				.. Translate(6729--[[Daily Production <n>]]):gsub("<n>", ": " .. (prod:GetPredictedDailyProduction() / r))
				.. ", "
				.. Translate(434--[[Lifetime<right><lifetime>]]):gsub("<right><lifetime>", ": " .. (prod.lifetime_production / r))
				.. "\n" .. Translate(519--[[Storage]]) .. ": "
				.. (prod:GetAmountStored() / r) .. "/" .. (prod.max_storage / r)
				, waste}, "\n")
		end,
		Dome = function(obj)
			if not obj.air then
				return ""
			end
			local medic_use, medic_max, medic_handles = GetService(obj, "needMedical")
			local food_use, food_max, food_handles = GetService(obj, "needFood")
			local food_need, medic_need = 0, 0
			local c = obj.labels.Colonist
			for i = 1, #c do
				if c[i].command == "VisitService" then
					local h = c[i].goto_target and c[i].goto_target.handle
					if medic_handles[h] then
						medic_need = medic_need + 1
					elseif food_handles[h] then
						food_need = food_need + 1
					end
				end
			end

			-- the .. below is (too long/too many ..) for ZeroBrane compile (used to find some stuff to clean up), so this is to shorten it
			local go_to = Translate(4439--[[Going to]]):gsub("<right><h SelectTarget InfopanelSelect><Target></h>", "%%s")
			local a, e, w = Translate(682--[[Oxygen]]), Translate(79--[[Power]]), Translate(681--[[Water]])
			local city = obj.city or UICity

			local ga = obj.air
			local ge = obj.electricity
			local gw = obj.water
			local ga_id = table.find(city.air, ga.grid) or Translate(6774--[[Error]])
			local ge_id = table.find(city.electricity, ge.grid) or Translate(6774--[[Error]])
			local gw_id = table.find(city.water, gw.grid) or Translate(6774--[[Error]])
			local l = obj.labels

			return "- " .. RetName(obj) .. " -\n"
				.. Translate(547--[[Colonists]]) .. ": " .. #(l.Colonist or "")
				.. "\n" .. Translate(6859--[[Unemployed]]) .. ": " .. #(l.Unemployed or "") .. "/" .. Dome_GetWorkingSpace(obj)
				.. ", " .. Translate(7553--[[Homeless]]) .. ": " .. #(l.Homeless or "") .. "/" .. obj:GetLivingSpace()
				.. "\n" .. Translate(7031--[[Renegades]]) .. ": " .. #(l.Renegade or "")
				.. ", " .. Translate(5647--[[Dead Colonists: <count>]]):gsub("<count>", #(l.DeadColonist or ""))
				.. "\n" .. Translate(6647--[[Guru]]) .. ": " .. #(l.Guru or "")
				.. ", " .. Translate(6640--[[Genius]]) .. ": " .. #(l.Genius or "")
				.. ", " .. Translate(6642--[[Celebrity]]) .. ": " .. #(l.Celebrity or "")
				.. ", " .. Translate(6644--[[Saint]]) .. ": " .. #(l.Saint or "")
				.. "\n\n" .. e .. ": " .. (ge.current_consumption / r) .. "/" .. (ge.consumption / r)
				.. ", " .. a .. ": " .. (ga.current_consumption / r) .. "/" .. (ga.consumption / r)
				.. ", " .. w .. ": " .. (gw.current_consumption / r) .. "/" .. (gw.consumption / r)
				.. "\n" .. Translate(1022--[[Food]]) .. " (" .. #(l.needFood or "") .. "): "
				.. go_to:format(": " .. food_need)
				.. ", " .. Translate(526--[[Visitors]]) .. ": " .. food_use .. "/" .. food_max
				.. "\n" .. Translate(3862--[[Medic]]) .. " (" .. #(l.needMedical or "") .. "): "
				.. go_to:format(": " .. medic_need)
				.. ", " .. Translate(526--[[Visitors]]) .. ": " .. medic_use .. "/" .. medic_max
				.. "\n\n" .. Strings[302535920000035--[[Grids]]] .. ": "
				.. a .. "(" .. ga_id .. ") "
				.. w .. "(" .. gw_id .. ") "
				.. e .. "(" .. ge_id .. ")"
		end,
	}

	local ptz8000 = point(0, 0, 8000)
	local ptz2000 = point(0, 0, 2000)
	local function AddViewObjInfo(label)
		local objs = MapGet(label)
		SuspendPassEdits("ChoGGi.MenuFuncs.BuildingInfo_Toggle.AddViewObjInfo")
		for i = 1, #objs do
			local obj = objs[i]
			-- only check for valid pos if it isn't a colonist (inside building = invalid pos)
			local pos = true
			if label ~= "Colonist" then
				pos = obj ~= InvalidPos
			end
			-- skip any missing objects
			if IsValid(obj) and pos then
				local text_obj = OText:new()
				text_obj:SetColor1(RandomColourLimited())
				text_obj:SetText(GetInfo[label](obj))
				obj:Attach(text_obj)
				obj.ChoGGi_ViewObjInfo_text = text_obj

				if label == "Dome" then
					text_obj:SetAttachOffset(ptz8000)
				elseif label ~= "Drone" then
					text_obj:SetAttachOffset(ptz2000)
				end
			end
		end
		ResumePassEdits("ChoGGi.MenuFuncs.BuildingInfo_Toggle.AddViewObjInfo")
	end

	local function RemoveViewObjInfo(cls)
		-- clear out the text objects
		local objs = MapGet(cls)
		for i = 1, #objs do
			local obj = objs[i]
			if IsValid(obj.ChoGGi_ViewObjInfo_text) then
				obj.ChoGGi_ViewObjInfo_text:delete()
				obj.ChoGGi_ViewObjInfo_text = nil
			end
		end
	end

	local function UpdateViewObjInfo(cls)
		-- fire an update every second
		update_info_thread[cls] = CreateGameTimeThread(function()
			local cameraRTS_GetPos = cameraRTS.GetPos
			local InvalidPos = ChoGGi.Consts.InvalidPos

			local objs = MapGet(cls)
			local thread = update_info_thread[cls]
			while thread do
				local cam_pos = cameraRTS_GetPos()

				-- update text loop
				for i = 1, #objs do
					local obj = objs[i]
					if IsValid(obj) and IsValid(obj.ChoGGi_ViewObjInfo_text) then
						local obj_pos = obj:GetVisualPos()
						local too_far_from_cam = obj_pos ~= InvalidPos and obj_pos:Dist2D(cam_pos) > 100000

						-- too far means hide the text and don't bother updating it
						if too_far_from_cam then
							obj.ChoGGi_ViewObjInfo_text:SetOpacityInterpolation(0)
						else
							obj.ChoGGi_ViewObjInfo_text:SetOpacityInterpolation(100)
							obj.ChoGGi_ViewObjInfo_text:SetText(GetInfo[cls](obj))
						end
					end

				end -- for
				Sleep(1000)
			end
		end)
	end

	function ChoGGi.MenuFuncs.BuildingInfo_Toggle()
		local item_list = {
			{text = Translate(83--[[Domes]]), value = "Dome"},
			{text = Translate(3982--[[Deposits]]), value = "Deposit"},
			{text = Translate(80--[[Production]]), value = "Production"},
			{text = Translate(517--[[Drones]]), value = "Drone"},
			{text = Translate(5433--[[Drone Control]]), value = "DroneControl"},
--~ 				{text = Translate(4290--[[Colonist]]), value = "Colonist"},
--~ 				{text = Translate(885971788025--[[Outside Buildings]]), value = "OutsideBuildings"},

--~ 			 {text = Translate(79--[[Power]]), value = "Power"},
--~			 {text = Translate(81--[[Life Support]]), value = "Life-Support"},
		}

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local value = choice[1].value

			OText = OText or ChoGGi_OText
			-- cleanup
			if viewing_obj_info[value] then
				viewing_obj_info[value] = nil
				RemoveViewObjInfo(value)
				DeleteThread(update_info_thread[value])
				update_info_thread[value] = nil
			else
				-- add signs
				viewing_obj_info[value] = true
				AddViewObjInfo(value)
			end

			-- auto-refresh
			if viewing_obj_info[value] then
				UpdateViewObjInfo(value)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = item_list,
			title = Strings[302535920000333--[[Building Info]]],
			hint = Strings[302535920001280--[[Double-click to toggle text (updates every second).]]],
			custom_type = 7,
		}
	end

end -- do

function ChoGGi.MenuFuncs.MonitorInfo()
	local item_list = {
		{text = Strings[302535920000936--[[Something you'd like to see added?]]], value = "New"},
		{text = "", value = "New"},
		{text = Strings[302535920000035--[[Grids]]] .. ": " .. Translate(891--[[Air]]), value = "Air"},
		{text = Strings[302535920000035--[[Grids]]] .. ": " .. Translate(79--[[Power]]), value = "Power"},
		{text = Strings[302535920000035--[[Grids]]] .. ": " .. Translate(681--[[Water]]), value = "Water"},
		{text = Strings[302535920000035--[[Grids]]] .. ": " .. Translate(891--[[Air]]) .. "/" .. Translate(79--[[Power]]) .. "/" .. Translate(681--[[Water]]), value = "Grids"},
		{text = Strings[302535920000042--[[City]]], value = "City"},
		{text = Translate(547--[[Colonists]]), value = "Colonists", hint = Strings[302535920000937--[[Laggy with lots of colonists.]]]},
		{text = Translate(5238--[[Rockets]]), value = "Rockets"},
	}
	if ChoGGi.testing then
		item_list[#item_list+1] = {text = Translate(311--[[Research]]), value = "Research"}
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		local value = choice[1].value
		if value == "New" then
			ChoGGi.ComFuncs.MsgWait(
				Strings[302535920000033--[[Post a request on Nexus or Github or send an email to: %s]]]:format(ChoGGi.email),
				Strings[302535920000034--[[Request]]]
			)
		else
			ChoGGi.ComFuncs.DisplayMonitorList(value)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = Strings[302535920000555--[[Monitor Info]]],
		hint = Strings[302535920000940--[[Select something to monitor.]]],
		custom_type = 7,
		custom_func = function(sel)
			ChoGGi.ComFuncs.DisplayMonitorList(sel[1].value, sel[1].parentobj)
		end,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.CleanAllObjects()
	local dust = const.DustMaterialExterior
	MapForEach("map", "BaseBuilding", function(o)
		if o.SetDust then
			o:SetDust(0, dust)
		end
	end)
	MsgPopup(
		"true",
		Strings[302535920000688--[[Clean All Objects]]]
	)
end

function ChoGGi.MenuFuncs.FixAllObjects()
	MapForEach("map", "BaseBuilding", function(o)
		if o.Repair then
			o:Repair()
			o.accumulated_maintenance_points = 0
		end
	end)

	MapForEach("map", "Drone", function(o)
		o:CheatRechargeBattery()
		o:SetCommand("RepairDrone", o)
	end)

	MsgPopup(
		"true",
		Strings[302535920000690--[[Fix All Objects]]]
	)
end

function ChoGGi.MenuFuncs.ScannerQueueLarger_Toggle()
	const.ExplorationQueueMaxSize = ChoGGi.ComFuncs.ValueRetOpp(const.ExplorationQueueMaxSize, 100, ChoGGi.Consts.ExplorationQueueMaxSize)
	ChoGGi.ComFuncs.SetSavedConstSetting("ExplorationQueueMaxSize")

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.ExplorationQueueMaxSize),
		Strings[302535920000700--[[Scanner Queue Larger]]]
	)
end
