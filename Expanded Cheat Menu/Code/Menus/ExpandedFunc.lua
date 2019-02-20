-- See LICENSE for terms

local type,string = type,string
local StringFormat = string.format

function OnMsg.ClassesGenerate()
	local TableConcat = ChoGGi.ComFuncs.TableConcat
	local RetName = ChoGGi.ComFuncs.RetName
	local S = ChoGGi.Strings
	local Trans = ChoGGi.ComFuncs.Translate

	do -- BuildGridList
		local IsValid = IsValid
		local function BuildGrid(grid,list)
			for i = 1, #grid do
				for j = 1, #grid[i].elements do
					local bld = grid[i].elements[j].building
					local name,display_name = RetName(bld),Trans(bld.display_name)

					if name == display_name then
						list[Trans(T{11629,"GRID <i>",i = i}) .. " - " .. name .. " h: " .. bld.handle] = bld
					else
						list[Trans(T{11629,"GRID <i>",i = i}) .. " - " .. display_name .. " " .. name .. " h: " .. bld.handle] = bld
					end
				end
			end
		end
		local function FilterExamineList(ex_dlg,class)
			-- loop through and remove any matching objects, as well as the hyperlink table
			local obj_ref = ex_dlg.obj_ref
			for key,value in pairs(obj_ref) do
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
			grid_list.air.name = Trans(891--[[Air--]])
			grid_list.electricity.name = Trans(79--[[Power--]])
			grid_list.electricity.__HideCables = {
				ChoGGi_AddHyperLink = true,
				name = S[302535920000142--[[Hide--]]] .. " " .. Trans(881--[[Power Cables--]]),
				func = function(ex_dlg)
					FilterExamineList(ex_dlg,"ElectricityGridElement")
				end,
			}
			grid_list.water.name = Trans(681--[[Water--]])
			grid_list.water.__HidePipes = {
				ChoGGi_AddHyperLink = true,
				name = S[302535920000142--[[Hide--]]] .. " " .. Trans(882--[[Pipes--]]),
				func = function(ex_dlg)
					FilterExamineList(ex_dlg,"LifeSupportGridElement")
				end,
			}

			BuildGrid(UICity.air,grid_list.air)
			BuildGrid(UICity.electricity,grid_list.electricity)
			BuildGrid(UICity.water,grid_list.water)
			ChoGGi.ComFuncs.OpenInExamineDlg(grid_list,nil,S[302535920001307--[[Grid Info--]]])
		end
	end -- do

	do -- ViewObjInfo_Toggle
		local PlaceObject = PlaceObject
		local r = ChoGGi.Consts.ResearchPointsScale
		local update_info_thread = {}
		local viewing_obj_info = {}

		local function Dome_GetWorkingSpace(obj)
			local max_workers = 0
			local objs = obj.labels.Workplaces or ""
			for i = 1, #objs do
				if not objs[i].destroyed then
					max_workers = max_workers + objs[i].max_workers
				end
			end
			return max_workers
		end

		local function GetService(dome,label)
			local use,max,handles = 0,0,{}
			local services = dome.labels[label] or ""
			for i = 1, #services do
				use = use + #services[i].visitors
				max = max + services[i].max_visitors
				handles[services[i].handle] = true
			end
			return use,max,handles
		end

		local GetInfo = {
	--~ 		Power = function(obj)
	--~ 		end,
	--~ 		["Life-Support"] = function(obj)
	--~ 		end,
			OutsideBuildings = function(obj)
				return "- " .. RetName(obj) .. " -\n" .. S[302535920000035--[[Grids--]]]
					.. ": " .. Trans(682--[[Oxygen--]])
					.. "(" .. tostring(obj.air and obj.air.grid.ChoGGi_GridHandle) .. ") "
					.. Trans(681--[[Water--]]) .. "("
					.. tostring(obj.water and obj.water.grid.ChoGGi_GridHandle) .. ") "
					.. Trans(79--[[Power--]]) .. "("
					.. tostring(obj.electricity and obj.electricity.grid.ChoGGi_GridHandle) .. ")"
			end,
			SubsurfaceDeposit = function(obj)
				return "- " .. RetName(obj) .. " -\n" .. Trans(6--[[Depth Layer--]])
					.. ": " .. obj.depth_layer .. ", " .. Trans(7--[[Is Revealed--]])
					.. ": " .. obj.revealed .. "\n" .. Trans(16--[[Grade--]]) .. ": "
					.. obj.grade .. ", " .. Trans(1000100--[[Amount--]]) .. ": "
					.. (obj.amount / r) .. "/" .. (obj.max_amount / r)
			end,
			DroneControl = function(obj)
				return "- " .. RetName(obj) .. " -\n" .. Trans(517--[[Drones--]])
					.. ": " .. #(obj.drones or "") .. "/" .. obj:GetMaxDronesCount()
					.. "\n"
					.. Trans(T{295--[[Idle <right>--]],right = ": " .. obj:GetIdleDronesCount()})
					.. ", " .. S[302535920000081--[[Workers--]]] .. ": "
					.. obj:GetMiningDronesCount() .. ", "
					.. Trans(T{293--[[Broken <right>--]],right = ": " .. obj:GetBrokenDronesCount()})
					.. ", "
					.. Trans(T{294--[[Discharged <right>--]],right = ": " .. obj:GetDischargedDronesCount()})
			end,
			Drone = function(obj)
				return "- " .. RetName(obj) .. " -\n"
					.. Trans(T{584248706535--[[Carrying<right><ResourceAmount>--]],right=": ",ResourceAmount = (obj.amount or 0) / r})
					.. " (" .. obj.resource .. "), " .. Trans(63--[[Travelling--]]) .. ": "
					.. obj.moving .. ", " .. Trans(40--[[Recharge--]]) .. ": "
					.. obj.going_to_recharger .. "\n" .. Trans(4448--[[Dust--]])
					.. ": " .. (obj.dust / r) .. "/" .. (obj.dust_max / r)
					.. ", " .. Trans(7607--[[Battery--]]) .. ": " .. (obj.battery / r)
					.. "/" .. (obj.battery_max / r)
			end,
			Production = function(obj)
				local prod = type(obj.GetProducerObj) == "function" and obj:GetProducerObj()
				if not prod then
					return ""
				end

				local predprod
				local prefix
				local waste = tostring(obj.wasterock_producer or "")
				if waste then
					predprod = tostring(waste:GetPredictedProduction())
					prefix = "0."
					if #predprod > 3 then
						prefix = ""
						predprod = predprod / r
					end
					waste = " -" .. Trans(4518--[[Waste Rock--]]) .. "\n-"
					.. Trans(80--[[Production--]]) .. "-\n" .. prefix .. ": " .. predprod
					.. ", "
					.. Trans(T{6729--[[Daily Production <n>--]],n = ": " .. (waste:GetPredictedDailyProduction() / r)})
					.. ", "
					.. Trans(T{434--[[Lifetime<right><lifetime>--]],right=": ",lifetime = (waste.lifetime_production / r)})
					.. "\n" .. Trans(519--[[Storage--]]) .. ": "
					.. (waste:GetAmountStored() / r) .. "/" .. (waste.max_storage / r)
				end
				predprod = tostring(prod:GetPredictedProduction())
				prefix = "0."
				if #predprod > 3 then
					prefix = ""
					predprod = predprod / r
				end
				return "- " .. RetName(obj) .. " -\n" .. Trans(80--[[Production--]])
					.. ": " .. prefix .. predprod .. ", "
					.. Trans(T{6729--[[Daily Production <n>--]],n = ": " .. (prod:GetPredictedDailyProduction() / r)})
					.. ", "
					.. Trans(T{434--[[Lifetime<right><lifetime>--]],right=": ",lifetime = (prod.lifetime_production / r)})
					.. "\n" .. Trans(519--[[Storage--]]) .. ": "
					.. (prod:GetAmountStored() / r) .. "/" .. (prod.max_storage / r)
					.. waste
			end,
			Dome = function(obj)
				if not obj.air then
					return ""
				end
				local medic_use,medic_max,medic_handles = GetService(obj,"needMedical")
				local food_use,food_max,food_handles = GetService(obj,"needFood")
				local food_need,medic_need = 0,0
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
				return "- " .. RetName(obj) .. " -\n"
					.. Trans(547--[[Colonists--]]) .. ": " .. #(obj.labels.Colonist or "")
					.. "\n" .. Trans(6859--[[Unemployed--]]) .. ": " .. #(obj.labels.Unemployed or "") .. "/" .. Dome_GetWorkingSpace(obj)
					.. ", " .. Trans(7553--[[Homeless--]]) .. ": " .. #(obj.labels.Homeless or "") .. "/" .. obj:GetLivingSpace()
					.. "\n" .. Trans(7031--[[Renegades--]]) .. ": " .. #(obj.labels.Renegade or "")
					.. ", " .. Trans(T{5647--[[Dead Colonists: <count>--]],count = #(obj.labels.DeadColonist or "")})
					.. "\n" .. Trans(6647--[[Guru--]]) .. ": " .. #(obj.labels.Guru or "")
					.. ", " .. Trans(6640--[[Genius--]]) .. ": " .. #(obj.labels.Genius or "")
					.. ", " .. Trans(6642--[[Celebrity--]]) .. ": " .. #(obj.labels.Celebrity or "")
					.. ", " .. Trans(6644--[[Saint--]]) .. ": " .. #(obj.labels.Saint or "")
					.. "\n\n" .. Trans(79--[[Power--]]) .. ": " .. (obj.electricity.current_consumption / r) .. "/" .. (obj.electricity.consumption / r)
					.. ", " .. Trans(682--[[Oxygen--]]) .. ": " .. (obj.air.current_consumption / r) .. "/" .. (obj.air.consumption / r)
					.. ", " .. Trans(681--[[Water--]]) .. ": " .. (obj.water.current_consumption / r) .. "/" .. (obj.water.consumption / r)
					.. "\n" .. Trans(1022--[[Food--]]) .. " (" .. #(obj.labels.needFood or "") .. "): "
					.. Trans(4439--[[Going to--]]):gsub("<right><h SelectTarget InfopanelSelect><Target></h>",food_need)
					.. ", " .. Trans(526--[[Visitors--]]) .. ": " .. food_use .. "/" .. food_max
					.. "\n" .. Trans(3862--[[Medic--]]) .. " (" .. #(obj.labels.needMedical or "") .. "): "
					.. Trans(4439--[[Going to--]]):gsub("<right><h SelectTarget InfopanelSelect><Target></h>",medic_need)
					.. ", " .. Trans(526--[[Visitors--]]) .. ": " .. medic_use .. "/" .. medic_max
					.. "\n\n" .. S[302535920000035--[[Grids--]]]
					.. ": " .. Trans(682--[[Oxygen--]]) .. "(" .. obj.air.grid.ChoGGi_GridHandle .. ")"
					.. Trans(681--[[Water--]]) .. "(" .. obj.water.grid.ChoGGi_GridHandle .. ") "
					.. Trans(79--[[Power--]]) .. "(" .. obj.electricity.grid.ChoGGi_GridHandle .. ")"
			end,
		}

		local function AddViewObjInfo(label)
			local objs = ChoGGi.ComFuncs.RetAllOfClass(label)
			for i = 1, #objs do
				local obj = objs[i]
				-- only check for valid pos if it isn't a colonist (inside building = invalid pos)
				local pos = true
				if label ~= "Colonist" then
					pos = obj:IsValidPos()
				end
				-- skip any missing objects
				if IsValid(obj) and pos then
					local text_obj = PlaceObject("ChoGGi_OText")
					local text_orient = PlaceObject("ChoGGi_OOrientation")
					text_orient.ChoGGi_ViewObjInfo_o = true
					text_obj.ChoGGi_ViewObjInfo_t = true
					text_obj:SetText(GetInfo[label](obj))
					text_obj:SetCenter(true)

					local _, origin = obj:GetAllSpots(0)
					obj:Attach(text_obj, origin)
					obj:Attach(text_orient, origin)
					if label == "Dome" then
						text_obj:SetAttachOffset(point(0,0,8000))
					elseif label ~= "Drone" then
						text_obj:SetAttachOffset(point(0,0,2000))
					end
				end
			end
		end

		local function AttachCleanUp(a)
			if a.ChoGGi_ViewObjInfo_t or a.ChoGGi_ViewObjInfo_o then
				a:delete()
			end
		end
		local function RemoveViewObjInfo(label)
			-- clear out the text objects
			local objs = ChoGGi.ComFuncs.RetAllOfClass(label)
			for i = 1, #objs do
				objs[i]:ForEachAttach(AttachCleanUp)
			end
		end

		local function UpdateViewObjInfo(label)
			local cam_pos = camera.GetPos
			-- fire an update every second
			update_info_thread[label] = CreateRealTimeThread(function()
				while update_info_thread[label] do
					-- add a grid number we can reference
					ChoGGi.ComFuncs.UpdateGridHandles()

					local objs = ChoGGi.ComFuncs.RetAllOfClass(label)
					local mine
					-- update text
					for i = 1, #objs do
						mine = nil
						objs[i]:ForEachAttach(function(a)
							if a.ChoGGi_ViewObjInfo_t then
								mine = {
									pos = objs[i]:GetVisualPos(),
									text = a,
								}
								a:SetText(GetInfo[label](objs[i]))
								return
							end
						end)

						-- set opacity depending on dist
						if mine then
							if mine.pos:Dist2D(cam_pos()) > 100000 then
								mine.text:SetOpacityInterpolation(0)
							else
								mine.text:SetOpacityInterpolation(127)
							end
	--~ 						local dist = mine.pos:Dist2D(cam_pos())
	--~ 						if dist < 50000 then
	--~ 							mine.text:SetOpacityInterpolation(127)
	--~ 						elseif dist < 100000 then
	--~ 							mine.text:SetOpacityInterpolation(75)
	--~ 						else
	--~ 							mine.text:SetOpacityInterpolation(0)
	--~ 						end
						end
					end
					Sleep(1000)
				end
			end)
		end

		function ChoGGi.MenuFuncs.BuildingInfo_Toggle()
			local ItemList = {
				{text = Trans(83--[[Domes--]]),value = "Dome"},
				{text = Trans(3982--[[Deposits--]]),value = "SubsurfaceDeposit"},
				{text = Trans(80--[[Production--]]),value = "Production"},
				{text = Trans(517--[[Drones--]]),value = "Drone"},
				{text = Trans(5433--[[Drone Control--]]),value = "DroneControl"},
				{text = Trans(885971788025--[[Outside Buildings--]]),value = "OutsideBuildings"},

	--~ 			 {text = Trans(79--[[Power--]]),value = "Power"},
	--~			 {text = Trans(81--[[Life Support--]]),value = "Life-Support"},
			}

			local function CallBackFunc(choice)
				if choice.nothing_selected then
					return
				end
				local value = choice[1].value

				-- cleanup
				if viewing_obj_info[value] then
					viewing_obj_info[value] = nil
					RemoveViewObjInfo(value)
					DeleteThread(update_info_thread[value])
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
				items = ItemList,
				title = S[302535920000333--[[Building Info--]]],
				hint = S[302535920001280--[[Double-click to toggle text (updates every second).--]]],
				custom_type = 7,
			}
		end

	end -- do

	function ChoGGi.MenuFuncs.MonitorInfo()
		local ChoGGi = ChoGGi
		local ItemList = {
			{text = S[302535920000936--[[Something you'd like to see added?--]]],value = "New"},
			{text = "",value = "New"},
			{text = S[302535920000035--[[Grids--]]] .. ": " .. Trans(891--[[Air--]]),value = "Air"},
			{text = S[302535920000035--[[Grids--]]] .. ": " .. Trans(79--[[Power--]]),value = "Power"},
			{text = S[302535920000035--[[Grids--]]] .. ": " .. Trans(681--[[Water--]]),value = "Water"},
			{text = S[302535920000035--[[Grids--]]] .. ": " .. Trans(891--[[Air--]]) .. "/" .. Trans(79--[[Power--]]) .. "/" .. Trans(681--[[Water--]]),value = "Grids"},
			{text = S[302535920000042--[[City--]]],value = "City"},
			{text = Trans(547--[[Colonists--]]),value = "Colonists",hint = S[302535920000937--[[Laggy with lots of colonists.--]]]},
			{text = Trans(5238--[[Rockets--]]),value = "Rockets"},
		}
		if ChoGGi.testing then
			ItemList[#ItemList+1] = {text = Trans(311--[[Research--]]),value = "Research"}
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local value = choice[1].value
			if value == "New" then
				ChoGGi.ComFuncs.MsgWait(
					S[302535920000033--[[Post a request on Nexus or Github or send an email to: %s--]]]:format(ChoGGi.email),
					S[302535920000034--[[Request--]]]
				)
			else
				ChoGGi.ComFuncs.DisplayMonitorList(value)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = S[302535920000555--[[Monitor Info--]]],
			hint = S[302535920000940--[[Select something to monitor.--]]],
			custom_type = 7,
			custom_func = function(sel)
				ChoGGi.ComFuncs.DisplayMonitorList(sel[1].value,sel[1].parentobj)
			end,
			skip_sort = true,
		}
	end

end
