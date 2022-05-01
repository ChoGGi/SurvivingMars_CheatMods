-- See LICENSE for terms

local RetSpotPos = ChoGGi.ComFuncs.RetSpotPos
local IsValid = IsValid
local FindNearestObject = FindNearestObject
local GetPassablePointNearby = GetPassablePointNearby
local Sleep = Sleep
local empty_table = empty_table

local mod_NearestLaser
local mod_NearestHub

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_NearestLaser = CurrentModOptions:GetProperty("NearestLaser")
	mod_NearestHub = CurrentModOptions:GetProperty("NearestHub")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function IdleTime(self)
	self:SetState("idle")
	Sleep(5000)
	self:SetCommand("Idle")
end

local function IsWorking(obj)
	return obj.working
end

-- for rovers without automode
local IsAutoModeEnabled = AutoMode.IsAutoModeEnabled

local function WaitItOut(idle_func, self, ...)
	if IsAutoModeEnabled(self) and g_MeteorStorm then
		if (mod_NearestLaser or mod_NearestHub) and not self.ChoGGi_AutoRoversDuringStorms then
			local valid_obj, working_objs

			local labels = UICity.labels

			if mod_NearestLaser then
				-- try lasers first since towers are from mystery (usually)
				working_objs = GetRealm(self):MapFilter(labels.MDSLaser or empty_table, IsWorking)
				valid_obj = FindNearestObject(working_objs, self)

				if not IsValid(valid_obj) then
					working_objs = GetRealm(self):MapFilter(labels.DefenceTower or empty_table, IsWorking)
					valid_obj = FindNearestObject(working_objs, self)
				end
			end

			if mod_NearestHub and not IsValid(valid_obj) then
				working_objs = GetRealm(self):MapFilter(labels.DroneHub or empty_table, IsWorking)
				valid_obj = FindNearestObject(working_objs, self)
			end

			-- make sure we don't keep looping through here
			self.ChoGGi_AutoRoversDuringStorms = valid_obj or true

			-- off we go
			if IsValid(valid_obj) then
				local pos = GetPassablePointNearby(RetSpotPos(self, valid_obj, "Workrover"))
				self:SetCommand("GotoFromUser", pos)
			else
				-- something messed up, or there's no buildings to hide around
				IdleTime(self)
			end

		else
			IdleTime(self)
		end
	else
		if self.ChoGGi_AutoRoversDuringStorms then
			self.ChoGGi_AutoRoversDuringStorms = nil
		end
		return idle_func(self, ...)
	end
end

-- replace some idles
local classes = {
	"ExplorerRover",
	"RCTransport",
	"RCHarvester",
	"RCTerraformer",
}
local g = _G
for i = 1, #classes do
	local cls_obj = g[classes[i]]
	local idle_func = cls_obj.Idle
	function cls_obj:Idle(...)
		return WaitItOut(idle_func, self, ...)
	end
end
