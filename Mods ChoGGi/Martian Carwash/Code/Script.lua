-- See LICENSE for terms

--~ s:SetDust(1000, const.DustMaterialExterior)

local description_text = [[Working at the car wash
Working at the car wash, yeah
Come on and sing it with me, car wash
Sing it with the feeling now, car wash, yeah]]

local CreateGameTimeThread = CreateGameTimeThread
local DeleteThread = DeleteThread
local IsValid = IsValid
local IsValidThread = IsValidThread
local NearestObject = NearestObject
local Sleep = Sleep
local Wakeup = Wakeup
local testbit = testbit
local HexNeighbours = HexNeighbours
local HexGetBuilding = HexGetBuilding
local WorldToHex = WorldToHex
local IsBuildableZone = IsBuildableZone
local GetMaxHeightInHex = GetMaxHeightInHex
local PlaceObject = PlaceObject
local Max = Max

DefineClass.Carwash = {
	__parents = {
		"Building",
		"ElectricityConsumer",
		"LifeSupportConsumer",
		"OutsideBuildingWithShifts",
		"ColdSensitive",
	},

	-- stuff from water tanks
	building_update_time = 10000,

	-- stuff from farm
	properties = {
		{ template = true, id = "water_consumption", name = T(656, "Water consumption"),	category = "Consumption", editor = "number", default = 0, scale = const.ResourceScale, read_only = true, modifiable = true },
		{ template = true, id = "air_consumption",	 name = T(657, "Oxygen Consumption"), category = "Consumption", editor = "number", default = 0, scale = const.ResourceScale, read_only = true, modifiable = true },
	},

	-- conventional farm
	anim_thread = false,

	nearby_thread = false,
	marker = false,
}

local function SprinklerColour(attach, color)
	if attach:GetParticlesName() == "HydroponicFarm_Shower" then
		attach:SetColorModifier(color or -10197916)
	end
end

local DustMaterialExterior = const.DustMaterialExterior
function Carwash:GameInit()
	self.description = description_text

	self.sprinkler = self:GetAttach("FarmSprinkler")
	local sprinkler = self.sprinkler

	self:StartAnimThread(sprinkler)

	self.nearby_thread = CreateGameTimeThread(function()
		while IsValid(self) and not self.destroyed do
			if self.working then
				local obj = nil
				-- check for anything on the "tarmac"
				obj = NearestObject(self, UICity.labels.Unit or {}, 1000)
				-- if so clean them
				if obj then
					-- get dust amount, and convert to percentage
					local dust_amt = (obj:GetDust() + 0.0) / 100
					if dust_amt ~= 0.0 then
						local value = 100
						sprinkler:ForEachAttach(SprinklerColour, -8249088)
						while true do
							if value == 0 then
								break
							end
							value = value - 1
							obj:SetDust(dust_amt * value, DustMaterialExterior)
							Sleep(100)
						end
						sprinkler:ForEachAttach(SprinklerColour, -10197916)
					end
				end
			end
			Sleep(1000)
		end
	end)

	-- make it look like not farm colours
	self:SetColorModifier(-16777216)

	-- remove the lights/etc
	self:DestroyAttaches{"DecorInt_10", "LampInt_04"}

	-- remove collision so we can drive over it
	self:ClearEnumFlags(const.efCollision + const.efApplyToGrids)
end

