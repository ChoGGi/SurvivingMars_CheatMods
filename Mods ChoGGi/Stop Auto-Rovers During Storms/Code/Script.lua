-- See LICENSE for terms

local options
local mod_NearestLaser
local mod_NearestHub

-- fired when settings are changed/init
local function ModOptions()
	mod_NearestLaser = options.NearestLaser
	mod_NearestHub = options.NearestHub
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_StopAutoRoversDuringStorms" then
		return
	end

	ModOptions()
end

local function IdleTime(self)
	self:SetState("idle")
	Sleep(5000)
	self:SetCommand("Idle")
end

local function IsWorking(obj)
	return obj.working
end

local function WaitItOut(idle_func, self, ...)
	if self.auto_mode_on and g_MeteorStorm then
		if (mod_NearestLaser or mod_NearestHub) and not self.ChoGGi_AutoRoversDuringStorms then
			local valid_obj, working_objs

			if mod_NearestLaser then
				-- try lasers first since towers are from mystery (usually)
				working_objs = MapFilter(UICity.labels.MDSLaser or empty_table, IsWorking)
				valid_obj = FindNearestObject(working_objs, self)

				if not IsValid(valid_obj) then
					working_objs = MapFilter(UICity.labels.DefenceTower or empty_table, IsWorking)
					valid_obj = FindNearestObject(working_objs, self)
				end
			end

			if mod_NearestHub and not IsValid(valid_obj) then
				working_objs = MapFilter(UICity.labels.DroneHub or empty_table, IsWorking)
				valid_obj = FindNearestObject(working_objs, self)
			end

			-- make sure we don't keep looping through here
			self.ChoGGi_AutoRoversDuringStorms = valid_obj or true

			-- off we go
			if IsValid(valid_obj) then
				local pos = GetPassablePointNearby(ChoGGi.ComFuncs.RetSpotPos(self, valid_obj, "Workrover"))
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
