-- See LICENSE for terms

-- translate all the strings at startup, so it's a table lookup instead of a func call
-- ~ ChoGGi.Strings[27]

local ChoGGi = ChoGGi
local _InternalTranslate = _InternalTranslate
local T = T
local tonumber = tonumber
local TableConcat = ChoGGi.ComFuncs.TableConcat

local TranslationTable = TranslationTable

-- devs didn't bother changing droid font to one that supports unicode, so we do this for not eng
-- pretty sure anything using droid is just for dev work so...
if ChoGGi.lang ~= "English" then
	local StringFormat = string.format
	-- first get the unicode font name

	local f = TranslationTable[997--[[*font*, 15, aa--]]]
	-- index of first , then crop out the rest
	f = f:sub(1,f:find(",")-1)
	ChoGGi.font = f

	-- these four don't get to use non-eng fonts, cause fuck you is why
	-- ok it's these aren't expected to be exposed to end users, but console is in mod editor so...
	local TextStyles = TextStyles
	TextStyles.Console.TextFont = StringFormat("%s, 18, bold, aa",f)
	TextStyles.ConsoleLog.TextFont = StringFormat("%s, 13, bold, aa",f)
	TextStyles.DevMenuBar.TextFont = StringFormat("%s, 18, aa",f)
	TextStyles.GizmoText.TextFont = StringFormat("%s, 32, bold, aa",f)

end

