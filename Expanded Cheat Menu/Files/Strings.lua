-- See LICENSE for terms

-- translate all the strings at startup, so it's a table lookup instead of a func call
-- ~ ChoGGi.Strings[27]

local ChoGGi = ChoGGi
local _InternalTranslate = _InternalTranslate
local T = T
local tonumber = tonumber
local TableConcat = ChoGGi.ComFuncs.TableConcat

-- devs didn't bother changing droid font to one that supports unicode, so we do this for not eng
-- pretty sure anything using droid is just for dev work so...
ChoGGi.font = "droid"
if ChoGGi.lang ~= "English" then
  local Concat = ChoGGi.ComFuncs.Concat
  -- first get the unicode font name
  local f = _InternalTranslate(T{984,"SchemeBk, 15, aa"})
  f = f:sub(1,f:find(",")-1)
  ChoGGi.font = f

  -- replace any fonts using droid
  local __game_font_styles = __game_font_styles
  __game_font_styles[false] = Concat(f,", 12, aa")
  __game_font_styles.Editor9 = Concat(f,", 9, aa")
  __game_font_styles.Editor11Bold = Concat(f,", 11, bold, aa")
  __game_font_styles.Editor11 = Concat(f,", 11, aa")
  __game_font_styles.Editor12Bold = Concat(f,", 12, bold, aa")
  __game_font_styles.Editor12 = Concat(f,", 12, aa")
  __game_font_styles.Editor13 = Concat(f,", 13, aa")
  __game_font_styles.Editor13Bold = Concat(f,", 13, bold, aa")
  __game_font_styles.Editor14 = Concat(f,", 14, aa")
  __game_font_styles.Editor14Bold = Concat(f,", 14, bold, aa")
  __game_font_styles.Editor16 = Concat(f,", 16, aa")
  __game_font_styles.Editor16Bold = Concat(f,", 16, bold, aa")
  __game_font_styles.Editor17 = Concat(f,", 17, aa")
  __game_font_styles.Editor17Bold = Concat(f,", 17, bold, aa")
  __game_font_styles.Editor18 = Concat(f,", 18, aa")
  __game_font_styles.Editor18Bold = Concat(f,", 18, bold, aa")
  __game_font_styles.Editor21Bold = Concat(f,", 21, bold, aa")
  __game_font_styles.Editor32Bold = Concat(f,", 32, bold")
  __game_font_styles.Rollover = Concat(f,", 14, bold, aa")
  __game_font_styles.DesignerCaption = Concat(f,", 18, bold, aa")
  __game_font_styles.DesignerPropEditor = Concat(f,", 12, aa")
  __game_font_styles.Console = Concat(f,", 13, bold, aa")
  __game_font_styles.UAMenu = Concat(f,", 14, aa")
  __game_font_styles.UAToolbar = Concat(f,", 14, bold, aa")
  __game_font_styles.EditorCaption = Concat(f,", 14, bold, aa")

  -- normally called when translation is changed, but i try to keep Init.lua simple
  InitGameFontStyles()
end

