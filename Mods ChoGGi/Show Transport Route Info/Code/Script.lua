-- See LICENSE for terms

-- local some funcs for faster access
local type = type
local AveragePoint2D = AveragePoint2D
local IsValid = IsValid
local IsPoint = IsPoint
local FixConstructPos = FixConstructPos
--~ local PlaceObject = PlaceObject
local _InternalTranslate = _InternalTranslate
--~ local PlaceText = PlaceText

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

local OPolyline,OText
local res_list
function OnMsg.ClassesBuilt()
	OPolyline = ChoGGi_OPolyline
	OText = ChoGGi_OText
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
	if not (IsPoint(route.from) and IsPoint(route.to)) then
		return
	end

	line = OPolyline:new()
	-- FixConstructPos sets z to ground height
	PolylineSetParabola(line, FixConstructPos(route.from), FixConstructPos(route.to))
	line:SetPos(AveragePoint2D(line.vertices))

	-- add floating text
	local res = obj.transport_resource or obj.can_pickup_from_resources
	local res_type = type(res)
	if res_type ~= "string" and res_type ~= "table" then
		return
	end

	local name,res_item = "",res_list[res]
	if res_item then
		name = _InternalTranslate(res_item.display_name)
	else
		name = _InternalTranslate(T(4493, "All"))
	end

	text = OText:new()
	text:SetText(name)
	-- use centre(ish) point, AveragePoint2D doesn't work since it skips Z
	text:SetPos(line.vertices[#line.vertices / 2] + pt_1500)

	-- nice n big
	text:SetTextStyle("Autosave")
end

