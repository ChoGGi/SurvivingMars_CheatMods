-- See LICENSE for terms

local table = table
local string_lower = string.lower
local floatfloor = floatfloor

local mod_TextScale
local mod_ShowText
local mod_CompactText

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local scale = CurrentModOptions:GetProperty("TextScale") * guim
	mod_TextScale = point(scale, scale)
	mod_ShowText = CurrentModOptions:GetProperty("ShowText")
	mod_CompactText = CurrentModOptions:GetProperty("CompactText")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local res_count_orig, res_count = {}
local added_objs = {}
local res_str, res_str_c = {}, 0
local res_list, res_list_c
local r

local function GetAvailableResources(self, cursor_obj)
	if not res_list then
		-- build list of resources
		res_list = AllResourcesList
		res_list_c = #res_list
		table.sort(res_list)
		r = const.ResourceScale
		-- build default list
		for i = 1, res_list_c do
			res_count_orig[res_list[i]] = 0
		end
	end

	if self:IsKindOf("Drone") then
		if not self.command_center then
			return T(5672, "Orphaned Drones")
		end
		self = self.command_center
	end

	-- reset to 0
	res_count = table.copy(res_count_orig)
	table.clear(added_objs)

--~ 	ex(cursor_obj)
	local objs = cursor_obj or self.connected_task_requesters or ""
	for i = 1, #objs do
		local obj = objs[i]
		-- don't count counted objs
		if not added_objs[obj] then
			added_objs[obj] = true
			local resource = obj.resource or ""
			if res_count[resource] then
				-- factory storage depots/mini storage depots
				if obj:IsKindOf("ResourceStockpile") then
					res_count[resource] = res_count[resource] + (obj.stockpiled_amount or 0)
				-- wasterock dumping sites
				elseif obj:IsKindOf("WasteRockDumpSite") then
					res_count[resource] = res_count[resource] + (obj.total_stockpiled or 0)
				-- large depots
				elseif obj:IsKindOf("MechanizedDepot") then
					res_count[resource] = res_count[resource] + (obj["GetStored_" .. resource](obj) or 0)
				-- loose piles
				elseif obj:IsKindOf("SurfaceDeposit") then
					res_count[resource] = res_count[resource] + (obj:GetAmount() or 0)
				end
			elseif obj:IsKindOf("StorageDepot") then
				for j = 1, #resource do
					local loop_res = resource[j]
					if res_count[loop_res] then
						res_count[loop_res] = res_count[loop_res] + (obj["GetStored_" .. loop_res](obj) or 0)
					end
				end
			end
		end
	end

--~ 	ex(res_count)

	table.iclear(res_str)
	res_str_c = 0

	local text
	-- only compact for construction cursor
	if mod_CompactText and cursor_obj then
		text = " <"
--~ 		res_str_c = 1
--~ 		res_str[1] = T("<newline>")
	else
		text = cursor_obj and "<newline><resource(res)> <"
			or "<newline><left><resource(res)><right><"
	end

	for i = 1, res_list_c do
		local res = res_list[i]
		local count = res_count[res]
		if count > 0 then
			-- round decimal points
			if cursor_obj then
				count = (floatfloor(count / r)) * r
			end
			res_str_c = res_str_c + 1
			res_str[res_str_c] = T{text .. string_lower(res) .. "(count)>",
				res = res,
				count = count,
			}
		end
	end
--~ 	ex(res_str)

	return table.concat(res_str)
end

RCRover.ChoGGi_GetAvailableResources = GetAvailableResources
RocketBase.ChoGGi_GetAvailableResources = GetAvailableResources
DroneHub.ChoGGi_GetAvailableResources = GetAvailableResources
Drone.ChoGGi_GetAvailableResources = GetAvailableResources

local function AddTemplate(xtemplate)
	if xtemplate.ChoGGi_Added_DroneControllerShowAvailableResources then
		return
	end
	xtemplate.ChoGGi_Added_DroneControllerShowAvailableResources = true
	if xtemplate.RolloverText then
		xtemplate.RolloverText = xtemplate.RolloverText .. T("<newline><ChoGGi_GetAvailableResources>")
	else
		xtemplate.RolloverText = T("<newline><ChoGGi_GetAvailableResources>")
	end
end

function OnMsg.ClassesPostprocess()
	AddTemplate(XTemplates.sectionServiceArea[1])

	local xtemplate = XTemplates.ipDrone[1]
	local idx = table.find(XTemplates.ipDrone[1], "Icon", "UI/Icons/Sections/facility.tga")
	if idx then
		AddTemplate(xtemplate[idx])
	end
end

local rockets = {"RocketLandingSite", "SupplyRocketBuilding"}
local txt_ctrl

local function ClearOldText()
	if txt_ctrl then
		txt_ctrl:Close()
		txt_ctrl = nil
	end
end

-- add text info to building placement
local ChoOrig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding:GameInit(...)
	local ret = ChoOrig_CursorBuilding_GameInit(self, ...)

	-- self-suff domes will fire CursorBuilding:GameInit more than once, so we get whatever is last?
	ClearOldText()

	if not mod_ShowText then
		return ret
	end

	-- DroneHubs or Rockets, not much point in rovers
	local sel_radius = self.template.GetSelectionRadiusScale
	if (sel_radius or self.template:IsKindOfClasses(rockets))
		and not self.template:IsKindOf("Dome")
	then
		-- If it has a radius then use it, otherwise fallback to rocket (for landing sites I think)
		self.ChoGGi_UpdateAvailableResources = sel_radius and sel_radius(self)
			or RocketBase.work_radius
		-- 0 means not a radius building
		if self.ChoGGi_UpdateAvailableResources == 0 then
			return ret
		end
		txt_ctrl = XText:new({
			Id = "ChoGGi_UpdateAvailableResources",
			TextStyle = "PhotoModeWarning",
			-- offset from the status text
			Margins = box(0, 40, 0, 0),
--~ 			Padding = box(0, 40, 0, 0),
			ScaleModifier = mod_TextScale,
		}, Dialogs.HUD)

		txt_ctrl:AddDynamicPosModifier{
			id = "ChoGGi_UpdateAvailableResources_follow_obj",
			target = self,
		}
	end

	return ret
end

local ChoOrig_CursorBuilding_UpdateShapeHexes = CursorBuilding.UpdateShapeHexes
function CursorBuilding:UpdateShapeHexes(...)
	local ret = ChoOrig_CursorBuilding_UpdateShapeHexes(self, ...)

	if txt_ctrl and self.ChoGGi_UpdateAvailableResources then
		-- build list of objs within distance to cursor placing thingy
		local objs = GetRealm(self):MapGet(self, "hex", self.ChoGGi_UpdateAvailableResources,
			"MechanizedDepot", "StorageDepot", "ResourceStockpile", "SurfaceDeposit"
		)
		if objs[1] then
			txt_ctrl:SetText(GetAvailableResources(self, objs))
		else
			txt_ctrl:SetText("")
		end
	end

	return ret
end

local ChoOrig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding.Done(...)
	ClearOldText()
	return ChoOrig_CursorBuilding_Done(...)
end