local Strings = {
  -- 1222 -> 3264 (names, be careful using)
  [1234] = _InternalTranslate(T{1234}), -- Dome
  [1608] = _InternalTranslate(T{1608}), -- Transparency
  [1635] = _InternalTranslate(T{1635}), -- Mission
  [1682] = _InternalTranslate(T{1682}), -- RC Rover
  [1683] = _InternalTranslate(T{1683}), -- RC Transport
  [1684] = _InternalTranslate(T{1684}), -- RC Explorer
  [1685] = _InternalTranslate(T{1685}), -- Rocket
  [1694] = _InternalTranslate(T{1694}), -- Start
  [1859] = _InternalTranslate(T{1859}), -- White

  [6] = _InternalTranslate(T{6}), -- Depth Layer
  [7] = _InternalTranslate(T{7}), -- Is Revealed
  [15] = _InternalTranslate(T{15}), -- Resource
  [16] = _InternalTranslate(T{16}), -- Grade
  [27] = _InternalTranslate(T{27}), -- Cheats
  [40] = _InternalTranslate(T{40}), -- Recharge
  [53] = _InternalTranslate(T{53}), -- Malfunction
  [63] = _InternalTranslate(T{63}), -- Travelling
  [79] = _InternalTranslate(T{79}), -- Power
  [80] = _InternalTranslate(T{80}), -- Production
  [81] = _InternalTranslate(T{81}), -- Life Support
  [83] = _InternalTranslate(T{83}), -- Domes
  [155] = _InternalTranslate(T{155}), -- Entity
  [134] = _InternalTranslate(T{134}), -- Instant Build
  [217] = _InternalTranslate(T{217}), -- Work Shifts
  [235] = _InternalTranslate(T{235}), -- Traits
  [240] = _InternalTranslate(T{240}), -- Specialization
  [291] = _InternalTranslate(T{291}), -- Maintenance<right><drone(MaintenanceDronesCount)>
  [292] = _InternalTranslate(T{292}), -- Workers<right><drone(TransportDronesCount)>
  [293] = _InternalTranslate(T{293}), -- Discharged<right><drone(DischargedDronesCount)>
  [294] = _InternalTranslate(T{294}), -- Broken<right><drone(BrokenDronesCount)>
  [295] = _InternalTranslate(T{295}), -- Idle<right><drone(IdleDronesCount)>
  [311] = _InternalTranslate(T{311}), -- Research
  [434] = _InternalTranslate(T{434}), -- Lifetime<right><lifetime>
  [517] = _InternalTranslate(T{517}), -- Drones
  [519] = _InternalTranslate(T{519}), -- Storage
  [526] = _InternalTranslate(T{526}), -- Visitors
  [547] = _InternalTranslate(T{547}), -- Colonists
  [588] = _InternalTranslate(T{588}), -- Empty
  [656] = _InternalTranslate(T{656}), -- Water consumption
  [657] = _InternalTranslate(T{657}), -- Oxygen Consumption
  [681] = _InternalTranslate(T{681}), -- Water
  [682] = _InternalTranslate(T{682}), -- Oxygen
  [683] = _InternalTranslate(T{683}), -- Power Consumption
  [692] = _InternalTranslate(T{692}), -- Resources
  [697] = _InternalTranslate(T{697}), -- Destroy
  [745] = _InternalTranslate(T{745}), -- Shuttles
  [793] = _InternalTranslate(T{793}), -- Deep Metals
  [797] = _InternalTranslate(T{797}), -- Deep Water
  [801] = _InternalTranslate(T{801}), -- Deep Rare Metals
  [891] = _InternalTranslate(T{891}), -- Air
  [904] = _InternalTranslate(T{904}), -- Terrain
  [1011] = _InternalTranslate(T{1011}), -- Close
  [1022] = _InternalTranslate(T{1022}), -- Food
  [1079] = _InternalTranslate(T{1079}), -- Surviving Mars
  [1120] = _InternalTranslate(T{1120}), -- Space Elevator
  [1176] = _InternalTranslate(T{1176}), -- Cancel Destroy
  [3474] = _InternalTranslate(T{3474}), -- Mission Sponsor
  [3478] = _InternalTranslate(T{3478}), -- Commander Profile
  [3486] = _InternalTranslate(T{3486}), -- Mystery
  [3490] = _InternalTranslate(T{3490}), -- Random
  [3513] = _InternalTranslate(T{3513}), -- Concrete
  [3514] = _InternalTranslate(T{3514}), -- Metals
  [3515] = _InternalTranslate(T{3515}), -- Polymers
  [3516] = _InternalTranslate(T{3516}), -- MachineParts
  [3517] = _InternalTranslate(T{3517}), -- Electronics
  [3518] = _InternalTranslate(T{3518}), -- Drone Hub
  [3540] = _InternalTranslate(T{3540}), -- Sanatorium
  [3581] = _InternalTranslate(T{3581}), -- Sounds
  [3591] = _InternalTranslate(T{3591}), -- Autosave
  [3613] = _InternalTranslate(T{3613}), -- Funding
  [3718] = _InternalTranslate(T{3718}), -- NONE
  [3720] = _InternalTranslate(T{3720}), -- Trait
  [3722] = _InternalTranslate(T{3722}), -- State
  [3734] = _InternalTranslate(T{3734}), -- Tech
  [3862] = _InternalTranslate(T{3862}), -- Medic
  [3973] = _InternalTranslate(T{3973}), -- Salvage
  [3980] = _InternalTranslate(T{3980}), -- Buildings
  [3982] = _InternalTranslate(T{3982}), -- Deposits
  [3983] = _InternalTranslate(T{3983}), -- Disasters
  [3984] = _InternalTranslate(T{3984}), -- Anomalies
  [4099] = _InternalTranslate(T{4099}), -- Game Time
  [4107] = _InternalTranslate(T{4107}), -- Sound FX
  [4139] = _InternalTranslate(T{4139}), -- RareMetals
  [4142] = _InternalTranslate(T{4142}), -- Dust Devils
  [4144] = _InternalTranslate(T{4144}), -- Dust Storms
  [4146] = _InternalTranslate(T{4146}), -- Meteors
  [4148] = _InternalTranslate(T{4148}), -- Cold Waves
  [4149] = _InternalTranslate(T{4149}), -- Cold Wave
  [4248] = _InternalTranslate(T{4248}), -- Hints
  [4250] = _InternalTranslate(T{4250}), -- Dust Storm
  [4251] = _InternalTranslate(T{4251}), -- Meteor
  [4273] = _InternalTranslate(T{4273}), -- Saved on <save_date>
  [4274] = _InternalTranslate(T{4274}), -- Playtime <playtime>
  [4283] = _InternalTranslate(T{4283}), -- Worker performance
  [4284] = _InternalTranslate(T{4284}), -- Age of death
  [4291] = _InternalTranslate(T{4291}), -- Health
  [4293] = _InternalTranslate(T{4293}), -- Sanity
  [4295] = _InternalTranslate(T{4295}), -- Comfort
  [4297] = _InternalTranslate(T{4297}), -- Morale
  [4356] = _InternalTranslate(T{4356}), -- Sex<right><Gender>
  [4357] = _InternalTranslate(T{4357}), -- Birthplace<right><UIBirthplace>
  [4439] = _InternalTranslate(T{4439}), -- Going to<right><h SelectTarget InfopanelSelect><Target></h>
  [4448] = _InternalTranslate(T{4448}), -- Dust
  [4493] = _InternalTranslate(T{4493}), -- All
  [4518] = _InternalTranslate(T{4518}), -- Waste Rock
  [4576] = _InternalTranslate(T{4576}), -- Chance Of Suicide
  [4594] = _InternalTranslate(T{4594}), -- Colonists Per Rocket
  [4616] = _InternalTranslate(T{4616}), -- Food Per Rocket Passenger
  [4645] = _InternalTranslate(T{4645}), -- Drone Recharge Time
  [4711] = _InternalTranslate(T{4711}), -- Crop Fail Threshold
  [4764] = _InternalTranslate(T{4764}), -- BlackCube
  [4765] = _InternalTranslate(T{4765}), -- Fuel
  [4801] = _InternalTranslate(T{4801}), -- Workplace
  [4809] = _InternalTranslate(T{4809}), -- Residence
  [4915] = _InternalTranslate(T{4915}), -- Good News, Everyone!
  [5017] = _InternalTranslate(T{5017}), -- Basic Dome
  [5068] = _InternalTranslate(T{5068}), -- Farms
  [5093] = _InternalTranslate(T{5093}), -- Geoscape Dome
  [5146] = _InternalTranslate(T{5146}), -- Medium Dome
  [5152] = _InternalTranslate(T{5152}), -- Mega Dome
  [5182] = _InternalTranslate(T{5182}), -- Omega Telescope
  [5188] = _InternalTranslate(T{5188}), -- Oval Dome
  [5238] = _InternalTranslate(T{5238}), -- Rockets
  [5433] = _InternalTranslate(T{5433}), -- Drone Control
  [5438] = _InternalTranslate(T{5438}), -- Rovers
  [5444] = _InternalTranslate(T{5444}), -- Workplaces
  [5451] = _InternalTranslate(T{5451}), -- DELETE
  [5452] = _InternalTranslate(T{5452}), -- START
  [5568] = _InternalTranslate(T{5568}), -- Stats
  [5620] = _InternalTranslate(T{5620}), -- Meteor Storm
  [5627] = _InternalTranslate(T{5627}), -- Great Dust Storm
  [5628] = _InternalTranslate(T{5628}), -- Electrostatic Dust Storm
  [5647] = _InternalTranslate(T{5647}), -- Dead Colonists: <count>
  [6546] = _InternalTranslate(T{6546}), -- Core Metals
  [6548] = _InternalTranslate(T{6548}), -- Core Water
  [6550] = _InternalTranslate(T{6550}), -- Core Rare Metals
  [6556] = _InternalTranslate(T{6556}), -- Alien Imprints
  [6640] = _InternalTranslate(T{6640}), -- Genius
  [6642] = _InternalTranslate(T{6642}), -- Celebrity
  [6644] = _InternalTranslate(T{6644}), -- Saint
  [6647] = _InternalTranslate(T{6647}), -- Guru
  [6652] = _InternalTranslate(T{6652}), -- Idiot
  [6729] = _InternalTranslate(T{6729}), -- Daily Production <n>
  [6761] = _InternalTranslate(T{6761}), -- None
  [6779] = _InternalTranslate(T{6779}), -- Warning
  [6859] = _InternalTranslate(T{6859}), -- Unemployed
  [6878] = _InternalTranslate(T{6878}), -- OK
  [6879] = _InternalTranslate(T{6879}), -- Cancel
  [7031] = _InternalTranslate(T{7031}), -- Renegades
  [7553] = _InternalTranslate(T{7553}), -- Homeless
  [7607] = _InternalTranslate(T{7607}), -- Battery
  [7657] = _InternalTranslate(T{7657}), -- <ButtonY> Activate
  [7790] = _InternalTranslate(T{7790}), -- Research Current Tech
  [7822] = _InternalTranslate(T{7822}), -- Destroy this building.
  [7824] = _InternalTranslate(T{7824}), -- Destroy this Drone.
  [7825] = _InternalTranslate(T{7825}), -- Destroy this Rover.
  [8039] = _InternalTranslate(T{8039}), -- Trait: Idiot (can cause a malfunction)
  [8064] = _InternalTranslate(T{8064}), -- MysteryResource
  [8076] = _InternalTranslate(T{8076}), -- Goal
  [8690] = _InternalTranslate(T{8690}), -- Protect
  [8800] = _InternalTranslate(T{8800}), -- Game Rules
  [8830] = _InternalTranslate(T{8830}), -- Food Storage
  [9000] = _InternalTranslate(T{9000}), -- Micro Dome
  [9003] = _InternalTranslate(T{9003}), -- Trigon Dome
  [9009] = _InternalTranslate(T{9009}), -- Mega Trigon Dome
  [9012] = _InternalTranslate(T{9012}), -- Diamond Dome
  [1000009] = _InternalTranslate(T{1000009}), -- Confirmation
  [1000011] = _InternalTranslate(T{1000011}), -- There is an active Steam upload
  [1000012] = _InternalTranslate(T{1000012}), -- Mod <ModLabel> will be uploaded to Steam
  [1000013] = _InternalTranslate(T{1000013}), -- Mod <ModLabel> was not uploaded to Steam. Error: <err>
  [1000014] = _InternalTranslate(T{1000014}), -- Mod <ModLabel> was successfully uploaded to Steam!
  [1000015] = _InternalTranslate(T{1000015}), -- Success
  [1000016] = _InternalTranslate(T{1000016}), -- Title
  [1000021] = _InternalTranslate(T{1000021}), -- Steam ID
  [1000037] = _InternalTranslate(T{1000037}), -- Name
  [1000058] = _InternalTranslate(T{1000058}), -- Missing file <u(src)> referenced in entity
  [1000081] = _InternalTranslate(T{1000081}), -- Scale
  [1000100] = _InternalTranslate(T{1000100}), -- Amount
  [1000107] = _InternalTranslate(T{1000107}), -- Mod
  [1000113] = _InternalTranslate(T{1000113}), -- Debug
  [1000121] = _InternalTranslate(T{1000121}), -- Default
  [1000145] = _InternalTranslate(T{1000145}), -- Text
  [1000155] = _InternalTranslate(T{1000155}), -- Hidden
  [1000162] = _InternalTranslate(T{1000162}), -- Menu
  [1000207] = _InternalTranslate(T{1000207}), -- Misc
  [1000220] = _InternalTranslate(T{1000220}), -- Refresh
  [1000232] = _InternalTranslate(T{1000232}), -- Next
  [1000287] = _InternalTranslate(T{1000287}), -- Delete
  [1000435] = _InternalTranslate(T{1000435}), -- Game
  [1000436] = _InternalTranslate(T{1000436}), -- Map
  [1000592] = _InternalTranslate(T{1000592}), -- Error
  [109035890389] = _InternalTranslate(T{109035890389}), -- Capacity
  [126095410863] = _InternalTranslate(T{126095410863}), -- Info
  [298035641454] = _InternalTranslate(T{298035641454}), -- Object
  [313911890683] = _InternalTranslate(T{313911890683}), -- <description>
  [327465361219] = _InternalTranslate(T{327465361219}), -- Edit
  [398847925160] = _InternalTranslate(T{398847925160}), -- New
  [487939677892] = _InternalTranslate(T{487939677892}), -- Help
  [584248706535] = _InternalTranslate(T{584248706535}), -- Carrying<right><ResourceAmount>
  [640016954592] = _InternalTranslate(T{640016954592}), -- Remove this switch or valve.
  [652319561018] = _InternalTranslate(T{652319561018}), -- All Traits
  [987289847467] = _InternalTranslate(T{987289847467}), -- Age Groups
}
-- for string.format ease of use
Strings[4356] = Strings[4356]:gsub("<right><Gender>","")
Strings[4357] = Strings[4357]:gsub("<right><UIBirthplace>","")

