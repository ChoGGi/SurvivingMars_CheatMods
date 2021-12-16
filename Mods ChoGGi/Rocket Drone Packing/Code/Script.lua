-- See LICENSE for terms

local function AddTemplate(rocket, template1, template2)
	local idx = table.find(rocket, "comment", "drones")
	if not idx then
		return
	end
	rocket = rocket[idx]

	ChoGGi.ComFuncs.RemoveXTemplateSections(rocket, "ChoGGi_DroneButton1")
	ChoGGi.ComFuncs.RemoveXTemplateSections(rocket, "ChoGGi_DroneButton2")

	rocket[#rocket+1] = template1
	rocket[#rocket+1] = template2
end

function OnMsg.ClassesPostprocess()
	local template1 = PlaceObj("XTemplateTemplate", {
		"ChoGGi_DroneButton1", true,
		"Id", "ChoGGi_DroneButton1",
		"__template", "InfopanelActiveSection",
		"Icon", "UI/Icons/IPButtons/drone_dismantle.tga",
		"RolloverText", T(8665, "Recalls a Drone and packs it into a Drone Prefab. Can be used to reassign Drones between controllers."),
		"RolloverHint", T(8668, "<left_click> Pack Drone for reassignment <em>Ctrl + <left_click></em> Pack five Drones"),
		'RolloverDisabledText', T(8666, --[[XTemplate ipRover RolloverDisabledText]] "No available Drones."),
--~ 		"RolloverHintGamepad", T(8669, "<ButtonA> Pack Drone for reassignment <ButtonX> Pack five Drones"),
		"RolloverTitle", T(8667, "Pack Drone for Reassignment"),
		"Title", T(302535920011759, "Pack Drone"),
		"OnContextUpdate", function(self, context, ...)
			self:SetEnabled(not not context:FindDroneToConvertToPrefab())
		end,
		}, {
			PlaceObj("XTemplateFunc", {
				"name", "OnActivate(self, context)",
				"parent", function(self)
					return self.parent
				end,
				"func", function(self, context)
					---
					if IsMassUIModifierPressed() then
						context:ConvertDroneToPrefab(true)
					else
						context:ConvertDroneToPrefab()
					end
					---
				end
			}),
	})
	local template2 = PlaceObj("XTemplateTemplate", {
		"ChoGGi_DroneButton2", true,
		"Id", "ChoGGi_DroneButton2",
		"__template", "InfopanelActiveSection",
		"Icon", "UI/Icons/IPButtons/drone_assemble.tga",
		"RolloverText", T(8460, "Unpack an existing Drone Prefab to build a new Drone. Drone Prefabs can be created from existing Drones or in a Drone Assembler (requires research). This action can be used to quickly reassign Drones between controllers.<newline><newline>Available Drone Prefabs: <drone(available_drone_prefabs)>"),
		"RolloverHint", T(8461, "<left_click> Unpack Drone <em>Ctrl + <left_click></em> Unpack five Drones"),
--~ 		"RolloverHintGamepad", T(8462, "<ButtonA> Unpack Drone <ButtonX> Unpack five Drones"),
		"Title", T(349, "Unpack Drone"),
		"OnContextUpdate", function(self, context, ...)
			self:SetEnabled((context.city or UICity).drone_prefabs > 0)
		end,
		}, {
			PlaceObj("XTemplateFunc", {
				"name", "OnActivate(self, context)",
				"parent", function(self)
					return self.parent
				end,
				"func", function(self, context)
					---
					if IsMassUIModifierPressed() then
						context:UseDronePrefab(true)
					else
						context:UseDronePrefab()
					end
					---
				end
			}),
	})

	AddTemplate(XTemplates.customSupplyRocket[1], template1, template2)
	AddTemplate(XTemplates.customRocketExpedition[1], template1, template2)
	if g_AccessibleDlc.picard then
		AddTemplate(XTemplates.customLanderRocket[1], template1, template2)
	end
end

-- UseDronePrefab() needs a return to remove from city.drone_prefabs count
-- and the Embark command keeps them stuck inside the rocket forever
local ChoOrig_RocketBase_SpawnDrone = RocketBase.SpawnDrone
local function ChoFake_RocketBase_SpawnDrone(self)
	if #self.drones >= self:GetMaxDrones() then
		return
	end

	local drone = self.city:CreateDrone()
	drone:SetCommandCenter(self)

	local spawn_pos = self:GetSpotLoc(self:GetSpotBeginIndex(self.drone_spawn_spot))
	drone:SetPos(spawn_pos)

--~ 	CreateGameTimeThread(Drone.SetCommand, drone, "Embark")
	drone:SetCommand("Idle")
	return drone
end
RocketBase.SpawnDrone = ChoFake_RocketBase_SpawnDrone

local ChoOrig_RocketBase_SpawnDronesFromEarth = RocketBase.SpawnDronesFromEarth
function RocketBase.SpawnDronesFromEarth(...)
	RocketBase.SpawnDrone = ChoOrig_RocketBase_SpawnDrone
	local spawned_drones = ChoOrig_RocketBase_SpawnDronesFromEarth(...)
	RocketBase.SpawnDrone = ChoFake_RocketBase_SpawnDrone
  return spawned_drones
end

