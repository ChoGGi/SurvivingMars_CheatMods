-- See LICENSE for terms

local mod_iddqd

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_iddqd = CurrentModOptions:GetProperty("iddqd")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

GlobalVar("g_RCMechanicRepairing", {})

local display_icon = CurrentModPath .. "UI/rover_combat.png"

DefineClass.RCMechanic = {
	__parents = {
		"BaseRover",
		"ComponentAttach",
	},
	description = T(302535920011194, [[Give me your tired, your poor,
Your huddled masses yearning to breathe free,
The wretched refuse of your teeming shore.]]),

	going_to_repair = false,
	blinky = false,
	repairing_list = false,

	entity = "CombatRover",
	accumulate_dust = false,
	status_text = T(6722, "Idle"),
	-- refund res
	on_demolish_resource_refund = { Metals = 20 * const.ResourceScale, MachineParts = 20 * const.ResourceScale , Electronics = 10 * const.ResourceScale },

	-- show the pin info
	pin_rollover = T(51, "<ui_command>"),
	-- needed for pinned icon
	display_icon = display_icon,
	-- picard dlc
  environment_entity = {
    base = "CombatRover",
  },
}

DefineClass.RCMechanicBuilding = {
	__parents = {"BaseRoverBuilding"},
	rover_class = "RCMechanic",
}

local skip_cmds = {
	Dead = true,
	Malfunction = true,
}
function RCMechanic:SetCommand(command, ...)
  if mod_iddqd and skip_cmds[command] then
    return
  end
	return BaseRover.SetCommand(self, command, ...)
end

function RCMechanic:AddBlinky()
	if IsValid(self.blinky) then
		return
	end

	-- add a blinky
	self.blinky = RotatyThing:new()
	self.blinky:SetVisible()

	self:Attach(self.blinky)

	-- move blinky above bar thingy
	local offsetx, offsety = (self:GetVisualPos() - MovePointAway(
		self:GetSpotLoc(self:GetSpotBeginIndex("Origin")),
		self:GetSpotLoc(self:GetSpotBeginIndex("Particle1")),
		200
	)):xy()

	self.blinky:SetAttachOffset(
		point(offsetx, offsety, self:GetObjectBBox():sizez() or 100)
	)
end

function RCMechanic:GameInit()
	self:AddBlinky()

	-- select sounds
	self.fx_actor_class = "AttackRover"
	-- Colour #, Colour, Roughness, Metallic (r/m go from -128 to 127)
	-- middle area
	self:SetColorizationMaterial(1, -9175040, -128, 120)
	-- body
	self:SetColorizationMaterial(2, -5987164, 120, 20)
	-- color of bands
	self:SetColorizationMaterial(3, -5694693, -128, 48)

end

function RCMechanic:Getui_command()
	return self.status_text
end

function RCMechanic:GotoFromUser(...)
	self.status_text = T(63, "Travelling")
	return BaseRover.GotoFromUser(self, ...)
end