Strings[1000012] = Strings[1000012]:gsub("<ModLabel>","%%s")
Strings[1000013] = Strings[1000013]:gsub("<ModLabel>","%%s"):gsub("<err>","%%s")
Strings[1000014] = Strings[1000014]:gsub("<ModLabel>","%%s")

Strings[291] = Strings[291]:gsub("<right>",": %%s")
Strings[292] = Strings[292]:gsub("<right>",": %%s")
Strings[293] = Strings[293]:gsub("<right>",": %%s")
Strings[294] = Strings[294]:gsub("<right>",": %%s")
Strings[295] = Strings[295]:gsub("<right>",": %%s")
Strings[434] = Strings[434]:gsub("<right><lifetime>",": %%s")
Strings[4273] = Strings[4273]:gsub("<save_date>",": %%s")
Strings[4274] = Strings[4274]:gsub("<playtime>",": %%s")
Strings[4439] = Strings[4439]:gsub("<right><h SelectTarget InfopanelSelect><Target></h>",": %%s")
Strings[5647] = Strings[5647]:gsub("<count>","%%s")
Strings[6729] = Strings[6729]:gsub("<n>",": %%s")
Strings[584248706535] = Strings[584248706535]:gsub("<right><ResourceAmount>",": %%s")

-- add all of my strings (skipping any missing ones)

-- we need to pad some zeros
local function TransZero(pad,first,last)
  for i = first, last do
    -- 1300 entries in the CSV file
    if i > 1300 then
      break
    end
    local num = tonumber(TableConcat{30253592000,pad,i})
    local str = _InternalTranslate(T{num})
    if str ~= "stripped" then
      Strings[num] = str
    end
  end
end

TransZero("000",0,9)
TransZero("00",10,99)
TransZero("0",100,999)
TransZero("",1000,9999)

ChoGGi.Strings = Strings
