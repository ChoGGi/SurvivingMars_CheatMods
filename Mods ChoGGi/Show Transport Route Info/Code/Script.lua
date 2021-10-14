-- See LICENSE for terms

local mod_EnableText
local mod_EnableIcon

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableText = CurrentModOptions:GetProperty("EnableText")
	mod_EnableIcon = CurrentModOptions:GetProperty("EnableIcon")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- local some globals
local type = type
local AveragePoint2D = AveragePoint2D
local IsValid = IsValid
local IsPoint = IsPoint
local FixConstructPos = FixConstructPos
local T = T

local PolylineSetParabola = ChoGGi.ComFuncs.PolylineSetParabola

-- store ref to line, res icon
local line, text
-- removes line when selection changes
local function RemoveLine()
	if IsValid(line) then
		line:delete()
	end
	if IsValid(text) then
		text:delete()
	end
end

-- remove line when selection done
OnMsg.SelectionRemoved = RemoveLine
-- make sure line isn't saved in the save file
OnMsg.SaveGame = RemoveLine

local OPolyline
local res_list
function OnMsg.ClassesBuilt()
	OPolyline = ChoGGi_OPolyline
	res_list = Resources
end

local pt_1500 = point(0, 0, 1500)
function OnMsg.SelectionAdded(obj)
	-- always remove it (since we add a new one each time)
	RemoveLine()

	-- nothing else has transport routes
	if not obj:IsKindOf("RCTransport") then
		return
	end

	local route = obj.transport_route
	-- just in case
	if not IsPoint(route.from) or not IsPoint(route.to) then
		return
	end

	local terrain = GetTerrain(obj.city or UICity)

	line = OPolyline:new()
	-- FixConstructPos sets z to ground height
	PolylineSetParabola(line, FixConstructPos(terrain, route.from), FixConstructPos(terrain, route.to))
	local avg = AveragePoint2D(line.vertices)
	line:SetPos(avg)

	-- add floating text
	local res = obj.transport_resource or obj.can_pickup_from_resources
	local res_type = type(res)
	if res_type ~= "string" and res_type ~= "table" then
		return
	end

	local name, icon
	local res_item = res_list[res]
	if res_item then
		name = T(res_item.display_name)
		icon = res
	else
		name = T(4493, "All")
		icon = "Work"
	end

	name = (mod_EnableIcon
			and T(const.TagLookupTable["icon_" .. icon]:gsub("1300", "3500")) or ""
		) .. " " .. (mod_EnableText and name or "")

	if name then
		local ctrl = Dialogs.HUD.idtxtConstructionStatus
		ctrl:SetVisible(true)
		ctrl:SetText(name)

		ctrl:AddDynamicPosModifier{id = "transport_info",
			target = FixConstructPos(terrain, avg) + pt_1500,
		}
	end

end

-- make sure the text stays on the screen
local ChoOrig_UpdateCursorText = UnitDirectionModeDialog.UpdateCursorText
function UnitDirectionModeDialog:UpdateCursorText(...)
	if self.unit and self.unit:IsKindOf("RCTransport") then
		local route = self.unit.transport_route
		if (IsPoint(route.from) and IsPoint(route.to)) then
			return
		end
	end
	return ChoOrig_UpdateCursorText(self, ...)
end
