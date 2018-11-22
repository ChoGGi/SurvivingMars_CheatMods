-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
local fire_once
function OnMsg.ModsReloaded()
	if fire_once then
		return
	end
	fire_once = true

	-- version to version check with
	local min_version = 37
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	-- if we can't find mod or mod is less then min_version (we skip steam since it updates automatically)
	if not idx or idx and not Platform.steam and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[RC AttackRover requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

function OnMsg.ClassesGenerate()
  DefineClass.AttackRover2 = {
    __parents = {
      "AttackRover",
      "PinnableObject",
      "ComponentAttach",
      "Demolishable",
      },
  }

  DefineClass.AttackRoverBuilding2 = {
    __parents = {
      "BaseRoverBuilding"
    },
    rover_class = "AttackRover2",
  }

end --ClassesGenerate

function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.AttackRoverBuilding2 then
		PlaceObj("BuildingTemplate",{
			"Id","AttackRoverBuilding2",
			"template_class","AttackRoverBuilding2",
			"construction_cost_Metals",20000,
			"construction_cost_Electronics",10000,
			"dome_forbidden",true,
			"display_name","RC AttackRover",
			"display_name_pl","RC AttackRover",
			"description","Not much",
			"build_category","ChoGGi",
			"Group", "ChoGGi",
			"display_icon","UI/Icons/Buildings/rover_combat.tga",
			"build_pos",2,
			"entity","RoverTransportBuilding",
			"encyclopedia_exclude",true,
			"on_off_button",false,
			"prio_button",false,
			"palettes","AttackRoverRed"
		})
	end

end --ClassesPostprocess

function OnMsg.ClassesBuilt()

--needed someplace to override it, and roam only happens after it's done what it needs to do
function AttackRover2:Roam()
  local city = self.city or UICity
  city:RemoveFromLabel("HostileAttackRovers", self)
  city:AddToLabel("Rover", self)
  self.reclaimed = true
  self.affected_by_no_battery_tech = true
  self.palettes = {
    "AttackRoverRed",
    --"AttackRoverBlue",
  }
  SetPaletteFromClassMember(self)
  CommandObject.SetCommand(self, "Idle")
end

function AttackRover2:Repair()
  self.battery_current = self.battery_max
  local city = self.city or UICity
  --self:DisconnectFromCommandCenters()
  self.current_health = self.max_health
  self.malfunction_idle_state = nil
  self:SetState("idle")
  self.is_repair_request_initialized = false

  self.reclaimed = true
  self.affected_by_no_battery_tech = true
  self.palettes = {"AttackRoverRed"}
  SetPaletteFromClassMember(self)
  city:AddToLabel("Rover", self)
  CommandObject.SetCommand(self, "Idle")

  Msg("AttackRoverRepaired", self)
  ObjModified(self)
end

end
