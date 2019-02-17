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
			grid_list.air.name = S[891--[[Air--]]]
			grid_list.electricity.name = S[79--[[Power--]]]
			grid_list.electricity.__HideCables = {
				ChoGGi_AddHyperLink = true,
				name = S[302535920000142--[[Hide--]]] .. " " .. S[881--[[Power Cables--]]],
				func = function(ex_dlg)
					FilterExamineList(ex_dlg,"ElectricityGridElement")
				end,
			}
			grid_list.water.name = S[681--[[Water--]]]
			grid_list.water.__HidePipes = {
				ChoGGi_AddHyperLink = true,
				name = S[302535920000142--[[Hide--]]] .. " " .. S[882--[[Pipes--]]],
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
				return StringFormat("- %s -\n%s: %s(%s) %s(%s) %s(%s)",
					RetName(obj),
					S[302535920000035--[[Grids--]]],
					S[682--[[Oxygen--]]],obj.air and obj.air.grid.ChoGGi_GridHandle,
					S[681--[[Water--]]],obj.water and obj.water.grid.ChoGGi_GridHandle,
					S[79--[[Power--]]],obj.electricity and obj.electricity.grid.ChoGGi_GridHandle
				)
			end,
			SubsurfaceDeposit = function(obj)
				return StringFormat("- %s -\n%s: %s, %s: %s\n%s: %s, %s: %s/%s",
					RetName(obj),
					S[6--[[Depth Layer--]]],obj.depth_layer,
					S[7--[[Is Revealed--]]],obj.revealed,
					S[16--[[Grade--]]],obj.grade,
					S[1000100--[[Amount--]]],obj.amount / r,obj.max_amount / r
				)
			end,
			DroneControl = function(obj)
				return StringFormat("- %s -\n%s: %s/%s\n%s, %s: %s, %s, %s",
					RetName(obj),
					S[517--[[Drones: %s--]]],#(obj.drones or ""),obj:GetMaxDronesCount(),
					S[295--[[Idle: %s--]]]:format(obj:GetIdleDronesCount()),
					S[302535920000081--[[Workers--]]],obj:GetMiningDronesCount(),
					S[293--[[Broken: %s--]]]:format(obj:GetBrokenDronesCount()),
					S[294--[[Discharged: %s--]]]:format(obj:GetDischargedDronesCount())
				)
			end,
			Drone = function(obj)
				return StringFormat("- %s -\n%s (%s), %s: %s, %s: %s\n%s: %s/%s, %s: %s/%s",
					RetName(obj),
					S[584248706535--[[Carrying: %s--]]]:format((obj.amount or 0) / r),obj.resource,
					S[63--[[Travelling--]]],obj.moving,
					S[40--[[Recharge--]]],obj.going_to_recharger,
					S[4448--[[Dust--]]],obj.dust / r,obj.dust_max / r,
					S[7607--[[Battery--]]],obj.battery / r,obj.battery_max / r
				)
			end,
			Production = function(obj)
				local prod = type(obj.GetProducerObj) == "function" and obj:GetProducerObj()
				if not prod then
					return ""
				end

				local predprod
				local prefix
				local waste = obj.wasterock_producer or nil -- can't use booleans for table.concat, so make it nil
				if waste then
					predprod = tostring(waste:GetPredictedProduction())
					prefix = "0."
					if #predprod > 3 then
						prefix = ""
						predprod = predprod / r
					end
					waste = StringFormat("\n-%s-\n%s: %s%s, %s, %s\n%s: %s/%s",
					S[4518--[[Waste Rock--]]],
					S[80--[[Production--]]],prefix,predprod,
					S[6729--[[Daily Production : %s--]]]:format(waste:GetPredictedDailyProduction() / r),
					S[434--[[Lifetime: %s--]]]:format(waste.lifetime_production / r),
					S[519--[[Storage--]]],waste:GetAmountStored() / r,waste.max_storage / r
					)
				end
				predprod = tostring(prod:GetPredictedProduction())
				prefix = "0."
				if #predprod > 3 then
					prefix = ""
					predprod = predprod / r
				end
				return TableConcat{StringFormat("- %s -\n%s: %s%s, %s, %s\n%s: %s/%s",
					RetName(obj),
					S[80--[[Production--]]],prefix,predprod,
					S[6729--[[Daily Production : %s--]]]:format(prod:GetPredictedDailyProduction() / r),
					S[434--[[Lifetime: %s--]]]:format(prod.lifetime_production / r),
					S[519--[[Storage--]]],prod:GetAmountStored() / r,prod.max_storage / r
				),waste}
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
				return StringFormat([[- %s -
	%s: %s
	%s: %s/%s, %s: %s/%s
	%s: %s, %s\n%s: %s, %s: %s, %s: %s, %s: %s

	%s: %s/%s, %s: %s/%s, %s: %s/%s
	%s (%s): %s, %s: %s/%s
	%s (%s): %s, %s: %s/%s

	%s: %s(%s) %s(%s) %s(%s)]],
					RetName(obj),
					S[547--[[Colonists--]]],#(obj.labels.Colonist or ""),
					S[6859--[[Unemployed--]]],#(obj.labels.Unemployed or ""),Dome_GetWorkingSpace(obj),
					S[7553--[[Homeless--]]],#(obj.labels.Homeless or ""),obj:GetLivingSpace(),
					S[7031--[[Renegades--]]],#(obj.labels.Renegade or ""),
					S[5647--[[Dead Colonists: %s--]]]:format(#(obj.labels.DeadColonist or "")),
					S[6647--[[Guru--]]],#(obj.labels.Guru or ""),
					S[6640--[[Genius--]]],#(obj.labels.Genius or ""),
					S[6642--[[Celebrity--]]],#(obj.labels.Celebrity or ""),
					S[6644--[[Saint--]]],#(obj.labels.Saint or ""),
					S[79--[[Power--]]],obj.electricity.current_consumption / r,obj.electricity.consumption / r,
					S[682--[[Oxygen--]]],obj.air.current_consumption / r,obj.air.consumption / r,
					S[681--[[Water--]]],obj.water.current_consumption / r,obj.water.consumption / r,
					S[1022--[[Food--]]],#(obj.labels.needFood or ""),
					S[4439--[[Going to: %s--]]]:format(food_need),
					S[526--[[Visitors--]]],food_use,food_max,
					S[3862--[[Medic--]]],#(obj.labels.needMedical or ""),
					S[4439--[[Going to: %s--]]]:format(medic_need),
					S[526--[[Visitors--]]],medic_use,medic_max,
					S[302535920000035--[[Grids--]]],
					S[682--[[Oxygen--]]],obj.air.grid.ChoGGi_GridHandle,
					S[681--[[Water--]]],obj.water.grid.ChoGGi_GridHandle,
					S[79--[[Power--]]],obj.electricity.grid.ChoGGi_GridHandle
				)
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
					local text_obj = Text:new()
					local text_orient = Orientation:new()
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
				{text = S[83--[[Domes--]]],value = "Dome"},
				{text = S[3982--[[Deposits--]]],value = "SubsurfaceDeposit"},
				{text = S[80--[[Production--]]],value = "Production"},
				{text = S[517--[[Drones--]]],value = "Drone"},
				{text = S[5433--[[Drone Control--]]],value = "DroneControl"},
				{text = S[885971788025--[[Outside Buildings--]]],value = "OutsideBuildings"},

	--~ 			 {text = S[79--[[Power--]]],value = "Power"},
	--~			 {text = S[81--[[Life Support--]]],value = "Life-Support"},
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
				title = 302535920000333--[[Building Info--]],
				hint = 302535920001280--[[Double-click to toggle text (updates every second).--]],
				custom_type = 7,
				custom_func = CallBackFunc,
			}
		end

	end -- do

	function ChoGGi.MenuFuncs.MonitorInfo()
		local ChoGGi = ChoGGi
		local ItemList = {
			{text = S[302535920000936--[[Something you'd like to see added?--]]],value = "New"},
			{text = "",value = "New"},
			{text = S[302535920000035--[[Grids--]]] .. ": " .. S[891--[[Air--]]],value = "Air"},
			{text = S[302535920000035--[[Grids--]]] .. ": " .. S[79--[[Power--]]],value = "Power"},
			{text = S[302535920000035--[[Grids--]]] .. ": " .. S[681--[[Water--]]],value = "Water"},
			{text = S[302535920000035--[[Grids--]]] .. ": " .. S[891--[[Air--]]] .. "/" .. S[79--[[Power--]]] .. "/" .. S[681--[[Water--]]],value = "Grids"},
			{text = S[302535920000042--[[City--]]],value = "City"},
			{text = S[547--[[Colonists--]]],value = "Colonists",hint = 302535920000937--[[Laggy with lots of colonists.--]]},
			{text = S[5238--[[Rockets--]]],value = "Rockets"},
--~ 			{text = "Research",value = "Research"}
		}
		if ChoGGi.testing then
			ItemList[#ItemList+1] = {text = S[311--[[Research--]]],value = "Research"}
		end

		local function CallBackFunc(choice)
			if choice.nothing_selected then
				return
			end
			local value = choice[1].value
			if value == "New" then
				ChoGGi.ComFuncs.MsgWait(
					S[302535920000033--[[Post a request on Nexus or Github or send an email to: %s--]]]:format(ChoGGi.email),
					302535920000034--[[Request--]]
				)
			else
				ChoGGi.ComFuncs.DisplayMonitorList(value)
			end
		end

		ChoGGi.ComFuncs.OpenInListChoice{
			callback = CallBackFunc,
			items = ItemList,
			title = 302535920000555--[[Monitor Info--]],
			hint = 302535920000940--[[Select something to monitor.--]],
			custom_type = 7,
			custom_func = function(sel)
				ChoGGi.ComFuncs.DisplayMonitorList(sel[1].value,sel[1].parentobj)
			end,
			skip_sort = true,
		}
	end

end
