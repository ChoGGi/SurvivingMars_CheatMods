-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 55
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[RC Mechanic requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				if p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/505/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/89?tab=files")
				end
			end
		end)
	end
end

local name = [[RC Mechanic]]
local description = [[Give me your tired, your poor,
Your huddled masses yearning to breathe free,
The wretched refuse of your teeming shore.]]
local display_icon = string.format("%sUI/rover_combat.png",CurrentModPath)
local idle_text = _InternalTranslate(T(295--[[Idle--]]))
local travel_text = _InternalTranslate(T(63--[[Travelling--]]))

DefineClass.RCMechanic = {
	__parents = {
		"BaseRover",
		"ComponentAttach",
	},
  name = name,
	description = description,
	display_icon = display_icon,
	display_name = name,

	entity = "CombatRover",
	accumulate_dust = false,
	status_text = idle_text,
	-- refund res
	on_demolish_resource_refund = { Metals = 20 * const.ResourceScale, MachineParts = 20 * const.ResourceScale , Electronics = 10 * const.ResourceScale },
}

DefineClass.RCMechanicBuilding = {
	__parents = {"BaseRoverBuilding"},
	rover_class = "RCMechanic",
}

function RCMechanic:GameInit()
	BaseRover.GameInit(self)

	-- select sounds
	self.fx_actor_class = "AttackRover"
	-- colour #, Color, Roughness, Metallic
	-- middle area
	self:SetColorizationMaterial(1, -9175040, -128, 120)
	-- body
	self:SetColorizationMaterial(2, -5987164, 120, 20)
	-- color of bands
	self:SetColorizationMaterial(3, -5694693, -128, 48)

	-- show the pin info
	self.pin_rollover = T(0,"<StatusUpdate>")
end

function RCMechanic:GetStatusUpdate()
--~ 	local info =
--~ 	info[1] = "show what it's doing..."
	return table.concat({self.status_text}, "<newline><left>")
end

function RCMechanic:GotoFromUser(...)
	self.status_text = travel_text
	return BaseRover.GotoFromUser(self,...)
end

-- for auto mode
function RCMechanic:ProcAutomation()
	local unreachable_objects = self:GetUnreachableObjectsTable()

	local rover = MapFindNearest(self, "map", "BaseRover", "Drone" ,function(o)
		local go_fix_it
		-- check for rovers without a cc or if all cc nearby have no working drones
		if o.command == "Malfunction" then
			-- can't hurt
			if o:IsKindOf("BaseRover") then
				if not o.repair_work_request:CanAssignUnit() then
					return
				end
			elseif o:IsKindOf("Drone") then
				if not table.find(g_BrokenDrones,"handle",o.handle) then
					return
				end
			end

			-- if has cc then check if they can fix, otherwise fix it
			local cc = o.command_centers
			if cc and #cc > 0 then
				local cc_count = #cc
				local not_working_count = 0
				for i = 1, cc_count do
					local drones_count = cc[i]:GetDronesCount()
					-- check for cc with no drones or all drones are malf'd
					if drones_count == 0 or drones_count == cc[i]:GetBrokenDronesCount()then
						not_working_count = not_working_count + 1
					end
				end
				-- if all cc nearby have no working drones
				if not_working_count == cc_count then
					go_fix_it = true
				end
			else
				go_fix_it = true
			end

		end
		if go_fix_it then
			return not unreachable_objects[o]
		end
--~ 		if o.command_centers and #o.command_centers == 0 and o:IsMalfunctioned() and o.repair_work_request:CanAssignUnit() then
--~ 			return not unreachable_objects[o]
--~ 		end
	end)

	if rover then
		local pos = GetPassablePointNearby(rover:GetPos())
		if self:HasPath(pos, "Workrover") then
			self.status_text = string.format([[Was the dark of the moon on the sixth of June
In a <color 199 124 45>%s</color> pullin' logs
Cab-over Pete with a reefer on
And a Jimmy haulin' hogs
We is headin' for bear on I-one-oh
'Bout a mile outta Shaky Town
I says, "Pig Pen, this here's the Rubber Duck.
"And I'm about to put the hammer down."]],rover.name ~= "" and rover.name or rover.class)
			self:Goto(pos)
			-- find a way to slow this down?
			rover:CheatCleanAndFix()

			self.status_text = idle_text
			return 5000
		else
			unreachable_objects[rover] = true
		end
	else
		return 10000
	end
	return 1000
end

function RCMechanic:Idle()
	self.status_text = idle_text
	local sleep = self:ProcAutomation()
	self:SetState("idle")

	Sleep(sleep or 1000)
	self:Gossip("Idle")
end

function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.RCMechanicBuilding then
		PlaceObj("BuildingTemplate",{
			"Id","RCMechanicBuilding",
			"template_class","RCMechanicBuilding",
			-- pricey?
			"construction_cost_Metals",40000,
			"construction_cost_MachineParts",40000,
			"construction_cost_Electronics",20000,
			-- add a bit of pallor to the skeleton
			"palette_color1", "rover_base",

			"dome_forbidden",true,
			"display_name",name,
			"display_name_pl",name,
			"description",description,
			"build_category","ChoGGi",
			"Group", "ChoGGi",
			"display_icon", display_icon,
			"encyclopedia_exclude",true,
			"on_off_button",false,
			"entity","CombatRover",
			"palettes","AttackRoverBlue",
		})
	end
end

--~ -- add some prod info to selection panel
--~ function OnMsg.ClassesBuilt()
--~ 	local rover = XTemplates.ipRover[1]

--~ 	-- check for and remove existing template
--~ 	ChoGGi.ComFuncs.RemoveXTemplateSections(rover,"ChoGGi_Template_RCMechanic_Prod",true)

--~ 	-- we replace status
--~ 	local status = table.find(rover, "Icon", "UI/Icons/Sections/sensor.tga")
--~ 	if status then
--~ 		rover[status]:delete()
--~ 		table.remove(rover,status)
--~ 	else
--~ 		-- screw it stick it at the end
--~ 		status = #rover
--~ 	end

--~ 	table.insert(
--~ 		rover,
--~ 		#rover,
--~ 		PlaceObj('XTemplateTemplate', {
--~ 			"ChoGGi_Template_RCMechanic_Prod", true,
--~ 			"__context_of_kind", "RCMechanic",
--~ 			"__template", "InfopanelActiveSection",
--~ 			"Title", T(6924, "Repair"),
--~ 			"Icon", "UI/Icons/Sections/construction.tga",
--~ 		}, {
--~ 			PlaceObj("XTemplateTemplate", {
--~ 				"__template", "InfopanelText",
--~ 				"Text",  T(0,"<StatusUpdate>"),
--~ 			}),
--~ 		})
--~ 	)
--~ end


-- CheatCleanAndFix
local function CheatAddDust(self)
	self.dust = self:GetDustMax()-1
	self:SetDustVisuals()
end
Drone.CheatAddDust = CheatAddDust
BaseRover.CheatAddDust = CheatAddDust

Drone.CheatCleanAndFix = function(self)
	CreateRealTimeThread(function()
		self.auto_connect = false
		if self.malfunction_end_state then
			self:PlayState(self.malfunction_end_state, 1)
			if not IsValid(self) then
				return
			end
		end
		self:CheatAddDust()
		Sleep(10)
		self.dust = 0
		self:SetDustVisuals()
		RebuildInfopanel(self)
 end)
end
BaseRover.CheatCleanAndFix = function(self)
	CreateRealTimeThread(function()
		self:CheatAddDust()
		Sleep(10)
		self.dust = 0
		self:SetDustVisuals()
		self:Repair()
 end)
end
