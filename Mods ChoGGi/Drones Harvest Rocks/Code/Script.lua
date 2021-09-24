-- See LICENSE for terms

local MapFindNearest = MapFindNearest
local IsValid = IsValid
local Sleep = Sleep
local PlayFX = PlayFX
local GetRandomPassableAround = GetRandomPassableAround
local TransformToStockpile = WasteRockObstructor.TransformToStockpile
local efSelectable = const.efSelectable
local GetCursorOrGamePadSelectObj = ChoGGi.ComFuncs.GetCursorOrGamePadSelectObj

function Drone:ChoGGi_RockRemove(rock)
	self:Face(rock, 100)

	PlayFX("Deconstruct", "start", self)
	self:PlayState("gatherStart")

	self:SetState("gatherIdle")
	-- we split in half so when the hands reach back it'll shrink
	local dur = self:GetAnimDuration("gatherIdle") / 2

	local scale = 100
	while scale > 0 do
		Sleep(dur)
		scale = scale - 15
		rock:SetScale(scale)
		Sleep(dur)
	end

	self:PlayState("gatherEnd")
	PlayFX("Deconstruct", "end", self)

	if rock.TransformToStockpile then
		rock:TransformToStockpile(self)
	else
		TransformToStockpile(rock, self)
	end
end

local function DroneRemoveRock(rock)
--~ 	if not rock.TransformToStockpile then
--~ 		return
--~ 	end
	if rock:IsKindOf("WasteRockObstructor") or rock:IsKindOf("StoneSmall") then
		local rock_pos = rock:GetPos()

		local drone = MapFindNearest(rock_pos, "map", "Drone", efSelectable, function(d)
			if d.command == "Idle" then
				return true
			end
		end)
		if not drone then
			return
		end

		local pos = GetRandomPassableAround(rock_pos, 500)
		if pos then

			-- only add one
			if not rock:GetAttaches("RotatyThing") then
				-- let user know
				local rotate = PlaceObject("RotatyThing")
				rock:Attach(rotate)
--~ 				rock:SetAttachOffset(point(0, 0, rock:GetPos():SetTerrainZ(5000):z()))
			end

			GetCommandFunc(drone)(drone, "Goto", pos:SetTerrainZ())

			-- good enough
			while drone.command ~= "Idle" and drone.command ~= "GoHome" do
				Sleep(250)
			end

			GetCommandFunc(drone)(drone, "ChoGGi_RockRemove", rock)
		end
	end
end

local ChoOrig_CanDemolish = DemolishModeDialog.CanDemolish
function DemolishModeDialog:CanDemolish(pt, obj, ...)
	obj = obj or GetCursorOrGamePadSelectObj()
	if IsValid(obj) then
		if obj:IsKindOf("WasteRockObstructor") or obj:IsKindOf("StoneSmall") then
			return true
		end
	end

	return ChoOrig_CanDemolish(self, pt, obj, ...)
end

local ChoOrig_OnMouseButtonDown = DemolishModeDialog.OnMouseButtonDown
function DemolishModeDialog:OnMouseButtonDown(pt, button, obj, ...)
	if button == "L" then
		obj = obj or GetCursorOrGamePadSelectObj()
		if IsValid(obj) then
			if obj:IsKindOf("WasteRockObstructor") or obj:IsKindOf("StoneSmall") then
				CreateGameTimeThread(DroneRemoveRock, obj)
				return "break"
			end
		end
	end

	return ChoOrig_OnMouseButtonDown(self, pt, button, obj, ...)
end
