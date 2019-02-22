-- See LICENSE for terms

-- custom shuttletask
DefineClass.MarsCompanion_FollowTask = {
	__parents = {"InitDone"},
	state = "new",
	shuttle = false,
	dest_pos = false, -- there isn't one, but adding one prevents log spam
}

DefineClass.MarsCompanion = {
	__parents = {
		"CargoShuttle",
	},
	last_good_pos = false,
	move_speed = 4000,
	boredom_count = false,
}

function MarsCompanion:GameInit()
	self.boredom_count = 0

	-- label stuff
	self.city = self.hub.city or UICity
  self.city:AddToLabel("MarsCompanion", self)

	self:SetState("fly") -- down tubes
	self:PlayFX("Land", "start")

	-- gagarin likes it dark
	self:SetColorModifier(-1)

	self:SetScale(15)
--~ 	self:SetScale(250)

	self:SetColorizationMaterial(1, -14468787, 48, -48)
	self:SetColorizationMaterial(2, -10720910, 127, -128)
	self:SetColorizationMaterial(3, -10461088, 48, 127)

	-- got me
	self:SetEnumFlags(const.efVisible)
	-- drone pusher
	self:SetEnumFlags(const.efCollision)
	-- not for now, maybe we'll do something with it
	self:ClearEnumFlags(const.efSelectable)

	-- dust thread
	self.dust_thread = CreateGameTimeThread(function()
		-- if we local in the thread it isn't caught by debug.getupvalue
		local IsValid = IsValid
		local Sleep = Sleep
		local GetTimeFactor = GetTimeFactor
		local GetHeight = terrain.GetHeight

		while IsValid(self) do
			-- check if our height is low enough for some dust kickup
			local pos = self:GetVisualPos()
			if pos and (pos:z() - GetHeight(pos)) < 1500 then
				-- cough cough
				self:PlayFX("Dust", "start")
				-- break loop if game is paused or height is changed to above 1500, otherwise dust
				while GetTimeFactor() ~= 0 do
					pos = self:GetVisualPos()
					if (pos:z() - GetHeight(pos)) > 1500 then
						break
					end
					Sleep(1000)
				end
				-- loop is done so we can stop the dust
				self:PlayFX("Dust", "end")
			end
			Sleep(1000)
		end

	end)
end

function MarsCompanion:Done()
	local city = self.city or UICity
  self.city:RemoveFromLabel("MarsCompanion", self)

	if IsValidThread(self.dust_thread) then
		DeleteThread(self.dust_thread)
	end
end

-- gets rid of error in log
MarsCompanion.SetTransportTask = empty_func
-- gives an error when we spawn shuttle since i'm using a fake task, so we just return true instead
function MarsCompanion:OnTaskAssigned()
	return true
end

function MarsCompanion:GoHome()
	-- fly up to nowhere and explode?
	Sleep(1000)
	print("goodbye cruel world")
	self:delete()
end

function MarsCompanion:Attach(obj, spot, ...)
	CargoShuttle.Attach(self, obj, spot, ...)

	local valid = IsValid(obj)
	if not valid or valid and obj.class ~= "ParSystem" then
		return
	end

	local name = obj:GetParticlesName()
	if name == "Shuttle_Trail" then
		obj:SetColorModifier(-7096460)
	elseif name == "Shuttle_Trail_Ignition" or name == "Shuttle_Sides_Ignition" then
		obj:SetColorModifier(-16711858)
	end
end

-- if it idles it'll go home, so we return my command till we remove thread
function MarsCompanion:Idle()
	Sleep(1000)
	self:SetCommand("MainLoop")
end

function MarsCompanion:MainLoop()
	local IsValid = IsValid
	local Sleep = Sleep
	local MovePointAway = MovePointAway

	local cGetLookAt = cameraRTS.GetLookAt
	local cGetPos = cameraRTS.GetPos
	local cGetProperties = cameraRTS.GetProperties
	local tIsPointInBounds = terrain.IsPointInBounds
	local tGetHeight = terrain.GetHeight

--~ 	local current_cam_pos = cGetPos()
--~ 	local same_pos_count = 0

	while IsValid(self) do
		local cam = cGetLookAt()
		if not tIsPointInBounds(cam) then
			print("else")
			cam = self.last_good_pos
		end
		local x,y = cam:x(),cam:y()

		local max = (cGetPos():z() - tGetHeight(x,y)) - 10000
		self.hover_height = self.Random(self.min_hover_height,max > self.min_hover_height and max or self.min_hover_height+1)

		if self.hover_height > cGetProperties(1).MaxZoom then
			self.hover_height = 1000
		elseif self.hover_height < self.min_hover_height then
			self.hover_height = self.min_hover_height
		end

		local dest = point(x+self.Random(-15000,15000), y+self.Random(-15000,15000))
		self.last_good_pos = dest

		local path = self:CalcPath(self:GetVisualPos(),dest)

		self:FlyingFace(dest, 2500)
		self:SetState("idle") -- level tubes
		self:FollowPathCmd(path)
		while self.next_spline do
			Sleep(1000)
		end

		self:SetState("fly") -- down tubes
		Sleep(self.Random(2500,10000))

--~ 		if same_pos_count > self.boredom_count then
--~ 			-- your friend is bored
--~ 			self:BoredFriend()
--~ 			same_pos_count = 0
--~ 		end
--~ 		if current_cam_pos == cGetPos() then
--~ 			same_pos_count = same_pos_count + 1
--~ 		end
--~ 		current_cam_pos = cGetPos()

	end

	-- buh-bye little flying companion
	self:SetCommand("GoHome")
end

function MarsCompanion:GotoPos(drone)
	local path = self:CalcPath(self:GetVisualPos(),drone:GetVisualPos())

	self:FlyingFace(path, 2500)
	self:FollowPathCmd(path)
	while self.next_spline do
		Sleep(1000)
	end

end

local function IdleDroneInAir()
	Sleep(1000)
end

function MarsCompanion:BoredFriend()
	local rand = self.Random(-10,10)

	rand = 0

	if rand > 0 then
		print(">")
	elseif rand < 0 then
		print("<")
	else -- 0
		print(0)
		self.hover_height = 100

		local drone = FindNearest("Drone", self:GetVisualPos())
		drone:SetEnumFlags(const.efCollision)

		local drone_pos = drone:GetVisualPos()
		while self:GetVisualPos():Dist2D(drone_pos) > 500 do
			-- keep at it
			if not IsValid(drone) then
				drone = FindNearest("Drone", self:GetVisualPos())
			end
			self:SetState("idle") -- level tubes
			self:GotoPos(drone_pos)
			drone_pos = drone:GetVisualPos()
		end
		self:SetState("fly") -- down tubes

		-- stick drone on shuttle
		self:Attach(drone,self:GetSpotBeginIndex("Origin"))
		drone:SetAttachOffset(point(0,0,325))
		drone.ChoGGi_SetCommand = drone.SetCommand
		drone.SetCommand = IdleDroneInAir

		local blds = self.city.labels.OutsideBuildings or ""
		local new_pos = GetRandomPassableAround(
			blds[self.Random(1,#blds)]:GetPos(),
			10000, 1000, self.city
		)
		self.hover_height = self.Random(self.min_hover_height,5000)
		self:GotoPos(new_pos)
		drone:Detach()

	end

end
