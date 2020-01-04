-- See LICENSE for terms

local mod_TextScale

-- fired when settings are changed/init
local function ModOptions()
	mod_TextScale = CurrentModOptions:GetProperty("TextScale") * guim
	mod_TextScale = point(mod_TextScale, mod_TextScale)
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local table = table
local MapGet = MapGet

local res_count = {}
local res_str, res_str_c = {}, 0
local res_list, res_list_c
local r

local function GetAvailableResources(self, cursor_obj)
	if not res_list then
		res_list = AllResourcesList
		res_list_c = #res_list
		table.sort(res_list)
		r = const.ResourceScale
	end
	-- reset to 0
	for i = 1, res_list_c do
		res_count[res_list[i]] = 0
	end

	local objs = cursor_obj or self.connected_task_requesters or ""
	for i = 1, #objs do
		local obj = objs[i]
		-- factory storage depots
		if obj:IsKindOf("ResourceStockpile") then
			res_count[obj.resource] = res_count[obj.resource] + obj.stockpiled_amount
		-- storage depots/rockets/wasterock
		elseif obj:IsKindOf("StorageDepot") then
			local resources = obj.resource or ""
			for j = 1, #resources do
				local r = resources[j]
				if r then
					res_count[r] = res_count[r] + (obj["GetStored_" .. r](obj) or 0)
				-- wasterock site
				elseif obj.resource then
					res_count[obj.resource] = res_count[obj.resource] + obj.total_stockpiled
				end
			end
		elseif obj:IsKindOf("SurfaceDeposit") then
			res_count[obj.resource] = res_count[obj.resource] + obj:GetAmount()
		end
	end

	table.iclear(res_str)
	res_str_c = 0

	local text = cursor_obj and "<newline><resource(res)> <"
		or "<newline><left><resource(res)><right><"

	local string_lower = string.lower
	local floatfloor = floatfloor
	for i = 1, res_list_c do
		local res = res_list[i]
		local count = res_count[res]
		if count > 0 then
			-- round out decimals
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
SupplyRocket.ChoGGi_GetAvailableResources = GetAvailableResources
DroneHub.ChoGGi_GetAvailableResources = GetAvailableResources

function OnMsg.ClassesPostprocess()
	local xtemplate = XTemplates.sectionServiceArea[1]
	if xtemplate.ChoGGi_Added_DroneControllerShowAvailableResources then
		return
	end
	xtemplate.ChoGGi_Added_DroneControllerShowAvailableResources = true

	xtemplate.RolloverText = xtemplate.RolloverText .. T("<newline><ChoGGi_GetAvailableResources>")
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
local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding:GameInit(...)
	orig_CursorBuilding_GameInit(self, ...)

	-- self-suff domes will fire this more than once
	ClearOldText()

	-- DroneHubs or Rockets, not much point in rovers
	local sel_radius = self.template.GetSelectionRadiusScale
	if (sel_radius or self.template:IsKindOfClasses(rockets))
		and not self.template:IsKindOf("Dome")
	then
		-- if it has a radius then use it, otherwise fallback to rocket (for landing sites I think)
		self.ChoGGi_UpdateAvailableResources = sel_radius and sel_radius(self)
			or SupplyRocket.work_radius
		-- 0 means not a radius building
		if self.ChoGGi_UpdateAvailableResources == 0 then
			return
		end
		txt_ctrl = XText:new({
			Id = "ChoGGi_UpdateAvailableResources",
			TextStyle = "PhotoModeWarning",
			-- offset from the status text
			Margins = box(0, 5, 0, 0),
			ScaleModifier = mod_TextScale,
		}, Dialogs.HUD)

		txt_ctrl:AddDynamicPosModifier{
			id = "ChoGGi_UpdateAvailableResources_follow_obj",
			target = self,
		}
	end
end

local orig_CursorBuilding_UpdateShapeHexes = CursorBuilding.UpdateShapeHexes
function CursorBuilding:UpdateShapeHexes(...)
	orig_CursorBuilding_UpdateShapeHexes(self, ...)
	if txt_ctrl and self.ChoGGi_UpdateAvailableResources then
		-- not sure why SurfaceDepositGroup don't work?
		local objs = MapGet(self, "hex", self.ChoGGi_UpdateAvailableResources, "StorageDepot", "ResourceStockpile", "SurfaceDeposit")
		if #objs > 0 then
			txt_ctrl:SetText(GetAvailableResources(self, objs))
		else
			txt_ctrl:SetText("")
		end
	end
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding.Done(...)
	ClearOldText()
	return orig_CursorBuilding_Done(...)
end
