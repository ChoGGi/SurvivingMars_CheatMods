--See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local AddAction = ChoGGi.ComFuncs.AddAction
local T = ChoGGi.ComFuncs.Trans

--~ local icon = "new_city.tga"

--~ AddAction(Menu,Action,Key,Des,Icon)

AddAction(
  Concat(T(302535920000104--[[Expanded CM--]]),"/",T(1635--[[Mission--]]),"/",T(302535920000704--[[Instant Mission Goal--]])),
  ChoGGi.MenuFuncs.InstantMissionGoal,
  nil,
  T(302535920000705--[[Mission goals are finished instantly (pretty sure the only difference is preventing a msg).

Needs to change Sol to update.--]]),
  "AlignSel.tga"
)

AddAction(
  Concat(T(302535920000104--[[Expanded CM--]]),"/",T(1635--[[Mission--]]),"/",T(302535920000706--[[Instant Colony Approval--]])),
  ChoGGi.MenuFuncs.InstantColonyApproval,
  nil,
  T(302535920000707--[[Make your colony instantly approved (can be called before you summon your first victims).--]]),
  "AlignSel.tga"
)

AddAction(
  Concat(T(302535920000104--[[Expanded CM--]]),"/",T(1635--[[Mission--]]),"/",T(3983--[[Disasters--]]),"/",T(302535920000708--[[Meteor Damage--]])),
  ChoGGi.MenuFuncs.MeteorHealthDamage_Toggle,
  nil,
  function()
    return ChoGGi.ComFuncs.SettingState(Consts.MeteorHealthDamage,
      302535920000709--[[Disable Meteor damage (colonists?).--]]
    )
  end,
  "remove_water.tga"
)

AddAction(
  Concat(T(302535920000104--[[Expanded CM--]]),"/",T(1635--[[Mission--]]),"/",T(302535920000710--[[Change Logo--]])),
  ChoGGi.MenuFuncs.ChangeGameLogo,
  nil,
  T(302535920000711--[[Change the logo for anything that uses the logo.--]]),
  "ViewArea.tga"
)

AddAction(
  Concat(T(302535920000104--[[Expanded CM--]]),"/",T(1635--[[Mission--]]),"/[1]",T(302535920000712--[[Set Sponsor--]])),
  ChoGGi.MenuFuncs.ChangeSponsor,
  nil,
  T(302535920000713--[[Switch to a different sponsor.--]]),
  "SelectByClassName.tga"
)

AddAction(
  Concat(T(302535920000104--[[Expanded CM--]]),"/",T(1635--[[Mission--]]),"/[3]",T(302535920000716--[[Set Commander--]])),
  ChoGGi.MenuFuncs.ChangeCommander,
  nil,
  T(302535920000717--[[Switch to a different commander.--]]),
  "SetCamPos&Loockat.tga"
)

------------
local bonusinfo = T(302535920000715--[[Applies the good effects only (no drawbacks).

(if value already exists; set to larger amount).
restart to set disabled.--]])
AddAction(
  Concat(T(302535920000104--[[Expanded CM--]]),"/",T(1635--[[Mission--]]),"/[2]",T(302535920000714--[[Set Bonuses Sponsor--]])),
  ChoGGi.MenuFuncs.SetSponsorBonus,
  nil,
  bonusinfo,
  "EV_OpenFromInputBox.tga"
)

AddAction(
  Concat(T(302535920000104--[[Expanded CM--]]),"/",T(1635--[[Mission--]]),"/[4]",T(302535920000718--[[Set Bonuses Commander--]])),
  ChoGGi.MenuFuncs.SetCommanderBonus,
  nil,
  bonusinfo,
  "EV_OpenFromInputBox.tga"
)

--------------------disasters
--~ local function DisasterOccurrenceText(Name)
--~   return Concat("Set the occurrence level of ",Name," disasters.\nCurrent: ",mapdata["MapSettings_",Name])
--~ end

--~ AddAction(
--~   Concat(T(302535920000104--[[Expanded CM--]]),"/",T(1635--[[Mission--]]),"/",T(3983--[[Disasters--]]),"/",T()"DustDevils"),
--~   function()
--~     ChoGGi.MenuFuncs.SetDisasterOccurrence("DustDevils")
--~   end,
--~   nil,
--~   DisasterOccurrenceText("DustDevils"),
--~   "RandomMapPresetEditor.tga"
--~ )
--~ AddAction(
--~   Concat(T(302535920000104--[[Expanded CM--]]),"/",T(1635--[[Mission--]]),"/",T(3983--[[Disasters--]]),"/",T()"ColdWave"),
--~   function()
--~     ChoGGi.MenuFuncs.SetDisasterOccurrence("ColdWave")
--~   end,
--~   nil,
--~   DisasterOccurrenceText("ColdWave"),
--~   "RandomMapPresetEditor.tga"
--~ )
--~ AddAction(
--~   Concat(T(302535920000104--[[Expanded CM--]]),"/",T(1635--[[Mission--]]),"/",T(3983--[[Disasters--]]),"/",T()"DustStorm"),
--~   function()
--~     ChoGGi.MenuFuncs.SetDisasterOccurrence("DustStorm")
--~   end,
--~   nil,
--~   DisasterOccurrenceText("DustStorm"),
--~   "RandomMapPresetEditor.tga"
--~ )
--~ AddAction(
--~   Concat(T(302535920000104--[[Expanded CM--]]),"/",T(1635--[[Mission--]]),"/",T(3983--[[Disasters--]]),"/",T()"Meteor"),
--~   function()
--~     ChoGGi.MenuFuncs.SetDisasterOccurrence("Meteor")
--~   end,
--~   nil,
--~   DisasterOccurrenceText("Meteor"),
--~   "RandomMapPresetEditor.tga"
--~ )
--~ AddAction(
--~   Concat(T(302535920000104--[[Expanded CM--]]),"/",T(1635--[[Mission--]]),"/",T()"Set Rules"),
--~   ChoGGi.ChangeRules,
--~   nil,
--~   T()"Change the map rules.",
--~   "ListCollections.tga"
--~ )
