function OnMsg.ClassesGenerate()
  DefineClass.AttackRover2 = {
    __parents = {
      "AttackRover",
      "PinnableObject",
      "ComponentAttach",
      "Demolishable",
      },
  }

  DefineClass.AttackRoverBuilding = {
    __parents = {
      "BaseRoverBuilding"
    },
    rover_class = "AttackRover2",
  }

end --ClassesGenerate

function OnMsg.ClassesPostprocess()

  PlaceObj("BuildingTemplate",{
    "Id","AttackRoverBuilding",
    "template_class","AttackRoverBuilding",
    "construction_cost_Metals",20000,
    "construction_cost_Electronics",10000,
    "dome_forbidden",true,
    "display_name","RC AttackRover",
    "display_name_pl","RC AttackRover",
    "description","Not much",
    "Group","Infrastructure",
    "build_category","Infrastructure",
    "display_icon","UI/Icons/Buildings/rover_combat.tga",
    "build_pos",2,
    "entity","RoverTransportBuilding",
    "encyclopedia_exclude",true,
    "on_off_button",false,
    "prio_button",false,
    "palettes","AttackRoverRed"
  })

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
