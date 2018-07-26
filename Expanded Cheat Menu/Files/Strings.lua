-- See LICENSE for terms

-- translate all the strings at startup, so it's a table lookup instead of a func
local ChoGGi = ChoGGi
local _InternalTranslate = _InternalTranslate
local T = T
local tonumber = tonumber
local TableConcat = ChoGGi.ComFuncs.TableConcat

local Strings = {
  [15] = _InternalTranslate(T{15}), --Resource
  [27] = _InternalTranslate(T{27}), --Cheats
  [53] = _InternalTranslate(T{53}), --Malfunction
  [155] = _InternalTranslate(T{155}), --Entity
  [134] = _InternalTranslate(T{134}), --Instant Build
  [217] = _InternalTranslate(T{217}), --Work Shifts
  [235] = _InternalTranslate(T{235}), --Traits
  [240] = _InternalTranslate(T{240}), --Specialization
  [311] = _InternalTranslate(T{311}), --Research
  [517] = _InternalTranslate(T{517}), --Drones
  [519] = _InternalTranslate(T{519}), --Storage
  [547] = _InternalTranslate(T{547}), --Colonists
  [588] = _InternalTranslate(T{588}), --Empty
  [656] = _InternalTranslate(T{656}), --Water consumption
  [657] = _InternalTranslate(T{657}), --Oxygen Consumption
  [681] = _InternalTranslate(T{681}), --Water
  [683] = _InternalTranslate(T{683}), --Power Consumption
  [692] = _InternalTranslate(T{692}), --Resources
  [697] = _InternalTranslate(T{697}), --Destroy
  [745] = _InternalTranslate(T{745}), --Shuttles
  [793] = _InternalTranslate(T{793}), --Deep Metals
  [797] = _InternalTranslate(T{797}), --Deep Water
  [801] = _InternalTranslate(T{801}), --Deep Rare Metals
  [891] = _InternalTranslate(T{891}), --Air
  [904] = _InternalTranslate(T{904}), --Terrain
  [1011] = _InternalTranslate(T{1011}), --Close
  [1022] = _InternalTranslate(T{1022}), --Food
  [1079] = _InternalTranslate(T{1079}), --Surviving Mars
  [1120] = _InternalTranslate(T{1120}), --Space Elevator
  [1176] = _InternalTranslate(T{1176}), --Cancel Destroy
  [1234] = _InternalTranslate(T{1234}), --Dome
  [1608] = _InternalTranslate(T{1608}), --Transparency
  [1635] = _InternalTranslate(T{1635}), --Mission
  [1682] = _InternalTranslate(T{1682}), --RC Rover
  [1683] = _InternalTranslate(T{1683}), --RC Transport
  [1684] = _InternalTranslate(T{1684}), --RC Explorer
  [1685] = _InternalTranslate(T{1685}), --Rocket
  [3474] = _InternalTranslate(T{3474}), --Mission Sponsor
  [3478] = _InternalTranslate(T{3478}), --Commander Profile
  [3486] = _InternalTranslate(T{3486}), --Mystery
  [3490] = _InternalTranslate(T{3490}), --Random
  [3513] = _InternalTranslate(T{3513}), --Concrete
  [3514] = _InternalTranslate(T{3514}), --Metals
  [3515] = _InternalTranslate(T{3515}), --Polymers
  [3516] = _InternalTranslate(T{3516}), --MachineParts
  [3517] = _InternalTranslate(T{3517}), --Electronics
  [3518] = _InternalTranslate(T{3518}), --Drone Hub
  [3540] = _InternalTranslate(T{3540}), --Sanatorium
  [3581] = _InternalTranslate(T{3581}), --Sounds
  [3591] = _InternalTranslate(T{3591}), --Autosave
  [3613] = _InternalTranslate(T{3613}), --Funding
  [3718] = _InternalTranslate(T{3718}), --NONE
  [3720] = _InternalTranslate(T{3720}), --Trait
  [3722] = _InternalTranslate(T{3722}), --State
  [3973] = _InternalTranslate(T{3973}), --Salvage
  [3980] = _InternalTranslate(T{3980}), --Buildings
  [3982] = _InternalTranslate(T{3982}), --Deposits
  [3983] = _InternalTranslate(T{3983}), --Disasters
  [3984] = _InternalTranslate(T{3984}), --Anomalies
  [4099] = _InternalTranslate(T{4099}), --Game Time
  [4107] = _InternalTranslate(T{4107}), --Sound FX
  [4139] = _InternalTranslate(T{4139}), --RareMetals
  [4142] = _InternalTranslate(T{4142}), --Dust Devils
  [4144] = _InternalTranslate(T{4144}), --Dust Storms
  [4146] = _InternalTranslate(T{4146}), --Meteors
  [4148] = _InternalTranslate(T{4148}), --Cold Waves
  [4149] = _InternalTranslate(T{4149}), --Cold Wave
  [4248] = _InternalTranslate(T{4248}), --Hints
  [4250] = _InternalTranslate(T{4250}), --Dust Storm
  [4251] = _InternalTranslate(T{4251}), --Meteor
  [4283] = _InternalTranslate(T{4283}), --Worker performance
  [4284] = _InternalTranslate(T{4284}), --Age of death
  [4291] = _InternalTranslate(T{4291}), --Health
  [4293] = _InternalTranslate(T{4293}), --Sanity
  [4295] = _InternalTranslate(T{4295}), --Comfort
  [4297] = _InternalTranslate(T{4297}), --Morale
  [4493] = _InternalTranslate(T{4493}), --All
  [4576] = _InternalTranslate(T{4576}), --Chance Of Suicide
  [4594] = _InternalTranslate(T{4594}), --Colonists Per Rocket
  [4616] = _InternalTranslate(T{4616}), --Food Per Rocket Passenger
  [4645] = _InternalTranslate(T{4645}), --Drone Recharge Time
  [4711] = _InternalTranslate(T{4711}), --Crop Fail Threshold
  [4764] = _InternalTranslate(T{4764}), --BlackCube
  [4765] = _InternalTranslate(T{4765}), --Fuel
  [4801] = _InternalTranslate(T{4801}), --Workplace
  [4809] = _InternalTranslate(T{4809}), --Residence
  [5017] = _InternalTranslate(T{5017}), --Basic Dome
  [5068] = _InternalTranslate(T{5068}), --Farms
  [5093] = _InternalTranslate(T{5093}), --Geoscape Dome
  [5146] = _InternalTranslate(T{5146}), --Medium Dome
  [5152] = _InternalTranslate(T{5152}), --Mega Dome
  [5182] = _InternalTranslate(T{5182}), --Omega Telescope
  [5188] = _InternalTranslate(T{5188}), --Oval Dome
  [5238] = _InternalTranslate(T{5238}), --Rockets
  [5438] = _InternalTranslate(T{5438}), --Rovers
  [5444] = _InternalTranslate(T{5444}), --Workplaces
  [5451] = _InternalTranslate(T{5451}), --DELETE
  [5568] = _InternalTranslate(T{5568}), --Stats
  [5620] = _InternalTranslate(T{5620}), --Meteor Storm
  [6546] = _InternalTranslate(T{6546}), --Core Metals
  [6548] = _InternalTranslate(T{6548}), --Core Water
  [6550] = _InternalTranslate(T{6550}), --Core Rare Metals
  [6556] = _InternalTranslate(T{6556}), --Alien Imprints
  [6652] = _InternalTranslate(T{6652}), --Idiot
  [6761] = _InternalTranslate(T{6761}), --None
  [6779] = _InternalTranslate(T{6779}), --Warning
  [6859] = _InternalTranslate(T{6859}), --Unemployed
  [6878] = _InternalTranslate(T{6878}), --OK
  [6879] = _InternalTranslate(T{6879}), --Cancel
  [7031] = _InternalTranslate(T{7031}), --Renegades
  [7553] = _InternalTranslate(T{7553}), --Homeless
  [7657] = _InternalTranslate(T{7657}), --<ButtonY> Activate
  [7790] = _InternalTranslate(T{7790}), --Research Current Tech
  [7822] = _InternalTranslate(T{7822}), --Destroy this building.
  [7824] = _InternalTranslate(T{7824}), --Destroy this Drone.
  [7825] = _InternalTranslate(T{7825}), --Destroy this Rover.
  [8039] = _InternalTranslate(T{8039}), --Trait: Idiot (can cause a malfunction)
  [8064] = _InternalTranslate(T{8064}), --MysteryResource
  [8076] = _InternalTranslate(T{8076}), --Goal
  [8690] = _InternalTranslate(T{8690}), --Protect
  [8800] = _InternalTranslate(T{8800}), --Game Rules
  [8830] = _InternalTranslate(T{8830}), --Food Storage
  [9000] = _InternalTranslate(T{9000}), --Micro Dome
  [9003] = _InternalTranslate(T{9003}), --Trigon Dome
  [9009] = _InternalTranslate(T{9009}), --Mega Trigon Dome
  [9012] = _InternalTranslate(T{9012}), --Diamond Dome
  [1000011] = _InternalTranslate(T{1000011}), --There is an active Steam upload
  [1000012] = _InternalTranslate(T{1000012}), --Mod <ModLabel> will be uploaded to Steam
  [1000013] = _InternalTranslate(T{1000013}), --Mod <ModLabel> was not uploaded to Steam. Error: <err>
  [1000014] = _InternalTranslate(T{1000014}), --Mod <ModLabel> was successfully uploaded to Steam!
  [1000015] = _InternalTranslate(T{1000015}), --Success
  [1000016] = _InternalTranslate(T{1000016}), --Title
  [1000021] = _InternalTranslate(T{1000021}), --Steam ID
  [1000037] = _InternalTranslate(T{1000037}), --Name
  [1000058] = _InternalTranslate(T{1000058}), --Missing file <u(src)> referenced in entity
  [1000081] = _InternalTranslate(T{1000081}), --Scale
  [1000107] = _InternalTranslate(T{1000107}), --Mod
  [1000113] = _InternalTranslate(T{1000113}), --Debug
  [1000121] = _InternalTranslate(T{1000121}), --Default
  [1000145] = _InternalTranslate(T{1000145}), --Text
  [1000155] = _InternalTranslate(T{1000155}), --Hidden
  [1000162] = _InternalTranslate(T{1000162}), --Menu
  [1000207] = _InternalTranslate(T{1000207}), --Misc
  [1000220] = _InternalTranslate(T{1000220}), --Refresh
  [1000232] = _InternalTranslate(T{1000232}), --Next
  [1000287] = _InternalTranslate(T{1000287}), --Delete
  [1000435] = _InternalTranslate(T{1000435}), --Game
  [1000436] = _InternalTranslate(T{1000436}), --Map
  [1000592] = _InternalTranslate(T{1000592}), --Error
  [109035890389] = _InternalTranslate(T{109035890389}), --Capacity
  [126095410863] = _InternalTranslate(T{126095410863}), --Info
  [298035641454] = _InternalTranslate(T{298035641454}), --Object
  [313911890683] = _InternalTranslate(T{313911890683}), --<description>
  [327465361219] = _InternalTranslate(T{327465361219}), --Edit
  [398847925160] = _InternalTranslate(T{398847925160}), --New
  [487939677892] = _InternalTranslate(T{487939677892}), --Help
  [640016954592] = _InternalTranslate(T{640016954592}), --Remove this switch or valve.
  [652319561018] = _InternalTranslate(T{652319561018}), --All Traits
}
-- what's wrong with string.format?
Strings[1000012] = Strings[1000012]:gsub("<ModLabel>","%%s")
Strings[1000013] = Strings[1000013]:gsub("<ModLabel>","%%s"):gsub("<err>","%%s")
Strings[1000014] = Strings[1000014]:gsub("<ModLabel>","%%s")

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
