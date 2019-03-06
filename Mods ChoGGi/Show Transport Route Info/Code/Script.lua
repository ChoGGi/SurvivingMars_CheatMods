-- See LICENSE for terms

-- local some funcs for faster access
local PolylineSetParabola = PolylineSetParabola
local AveragePoint2D = AveragePoint2D
local IsValid = IsValid
local IsPoint = IsPoint
local FixConstructPos = FixConstructPos
local PlaceObject = PlaceObject
local _InternalTranslate = _InternalTranslate
local type = type
local PlaceText = PlaceText

-- store ref to line,res icon
local line,text
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
function OnMsg.SelectionRemoved()
	RemoveLine()
end
-- make sure line isn't saved in the save file
function OnMsg.SaveGame()
	RemoveLine()
end

local pt_1500 = point(0,0,1500)
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

	line = PlaceObject("Polyline")
	-- FixConstructPos sets z to ground height
	PolylineSetParabola(line, FixConstructPos(route.from), FixConstructPos(route.to))
	line:SetPos(AveragePoint2D(line.vertices))

	-- add floating text
	local res = obj.transport_resource
	local res_type = type(res)
	if res_type ~= "string" and res_type ~= "table" then
		return
	end

	local is_res = Resources[res]
	if is_res then
		text = _InternalTranslate(is_res.display_name)
	else
		text = _InternalTranslate(T(4493,"All"))
	end

	text = PlaceText(
		text,
		-- get centre(ish) point, AveragePoint2D doesn't work since it skips Z
		line.vertices[#line.vertices/2]+pt_1500
	)

	-- nice n big
	text:SetTextStyle("Autosave")
--~ 	-- spins text to face camera
--~ 	text:Attach(PlaceObject("Orientation"))

end