function Carwash:StartAnimThread(sprinkler)
	sprinkler = sprinkler or self.sprinkler
	if not sprinkler then
		return
	end

	-- FarmConventional:StartAnimThread
	self.anim_thread = CreateGameTimeThread(function()
		while IsValid(self) and not self.destroyed do
			local working = self.working
			if working and not self.is_up then
				sprinkler:SetAnim(1, "workingStart")
				Sleep(sprinkler:TimeToAnimEnd())
				PlayFX("FarmWater", "start", sprinkler)

--~ 				sprinkler.fx_actor_class = "AlienDigger"
--~ 				PlayFX("Deconstruct", "start", sprinkler)
--~ 				sprinkler.fx_actor_class = false

				self.is_up = true

				-- larger spray
				sprinkler:ForEachAttach("ParSystem", function(a)
					if a:GetParticlesName() == "HydroponicFarm_Shower" then
						a:SetScale(250)
					end
				end)

			elseif not working and self.is_up then
				PlayFX("FarmWater", "end", sprinkler)

--~ 				sprinkler.fx_actor_class = "AlienDigger"
--~ 				PlayFX("Deconstruct", "end", sprinkler)
--~ 				sprinkler.fx_actor_class = false

				sprinkler:SetAnim(1, "workingEnd")
				Sleep(sprinkler:TimeToAnimEnd())
				self.is_up = false

			end

			-- if working state changed start over, otherwise set appropritate idle state, fire fx and wait
			if working == self.working then
				sprinkler:SetAnim(1, working and "workingIdle" or "idle")
				WaitWakeup()
			end
		end
	end)

end

function Carwash:OnSetWorking(working)
	OutsideBuildingWithShifts.OnSetWorking(self, working)
	ElectricityConsumer.OnSetWorking(self, working)

	if IsValidThread(self.anim_thread) then
		Wakeup(self.anim_thread)
	else
		FarmConventional.StartAnimThread(self)
	end
end

function Carwash:UpdateAttachedSigns()
	ElectricityConsumer.UpdateAttachedSigns(self)

	LifeSupportConsumer.UpdateAttachedSigns(self)
end

function Carwash:Done()
	FarmConventional.Done(self)
	if IsValidThread(self.nearby_thread) then
		DeleteThread(self.nearby_thread)
	end
end

-- we want main points, but no dust
-- wtf are the main points?
Carwash.SetDust = empty_func

function Carwash:OnDestroyed()
	-- delete the threads
	self:Done()

	-- make sure sprinkler is stopped
	if self.sprinkler then
--~ 		self.sprinkler.fx_actor_class = "AlienDigger"
--~ 		PlayFX("Deconstruct", "end", self.sprinkler)
--~ 		self.sprinkler.fx_actor_class = false
		PlayFX("FarmWater", "end", self.sprinkler)
		self.sprinkler:SetAnim(1, "workingEnd")
	end
end