-- i stick all the strings from sm that I use in my table for ease of access
local Strings = {
	-- 1222 -> 3264 (be careful using for generic these are names)
	[1234] = TranslationTable[1234], -- Dome
	[1608] = TranslationTable[1608], -- Transparency
	[1635] = TranslationTable[1635], -- Mission
	[1681] = TranslationTable[1681], -- Drone
	[1682] = TranslationTable[1682], -- RC Rover
	[1683] = TranslationTable[1683], -- RC Transport
	[1684] = TranslationTable[1684], -- RC Explorer
	[1685] = TranslationTable[1685], -- Rocket
	[1694] = TranslationTable[1694], -- Start
	[1859] = TranslationTable[1859], -- White
	[2993] = TranslationTable[2993], -- Tilde

	[2] = TranslationTable[2], -- Unlock Tech
	[3] = TranslationTable[3], -- Grant Research
	[6] = TranslationTable[6], -- Depth Layer
	[7] = TranslationTable[7], -- Is Revealed
	[8] = TranslationTable[8], -- Breakthrough Tech
	[9] = TranslationTable[9], -- Anomaly
	[11] = _InternalTranslate(T{11}), -- Our scientists believe that this Anomaly may lead to a <em>Breakthrough</em>.<newline><newline>Send an <em>Explorer</em> to analyze the Anomaly.
	[12] = _InternalTranslate(T{12}), -- Scans have detected some interesting readings that might help us discover <em>new Technologies</em>.<newline><newline>Send an <em>Explorer</em> to analyze the Anomaly.
	[13] = _InternalTranslate(T{13}), -- Sensors readings suggest that this Anomaly will help us with our current <em>Research</em> goals.<newline><newline>Send an <em>Explorer</em> to analyze the Anomaly.
	[14] = _InternalTranslate(T{14}), -- We have detected alien artifacts at this location that will <em>speed up</em> our Research efforts.<newline><newline>Send an <em>Explorer</em> to analyze the Anomaly.
	[15] = TranslationTable[15], -- Resource
	[16] = TranslationTable[16], -- Grade
	[25] = TranslationTable[25], -- Anomaly Scanning
	[27] = TranslationTable[27], -- Cheats
	[40] = TranslationTable[40], -- Recharge
	[53] = TranslationTable[53], -- Malfunction
	[63] = TranslationTable[63], -- Travelling
	[67] = TranslationTable[67], -- Loading resourcesLoading resources
	[79] = TranslationTable[79], -- Power
	[80] = TranslationTable[80], -- Production
	[81] = TranslationTable[81], -- Life Support
	[83] = TranslationTable[83], -- Domes
	[134] = TranslationTable[134], -- Instant Build
	[155] = TranslationTable[155], -- Entity
	[174] = TranslationTable[174], -- Color Modifier
	[217] = TranslationTable[217], -- Work Shifts
	[235] = TranslationTable[235], -- Traits
	[240] = TranslationTable[240], -- Specialization
	[293] = _InternalTranslate(T{293}), -- Discharged<right><drone(DischargedDronesCount)>
	[294] = _InternalTranslate(T{294}), -- Broken<right><drone(BrokenDronesCount)>
	[295] = _InternalTranslate(T{295}), -- Idle<right><drone(IdleDronesCount)>
	[311] = TranslationTable[311], -- Research
	[434] = _InternalTranslate(T{434}), -- Lifetime<right><lifetime>
	[517] = TranslationTable[517], -- Drones
	[519] = TranslationTable[519], -- Storage
	[526] = TranslationTable[526], -- Visitors
	[547] = TranslationTable[547], -- Colonists
	[588] = TranslationTable[588], -- Empty
	[594] = TranslationTable[594], -- Clear
	[656] = TranslationTable[656], -- Water consumption
	[657] = TranslationTable[657], -- Oxygen Consumption
	[681] = TranslationTable[681], -- Water
	[682] = TranslationTable[682], -- Oxygen
	[683] = TranslationTable[683], -- Power Consumption
	[692] = TranslationTable[692], -- Resources
	[697] = TranslationTable[697], -- Destroy
	[728] = TranslationTable[728], -- Health change on visit
	[729] = TranslationTable[729], -- Sanity change on visit
	[730] = TranslationTable[730], -- Service Comfort
	[731] = TranslationTable[731], -- Comfort increase on visit
	[732] = TranslationTable[732], -- Service interest
	[734] = TranslationTable[734], -- Visit duration
	[735] = TranslationTable[735], -- Usable by children
	[736] = TranslationTable[736], -- Children Only
	[745] = TranslationTable[745], -- Shuttles
	[793] = TranslationTable[793], -- Deep Metals
	[797] = TranslationTable[797], -- Deep Water
	[801] = TranslationTable[801], -- Deep Rare Metals
	[891] = TranslationTable[891], -- Air
	[904] = TranslationTable[904], -- Terrain
	[931] = TranslationTable[931], -- Modified property
	[1011] = TranslationTable[1011], -- Close
	[1022] = TranslationTable[1022], -- Food
	[1079] = TranslationTable[1079], -- Surviving Mars
	[1110] = TranslationTable[1110], -- Prefab Buildings
	[1111] = TranslationTable[1111], -- Prefabricated parts needed for the construction of certain buildings on Mars.
	[1120] = TranslationTable[1120], -- Space Elevator
	[1157] = TranslationTable[1157], -- Complete thread
	[1176] = TranslationTable[1176], -- Cancel Destroy
	[3474] = TranslationTable[3474], -- Mission Sponsor
	[3478] = TranslationTable[3478], -- Commander Profile
	[3482] = TranslationTable[3482], -- Colony Logo
	[3486] = TranslationTable[3486], -- Mystery
	[3490] = TranslationTable[3490], -- Random
	[3491] = TranslationTable[3491], -- Challenge Mod (%)
	[3513] = TranslationTable[3513], -- Concrete
	[3514] = TranslationTable[3514], -- Metals
	[3515] = TranslationTable[3515], -- Polymers
	[3516] = TranslationTable[3516], -- MachineParts
	[3517] = TranslationTable[3517], -- Electronics
	[3518] = TranslationTable[3518], -- Drone Hub
	[3540] = TranslationTable[3540], -- Sanatorium
	[3581] = TranslationTable[3581], -- Sounds
	[3591] = TranslationTable[3591], -- Autosave
	[3595] = TranslationTable[3595], -- Color
	[3613] = TranslationTable[3613], -- Funding
	[3718] = TranslationTable[3718], -- NONE
	[3720] = TranslationTable[3720], -- Trait
	[3722] = TranslationTable[3722], -- State
	[3734] = TranslationTable[3734], -- Tech
	[3768] = TranslationTable[3768], -- Destroy all?
	[3862] = TranslationTable[3862], -- Medic
	[3973] = TranslationTable[3973], -- Salvage
	[3980] = TranslationTable[3980], -- Buildings
	[3982] = TranslationTable[3982], -- Deposits
	[3983] = TranslationTable[3983], -- Disasters
	[3984] = TranslationTable[3984], -- Anomalies
	[4099] = TranslationTable[4099], -- Game Time
	[4139] = TranslationTable[4139], -- Rare Metals
	[4142] = TranslationTable[4142], -- Dust Devils
	[4144] = TranslationTable[4144], -- Dust Storms
	[4146] = TranslationTable[4146], -- Meteors
	[4148] = TranslationTable[4148], -- Cold Waves
	[4149] = TranslationTable[4149], -- Cold Wave
	[4248] = TranslationTable[4248], -- Hints
	[4250] = TranslationTable[4250], -- Dust Storm
	[4273] = _InternalTranslate(T{4273}), -- Saved on <save_date>
	[4274] = _InternalTranslate(T{4274}), -- Playtime <playtime>
	[4283] = TranslationTable[4283], -- Worker performance
	[4284] = TranslationTable[4284], -- Age of death
	[4291] = TranslationTable[4291], -- Health
	[4293] = TranslationTable[4293], -- Sanity
	[4295] = TranslationTable[4295], -- Comfort
	[4297] = TranslationTable[4297], -- Morale
	[4325] = TranslationTable[4325], -- Free
	[4356] = _InternalTranslate(T{4356}), -- Sex<right><Gender>
	[4357] = _InternalTranslate(T{4357}), -- Birthplace<right><UIBirthplace>
	[4439] = _InternalTranslate(T{4439}), -- Going to<right><h SelectTarget InfopanelSelect><Target></h>
	[4448] = TranslationTable[4448], -- Dust
	[4493] = TranslationTable[4493], -- All
	[4518] = TranslationTable[4518], -- Waste Rock
	[4576] = TranslationTable[4576], -- Chance Of Suicide
	[4594] = TranslationTable[4594], -- Colonists Per Rocket
	[4616] = TranslationTable[4616], -- Food Per Rocket Passenger
	[4645] = TranslationTable[4645], -- Drone Recharge Time
	[4711] = TranslationTable[4711], -- Crop Fail Threshold
	[4764] = TranslationTable[4764], -- BlackCube
	[4765] = TranslationTable[4765], -- Fuel
	[4801] = TranslationTable[4801], -- Workplace
	[4809] = TranslationTable[4809], -- Residence
	[4810] = TranslationTable[4810], -- Service
	[4915] = TranslationTable[4915], -- Good News, Everyone!
	[5017] = TranslationTable[5017], -- Basic Dome
	[5068] = TranslationTable[5068], -- Farms
	[5093] = TranslationTable[5093], -- Geoscape Dome
	[5146] = TranslationTable[5146], -- Medium Dome
	[5152] = TranslationTable[5152], -- Mega Dome
	[5182] = TranslationTable[5182], -- Omega Telescope
	[5188] = TranslationTable[5188], -- Oval Dome
	[5221] = TranslationTable[5221], -- RC Commanders
	[5238] = TranslationTable[5238], -- Rockets
	[5245] = TranslationTable[5245], -- Sanatoriums
	[5248] = TranslationTable[5248], -- Schools
	[5422] = TranslationTable[5422], -- Exploration
	[5433] = TranslationTable[5433], -- Drone Control
	[5438] = TranslationTable[5438], -- Rovers
	[5439] = TranslationTable[5439], -- Service Buildings
	[5443] = TranslationTable[5443], -- Training Buildings
	[5444] = TranslationTable[5444], -- Workplaces
	[5451] = TranslationTable[5451], -- DELETE
	[5452] = TranslationTable[5452], -- START
	[5568] = TranslationTable[5568], -- Stats
	[5620] = TranslationTable[5620], -- Meteor Storm
	[5627] = TranslationTable[5627], -- Great Dust Storm
	[5628] = TranslationTable[5628], -- Electrostatic Dust Storm
	[5647] = _InternalTranslate(T{5647}), -- Dead Colonists: <count>
	[5661] = TranslationTable[5661], -- Mystery Log
	[6546] = TranslationTable[6546], -- Core Metals
	[6548] = TranslationTable[6548], -- Core Water
	[6550] = TranslationTable[6550], -- Core Rare Metals
	[6556] = TranslationTable[6556], -- Alien Imprints
	[6640] = TranslationTable[6640], -- Genius
	[6642] = TranslationTable[6642], -- Celebrity
	[6644] = TranslationTable[6644], -- Saint
	[6647] = TranslationTable[6647], -- Guru
	[6652] = TranslationTable[6652], -- Idiot
	[6729] = _InternalTranslate(T{6729}), -- Daily Production <n>
	[6761] = TranslationTable[6761], -- None
	[6779] = TranslationTable[6779], -- Warning
	[6859] = TranslationTable[6859], -- Unemployed
	[6878] = TranslationTable[6878], -- OK
	[6879] = TranslationTable[6879], -- Cancel
	[7031] = TranslationTable[7031], -- Renegades
	[7553] = TranslationTable[7553], -- Homeless
	[7607] = TranslationTable[7607], -- Battery
	[7657] = _InternalTranslate(T{7657}), -- <ButtonY> Activate
	[7790] = TranslationTable[7790], -- Research Current Tech
	[7822] = TranslationTable[7822], -- Destroy this building.
	[7824] = TranslationTable[7824], -- Destroy this Drone.
	[7825] = TranslationTable[7825], -- Destroy this Rover.
	[8039] = TranslationTable[8039], -- Trait: Idiot (can cause a malfunction)
	[8064] = TranslationTable[8064], -- MysteryResource
	[8490] = TranslationTable[8490], -- Loading complete
	[8690] = TranslationTable[8690], -- Protect
	[8800] = TranslationTable[8800], -- Game Rules
	[8830] = TranslationTable[8830], -- Food Storage
	[9000] = TranslationTable[9000], -- Micro Dome
	[9003] = TranslationTable[9003], -- Trigon Dome
	[9009] = TranslationTable[9009], -- Mega Trigon Dome
	[9012] = TranslationTable[9012], -- Diamond Dome
	[9763] = TranslationTable[9763], -- No objects matching current filters.
	[10278] = TranslationTable[10278], -- Wasp Drone
	[11412] = TranslationTable[11412], -- Trigger fireworks
	[1000009] = TranslationTable[1000009], -- Confirmation
	[1000011] = TranslationTable[1000011], -- There is an active Steam upload
	[1000012] = _InternalTranslate(T{1000012}), -- Mod <ModLabel> will be uploaded to Steam
	[1000013] = _InternalTranslate(T{1000013}), -- Mod <ModLabel> was not uploaded to Steam. Error: <err>
	[1000014] = _InternalTranslate(T{1000014}), -- Mod <ModLabel> was successfully uploaded to Steam!
	[1000015] = TranslationTable[1000015], -- Success
	[1000016] = TranslationTable[1000016], -- Title
	[1000021] = TranslationTable[1000021], -- Steam ID
	[1000037] = TranslationTable[1000037], -- Name
	[1000058] = _InternalTranslate(T{1000058}), -- Missing file <u(src)> referenced in entity
	[1000081] = TranslationTable[1000081], -- Scale
	[1000097] = TranslationTable[1000097], -- Category
	[1000100] = TranslationTable[1000100], -- Amount
	[1000107] = TranslationTable[1000107], -- Mod
	[1000110] = TranslationTable[1000110], -- Type
	[1000113] = TranslationTable[1000113], -- Debug
	[1000121] = TranslationTable[1000121], -- Default
	[1000145] = TranslationTable[1000145], -- Text
	[1000155] = TranslationTable[1000155], -- Hidden
	[1000162] = TranslationTable[1000162], -- Menu
	[1000207] = TranslationTable[1000207], -- Misc
	[1000220] = TranslationTable[1000220], -- Refresh
	[1000232] = TranslationTable[1000232], -- Next
	[1000447] = TranslationTable[1000447], -- Enter
	[1000457] = TranslationTable[1000457], -- Left
	[1000459] = TranslationTable[1000459], -- Right
	[1000592] = TranslationTable[1000592], -- Error
	[1000615] = TranslationTable[1000615], -- Delete
	[1000760] = TranslationTable[1000760], -- Not Steam
	[109035890389] = TranslationTable[109035890389], -- Capacity
	[126095410863] = TranslationTable[126095410863], -- Info
	[128569337702] = TranslationTable[128569337702], -- Reward:
	[283142739680] = TranslationTable[283142739680], -- Game
	[298035641454] = TranslationTable[298035641454], -- Object
	[313911890683] = _InternalTranslate(T{313911890683}), -- <description>
	[327465361219] = TranslationTable[327465361219], -- Edit
	[460479110814] = TranslationTable[460479110814], -- Enabled
	[487939677892] = TranslationTable[487939677892], -- Help
	[584248706535] = _InternalTranslate(T{584248706535}), -- Carrying<right><ResourceAmount>
	[591853191640] = _InternalTranslate(T{591853191640}), -- Empty list
	[619281504128] = TranslationTable[619281504128], -- Maintenance
	[640016954592] = TranslationTable[640016954592], -- Remove this switch or valve.
	[652319561018] = TranslationTable[652319561018], -- All Traits
	[847439380056] = TranslationTable[847439380056], -- Disabled
	[885971788025] = TranslationTable[885971788025], -- Outside Buildings
	[889032422791] = TranslationTable[889032422791], -- OUTSOURCE
	[979029137252] = TranslationTable[979029137252], -- Scanned an Anomaly
	[987289847467] = TranslationTable[987289847467], -- Age Groups
}

-- for string.format ease of use
Strings[4356] = Strings[4356]:gsub("<right><Gender>","")
Strings[4357] = Strings[4357]:gsub("<right><UIBirthplace>","")

Strings[1000012] = Strings[1000012]:gsub("<ModLabel>","%%s")
Strings[1000013] = Strings[1000013]:gsub("<ModLabel>","%%s"):gsub("<err>","%%s")
Strings[1000014] = Strings[1000014]:gsub("<ModLabel>","%%s")

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
		-- entries in the CSV file
		if i > 1450 then
			break
		end
		local num = tonumber(TableConcat{30253592000,pad,i})
		local str = _InternalTranslate(T{num})
		if str ~= "Missing text" then
			Strings[num] = str
		end
	end
end

TransZero("000",0,9)
TransZero("00",10,99)
TransZero(0,100,999)
TransZero("",1000,9999)

ChoGGi.Strings = Strings