-- for auto mode
function RCMechanic:ProcAutomation()
	self.repairing_list = self.repairing_list or g_RCMechanicRepairing or {}

	local unreachable_objects = self:GetUnreachableObjectsTable() or {}
	local HourDuration = const.HourDuration

	local rover = MapFindNearest(self, "map", "BaseRover", "Drone" , function(o)
		local go_fix_it
		-- check for rovers without a cc or if all cc nearby have no working drones
		if o.command == "Malfunction" then
			-- can't hurt
			if o:IsKindOf("BaseRover") then
				if not o.repair_work_request:CanAssignUnit() then
					return
				end
			elseif o:IsKindOf("Drone") then
				if not table.find(g_BrokenDrones, "handle", o.handle) then
					return
				end
			end

			-- If has cc then check if they can fix, otherwise fix it
			local cc = o.command_centers
			if cc and #cc > 0 then
				local cc_count = #cc
				local not_working_count = 0
				for i = 1, cc_count do
					local centre = cc[i]
					local drones_count = centre:GetDronesCount()
					-- check for cc with no drones or all drones are malf'd
					if drones_count == 0
						or drones_count == centre:GetBrokenDronesCount()
					then
						not_working_count = not_working_count + 1
					end
				end
				-- If all cc nearby have no working drones
				if not_working_count == cc_count then
					go_fix_it = true
				end
			else
				-- no cc
				go_fix_it = true
			end

		end

		-- return rover obj if it isn't in the unreachable list
		if go_fix_it then
			return not unreachable_objects[o]
		end
	end)

	if rover then
		local visual_pos = rover:GetVisualPos()
		-- don't go if someone else is on the job
		local string_pos = tostring(visual_pos)
		if self.repairing_list[string_pos] then
			return HourDuration
		end
		self.repairing_list[string_pos] = true

		local pos = GetPassablePointNearby(visual_pos)
		if self:HasPath(pos, "Workrover") then
			self.status_text = T{302535920011195, [[Was the dark of the moon on the sixth of June
In a <color 199 124 45><name></color> pullin' logs
Cab-over Pete with a reefer on
And a Jimmy haulin' hogs
We is headin' for bear on I-one-oh
'Bout a mile outta Shaky Town
I says, "Pig Pen, this here's the Rubber Duck.
And I'm about to put the hammer down."]], name = rover.name ~= "" and rover.name or rover.class}

			-- add a pretty light
			self:AddBlinky()
			self.blinky:SetVisible(true)
			self.going_to_repair = string_pos
			-- vrrrooom
			self.move_speed = 2 * self.base_move_speed
			-- and we're off
			self:Goto(pos)
			self.status_text = T(6924, "Repair")
			self:SetState("idle")
			rover:RCMech_CleanAndFix()
			return HourDuration
		else
			unreachable_objects[rover] = true
		end
	else
		return HourDuration
	end
	return 1000
end

function RCMechanic:Idle()
	if self.going_to_repair then
		self:AddBlinky()
		self.blinky:SetVisible(false)
		self.move_speed = self.base_move_speed
		self.repairing_list[self.going_to_repair] = nil
		self.going_to_repair = false
	end

	self.status_text = T(6722, "Idle")
	local sleep = self:ProcAutomation()
	self:SetState("idle")

	Sleep(sleep or 1000)
	self:Gossip("Idle")
end

function OnMsg.ClassesPostprocess()
	if BuildingTemplates.RCMechanicBuilding then
		return
	end

	PlaceObj("BuildingTemplate", {

		-- added, not uploaded
		"disabled_in_environment1", "",
		"disabled_in_environment2", "",
		"disabled_in_environment3", "",
		"disabled_in_environment4", "",

		"Id", "RCMechanicBuilding",
		"template_class", "RCMechanicBuilding",
		-- pricey?
		"construction_cost_Metals", 40000,
		"construction_cost_MachineParts", 40000,
		"construction_cost_Electronics", 20000,
		-- add a bit of pallor to the skeleton
		"palettes", AttackRover.palette,

		"dome_forbidden", true,
		"display_name", T(302535920011193, "RC Mechanic"),
		"display_name_pl", T(302535920011193, "RC Mechanic"),
		"description", T(302535920011194, [[Give me your tired, your poor,
Your huddled masses yearning to breathe free,
The wretched refuse of your teeming shore.]]),
		"build_category", "ChoGGi",
		"Group", "ChoGGi",
		"display_icon", display_icon,
		"encyclopedia_exclude", true,
		"on_off_button", false,
		"entity", "CombatRover",
	})
end

-- RCMech_CleanAndFix
local DustMaterialExterior = const.DustMaterialExterior
local function RCMech_ResetDust(self)
	self.dust = self:GetDustMax()-1
	self:SetDustVisuals()
	Sleep(10)

	-- get dust amount, and convert to percentage
	local dust_amt = (self:GetDust() + 0.0) / 100
	if dust_amt ~= 0.0 then
		local value = 100
		while true do
			if value == 0 or not IsValid(self) then
				break
			end
			value = value - 1
			self:SetDust(dust_amt * value, DustMaterialExterior)
			Sleep(50)
		end
	end
end
Drone.RCMech_ResetDust = RCMech_ResetDust
BaseRover.RCMech_ResetDust = RCMech_ResetDust

Drone.RCMech_CleanAndFix = function(self)
	if not IsValid(self) then
		return
	end
	self.auto_connect = false
	if self.malfunction_end_state then
		self:PlayState(self.malfunction_end_state, 1)
	end

	self:RCMech_ResetDust()
	if self.command == "NoBattery" then
		self.battery = self.battery_max
		self:SetCommand("Fixed", "noBatteryFixed")
	elseif self.command == "Malfunction" or self.command == "Freeze" and self:CanBeThawed() then
		self:SetCommand("Fixed", "breakDownFixed")
	else
		self:SetCommand("Fixed", "Something")
	end

	RebuildInfopanel(self)
end
BaseRover.RCMech_CleanAndFix = function(self)
	if not IsValid(self) then
		return
	end
	self:RCMech_ResetDust()
	self:Repair()
end