function Carwash:AddFakeMarkers(list)
	-- we need to add extra marker and move them to the correct places
	self:ForEachAttach("GridTileWater", function(a)
		-- they're normally made invis because they're "under" a building
		a:SetVisible(true)

		local offset = a:GetAttachOffset()
		local num = a:GetAttachSpot()

		a:SetAttachOffset(offset:SetX(-325):SetY(-1000))

		-- add 3 extra markers to each spot (SetObjWaterMarkers adds one to each spot)
		for i = 1, 3 do
			local marker = PlaceObject("GridTileWater", nil, const.cfComponentAttach)
			self:Attach(marker, num)
			marker:SetAttachAngle(- marker:GetAngle())
			marker:SetAttachOffset(0, 0, offset:z())
			if i == 1 then
				marker:SetAttachOffset(offset:SetX(-325):SetY(1000))
			elseif i == 2 then
				marker:SetAttachOffset(offset:SetX(-1200):SetY(500))
			elseif i == 3 then
				marker:SetAttachOffset(offset:SetX(-1200):SetY(-500))
			end

			if list then
				list[#list + 1] = marker
			end
		end

	end)
end

-- fake the pipe hookups
local orig_SetObjWaterMarkers = SetObjWaterMarkers
function SetObjWaterMarkers(obj, show, list, ...)
	local marked = orig_SetObjWaterMarkers(obj, show, list, ...)
	-- means it found n added markers then made them invis since they're "touching" the building
	if marked and show == true and obj:IsKindOf("Carwash") then
		obj:AddFakeMarkers(list)
	end
	return marked
end

-- needed by SetObjWaterMarkers() in construction.lua
local orig_HasSpot = g_CObjectFuncs.HasSpot
function Carwash:HasSpot(name, ...)
	if name == "Lifesupportgrid" then
		return true
	end
	return orig_HasSpot(self, name, ...)
end
--
local orig_GetSpotRange = g_CObjectFuncs.GetSpotRange
function Carwash:GetSpotRange(name, ...)
	if name == "Lifesupportgrid" then
		-- the lamp spots work for my needs
		return 4, 6
	end
	return orig_GetSpotRange(self, name, ...)
end

local GetPipeConnections = {
	-- hex_point, direction (0..5), spot-index, entity-to-attach, something else
	-- i only need 4 per, but i'm lazy
	{point(1, -2), 0, 4, "SignWater"},
	{point(1, -2), 1, 4, "SignWater"},
	{point(1, -2), 2, 4, "SignWater"},
	{point(1, -2), 3, 4, "SignWater"},
	{point(1, -2), 4, 4, "SignWater"},
	{point(1, -2), 5, 4, "SignWater"},
	----------------------------------
	{point(-2, 1), 0, 5, "SignWater"},
	{point(-2, 1), 1, 5, "SignWater"},
	{point(-2, 1), 2, 5, "SignWater"},
	{point(-2, 1), 3, 5, "SignWater"},
	{point(-2, 1), 4, 5, "SignWater"},
	{point(-2, 1), 5, 5, "SignWater"},
	----------------------------------
	{point(1, 1), 0, 6, "SignWater"},
	{point(1, 1), 1, 6, "SignWater"},
	{point(1, 1), 2, 6, "SignWater"},
	{point(1, 1), 3, 6, "SignWater"},
	{point(1, 1), 4, 6, "SignWater"},
	{point(1, 1), 5, 6, "SignWater"},
}

function Carwash.GetPipeConnections()
	return GetPipeConnections
end

-- change the plugs to seams to hide our lack of tube
local orig_LifeSupportGridElement_UpdateVisuals = LifeSupportGridElement.UpdateVisuals
function LifeSupportGridElement:UpdateVisuals(supply_resource, ...)
	local result = orig_LifeSupportGridElement_UpdateVisuals(self, supply_resource, ...)

	-- check for connections to a carwash and make it the seam entity
	if result then
		-- make sure we're using the correct entity
		local skin = self:GetSkinFromGrid(self:GetGridSkinName()).TubeJointSeam
		local my_q, my_r = WorldToHex(self)
		local conn = self.conn
		for dir = 0, 5 do
			if testbit(conn, dir) then
				local dq, dr = HexNeighbours[dir + 1]:xy()
				local bld = HexGetBuilding(my_q + dq, my_r + dr)

				if bld and bld:IsKindOf("Carwash") then
					local bld_angle = 180 * 60 + dir * 60 * 60
					-- from SetAttachAngle to GetAttachAngle the numbers change (rotation loops over?)
					local neg = bld_angle - 21600
					self:ForEachAttach("TubeHubPlug", function(a)
						-- check the angle of the attach to make sure we only change the correct one
						local angle = a:GetAttachAngle()
						if angle == bld_angle or angle == neg then
							a:ChangeEntity(skin)
						end
					end)
				end

			end
		end
	end

	return result
end

-- add building to building template list
function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.Carwash then
		PlaceObj("BuildingTemplate", {
			"Id", "Carwash",
			"template_class", "Carwash",
			"dome_forbidden", true,
			"display_name", [[Martian Carwash]],
			"display_name_pl", [[Martian Carwashes]],
			"description", description_text,
			"build_category", "ChoGGi",
			"Group", "ChoGGi",
			"display_icon", CurrentModPath .. "UI/carwash.png",
			"entity", "Farm",
			"electricity_consumption", 2500,
			"water_consumption", 1000,
			"air_consumption", 0,
			"construction_cost_Concrete", 20000,
			"construction_cost_Metals", 15000,
			"construction_cost_Electronics", 1000,
			"construction_cost_Polymers", 1000,
			"maintenance_resource_type", "Metals",
			"maintenance_resource_amount", 1000,
			"demolish_sinking", range(1, 5),
		})
	end
end --ClassesPostprocess

-- dust buildup during storms
function Carwash:GetUIWarning()
	return Building.GetUIWarning(self) or g_DustStorm and NotWorkingWarning.SuspendedDustStorm
end
