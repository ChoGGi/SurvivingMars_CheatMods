-- See LICENSE for terms

local table = table
local NameUnit = NameUnit

local mod_RandomBirthplace
local mod_DefaultNationNames

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_RandomBirthplace = CurrentModOptions:GetProperty("RandomBirthplace")
	mod_DefaultNationNames = CurrentModOptions:GetProperty("DefaultNationNames")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- override naming func
-- we need a local function for GetWeightedRandNation below
local function GetNationName()
	return table.rand(Nations).value
end

local ChoOrig_GenerateColonistData = GenerateColonistData
function GenerateColonistData(...)
	if mod_RandomBirthplace then
		local c = ChoOrig_GenerateColonistData(...)
		c.birthplace = GetNationName()
		NameUnit(c)
		return c
	else
		return ChoOrig_GenerateColonistData(...)
	end
end

-- local some stuff
local path = CurrentModPath .. "Flags/flag_"

local function AddExisting(name, flag_name, Nations, c)
	local idx = table.find(Nations, "value", name)
	if idx then
		Nations[idx].flag = path .. flag_name .. ".png"
	else
		c = c + 1
		Nations[c] = {
			value = name,
			text = name,
			flag = path .. flag_name .. ".png",
		}
	end
	return c
end

local ChoOrig_Colonist_GetUIInfo = Colonist.GetUIInfo
function Colonist:GetUIInfo(...)
	local ret = ChoOrig_Colonist_GetUIInfo(self, ...)

	local Nations = Nations
	local idx = table.find(Nations, "value", self.birthplace)
	-- ret[1].table[4] = T{4357, "Birthplace<right><UIBirthplace>", self}
	-- when you hover over the colonist section of a selected colonist
	ret[1].table[4] = T{"<orig><newline><right><birthplace>",
		orig = ret[1].table[4],
		birthplace = Nations[idx].text,
	}
	return ret
end

-- just in case anyone adds some custom HumanNames
function OnMsg.ModsReloaded()

	local Nations = Nations

	-- already added
	if Nations[13] then
		return
	end

	local HumanNames = HumanNames

	local existing_nation = {}
	for i = 1, #Nations do
		existing_nation[Nations[i].value] = true
	end

	-- replace the func that gets a nation (it gets a weighted nation depending on your sponsors instead of all of them)
	GetWeightedRandNation = GetNationName

	-- I doubt any game will last 99999 sols
	const.FullTransitionToMarsNames = 99999

	-- get all human names then merge into one table and apply to all nations
	local name_table = {
		Family = {
			"Abrudan",
			"Aciubotariței",
			"Adam",
			"Adamache",
			"Adameșteanu",
			"Adamuț",
			"Adămuț",
			"Adrianescu",
			"Agache",
			"Agrișan",
			"Ailenei",
			"Aionițoaei",
			"Aiordăchioaei",
			"Aiordăchioaiei",
			"Alba",
			"Albescu",
			"Albu",
			"Albulescu",
			"Albuță",
			"Aldea",
			"Alecsandri",
			"Alecu",
			"Alexan",
			"Alexandrescu",
			"Alice",
			"Almășan",
			"Alupoaei",
			"Alupoaiei",
			"Aluței",
			"Amânar",
			"Ambrozie",
			"Amironesei",
			"Anania",
			"Andersson",
			"Andone",
			"Andreescu",
			"Andreica",
			"Andreșan",
			"Andronache",
			"Andru",
			"Anghel",
			"Anghelache",
			"Anghelescu",
			"Angheluța",
			"Angheluță",
			"Anițaș",
			"Aniței",
			"Antikainen",
			"Antohie",
			"Antonescu",
			"Anușca",
			"Apatachioae",
			"Apetroaei",
			"Apostol",
			"Apostolescu",
			"Apostu",
			"Aprodu",
			"Arădeanu",
			"Arăpașu",
			"Ardelean",
			"Ardeleanu",
			"Arghezi",
			"Arghir",
			"Argintaru",
			"Armășelu",
			"Armașu",
			"Atanasiu",
			"Augustin",
			"Avadanei",
			"Avalonu",
			"Averescu",
			"Avram",
			"Avramescu",
			"Bab",
			"Baba",
			"Băban",
			"Babeș",
			"Babu",
			"Baciu",
			"Băciuț",
			"Bâcleșanu",
			"Bacovia",
			"Bădălău",
			"Badale",
			"Badea",
			"Bădeliță",
			"Bădescu",
			"Badilă",
			"Bădulescu",
			"Baghiu",
			"Bagiu",
			"Baicu",
			"Baieș",
			"Băieșu",
			"Baiu",
			"Băjănaru",
			"Bălăceanu",
			"Bălan",
			"Bălănean",
			"Bălăneanu",
			"Bălănescu",
			"Balaur",
			"Balauru",
			"Balc",
			"Bălcescu",
			"Bâldean",
			"Balea",
			"Balga",
			"Balint",
			"Balițiu",
			"Băloiu",
			"Balomirean",
			"Baltag",
			"Baltagă",
			"Ban",
			"Bănceu",
			"Banciu",
			"Bancu",
			"Bănică",
			"Bănilă",
			"Bănulescu",
			"Banuț",
			"Bar",
			"Bărăitaru",
			"Bărar",
			"Bărăscu",
			"Barbu",
			"Barbulescu",
			"Bărceanu",
			"Bârdea",
			"Barițiu",
			"Bârla",
			"Bârladeanu",
			"Bârlădeanu",
			"Barnuțiu",
			"Bărnuțiu",
			"Baron",
			"Bârsan",
			"Bârzan",
			"Bărzoi",
			"Basarab",
			"Basarabeanu",
			"Băsărăbeanu",
			"Basarabescu",
			"Băsărăbescu",
			"Băsescu",
			"Bâtă",
			"Bătrân",
			"Bătrânac",
			"Bedelean",
			"Begu",
			"Beian",
			"Bejan",
			"Bejenar",
			"Bejenariu",
			"Beldean",
			"Belea",
			"Beleanu",
			"Beleiu",
			"Belu",
			"Benchea",
			"Bendea",
			"Bendeac",
			"Bengescu",
			"Bentoiu",
			"Berbec",
			"Berbecu",
			"Berce",
			"Bercean",
			"Berceanu",
			"Berciu",
			"Berdilă",
			"Berea",
			"Berescu",
			"Berg",
			"Bergstrom",
			"Berinde",
			"Berlea",
			"Beșleagă",
			"Bibescu",
			"Bica",
			"Bîcleșanu",
			"Bieșu",
			"Bighiu",
			"Bihoreanu",
			"Bilăuș",
			"Bilescu",
			"Biolan",
			"Birău",
			"Biriș",
			"Bîrladeanu",
			"Bîrlea",
			"Birșan",
			"Bîrsan",
			"Birtocean",
			"Biru",
			"Bistrian",
			"Bistrițeanu",
			"Bizgan",
			"Blaga",
			"Blaj",
			"Blăjan",
			"Blăjean",
			"Blandiana",
			"Bledea",
			"Blejnar",
			"Bleoju",
			"Blerinca",
			"Blic",
			"Blidar",
			"Blidaru",
			"Boariu",
			"Bob",
			"Bobeica",
			"Boboc",
			"Boboia",
			"Bobu",
			"Boc",
			"Boca",
			"Bocan",
			"Bocaniciu",
			"Bocea",
			"Bocean",
			"Bocșa",
			"Bocșan",
			"Bocuțiu",
			"Bodea",
			"Bodiu",
			"Bodola",
			"Bodonea",
			"Bodorin",
			"Boeriu",
			"Boga",
			"Bogdănescu",
			"Bogdescu",
			"Boghean",
			"Bogoescu",
			"Bogza",
			"Boian",
			"Boicu",
			"Boiculese",
			"Boieru",
			"Bolboacă",
			"Bolcaș",
			"Boldijar",
			"Boldureanu",
			"Bolintineanu",
			"Boloca",
			"Bologa",
			"Bolojan",
			"Bolovăneanu",
			"Bolovănescu",
			"Bonaciu",
			"Bondar",
			"Bondăraș",
			"Bondor",
			"Bonea",
			"Bonta",
			"Bordea",
			"Bordean",
			"Borha",
			"Borilă",
			"Boroi",
			"Borșan",
			"Borza",
			"Borzan",
			"Boșca",
			"Boșcodeală",
			"Boșîntă",
			"Boșutar",
			"Bota",
			"Botan",
			"Botea",
			"Botescu",
			"Botezatu",
			"Botiș",
			"Botnaru",
			"Botorogeanu",
			"Boureanu",
			"Bourescu",
			"Bozga",
			"Bracaciu",
			"Brad",
			"Bradea",
			"Brădișteanu",
			"Brăileanu",
			"Brăncescu",
			"Brâncoveanu",
			"Brâncuși",
			"Brănescu",
			"Brânză",
			"Brânzescu",
			"Brașovean",
			"Brașoveanu",
			"Brașovianu",
			"Brătean",
			"Brătianu",
			"Bratu",
			"Bratuva",
			"Breana",
			"Breban",
			"Brega",
			"Breharu",
			"Bria",
			"Briciu",
			"Brînza",
			"Briscan",
			"Brozbă",
			"Brujan",
			"Bruma",
			"Brumă",
			"Brumaru",
			"Brustur",
			"Buboi",
			"Buburuz",
			"Bucin",
			"Buciuman",
			"Bucșa",
			"Bucșoiu",
			"Bucur",
			"Bucurean",
			"Bucureanu",
			"Bucurescu",
			"Budău",
			"Budescu",
			"Budișteanu",
			"Budnar",
			"Budnaru",
			"Bufnea",
			"Buga",
			"Bugnariu",
			"Buha",
			"Buhăescu",
			"Buhai",
			"Buică",
			"Bujdea",
			"Bujor",
			"Bulboaca",
			"Bulgeac",
			"Bulmez",
			"Buluță",
			"Bulzan",
			"Bulzean",
			"Bulzescu",
			"Bumbar",
			"Bumbescu",
			"Bumbu",
			"Bunău",
			"Bunea",
			"Bungețeanu",
			"Burcă",
			"Burciu",
			"Buric",
			"Burlaca",
			"Burlacu",
			"Burnea",
			"Buruleanu",
			"Bus",
			"Buse",
			"Busecan",
			"Bușoi",
			"Busuioc",
			"Bușulenga",
			"Buta",
			"Butacu",
			"Butan",
			"Butaru",
			"Bute",
			"Butean",
			"Butescu",
			"Butnariu",
			"Butnaru",
			"Butuc",
			"Buz",
			"Buză",
			"Buzărnescu",
			"Buzaș",
			"Buzdugan",
			"Buzea",
			"Buzescu",
			"Buzilă",
			"Caba",
			"Cabău",
			"Cabiniuc",
			"Cachiț",
			"Căciulă",
			"Cacovean",
			"Cădar",
			"Cadiș",
			"Calenici",
			"Calimah",
			"Călin",
			"Călinescu",
			"Calmațul",
			"Călugăr",
			"Călugăreanu",
			"Călugărescu",
			"Călugăru",
			"Cămilar",
			"Câmpanu",
			"Câmpean",
			"Câmpeanu",
			"Câmpian",
			"Candale",
			"Cândea",
			"Canta",
			"Cantaragiu",
			"Cantemir",
			"Capet",
			"Căpraru",
			"Cărăbăț",
			"Caraciobanu",
			"Caragiale",
			"Cărăian",
			"Caraion",
			"Cărămidaru",
			"Caramitru",
			"Cărare",
			"Cărăușan",
			"Caravia",
			"Cârciumaru",
			"Cardei",
			"Cârjan",
			"Cârlan",
			"Cărlan",
			"Cârlig",
			"Cârlova",
			"Cârmu",
			"Cârpar",
			"Cărpar",
			"Cârstea",
			"Cărtărescu",
			"Carțiș",
			"Căstăian",
			"Cașu",
			"Catana",
			"Cataraga",
			"Cataramă",
			"Catargiu",
			"Câțescu",
			"Cătina",
			"Cătinean",
			"Cazac",
			"Cazacu",
			"Cazan",
			"Cazanciuc",
			"Cazimir",
			"Ceaușescu",
			"Cebotari",
			"Cec",
			"Celan",
			"Cenan",
			"Ceoban",
			"Ceobanu",
			"Ceobotărescu",
			"Ceoca",
			"Cepoi",
			"Cerba",
			"Cercelaru",
			"Cernat",
			"Cernău",
			"Cernea",
			"Cetină",
			"Chelaru",
			"Chelu",
			"Chesăuan",
			"Chețan",
			"Chiaburu",
			"Chiciudean",
			"Chifan",
			"Chindea",
			"Chindriș",
			"Chioran",
			"Chiorean",
			"Chiriac",
			"Chirică",
			"Chirilă",
			"Chiru",
			"Chișe",
			"Chițu",
			"Chițureanu",
			"Chiuariu",
			"Chivu",
			"Chivulescu",
			"Cibotaru",
			"Cicu",
			"Cifor",
			"Cîmpan",
			"Cîmpanu",
			"Cîmpean",
			"Cîmpeanu",
			"Cîmpian",
			"Cimpoi",
			"Cinca",
			"Cinicam",
			"Cioară",
			"Cioba",
			"Cioban",
			"Ciobanu",
			"Ciobotaru",
			"Ciobotea",
			"Cioca",
			"Ciocan",
			"Ciocanu",
			"Cioci",
			"Cioclea",
			"Cioculescu",
			"Ciolacu",
			"Cionca",
			"Ciontescu",
			"Ciora",
			"Cioran",
			"Ciorbă",
			"Ciordaș",
			"Ciorei",
			"Ciorhan",
			"Ciorican",
			"Ciorogariu",
			"Cioroianu",
			"Ciortea",
			"Cios",
			"Cipcigan",
			"Cîrciumaru",
			"Ciribiu",
			"Cirimpei",
			"Cîrjan",
			"Cîrlig",
			"Cîrlova",
			"Cîrpar",
			"Cîrstea",
			"Cîțescu",
			"Ciubotaru",
			"Ciuca",
			"Ciucă",
			"Ciucu",
			"Ciufudean",
			"Ciuhandu",
			"Ciuhat",
			"Ciulei",
			"Ciumpiliac",
			"Ciungan",
			"Ciungu",
			"Ciupei",
			"Ciupit",
			"Ciupitu",
			"Ciurca",
			"Ciurcă",
			"Ciurea",
			"Ciuta",
			"Ciutac",
			"Cizmaru",
			"Clapa",
			"Clinci",
			"Cloanda",
			"Coandă",
			"Cobe",
			"Coca",
			"Cocan",
			"Cocean",
			"Cocian",
			"Cociorvă",
			"Cociș",
			"Cocoreanu",
			"Cocoș",
			"Codarcea",
			"Codoban",
			"Codrea",
			"Codreanca",
			"Codreanu",
			"Codrescu",
			"Codru",
			"Cojan",
			"Cojoc",
			"Cojocar",
			"Cojocariu",
			"Cojocaru",
			"Cojocean",
			"Colac",
			"Colan",
			"Colceriu",
			"Colta",
			"Coman",
			"Comăneci",
			"Comănescu",
			"Comiza",
			"Conea",
			"Constandache",
			"Constănțeanu",
			"Constantin",
			"Constantinescu",
			"Constantinoiu",
			"Conta",
			"Contan",
			"Copaciu",
			"Copândean",
			"Copciuc",
			"Copil",
			"Copindean",
			"Copos",
			"Coposu",
			"Coprean",
			"Coptu",
			"Corbea",
			"Corbean",
			"Corbeanu",
			"Corbu",
			"Corda",
			"Corduneanu",
			"Corha",
			"Corlățean",
			"Corlăteanu",
			"Corlățeanu",
			"Cornea",
			"Corneanu",
			"Cornilescu",
			"Coroian",
			"Coroiu",
			"Coșarcă",
			"Coșbuc",
			"Coșeriu",
			"Cosma",
			"Cosmescu",
			"Coșofreț",
			"Cosovanu",
			"Costache",
			"Costan",
			"Costanciuc",
			"Coste",
			"Costea",
			"Costean",
			"Costeanu",
			"Costescu",
			"Costin",
			"Costiniu",
			"Costiță",
			"Costiuc",
			"Cotan",
			"Coțan",
			"Cotârță",
			"Cotaru",
			"Cotelea",
			"Cotîrță",
			"Coțofană",
			"Cotoi",
			"Cotruș",
			"Cotuțiu",
			"Covaci",
			"Covrin",
			"Cozaciuc",
			"Cozma",
			"Cozmei",
			"Crăciun",
			"Crăciunaș",
			"Crăciunean",
			"Crainic",
			"Craioveanu",
			"Crămar",
			"Cramba",
			"Crăngașu",
			"Cravă",
			"Cravcescu",
			"Creangă",
			"Creț",
			"Cretu",
			"Crețu",
			"Crișan",
			"Crișanu",
			"Crîșmaru",
			"Criste",
			"Cristea",
			"Cristescu",
			"Cristoiu",
			"Cristurean",
			"Crivăț",
			"Crivei",
			"Croitor",
			"Croitoru",
			"Cruceru",
			"Crudu",
			"Cucea",
			"Cucereanu",
			"Cucicea",
			"Cuciureanu",
			"Cuciuroschi",
			"Cucoș",
			"Cucuieț",
			"Cuibuș",
			"Culgheru",
			"Culianu",
			"Cumpănas",
			"Cumpănașu",
			"Cupcea",
			"Curagău",
			"Curculescu",
			"Curea",
			"Curelaru",
			"Curpan",
			"Cuțui",
			"Cuza",
			"Dahlberg",
			"Daicoviciu",
			"Dâlca",
			"Dâlcă",
			"Damian",
			"Danciu",
			"Daneș",
			"Dărăban",
			"Darida",
			"Dârjan",
			"Dârlău",
			"Dascăl",
			"Dăscălescu",
			"Dascălu",
			"Deac",
			"Deaconescu",
			"Decean",
			"Dehelean",
			"Dej",
			"Dejeu",
			"Delean",
			"Deleanu",
			"Deliorga",
			"Demetrescu",
			"Demian",
			"Densușianu",
			"Diacon",
			"Diaconescu",
			"Diaconu",
			"Dică",
			"Dicescu",
			"Dima",
			"Dimitrescu",
			"Dincu",
			"Dincuță",
			"Dinescu",
			"Dinică",
			"Dinu",
			"Dioșan",
			"Dîrjan",
			"Dirlău",
			"Dîrlău",
			"Diță",
			"Divoiu",
			"Divricean",
			"Dobra",
			"Dobraș",
			"Dobre",
			"Dobrea",
			"Dobrean",
			"Dobrescu",
			"Dobrilă",
			"Dobrița",
			"Dobriță",
			"Dobrogeanu",
			"Doga",
			"Dogaru",
			"Doinea",
			"Doja",
			"Dolănescu",
			"Dolgan",
			"Dolha",
			"Donceanu",
			"Donici",
			"Dorneanu",
			"Doroftei",
			"Drăgan",
			"Drăganu",
			"Drăghiceanu",
			"Drăghicescu",
			"Drăghici",
			"Drăghicioiu",
			"Drăghinescu",
			"Dragnea",
			"Drăgoescu",
			"Drăgoi",
			"Drăgoiu",
			"Dragomir",
			"Dragomirescu",
			"Dragomiroiu",
			"Dragu",
			"Drăgulin",
			"Dregan",
			"Driha",
			"Drimba",
			"Drob",
			"Drobot",
			"Druc",
			"Drule",
			"Druță",
			"Dubleșiu",
			"Duca",
			"Ducă",
			"Ducai",
			"Dudaș",
			"Dudău",
			"Dudric",
			"Duică",
			"Dulfu",
			"Dulgheru",
			"Duma",
			"Dumbravă",
			"Duminică",
			"Dumitrache",
			"Dumitraș",
			"Dumitrescu",
			"Dumitriu",
			"Dumitru",
			"Durgău",
			"Dușa",
			"Duță",
			"Duțescu",
			"Duțulescu",
			"Eerikäinen",
			"Eliade",
			"Eminescu",
			"Enache",
			"Encean",
			"Enchiridionu",
			"Ene",
			"Enea",
			"Enescu",
			"Epure",
			"Epureanu",
			"Eremia",
			"Eriksson",
			"Esinencu",
			"Fabian",
			"Făgădău",
			"Faiciuc",
			"Fânaru",
			"Fărăgău",
			"Farcaș",
			"Fărcaș",
			"Fărcășanu",
			"Farcașianu",
			"Fâșie",
			"Faur",
			"Fecioru",
			"Fedeșan",
			"Felea",
			"Felecan",
			"Feneșan",
			"Feraru",
			"Fericean",
			"Fericeanu",
			"Fericescu",
			"Fieraru",
			"Fierăscu",
			"Filimon",
			"Filimonescu",
			"Filip",
			"Filipaș",
			"Filipciuc",
			"Filipescu",
			"Fir",
			"Firan",
			"Firu",
			"Flămând",
			"Flișto",
			"Floare",
			"Flore",
			"Florea",
			"Florescu",
			"Florian",
			"Florinescu",
			"Floriștean",
			"Florișteanu",
			"Flutur",
			"Foarță",
			"Focșeanu",
			"Fodor",
			"Fogaș",
			"Fosa",
			"Fotache",
			"Frătean",
			"Frățilă",
			"Frigea",
			"Frumos",
			"Frumușanu",
			"Frunză",
			"Fufezan",
			"Fulgeanu",
			"Funar",
			"Furcă",
			"Furtună",
			"Fusu",
			"Gabor",
			"Găceanu",
			"Gădălean",
			"Gafencu",
			"Găină",
			"Gal",
			"Galaicu",
			"Galanton",
			"Gălăteanu",
			"Galbază",
			"Gâlcă",
			"Gale",
			"Galea",
			"Galoș",
			"Gan",
			"Gândac",
			"Ganea",
			"Ganga",
			"Gârbovan",
			"Gârjoabă",
			"Gârleanu",
			"Gârneț",
			"Gașpar",
			"Gâșteanu",
			"Gâștescu",
			"Gatu",
			"Gavril",
			"Gavrilă",
			"Gavrilescu",
			"Gavriliu",
			"Gavriloae",
			"Gavriloaie",
			"Gavriluță",
			"Gavriș",
			"Geamănă",
			"Geantă",
			"Geoana",
			"Georgescu",
			"Ghena",
			"Ghencean",
			"Ghenghe",
			"Gheoace",
			"Gheorghe",
			"Gheorghel",
			"Gheorghescu",
			"Gheorghică",
			"Gheorghiu",
			"Gherasim",
			"Ghercă",
			"Gherea",
			"Gherescu",
			"Gherman",
			"Ghibu",
			"Ghică",
			"Ghidirim",
			"Ghilescu",
			"Ghilezan",
			"Ghimpu",
			"Ghinea",
			"Ghiocel",
			"Ghișa",
			"Ghiță",
			"Ghițea",
			"Ghitera",
			"Ghitu",
			"Ghiu",
			"Ghiurea",
			"Gican",
			"Gigină",
			"Gilăuan",
			"Gima",
			"Gîndac",
			"Gînsari",
			"Gioșan",
			"Gîrboan",
			"Gîrjoabă",
			"Giurean",
			"Giureanu",
			"Giurescu",
			"Giurgiu",
			"Giurgiuveanu",
			"Gligor",
			"Gociu",
			"Godean",
			"Godeanu",
			"Godiac",
			"Goga",
			"Gogean",
			"Goia",
			"Goian",
			"Goie",
			"Goje",
			"Goldiș",
			"Golea",
			"Goma",
			"Gonța",
			"Gorân",
			"Gordan",
			"Gore",
			"Gorîn",
			"Grădinariu",
			"Grădinaru",
			"Grasu",
			"Grâu",
			"Graur",
			"Grecu",
			"Gref",
			"Gribincea",
			"Grigoraș",
			"Grigoreanu",
			"Grigorescu",
			"Grigoriu",
			"Grigoroiu",
			"Grivei",
			"Groparu",
			"Grosan",
			"Grosu",
			"Groza",
			"Grozea",
			"Grozeanu",
			"Grozescu",
			"Gruia",
			"Gudulea",
			"Gujel",
			"Gunescu",
			"Gușa",
			"Gușă",
			"Gustafsson",
			"Hadarca",
			"Hadârcă",
			"Hădăreanu",
			"Hagi",
			"Hăidăuțu",
			"Haiduc",
			"Haiducescu",
			"Hâjdău",
			"Halagian",
			"Haliță",
			"Halmăgean",
			"Hämäläinen",
			"Han",
			"Hâncu",
			"Handru",
			"Haneș",
			"Hănescu",
			"Hănganu",
			"Hangea",
			"Hapa",
			"Hârceagă",
			"Hașdeu",
			"Hațieganu",
			"Herăscu",
			"Herea",
			"Herescu",
			"Herineanu",
			"Herța",
			"Herțeg",
			"Hodișan",
			"Hodrea",
			"Hogaș",
			"Hojbota",
			"Holban",
			"Holmberg",
			"Hopârțean",
			"Horincar",
			"Hosu",
			"Hotar",
			"Hotea",
			"Hrițcu",
			"Hudea",
			"Huidu",
			"Hule",
			"Hulea",
			"Humiță",
			"Hunedoreanu",
			"Hurducaș",
			"Hurgoi",
			"Husar",
			"Huțanu",
			"Huțu",
			"Huțupan",
			"Huzui",
			"Iacob",
			"Iacobeanu",
			"Iacobescu",
			"Iacoviță",
			"Iagăr",
			"Iancău",
			"Ianciu",
			"Iancu",
			"Ianculescu",
			"Iaru",
			"Ichim",
			"Iederan",
			"Ielcean",
			"Ienășoiu",
			"Ieniciu",
			"Ieșan",
			"Ifrim",
			"Iftimia",
			"Iga",
			"Ignat",
			"Ignățoiu",
			"Ilaș",
			"Ile",
			"Ilea",
			"Iliaș",
			"Ilica",
			"Ilie",
			"Ilieă",
			"Ilieș",
			"Iliescu",
			"Ilionescu",
			"Ilisei",
			"Inășel",
			"Inculeț",
			"Indrie",
			"Indrieș",
			"Inovan",
			"Ioaniciu",
			"Ioja",
			"Iolu",
			"Ion",
			"Ionaș",
			"Ionașcu",
			"Ioncu",
			"Ionesco",
			"Ionescu",
			"Ioniță",
			"Iordache",
			"Iordăcheanu",
			"Iordănescu",
			"Iorga",
			"Iosif",
			"Iova",
			"Iovan",
			"Ioveanu",
			"Ioviță",
			"Irimescu",
			"Isărescu",
			"Ispas",
			"Ispirescu",
			"Istoan",
			"Istrate",
			"Istrati",
			"Iudean",
			"Iuga",
			"Iurașcu",
			"Iureș",
			"Ivan",
			"Ivănescu",
			"Ivanțoc",
			"Ivașcu",
			"Izbașa",
			"Jalea",
			"Jeican",
			"Jelea",
			"Jelescu",
			"Jianu",
			"Jilieru",
			"Jinga",
			"Jitariu",
			"Jitea",
			"Joandrea",
			"Jokinen",
			"Jora",
			"Josan",
			"Juc",
			"Jucan",
			"Judea",
			"Judean",
			"Jugaru",
			"Jula",
			"Jurcă",
			"Jurma",
			"Karjalainen",
			"Karlsson",
			"Labiș",
			"Lăcătuș",
			"Lăcătușu",
			"Lăcustă",
			"Laic",
			"Lala",
			"Lang",
			"Lăpădean",
			"Lappalainen",
			"Lăpușan",
			"Larion",
			"Lascăr",
			"Lascu",
			"Laslău",
			"Lătărețu",
			"Latcu",
			"Latiș",
			"Laurikainen",
			"Laza",
			"Lazăr",
			"Lazea",
			"Lăzureanu",
			"Leancă",
			"Lechințan",
			"Lefter",
			"Lemnaru",
			"Lenga",
			"Leonte",
			"Leordean",
			"Lepădatu",
			"Lesenciuc",
			"Leu",
			"Leucuța",
			"Licu",
			"Lificiu",
			"Liiceanu",
			"Lincar",
			"Lincu",
			"Lind",
			"Lindberg",
			"Lipa",
			"Lipan",
			"Litescu",
			"Lițiu",
			"Loghiade",
			"Loghin",
			"Loteanu",
			"Lovinescu",
			"Lozbă",
			"Luca",
			"Lucescu",
			"Ludoșan",
			"Ludușan",
			"Luncan",
			"Luncașu",
			"Lung",
			"Lungu",
			"Lup",
			"Lupan",
			"Lupaș",
			"Lupe",
			"Lupean",
			"Lupeanu",
			"Lupei",
			"Lupescu",
			"Lupșa",
			"Lupșe",
			"Lupu",
			"Lupul",
			"Mac",
			"Macari",
			"Macaru",
			"Macaveiu",
			"Măceșanu",
			"Machin",
			"Macinic",
			"Macovciuc",
			"Macovei",
			"Macovescu",
			"Mădgearu",
			"Maftuleac",
			"Magdaș",
			"Maior",
			"Maiorescu",
			"Majaru",
			"Măjeri",
			"Mălăiești",
			"Malarciuc",
			"Mălin",
			"Mălureanu",
			"Mamot",
			"Mândâcanu",
			"Mândru",
			"Mândruleanu",
			"Manea",
			"Mănescu",
			"Maniu",
			"Manolache",
			"Manole",
			"Manoliu",
			"Manu",
			"Mânzat",
			"Marc",
			"Marchiș",
			"Marcovici",
			"Marcu",
			"Marculescu",
			"Mărcuș",
			"Mareș",
			"Marga",
			"Margea",
			"Mărgelaru",
			"Mărginean",
			"Mărgineanu",
			"Marian",
			"Mărie",
			"Mărieș",
			"Marin",
			"Marinca",
			"Marincaș",
			"Mărincaș",
			"Marinescu",
			"Marișca",
			"Măriuț",
			"Martinescu",
			"Marton",
			"Mârza",
			"Mătărângă",
			"Mătărîngă",
			"Mătcaș",
			"Mătean",
			"Mateaș",
			"Mateescu",
			"Matei",
			"Mateș",
			"Mateuț",
			"Maxim",
			"Mazilescu",
			"Mazilu",
			"Meciu",
			"Medan",
			"Medrea",
			"Megheșan",
			"Melencu",
			"Melinescu",
			"Melnic",
			"Melniciuc",
			"Meniuc",
			"Mercan",
			"Mercheș",
			"Mergea",
			"Merisanu",
			"Merișescu",
			"Merlușcă",
			"Mermeze",
			"Meseșan",
			"Meteș",
			"Mețianu",
			"Mic",
			"Micle",
			"Miclea",
			"Micu",
			"Micula",
			"Miculiciu",
			"Micuț",
			"Mihacea",
			"Mihăescu",
			"Mihai",
			"Mihăilă",
			"Mihăilescu",
			"Mihaili",
			"Mihalache",
			"Mihalachi",
			"Mihalcea",
			"Mihălcescu",
			"Mihale",
			"Mihali",
			"Mihele",
			"Miherța",
			"Mihnea",
			"Mihoc",
			"Mihoci",
			"Mihu",
			"Mihuț",
			"Mihuța",
			"Mija",
			"Mikkola",
			"Milcu",
			"Milea",
			"Milescu",
			"Militaru",
			"Mincu",
			"Mîndru",
			"Mîndruță",
			"Mîndruțescu",
			"Minea",
			"Mintău",
			"Minulescu",
			"Mînzat",
			"Mirălcean",
			"Mircea",
			"Mircescu",
			"Mirea",
			"Mirescu",
			"Mirică",
			"Miron",
			"Mironeasa",
			"Mironescu",
			"Mîrza",
			"Mișină",
			"Mitariu",
			"Mititean",
			"Mititiuc",
			"Mitrache",
			"Mitran",
			"Mitrea",
			"Mitrică",
			"Mitroaica",
			"Mițu",
			"Mițulescu",
			"Mituța",
			"Miu",
			"Miulescu",
			"Mizgan",
			"Mizil",
			"Mladin",
			"Mlendea",
			"Mocanu",
			"Moceanu",
			"Moculeanu",
			"Moculescu",
			"Modoi",
			"Moga",
			"Mohanea",
			"Moianu",
			"Moise",
			"Moisescu",
			"Moisiu",
			"Moisuc",
			"Moldovan",
			"Moldovanu",
			"Moldovean",
			"Moldoveanu",
			"Molie",
			"Morar",
			"Morariu",
			"Moraru",
			"Morcoșan",
			"Morgovan",
			"Mornea",
			"Morosan",
			"Moroșan",
			"Moroșanu",
			"Moșanu",
			"Moscaliuc",
			"Moscovici",
			"Moț",
			"Motrescu",
			"Movilă",
			"Movileanu",
			"Mudrea",
			"Mudreac",
			"Mugea",
			"Mugurescu",
			"Muntea",
			"Muntean",
			"Munteanu",
			"Muntianu",
			"Murar",
			"Murariu",
			"Muraru",
			"Murea",
			"Mureăan",
			"Mureșan",
			"Mureșanu",
			"Murescu",
			"Murgu",
			"Mușat",
			"Muscă",
			"Muscaș",
			"Mutu",
			"Muzicescu",
			"Naghiu",
			"Napău",
			"Nașca",
			"Nastai",
			"Năstase",
			"Naste",
			"Naum",
			"Naumescu",
			"Neacșa",
			"Neacșu",
			"Neag",
			"Neaga",
			"Neagoe",
			"Neagu",
			"Neamț",
			"Neamțu",
			"Nechita",
			"Necșulescu",
			"Neculai",
			"Neculce",
			"Neculcea",
			"Nedelciuc",
			"Nedelcu",
			"Negoiță",
			"Negoițescu",
			"Negrău",
			"Negrea",
			"Negrean",
			"Negreanu",
			"Negrescu",
			"Negri",
			"Negrilă",
			"Negru",
			"Negruț",
			"Negruțiu",
			"Negulescu",
			"Negură",
			"Nemes",
			"Nemeș",
			"Nemoianu",
			"Nemțeanu",
			"Nenciulescu",
			"Neșa",
			"Nestor",
			"Nevalainen",
			"Nica",
			"Nichițescu",
			"Nicoară",
			"Nicolae",
			"Nicolăescu",
			"Nicolaie",
			"Nicolau",
			"Nicolescu",
			"Nicu",
			"Niculai",
			"Niculaie",
			"Niculescu",
			"Niculiță",
			"Nimaș",
			"Nisipeanu",
			"Nistor",
			"Nistorescu",
			"Nistrean",
			"Niță",
			"Nițulescu",
			"Nivalainen",
			"Noica",
			"Nuț",
			"Nuțu",
			"Oană",
			"Oancea",
			"Oarga",
			"Oatu",
			"Oblezniuc",
			"Obreja",
			"Octavian",
			"Ofițeru",
			"Olar",
			"Olariu",
			"Olaru",
			"Oleinic",
			"Olenici",
			"Olinescu",
			"Ologu",
			"Olos",
			"Oltean",
			"Olteanu",
			"Onaciu",
			"Oncescu",
			"Oncioiu",
			"Onea",
			"Onicescu",
			"Onișor",
			"Onița",
			"Onițiu",
			"Onofras",
			"Onofrei",
			"Onogea",
			"Oprea",
			"Oprescu",
			"Opriș",
			"Oprișa",
			"Oproiu",
			"Orădean",
			"Orădeanu",
			"Orășanu",
			"Ordean",
			"Oros",
			"Orz",
			"Orza",
			"Paciurea",
			"Păcurar",
			"Păcurariu",
			"Pacuraru",
			"Păcuraru",
			"Pădurar",
			"Pădurariu",
			"Păduraru",
			"Pădurean",
			"Pădureanu",
			"Pălăcean",
			"Palade",
			"Palalogoș",
			"Pălângeanu",
			"Pălărie",
			"Palega",
			"Paleologu",
			"Paler",
			"Pamfile",
			"Pamfilie",
			"Pană",
			"Panainte",
			"Pâncă",
			"Panea",
			"Panfil",
			"Pantea",
			"Pantelimon",
			"Pantiru",
			"Pantofaru",
			"Pânzariu",
			"Pap",
			"Papacostea",
			"Papadat",
			"Papadopol",
			"Papară",
			"Papu",
			"Paraschiv",
			"Parfene",
			"Parge",
			"Paroș",
			"Parțoc",
			"Pârvan",
			"Pârvovanu",
			"Pârvu",
			"Pârvulescu",
			"Pașc",
			"Pasca",
			"Pască",
			"Pascal",
			"Pascalău",
			"Paschia",
			"Pascu",
			"Pășcuțiu",
			"Pâslaru",
			"Pastiu",
			"Paștiu",
			"Păstor",
			"Patalău",
			"Pătcaș",
			"Pătrășcanu",
			"Pătrașcu",
			"Patrichi",
			"Patriciu",
			"Patroc",
			"Patron",
			"Pătru",
			"Păulescu",
			"Păun",
			"Păunescu",
			"Păvălucă",
			"Pavel",
			"Pavelescu",
			"Peciu",
			"Pelea",
			"Peneac",
			"Perciun",
			"Pescar",
			"Pescariu",
			"Pescaru",
			"Petca",
			"Petcu",
			"Petrache",
			"Petran",
			"Petrașcu",
			"Petrea",
			"Petrean",
			"Petreanu",
			"Petrencu",
			"Petrescu",
			"Petric",
			"Petriceicu",
			"Petrovici",
			"Petru",
			"Petruș",
			"Petrușel",
			"Petruț",
			"Petruțiu",
			"Piciu",
			"Picoș",
			"Pieleanu",
			"Piersic",
			"Pilca",
			"Pincu",
			"Pinte",
			"Pintea",
			"Pinteru",
			"Pintilie",
			"Pînzariu",
			"Pircăbulescu",
			"Pirtea",
			"Pîrvan",
			"Pirvu",
			"Pîrvu",
			"Pîrvulescu",
			"Piscoi",
			"Pîslaru",
			"Pistol",
			"Pitaru",
			"Piteșteanu",
			"Pițigoi",
			"Pitiritean",
			"Pitu",
			"Pițurcă",
			"Pituț",
			"Pivaru",
			"Plăcuț",
			"Plahotniuc",
			"Plămădeală",
			"Platon",
			"Pleșa",
			"Pleșu",
			"Pletea",
			"Ploieșteanu",
			"Plotuna",
			"Plugaru",
			"Plumb",
			"Podar",
			"Podariu",
			"Podoleanu",
			"Poenaru",
			"Pogor",
			"Pohilă",
			"Poienar",
			"Poienaru",
			"Poja",
			"Pojar",
			"Pojoranu",
			"Pol",
			"Pomohaci",
			"Ponor",
			"Ponorean",
			"Ponta",
			"Pop",
			"Popa",
			"Popan",
			"Popescu",
			"Popovici",
			"Popoviciu",
			"Poptean",
			"Porcar",
			"Porim",
			"Porohniuc",
			"Porumbel",
			"Porumbescu",
			"Porumboiu",
			"Postică",
			"Potângă",
			"Potcovaru",
			"Poteraș",
			"Potinteu",
			"Potop",
			"Prahovean",
			"Prahoveanu",
			"Praporgescu",
			"Precup",
			"Preda",
			"Predoiu",
			"Prelipceanu",
			"Preotu",
			"Presecan",
			"Pribag",
			"Pribagu",
			"Pribilean",
			"Pricop",
			"Prigoană",
			"Prisăcaru",
			"Prislopan",
			"Proca",
			"Prodan",
			"Prodănescu",
			"Prohin",
			"Prună",
			"Prunariu",
			"Prunaru",
			"Prunea",
			"Pruneanu",
			"Prutean",
			"Pruteanu",
			"Puia",
			"Puiu",
			"Pupăză",
			"Purcar",
			"Purdea",
			"Purge",
			"Puscaș",
			"Pușcaș",
			"Pușcașu",
			"Puțaru",
			"Putină",
			"Răceanu",
			"Raceu",
			"Racheru",
			"Răcilă",
			"Racoviță",
			"Racu",
			"Rădăcanu",
			"Rădăuțeanu",
			"Rădeanu",
			"Rădescu",
			"Rădoi",
			"Rădoiu",
			"Radu",
			"Răducă",
			"Răducan",
			"Răducanu",
			"Răducioiu",
			"Răduleanu",
			"Rădulescu",
			"Răduț",
			"Răduţă",
			"Răduțan",
			"Raețchi",
			"Răgar",
			"Raicu",
			"Răileanu",
			"Rapcea",
			"Rarău",
			"Rasica",
			"Raț",
			"Rațiu",
			"Răuț",
			"Rebengiuc",
			"Rebreanu",
			"Reliu",
			"Reniță",
			"Resmeriță",
			"Retegan",
			"Richițeanu",
			"Ripnu",
			"Riza",
			"Rizea",
			"Rodeanu",
			"Rog",
			"Rogojan",
			"Rohan",
			"Roiban",
			"Rojan",
			"Roman",
			"Român",
			"Romanciuc",
			"Romanescu",
			"Românescu",
			"Romanu",
			"Roșca",
			"Rosoga",
			"Roșu",
			"Rotar",
			"Rotaru",
			"Rotiu",
			"Rotund",
			"Rozeanu",
			"Rudeanu",
			"Rugină",
			"Rujan",
			"Runcan",
			"Rurac",
			"Rus",
			"Rusescu",
			"Rusu",
			"Sabău",
			"Saca",
			"Sadoveanu",
			"Safta",
			"Saftoiu",
			"Săftoiu",
			"Șaguna",
			"Sainciuc",
			"Sala",
			"Sălăgeanu",
			"Sălăjean",
			"Sălăjeanu",
			"Salanța",
			"Sălcudean",
			"Sălcudeanu",
			"Șamșodan",
			"Sână",
			"Sânc",
			"Sâncrăian",
			"Șandor",
			"Șandru",
			"Sandu",
			"Sandulescu",
			"Săndulescu",
			"Sane",
			"Șanta",
			"Săpuneanu",
			"Sărac",
			"Șaran",
			"Sârb",
			"Șarba",
			"Sârbu",
			"Sarca",
			"Sârca",
			"Sas",
			"Sasu",
			"Sav",
			"Sava",
			"Savescu",
			"Săvescu",
			"Savianu",
			"Savolainen",
			"Savu",
			"Săvulescu",
			"Sbârcea",
			"Scărlătescu",
			"Scrob",
			"Scrobota",
			"Scurtu",
			"Scurtuț",
			"Scutaru",
			"Sebeștean",
			"Sebestin",
			"Secelean",
			"Șeicaru",
			"Selejan",
			"Șendrea",
			"Șerban",
			"Șerbănescu",
			"Șerbușcă",
			"Șercan",
			"Sereiduc",
			"Șerif",
			"Șesan",
			"Sfecheș",
			"Sfechiș",
			"Sfirijan",
			"Silimon",
			"Sim",
			"Sima",
			"Sime",
			"Simeonescu",
			"Similea",
			"Simion",
			"Simionescu",
			"Simon",
			"Simu",
			"Simula",
			"Sin",
			"Sindile",
			"Sîngeorzan",
			"Sirca",
			"Sircă",
			"Sitaru",
			"Slavic",
			"Slavici",
			"Smochină",
			"Snegur",
			"Soare",
			"Socaciu",
			"Sociu",
			"Socol",
			"Sofron",
			"Șoim",
			"Solomon",
			"Solovastru",
			"Solzaru",
			"Somesan",
			"Someșan",
			"Someșanu",
			"Șoncutean",
			"Șonțu",
			"Soponea",
			"Soporan",
			"Sora",
			"Șora",
			"Sorescu",
			"Sorlea",
			"Sormunen",
			"Șotropa",
			"Șpan",
			"Spătăcean",
			"Spătaru",
			"Speretoiu",
			"Spinean",
			"Spinei",
			"Staicu",
			"Stan",
			"Stână",
			"Stânca",
			"Stâncă",
			"Stâncel",
			"Stăncel",
			"Stanciu",
			"Stancu",
			"Stănculescu",
			"Stanea",
			"Stănescu",
			"Stanese",
			"Stângaci",
			"Stănilă",
			"Stăniloae",
			"Stăniloaie",
			"Stănoiu",
			"Stănușoiu",
			"Stârcu",
			"Stavilă",
			"Ștefan",
			"Ștefănescu",
			"Ștefănoiu",
			"Ștefănucă",
			"Ștefu",
			"Ștegănescu",
			"Stegaru",
			"Stegerean",
			"Stejerean",
			"Stelea",
			"Stere",
			"Sterea",
			"Sterian",
			"Sticlaru",
			"Stîncel",
			"Stîngaci",
			"Știrb",
			"Știrbei",
			"Știrbu",
			"Stîrcu",
			"Stoenescu",
			"Stoian",
			"Stoica",
			"Stoicescu",
			"Stoicoiu",
			"Stoienescu",
			"Stoleru",
			"Stolnici",
			"Stolojan",
			"Storescu",
			"Strachinescu",
			"Strâmbeanu",
			"Stratan",
			"Strețea",
			"Stribei",
			"Stroe",
			"Stupariu",
			"Sturza",
			"Sturzoiu",
			"Șuba",
			"Subțirică",
			"Suceveanu",
			"Suciu",
			"Suominen",
			"Surdu",
			"Șutu",
			"Tabără",
			"Tabarcea",
			"Tăbleț",
			"Țâbuleac",
			"Tăbușcă",
			"Taciuc",
			"Talpău",
			"Tamaș",
			"Tămaș",
			"Tamazlăcaru",
			"Tănase",
			"Tănăsescu",
			"Țapu",
			"Țăran",
			"Țăranu",
			"Tărășenie",
			"Tărâță",
			"Tarcău",
			"Tarcea",
			"Tăriceanu",
			"Tărîță",
			"Târlea",
			"Târnăvan",
			"Târnăvean",
			"Tărniceru",
			"Tăslăuanu",
			"Tătar",
			"Tătăran",
			"Tătăranu",
			"Tătărean",
			"Tătăreanu",
			"Tătărescu",
			"Tătărușanu",
			"Taușan",
			"Tăutu",
			"Tavițian",
			"Tecău",
			"Țecu",
			"Tecuceanu",
			"Țeculescu",
			"Telcian",
			"Teleucă",
			"Țene",
			"Tenie",
			"Tenișan",
			"Teocan",
			"Teodor",
			"Teodorescu",
			"Teodoru",
			"Terheș",
			"Testemițianu",
			"Teșu",
			"Theodorian",
			"Tibrea",
			"Țică",
			"Tighineanu",
			"Tilea",
			"Timiș",
			"Timișoreanu",
			"Timoc",
			"Timoce",
			"Timofte",
			"Tincescu",
			"Tincu",
			"Tirculescu",
			"Țiriac",
			"Tiriplic",
			"Tîrnovan",
			"Tiroiu",
			"Tiron",
			"Tirpe",
			"Țîru",
			"Tișe",
			"Tismăneanu",
			"Titulescu",
			"Tivadar",
			"Toader",
			"Tocilescu",
			"Tocitu",
			"Tocoian",
			"Tocut",
			"Todea",
			"Todoran",
			"Todoruț",
			"Tofan",
			"Tog",
			"Țoiu",
			"Tolna",
			"Tolontan",
			"Toma",
			"Tomache",
			"Tomescu",
			"Tomofciuc",
			"Tomoiagă",
			"Tonciu",
			"Tonegaru",
			"Tontoroiu",
			"Topârceanu",
			"Topîrceanu",
			"Trahanache",
			"Traistă",
			"Trâmbițaș",
			"Trașcă",
			"Trif",
			"Trifa",
			"Trifan",
			"Trifu",
			"Trilea",
			"Trîmbițaș",
			"Tripon",
			"Tritean",
			"Trofan",
			"Trofin",
			"Trombițaș",
			"Trufan",
			"Truică",
			"Tuchilatu",
			"Țucudean",
			"Tudor",
			"Tudorache",
			"Tudoran",
			"Tudorescu",
			"Tudoroiu",
			"Tudosă",
			"Tudose",
			"Țugurlan",
			"Tulbure",
			"Tulea",
			"Tunea",
			"Tuns",
			"Tunsu",
			"Țurcă",
			"Turcanu",
			"Țurcanu",
			"Turcaș",
			"Turcescu",
			"Turcu",
			"Turdean",
			"Turian",
			"Turlan",
			"Țurțure",
			"Țuțea",
			"Tutilescu",
			"Țuțu",
			"Țuțuianu",
			"Udiștean",
			"Udișteanu",
			"Udrea",
			"Uifălean",
			"Uifăleanu",
			"Ungur",
			"Ungureanu",
			"Ungurescu",
			"Untaru",
			"Urât",
			"Urâțescu",
			"Urdăreanu",
			"Urdea",
			"Ureche",
			"Urechean",
			"Urît",
			"Urițescu",
			"Urîțescu",
			"Ursache",
			"Ursachi",
			"Ursu",
			"Ursuța",
			"Urzică",
			"Urziceanu",
			"Ușeriu",
			"Ușor",
			"Ușurelu",
			"Uță",
			"Văcărean",
			"Văcăreanu",
			"Văcărescu",
			"Vădan",
			"Văduva",
			"Văduvă",
			"Vaida",
			"Vaina",
			"Vâlceanu",
			"Vâlcov",
			"Vălean",
			"Valeca",
			"Valentin",
			"Vancea",
			"Vanciu",
			"Vancu",
			"Vântu",
			"Văran",
			"Varga",
			"Variu",
			"Varta",
			"Vârtosu",
			"Vasilache",
			"Vasile",
			"Vasilescu",
			"Vasiliu",
			"Vasluianu",
			"Vătămănescu",
			"Vatamanu",
			"Vedean",
			"Velciu",
			"Velea",
			"Velicu",
			"Verde",
			"Vereș",
			"Vermeșan",
			"Verziu",
			"Vesa",
			"Veștea",
			"Vianu",
			"Vidican",
			"Vidrean",
			"Vieru",
			"Vija",
			"Vîlceanu",
			"Vinea",
			"Vinț",
			"Vintilă",
			"Vintiloiu",
			"Vintiloju",
			"Virtanen",
			"Vișan",
			"Vișinescu",
			"Vișniec",
			"Viziru",
			"Vladimirescu",
			"Vladu",
			"Vlăducu",
			"Vlăduțescu",
			"Vlah",
			"Vlahuță",
			"Vlaicu",
			"Vlăsceanu",
			"Vlascu",
			"Vleju",
			"Vodă",
			"Voican",
			"Voicu",
			"Voiculescu",
			"Voiculeț",
			"Voina",
			"Voinea",
			"Voinescu",
			"Voinic",
			"Volontir",
			"Vorobeț",
			"Vrabie",
			"Vrăbioiu",
			"Vrâncean",
			"Vrânceanu",
			"Vranciu",
			"Vrîncean",
			"Vrînceanu",
			"Vuciu",
			"Vulc",
			"Vulcan",
			"Vulcănescu",
			"Vulpe",
			"Vulpean",
			"Vulpes",
			"Vulpeș",
			"Vultur",
			"Vușcanu",
			"Vutcărău",
			"Wallin",
			"Zabulică",
			"Zăgan",
			"Zăgănescu",
			"Zăhărescu",
			"Zaharia",
			"Zaharie",
			"Zahiu",
			"Zaiț",
			"Zaițuc",
			"Zamfir",
			"Zamfirache",
			"Zamfirescu",
			"Zanfir",
			"Zare",
			"Zarif",
			"Zăvoian",
			"Zăvoran",
			"Zăvoranu",
			"Zbârciog",
			"Zbârnea",
			"Zbranca",
			"Zdrenghia",
			"Zegreanu",
			"Zelea",
			"Zgonea",
			"Zidaru",
			"Zinca",
			"Zirbo",
			"Zisu",
			"Zoană",
			"Zota",
			"Zugrăvescu",
			"Zugravu",
		},
		Female = {
			"Adela",
			"Adelina",
			"Adina",
			"Adriana",
			"Agneta",
			"Aino",
			"Alexandra",
			"Alina",
			"Alisia",
			"Amalia",
			"Amelia",
			"Ana",
			"Anamaria",
			"Anca",
			"Ancuța",
			"Anda",
			"Andra",
			"Andrada",
			"Andreea",
			"Aneta",
			"Angela",
			"Anisa",
			"Anișoara",
			"Anne",
			"Annukka",
			"Antonia",
			"Aune",
			"Aura",
			"Aurelia",
			"Aurica",
			"Aurora",
			"Bianca",
			"Camelia",
			"Carina",
			"Carla",
			"Carmen",
			"Cătălina",
			"Catinca",
			"Catița",
			"Clara",
			"Claudia",
			"Codrina",
			"Codruța",
			"Constanța",
			"Corina",
			"Cornelia",
			"Cosmina",
			"Crina",
			"Cristiana",
			"Cristina",
			"Daciana",
			"Daliana",
			"Dalina",
			"Dana",
			"Daniela",
			"Dănuța",
			"Daria",
			"Delia",
			"Denisa",
			"Diana",
			"Dochia",
			"Doina",
			"Dora",
			"Dorina",
			"Dumitra",
			"Dumitrița",
			"Ecaterina",
			"Elena",
			"Eleonora",
			"Elina",
			"Elisabeta",
			"Eliza",
			"Elsa",
			"Elviira",
			"Elvira",
			"Emanuela",
			"Emilia",
			"Eugenia",
			"Eva",
			"Felicia",
			"Firoanda",
			"Flavia",
			"Flora",
			"Florentina",
			"Florica",
			"Florina",
			"Gabriela",
			"Geanina",
			"Georgeta",
			"Georgiana",
			"Gina",
			"Hanne",
			"Helena",
			"Heli",
			"Hilda",
			"Hortensia",
			"Ileana",
			"Ilinca",
			"Ilona",
			"Inesa",
			"Inkeri",
			"Ioana",
			"Ionela",
			"Irina",
			"Irja",
			"Isabela",
			"Iulia",
			"Iuliana",
			"Izabela",
			"Jaana",
			"Jenni",
			"Kaarina",
			"Kaisa",
			"Kamilla",
			"Kirsti",
			"Larisa",
			"Laura",
			"Lavinia",
			"Leena",
			"Leila",
			"Lenuța",
			"Leontina",
			"Letiția",
			"Liana",
			"Lidia",
			"Ligia",
			"Liliana",
			"Lisa",
			"Livia",
			"Loredana",
			"Lorena",
			"Lotta",
			"Loviisa",
			"Lucia",
			"Luciana",
			"Lucreția",
			"Luiza",
			"Luminița",
			"Mădălina",
			"Magda",
			"Magdalena",
			"Maia",
			"Manuela",
			"Mara",
			"Marcela",
			"Margareta",
			"Maria",
			"Mariana",
			"Marieta",
			"Marilena",
			"Marina",
			"Marinela",
			"Marioara",
			"Mărioara",
			"Marișca",
			"Măriuca",
			"Marta",
			"Matilda",
			"Melania",
			"Melisa",
			"Mihaela",
			"Milena",
			"Minna",
			"Mioara",
			"Mirabela",
			"Mirela",
			"Miruna",
			"Mona",
			"Monica",
			"Morica",
			"Nadia",
			"Nadina",
			"Narcisa",
			"Natalia",
			"Nea",
			"Nelli",
			"Netta",
			"Nichita",
			"Nicoleta",
			"Niculina",
			"Nina",
			"Oana",
			"Octavia",
			"Olimpia",
			"Olivia",
			"Olivia",
			"Oona",
			"Otilia",
			"Patricia",
			"Paula",
			"Persida",
			"Petra",
			"Petronela",
			"Petruța",
			"Rafaela",
			"Raluca",
			"Ramona",
			"Rauha",
			"Rebeca",
			"Reetta",
			"Renata",
			"Roberta",
			"Rodica",
			"Romanița",
			"Romina",
			"Ronja",
			"Roxana",
			"Rozalia",
			"Rozica",
			"Ruxandra",
			"Sabina",
			"Samica",
			"Sanda",
			"Sandra",
			"Sanna",
			"Saveta",
			"Sigrid",
			"Siiri",
			"Silvia",
			"Simona",
			"Sofia",
			"Sonia",
			"Sorina",
			"Ștefana",
			"Ștefania",
			"Stela",
			"Tamara",
			"Tatiana",
			"Teodora",
			"Tiina",
			"Ulla",
			"Valentina",
			"Valeria",
			"Valerica",
			"Venla",
			"Veronica",
			"Victoria",
			"Viorica",
			"Voichița",
			"Zeina",
			"Zoia",
			-- Bulgarian and Russian (for now)
			Family = {},
		},
		Male = {
			"Aapeli",
			"Aarne",
			"Adam",
			"Adelin",
			"Adrian",
			"Alex",
			"Alexandru",
			"Alin",
			"Anatolie",
			"Andrei",
			"Anghel",
			"Antero",
			"Anton",
			"Antonie",
			"Antoniu",
			"Antti",
			"Apostol",
			"Arsenie",
			"Arvi",
			"Augustin",
			"Aurel",
			"Aurelian",
			"Avram",
			"Barbu",
			"Bogdan",
			"Călin",
			"Camil",
			"Carol",
			"Casian",
			"Cătălin",
			"Cezar",
			"Ciprian",
			"Claudiu",
			"Codin",
			"Codrin",
			"Codruț",
			"Constantin",
			"Coriolan",
			"Cornel",
			"Corneliu",
			"Corvin",
			"Cosmin",
			"Costache",
			"Costel",
			"Costin",
			"Cozma",
			"Crin",
			"Cristian",
			"Cristofor",
			"Dacian",
			"Damian",
			"Dan",
			"Daniel",
			"Darian",
			"Dariu",
			"Darius",
			"David",
			"Decebal",
			"Denis",
			"Dimitrie",
			"Dinu",
			"Dorian",
			"Dorin",
			"Doru",
			"Dragomir",
			"Dragoș",
			"Dumitru",
			"Eduard",
			"Edvin",
			"Eemeli",
			"Eero",
			"Eftimie",
			"Einari",
			"Eliodor",
			"Elmeri",
			"Emanuel",
			"Emanuil",
			"Emil",
			"Emilian",
			"Enache",
			"Eremia",
			"Eugen",
			"Eugeniu",
			"Eusebiu",
			"Fabian",
			"Felician",
			"Felix",
			"Filip",
			"Flaviu",
			"Flavius",
			"Florentin",
			"Florian",
			"Florin",
			"Fredrik",
			"Gabriel",
			"Gavril",
			"Gelu",
			"George",
			"Ghenadie",
			"Gheorghe",
			"Ghiță",
			"Gica",
			"Glad",
			"Grațian",
			"Grigore",
			"Hannes",
			"Hannu",
			"Horațiu",
			"Horea",
			"Horia",
			"Iacob",
			"Iancu",
			"Ieremia",
			"Ignat",
			"Ignațiu",
			"Iivari",
			"Ilari",
			"Ilarie",
			"Ilarion",
			"Ilie",
			"Ilmari",
			"Ioan",
			"Ion",
			"Ionel",
			"Ionuț",
			"Iordache",
			"Iordan",
			"Iorghu",
			"Iorgu",
			"Iosif",
			"Irinel",
			"Irineu",
			"Iulian",
			"Iuliu",
			"Iurie",
			"Iustin",
			"Iustinian",
			"Ivantie",
			"Jouni",
			"Juha",
			"Juhani",
			"Juho",
			"Kaarle",
			"Kalevi",
			"Kalle",
			"Kari",
			"Kasperi",
			"Lascăr",
			"Lasse",
			"Latcu",
			"Laur",
			"Laurențiu",
			"Lauri",
			"Laviniu",
			"Lazăr",
			"Leevi",
			"Leonard",
			"Leontin",
			"Lică",
			"Liviu",
			"Lorin",
			"Luca",
			"Lucian",
			"Lucrețiu",
			"Mădălin",
			"Manea",
			"Manole",
			"Manuel",
			"Marc",
			"Marcel",
			"Marcu",
			"Marian",
			"Marin",
			"Marinache",
			"Marinel",
			"Marius",
			"Markku",
			"Matei",
			"Mauri",
			"Maximilian",
			"Mihai",
			"Mihail",
			"Mihnea",
			"Mikael",
			"Mikko",
			"Mircea",
			"Mirel",
			"Miron",
			"Mitică",
			"Mitru",
			"Mitruț",
			"Moise",
			"Mugur",
			"Narcis",
			"Naum",
			"Nechifor",
			"Neculai",
			"Nelu",
			"Nichifor",
			"Nicoară",
			"Nicolae",
			"Nicolaie",
			"Nicu",
			"Niculae",
			"Niculaie",
			"Nicușor",
			"Niko",
			"Nistor",
			"Octavian",
			"Olavi",
			"Olimpiu",
			"Oliviu",
			"Olli",
			"Oskari",
			"Ovidiu",
			"Patriciu",
			"Paul",
			"Pauli",
			"Pavel",
			"Pertti",
			"Petre",
			"Petrică",
			"Petru",
			"Pompiliu",
			"Puiu",
			"Radu",
			"Raimo",
			"Rareș",
			"Raul",
			"Răzvan",
			"Relu",
			"Remus",
			"Risto",
			"Robert",
			"Roman",
			"Romică",
			"Sabin",
			"Sami",
			"Sandu",
			"Sauli",
			"Sebastian",
			"Șerban",
			"Sergiu",
			"Sever",
			"Silviu",
			"Simion",
			"Simo",
			"Sorin",
			"Spiru",
			"Stan",
			"Ștefan",
			"Stelian",
			"Stroe",
			"Tache",
			"Tapani",
			"Teodor",
			"Teuvo",
			"Theodor",
			"Tiberiu",
			"Timotei",
			"Titu",
			"Titus",
			"Toader",
			"Toma",
			"Traian",
			"Tudor",
			"Unto",
			"Vadim",
			"Väinö",
			"Valentin",
			"Valerian",
			"Valeriu",
			"Vasile",
			"Veikko",
			"Vicențiu",
			"Victor",
			"Viljami",
			"Ville",
			"Vintilă",
			"Viorel",
			"Virgil",
			"Virgiliu",
			"Vlad",
			"Vladimir",
			"Vlaicu",
			"Voicu",
			"Yrjö",
			"Zaharia",
			"Zamfir",
			Family = {},
		},
		-- add some extra names associated with space (loosely)
		Unique = {
			Female = {
				"Anna Fisher",
				"Christa McAuliffe",
				"Judith Resnik",
				"Kalpana Chawla",
				"Kathryn D. Sullivan",
				"Laurel B. Clark",
				"Sally Ride",
				"Svetlana Savitskaya",
				"Valentina Tereshkova",
			},
			Male = {
				"Adolf Thiel",
				"Alan T. Waterman",
				"Albert Zeiler",
				"Albin Wittmann",
				"Aleksandr Lyapunov",
				"Alexander Bolonkin",
				"Alexander Kemurdzhian",
				"Alexander M. Lippisch",
				"Andreas Alexandrakis",
				"Apollo M. O. Smith",
				"Arkady Ostashev",
				"Arthur Rudolph",
				"August Schulze",
				"Auguste Piccard",
				"Bernhard Tessmann",
				"Boris Chertok",
				"Charles Gifford",
				"Chuck Yeager",
				"Dieter Grau",
				"Dieter Huzel",
				"Dmitri Ilyich Kozlov",
				"Dmitry Okhotsimsky",
				"Eberhard Rees",
				"Edward S. Forman",
				"Erich W. Neubert",
				"Ernst Geissler",
				"Ernst R. G. Eckert",
				"Ernst Stuhlinger",
				"Eugene Saenger",
				"Frank Malina",
				"Fridtjof Speer",
				"Friedrich von Saurma",
				"Friedrich Zander",
				"Fritz Mueller",
				"Georg E. Knausenberger",
				"Georg Rickhey",
				"Georg von Tiesenhausen",
				"George Edward Pendray",
				"George H. Ludwig",
				"Georgy Babakin",
				"Gerhard Reisig",
				"Glenn L. Martin",
				"Guenter Wendt",
				"György Marx",
				"Hans Fichtner",
				"Hans Hosenthien",
				"Hans Hueter",
				"Hans Maus",
				"Hans R. Palaoro",
				"Harry Ruppe",
				"Harry W. Bull",
				"Heinz-Hermann Koelle",
				"Helmut Gröttrup",
				"Helmut Hölzer",
				"Helmut Zoike",
				"Herman Potočnik",
				"Hermann H. Kurzweg",
				"Hermann Oberth",
				"Hubert E. Kroh",
				"Igor Kurchatov",
				"Ivan Kleimenov",
				"Jack Parsons",
				"James Hart Wyld",
				"James Van Allen",
				"Jean d'Alembert",
				"Jean Piccard",
				"Jesco von Puttkamer",
				"Johannes Kepler",
				"John Bruce Medaris",
				"Joseph-Louis Lagrange",
				"Karl Heimburg",
				"Klaus Riedel",
				"Konrad Dannenberg",
				"Konstantin Tsiolkovsky",
				"Krafft Arnold Ehricke",
				"Kurt H. Debus",
				"Leonhard Euler",
				"Leonid A. Voskresenskiy",
				"Lovell Lawrence Jr.",
				"Ludwig Prandtl",
				"Ludwig Roth",
				"Martin Summerfield",
				"Mikhail B. Dobriyan",
				"Mikhail Gurevich",
				"Mikhail Tikhonravov",
				"Mikhail Yangel",
				"Milton Rosen",
				"Mstislav Keldysh",
				"Nikolay Pilyugin",
				"Oswald Lange",
				"Otto Hirschler",
				"Qian Xuesen",
				"Robert Esnault-Pelterie",
				"Robert H. Goddard",
				"Rudi Beichel",
				"Rudolf Nebel",
				"Sergei Korolev",
				"Theodor A. Poppel",
				"Theodor Karl Otto Vowe",
				"Theodore von Kármán",
				"Valentin Glushko",
				"Vasily Mishin",
				"Vladimir Chelomey",
				"Vladimir Komarov",
				"Vladimir Syromyatnikov",
				"Walter Dornberger",
				"Walter Häussermann",
				"Walter Riedel",
				"Walter Schwidetzky",
				"Walter Thiel",
				"Weld Arnold",
				"Werner Dahm",
				"Werner Kuers",
				"Werner Rosinski",
				"Wernher von Braun",
				"Wilhelm Jungert",
				"William Mrazek",
				"William Pickering",
				"Willy Ley",
				"Willy Mrazek",
				"Yevgeny Ostashev",
				"Yuri Gagarin",
				"Yuri Shargin",
			},
		},
	}

	-- loop through each nation group
	for Name_R, Race in pairs(HumanNames) do
		-- then each type of name Family, Female, Male, Unique
		for Type, Names in pairs(Race) do

			-- first + last
			if Type == "Unique" then
				for Type2, Names2 in pairs(Names) do
					for i = 1, #Names2 do
						name_table[Type][Type2][#name_table[Type][Type2]+1] = Names2[i]
					end
				end

			-- Bulgarian and Russian both have extra tables added (you can probably add this to any lang, but I haven't checked)
			elseif Name_R == "Bulgarian" or Name_R == "Russian" then
				for Type2, Names2 in pairs(Names) do
					if Type2 == "First" then
						for i = 1, #Names2 do
							name_table[Type][#name_table[Type]+1] = Names2[i]
						end
					else
						-- family
						for i = 1, #Names2 do
							name_table[Type][Type2][#name_table[Type][Type2]+1] = Names2[i]
						end
					end
				end

			-- regular names (Female, Male, Family)
			else
				for i = 1, #Names do
					name_table[Type][#name_table[Type]+1] = Names[i]
				end
			end

		end
	end


	-- Instead of just replacing the orig table we add on to it (just in case more nations are added, maybe by another mod)
	local c = #Nations

	-- make sure built-in ones use my bigger flags
	c = AddExisting("English", "the_united_kingdom", Nations, c)
	c = AddExisting("American", "the_united_states", Nations, c)
	c = AddExisting("German", "germany", Nations, c)
	c = AddExisting("French", "france", Nations, c)
	c = AddExisting("Russian", "russia", Nations, c)
	c = AddExisting("Chinese", "the_peoples_republic_of_china", Nations, c)
	c = AddExisting("Bulgarian", "bulgaria", Nations, c)
	c = AddExisting("Indian", "india", Nations, c)
	c = AddExisting("Swedish", "sweden", Nations, c)
	-- Gagarin added names
	c = AddExisting("Japanese", "japan", Nations, c)
	c = AddExisting("Brazilian", "brazil", Nations, c)

	do -- add new nations
		c = c + 1
		Nations[c] = {
			value = "abkhazia",
			text = "Abkhazia",
			flag = path .. "abkhazia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "afghanistan",
			text = "Afghanistan",
			flag = path .. "afghanistan.png",
		}
		c = c + 1
		Nations[c] = {
			value = "aland",
			text = "Aland",
			flag = path .. "aland.png",
		}
		c = c + 1
		Nations[c] = {
			value = "alaska",
			text = "Alaska",
			flag = path .. "alaska.png",
		}
		c = c + 1
		Nations[c] = {
			value = "albania",
			text = "Albania",
			flag = path .. "albania.png",
		}
		c = c + 1
		Nations[c] = {
			value = "alderney",
			text = "Alderney",
			flag = path .. "alderney.png",
		}
		c = c + 1
		Nations[c] = {
			value = "algeria",
			text = "Algeria",
			flag = path .. "algeria.png",
		}
		c = c + 1
		Nations[c] = {
			value = "american_samoa",
			text = "American Samoa",
			flag = path .. "american_samoa.png",
		}
		c = c + 1
		Nations[c] = {
			value = "andorra",
			text = "Andorra",
			flag = path .. "andorra.png",
		}
		c = c + 1
		Nations[c] = {
			value = "angola",
			text = "Angola",
			flag = path .. "angola.png",
		}
		c = c + 1
		Nations[c] = {
			value = "anguilla",
			text = "Anguilla",
			flag = path .. "anguilla.png",
		}
		c = c + 1
		Nations[c] = {
			value = "anjouan",
			text = "Anjouan",
			flag = path .. "anjouan.png",
		}
		c = c + 1
		Nations[c] = {
			value = "antigua_and_barbuda",
			text = "Antigua And Barbuda",
			flag = path .. "antigua_and_barbuda.png",
		}
		c = c + 1
		Nations[c] = {
			value = "argentina",
			text = "Argentina",
			flag = path .. "argentina.png",
		}
		c = c + 1
		Nations[c] = {
			value = "armenia",
			text = "Armenia",
			flag = path .. "armenia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "artsakh",
			text = "Artsakh",
			flag = path .. "artsakh.png",
		}
		c = c + 1
		Nations[c] = {
			value = "aruba",
			text = "Aruba",
			flag = path .. "aruba.png",
		}
		c = c + 1
		Nations[c] = {
			value = "ascension_island",
			text = "Ascension Island",
			flag = path .. "ascension_island.png",
		}
		c = c + 1
		Nations[c] = {
			value = "ashanti",
			text = "Ashanti",
			flag = path .. "ashanti.png",
		}
		c = c + 1
		Nations[c] = {
			value = "australia",
			text = "Australia",
			flag = path .. "australia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "austria-hungary",
			text = "Austria-hungary",
			flag = path .. "austria-hungary.png",
		}
		c = c + 1
		Nations[c] = {
			value = "austria",
			text = "Austria",
			flag = path .. "austria.png",
		}
		c = c + 1
		Nations[c] = {
			value = "azerbaijan",
			text = "Azerbaijan",
			flag = path .. "azerbaijan.png",
		}
		c = c + 1
		Nations[c] = {
			value = "bahrain",
			text = "Bahrain",
			flag = path .. "bahrain.png",
		}
		c = c + 1
		Nations[c] = {
			value = "balawaristan",
			text = "Balawaristan",
			flag = path .. "balawaristan.png",
		}
		c = c + 1
		Nations[c] = {
			value = "bamileke_national_movement",
			text = "Bamileke National Movement",
			flag = path .. "bamileke_national_movement.png",
		}
		c = c + 1
		Nations[c] = {
			value = "bangladesh",
			text = "Bangladesh",
			flag = path .. "bangladesh.png",
		}
		c = c + 1
		Nations[c] = {
			value = "barbados",
			text = "Barbados",
			flag = path .. "barbados.png",
		}
		c = c + 1
		Nations[c] = {
			value = "bavaria",
			text = "Bavaria",
			flag = path .. "bavaria.png",
		}
		c = c + 1
		Nations[c] = {
			value = "belarus",
			text = "Belarus",
			flag = path .. "belarus.png",
		}
		c = c + 1
		Nations[c] = {
			value = "belgium",
			text = "Belgium",
			flag = path .. "belgium.png",
		}
		c = c + 1
		Nations[c] = {
			value = "belize",
			text = "Belize",
			flag = path .. "belize.png",
		}
		c = c + 1
		Nations[c] = {
			value = "benin",
			text = "Benin",
			flag = path .. "benin.png",
		}
		c = c + 1
		Nations[c] = {
			value = "bermuda",
			text = "Bermuda",
			flag = path .. "bermuda.png",
		}
		c = c + 1
		Nations[c] = {
			value = "bhutan",
			text = "Bhutan",
			flag = path .. "bhutan.png",
		}
		c = c + 1
		Nations[c] = {
			value = "biafra",
			text = "Biafra",
			flag = path .. "biafra.png",
		}
		c = c + 1
		Nations[c] = {
			value = "bolivia",
			text = "Bolivia",
			flag = path .. "bolivia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "bonaire",
			text = "Bonaire",
			flag = path .. "bonaire.png",
		}
		c = c + 1
		Nations[c] = {
			value = "bonnie_blue_flag_the_confederate_states_of_america",
			text = "Bonnie Blue Flag The Confederate States Of America",
			flag = path .. "bonnie_blue_flag_the_confederate_states_of_america.png",
		}
		c = c + 1
		Nations[c] = {
			value = "bophuthatswana",
			text = "Bophuthatswana",
			flag = path .. "bophuthatswana.png",
		}
		c = c + 1
		Nations[c] = {
			value = "bora_bora",
			text = "Bora Bora",
			flag = path .. "bora_bora.png",
		}
		c = c + 1
		Nations[c] = {
			value = "bosnia_and_herzegovina",
			text = "Bosnia And Herzegovina",
			flag = path .. "bosnia_and_herzegovina.png",
		}
		c = c + 1
		Nations[c] = {
			value = "botswana",
			text = "Botswana",
			flag = path .. "botswana.png",
		}
		c = c + 1
		Nations[c] = {
			value = "bougainville",
			text = "Bougainville",
			flag = path .. "bougainville.png",
		}
		c = c + 1
		Nations[c] = {
			value = "brittany",
			text = "Brittany",
			flag = path .. "brittany.png",
		}
		c = c + 1
		Nations[c] = {
			value = "brunei",
			text = "Brunei",
			flag = path .. "brunei.png",
		}
		c = c + 1
		Nations[c] = {
			value = "bumbunga",
			text = "Bumbunga",
			flag = path .. "bumbunga.png",
		}
		c = c + 1
		Nations[c] = {
			value = "burkina_faso",
			text = "Burkina Faso",
			flag = path .. "burkina_faso.png",
		}
		c = c + 1
		Nations[c] = {
			value = "burundi",
			text = "Burundi",
			flag = path .. "burundi.png",
		}
		c = c + 1
		Nations[c] = {
			value = "byelorussian_ssr",
			text = "Byelorussian SSR",
			flag = path .. "byelorussian_ssr.png",
		}
		c = c + 1
		Nations[c] = {
			value = "cabinda",
			text = "Cabinda",
			flag = path .. "cabinda.png",
		}
		c = c + 1
		Nations[c] = {
			value = "california",
			text = "California",
			flag = path .. "california.png",
		}
		c = c + 1
		Nations[c] = {
			value = "california_independence",
			text = "California Independence",
			flag = path .. "california_independence.png",
		}
		c = c + 1
		Nations[c] = {
			value = "cambodia",
			text = "Cambodia",
			flag = path .. "cambodia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "cameroon",
			text = "Cameroon",
			flag = path .. "cameroon.png",
		}
		c = c + 1
		Nations[c] = {
			value = "canada",
			text = "Canada",
			flag = path .. "canada.png",
		}
		c = c + 1
		Nations[c] = {
			value = "cantabrian_labaru",
			text = "Cantabrian Labaru",
			flag = path .. "cantabrian_labaru.png",
		}
		c = c + 1
		Nations[c] = {
			value = "canu",
			text = "Canu",
			flag = path .. "canu.png",
		}
		c = c + 1
		Nations[c] = {
			value = "cape_verde",
			text = "Cape Verde",
			flag = path .. "cape_verde.png",
		}
		c = c + 1
		Nations[c] = {
			value = "casamance",
			text = "Casamance",
			flag = path .. "casamance.png",
		}
		c = c + 1
		Nations[c] = {
			value = "cascadia",
			text = "Cascadia",
			flag = path .. "cascadia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "castile",
			text = "Castile",
			flag = path .. "castile.png",
		}
		c = c + 1
		Nations[c] = {
			value = "chad",
			text = "Chad",
			flag = path .. "chad.png",
		}
		c = c + 1
		Nations[c] = {
			value = "chechen_republic_of_ichkeria",
			text = "Chechen Republic Of Ichkeria",
			flag = path .. "chechen_republic_of_ichkeria.png",
		}
		c = c + 1
		Nations[c] = {
			value = "chile",
			text = "Chile",
			flag = path .. "chile.png",
		}
		c = c + 1
		Nations[c] = {
			value = "chin_national_front",
			text = "Chin National Front",
			flag = path .. "chin_national_front.png",
		}
		c = c + 1
		Nations[c] = {
			value = "christmas_island",
			text = "Christmas Island",
			flag = path .. "christmas_island.png",
		}
		c = c + 1
		Nations[c] = {
			value = "ciskei",
			text = "Ciskei",
			flag = path .. "ciskei.png",
		}
		c = c + 1
		Nations[c] = {
			value = "colombia",
			text = "Colombia",
			flag = path .. "colombia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "cornwall",
			text = "Cornwall",
			flag = path .. "cornwall.png",
		}
		c = c + 1
		Nations[c] = {
			value = "corsica",
			text = "Corsica",
			flag = path .. "corsica.png",
		}
		c = c + 1
		Nations[c] = {
			value = "cospaia",
			text = "Cospaia",
			flag = path .. "cospaia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "costa_rica",
			text = "Costa Rica",
			flag = path .. "costa_rica.png",
		}
		c = c + 1
		Nations[c] = {
			value = "cote_divoire",
			text = "Cote Divoire",
			flag = path .. "cote_divoire.png",
		}
		c = c + 1
		Nations[c] = {
			value = "cretan_state",
			text = "Cretan State",
			flag = path .. "cretan_state.png",
		}
		c = c + 1
		Nations[c] = {
			value = "crimea",
			text = "Crimea",
			flag = path .. "crimea.png",
		}
		c = c + 1
		Nations[c] = {
			value = "croatia",
			text = "Croatia",
			flag = path .. "croatia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "cuba",
			text = "Cuba",
			flag = path .. "cuba.png",
		}
		c = c + 1
		Nations[c] = {
			value = "curacao",
			text = "Curacao",
			flag = path .. "curacao.png",
		}
		c = c + 1
		Nations[c] = {
			value = "cyprus",
			text = "Cyprus",
			flag = path .. "cyprus.png",
		}
		c = c + 1
		Nations[c] = {
			value = "dar_el_kuti_republic",
			text = "Dar El Kuti Republic",
			flag = path .. "dar_el_kuti_republic.png",
		}
		c = c + 1
		Nations[c] = {
			value = "denmark",
			text = "Denmark",
			flag = path .. "denmark.png",
		}
		c = c + 1
		Nations[c] = {
			value = "djibouti",
			text = "Djibouti",
			flag = path .. "djibouti.png",
		}
		c = c + 1
		Nations[c] = {
			value = "dominica",
			text = "Dominica",
			flag = path .. "dominica.png",
		}
		c = c + 1
		Nations[c] = {
			value = "donetsk_oblast",
			text = "Donetsk Oblast",
			flag = path .. "donetsk_oblast.png",
		}
		c = c + 1
		Nations[c] = {
			value = "eastern_rumelia",
			text = "Eastern Rumelia",
			flag = path .. "eastern_rumelia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "easter_island",
			text = "Easter Island",
			flag = path .. "easter_island.png",
		}
		c = c + 1
		Nations[c] = {
			value = "east_germany",
			text = "East Germany",
			flag = path .. "east_germany.png",
		}
		c = c + 1
		Nations[c] = {
			value = "east_timor",
			text = "East Timor",
			flag = path .. "east_timor.png",
		}
		c = c + 1
		Nations[c] = {
			value = "ecuador",
			text = "Ecuador",
			flag = path .. "ecuador.png",
		}
		c = c + 1
		Nations[c] = {
			value = "egypt",
			text = "Egypt",
			flag = path .. "egypt.png",
		}
		c = c + 1
		Nations[c] = {
			value = "el_salvador",
			text = "El Salvador",
			flag = path .. "el_salvador.png",
		}
		c = c + 1
		Nations[c] = {
			value = "enenkio",
			text = "Enenkio",
			flag = path .. "enenkio.png",
		}
		c = c + 1
		Nations[c] = {
			value = "england",
			text = "England",
			flag = path .. "england.png",
		}
		c = c + 1
		Nations[c] = {
			value = "equatorial_guinea",
			text = "Equatorial Guinea",
			flag = path .. "equatorial_guinea.png",
		}
		c = c + 1
		Nations[c] = {
			value = "eritrea",
			text = "Eritrea",
			flag = path .. "eritrea.png",
		}
		c = c + 1
		Nations[c] = {
			value = "estonia",
			text = "Estonia",
			flag = path .. "estonia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "ethiopia",
			text = "Ethiopia",
			flag = path .. "ethiopia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "evis",
			text = "Evis",
			flag = path .. "evis.png",
		}
		c = c + 1
		Nations[c] = {
			value = "fiji",
			text = "Fiji",
			flag = path .. "fiji.png",
		}
		c = c + 1
		Nations[c] = {
			value = "finland",
			text = "Finland",
			flag = path .. "finland.png",
		}
		c = c + 1
		Nations[c] = {
			value = "flnks",
			text = "Front de Libération Nationale Kanak et Socialiste",
			flag = path .. "flnks.png",
		}
		c = c + 1
		Nations[c] = {
			value = "forcas_and_careiras",
			text = "Forcas And Careiras",
			flag = path .. "forcas_and_careiras.png",
		}
		c = c + 1
		Nations[c] = {
			value = "formosa",
			text = "Formosa",
			flag = path .. "formosa.png",
		}
		c = c + 1
		Nations[c] = {
			value = "franceville",
			text = "Franceville",
			flag = path .. "franceville.png",
		}
		c = c + 1
		Nations[c] = {
			value = "free_aceh_movement",
			text = "Free Aceh Movement",
			flag = path .. "free_aceh_movement.png",
		}
		c = c + 1
		Nations[c] = {
			value = "free_morbhan_republic",
			text = "Free Morbhan Republic",
			flag = path .. "free_morbhan_republic.png",
		}
		c = c + 1
		Nations[c] = {
			value = "free_territory_trieste",
			text = "Free Territory Trieste",
			flag = path .. "free_territory_trieste.png",
		}
		c = c + 1
		Nations[c] = {
			value = "french_guiana",
			text = "French Guiana",
			flag = path .. "french_guiana.png",
		}
		c = c + 1
		Nations[c] = {
			value = "french_polynesia",
			text = "French Polynesia",
			flag = path .. "french_polynesia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "gabon",
			text = "Gabon",
			flag = path .. "gabon.png",
		}
		c = c + 1
		Nations[c] = {
			value = "gdansk",
			text = "Gdansk",
			flag = path .. "gdansk.png",
		}
		c = c + 1
		Nations[c] = {
			value = "genoa",
			text = "Genoa",
			flag = path .. "genoa.png",
		}
		c = c + 1
		Nations[c] = {
			value = "georgia",
			text = "Georgia",
			flag = path .. "georgia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "ghana",
			text = "Ghana",
			flag = path .. "ghana.png",
		}
		c = c + 1
		Nations[c] = {
			value = "gibraltar",
			text = "Gibraltar",
			flag = path .. "gibraltar.png",
		}
		c = c + 1
		Nations[c] = {
			value = "greece",
			text = "Greece",
			flag = path .. "greece.png",
		}
		c = c + 1
		Nations[c] = {
			value = "greenland",
			text = "Greenland",
			flag = path .. "greenland.png",
		}
		c = c + 1
		Nations[c] = {
			value = "grenada",
			text = "Grenada",
			flag = path .. "grenada.png",
		}
		c = c + 1
		Nations[c] = {
			value = "grobherzogtum_baden",
			text = "Grobherzogtum Baden",
			flag = path .. "grobherzogtum_baden.png",
		}
		c = c + 1
		Nations[c] = {
			value = "grobherzogtum_hessen_ohne_wappen",
			text = "Grobherzogtum Hessen Ohne Wappen",
			flag = path .. "grobherzogtum_hessen_ohne_wappen.png",
		}
		c = c + 1
		Nations[c] = {
			value = "guadeloupe",
			text = "Guadeloupe",
			flag = path .. "guadeloupe.png",
		}
		c = c + 1
		Nations[c] = {
			value = "guam",
			text = "Guam",
			flag = path .. "guam.png",
		}
		c = c + 1
		Nations[c] = {
			value = "guangdong",
			text = "Guangdong",
			flag = path .. "guangdong.png",
		}
		c = c + 1
		Nations[c] = {
			value = "guatemala",
			text = "Guatemala",
			flag = path .. "guatemala.png",
		}
		c = c + 1
		Nations[c] = {
			value = "guernsey",
			text = "Guernsey",
			flag = path .. "guernsey.png",
		}
		c = c + 1
		Nations[c] = {
			value = "guinea-bissau",
			text = "Guinea-bissau",
			flag = path .. "guinea-bissau.png",
		}
		c = c + 1
		Nations[c] = {
			value = "guinea",
			text = "Guinea",
			flag = path .. "guinea.png",
		}
		c = c + 1
		Nations[c] = {
			value = "gurkhaland",
			text = "Gurkhaland",
			flag = path .. "gurkhaland.png",
		}
		c = c + 1
		Nations[c] = {
			value = "guyana",
			text = "Guyana",
			flag = path .. "guyana.png",
		}
		c = c + 1
		Nations[c] = {
			value = "gwynedd",
			text = "Gwynedd",
			flag = path .. "gwynedd.png",
		}
		c = c + 1
		Nations[c] = {
			value = "haiti",
			text = "Haiti",
			flag = path .. "haiti.png",
		}
		c = c + 1
		Nations[c] = {
			value = "hawaii",
			text = "Hawaii",
			flag = path .. "hawaii.png",
		}
		c = c + 1
		Nations[c] = {
			value = "hejaz",
			text = "Hejaz",
			flag = path .. "hejaz.png",
		}
		c = c + 1
		Nations[c] = {
			value = "honduras",
			text = "Honduras",
			flag = path .. "honduras.png",
		}
		c = c + 1
		Nations[c] = {
			value = "hong_kong",
			text = "Hong Kong",
			flag = path .. "hong_kong.png",
		}
		c = c + 1
		Nations[c] = {
			value = "huahine",
			text = "Huahine",
			flag = path .. "huahine.png",
		}
		c = c + 1
		Nations[c] = {
			value = "hungary",
			text = "Hungary",
			flag = path .. "hungary.png",
		}
		c = c + 1
		Nations[c] = {
			value = "hyderabad_state",
			text = "Hyderabad State",
			flag = path .. "hyderabad_state.png",
		}
		c = c + 1
		Nations[c] = {
			value = "iceland",
			text = "Iceland",
			flag = path .. "iceland.png",
		}
		c = c + 1
		Nations[c] = {
			value = "idel-ural_state",
			text = "Idel-ural State",
			flag = path .. "idel-ural_state.png",
		}
		c = c + 1
		Nations[c] = {
			value = "independent_state_of_croatia",
			text = "Independent State Of Croatia",
			flag = path .. "independent_state_of_croatia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "indonesia",
			text = "Indonesia",
			flag = path .. "indonesia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "iran",
			text = "Iran",
			flag = path .. "iran.png",
		}
		c = c + 1
		Nations[c] = {
			value = "iraq",
			text = "Iraq",
			flag = path .. "iraq.png",
		}
		c = c + 1
		Nations[c] = {
			value = "ireland",
			text = "Ireland",
			flag = path .. "ireland.png",
		}
		c = c + 1
		Nations[c] = {
			value = "israel",
			text = "Israel",
			flag = path .. "israel.png",
		}
		c = c + 1
		Nations[c] = {
			value = "italy",
			text = "Italy",
			flag = path .. "italy.png",
		}
		c = c + 1
		Nations[c] = {
			value = "jamaica",
			text = "Jamaica",
			flag = path .. "jamaica.png",
		}
		c = c + 1
		Nations[c] = {
			value = "japan",
			text = "Japan",
			flag = path .. "japan.png",
		}
		c = c + 1
		Nations[c] = {
			value = "jersey",
			text = "Jersey",
			flag = path .. "jersey.png",
		}
		c = c + 1
		Nations[c] = {
			value = "johnston_atoll",
			text = "Johnston Atoll",
			flag = path .. "johnston_atoll.png",
		}
		c = c + 1
		Nations[c] = {
			value = "jordan",
			text = "Jordan",
			flag = path .. "jordan.png",
		}
		c = c + 1
		Nations[c] = {
			value = "kapok",
			text = "Kapok",
			flag = path .. "kapok.png",
		}
		c = c + 1
		Nations[c] = {
			value = "karen_national_liberation_army",
			text = "Karen National Liberation Army",
			flag = path .. "karen_national_liberation_army.png",
		}
		c = c + 1
		Nations[c] = {
			value = "karen_national_union",
			text = "Karen National Union",
			flag = path .. "karen_national_union.png",
		}
		c = c + 1
		Nations[c] = {
			value = "katanga",
			text = "Katanga",
			flag = path .. "katanga.png",
		}
		c = c + 1
		Nations[c] = {
			value = "kazakhstan",
			text = "Kazakhstan",
			flag = path .. "kazakhstan.png",
		}
		c = c + 1
		Nations[c] = {
			value = "kenya",
			text = "Kenya",
			flag = path .. "kenya.png",
		}
		c = c + 1
		Nations[c] = {
			value = "khalistans",
			text = "Khalistans",
			flag = path .. "khalistans.png",
		}
		c = c + 1
		Nations[c] = {
			value = "kingdom_of_kurdistan",
			text = "Kingdom Of Kurdistan",
			flag = path .. "kingdom_of_kurdistan.png",
		}
		c = c + 1
		Nations[c] = {
			value = "kiribati",
			text = "Kiribati",
			flag = path .. "kiribati.png",
		}
		c = c + 1
		Nations[c] = {
			value = "khmers_kampuchea_krom",
			text = "Khmers Kampuchea-Krom",
			flag = path .. "khmers_kampuchea_krom.png",
		}
		c = c + 1
		Nations[c] = {
			value = "kokbayraq",
			text = "Kokbayraq",
			flag = path .. "kokbayraq.png",
		}
		c = c + 1
		Nations[c] = {
			value = "konigreich_wurttemberg",
			text = "Konigreich Wurttemberg",
			flag = path .. "konigreich_wurttemberg.png",
		}
		c = c + 1
		Nations[c] = {
			value = "kosovo",
			text = "Kosovo",
			flag = path .. "kosovo.png",
		}
		c = c + 1
		Nations[c] = {
			value = "krusevo_republic",
			text = "Krusevo Republic",
			flag = path .. "krusevo_republic.png",
		}
		c = c + 1
		Nations[c] = {
			value = "kuban_peoples_republic",
			text = "Kuban People's Republic",
			flag = path .. "kuban_peoples_republic.png",
		}
		c = c + 1
		Nations[c] = {
			value = "kurdistan",
			text = "Kurdistan",
			flag = path .. "kurdistan.png",
		}
		c = c + 1
		Nations[c] = {
			value = "kuwait",
			text = "Kuwait",
			flag = path .. "kuwait.png",
		}
		c = c + 1
		Nations[c] = {
			value = "kyrgyzstan",
			text = "Kyrgyzstan",
			flag = path .. "kyrgyzstan.png",
		}
		c = c + 1
		Nations[c] = {
			value = "ladonia",
			text = "Ladonia",
			flag = path .. "ladonia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "laos",
			text = "Laos",
			flag = path .. "laos.png",
		}
		c = c + 1
		Nations[c] = {
			value = "latvia",
			text = "Latvia",
			flag = path .. "latvia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "lebanon",
			text = "Lebanon",
			flag = path .. "lebanon.png",
		}
		c = c + 1
		Nations[c] = {
			value = "lesotho",
			text = "Lesotho",
			flag = path .. "lesotho.png",
		}
		c = c + 1
		Nations[c] = {
			value = "liberia",
			text = "Liberia",
			flag = path .. "liberia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "libya",
			text = "Libya",
			flag = path .. "libya.png",
		}
		c = c + 1
		Nations[c] = {
			value = "liechtenstein",
			text = "Liechtenstein",
			flag = path .. "liechtenstein.png",
		}
		c = c + 1
		Nations[c] = {
			value = "lithuania",
			text = "Lithuania",
			flag = path .. "lithuania.png",
		}
		c = c + 1
		Nations[c] = {
			value = "lorraine",
			text = "Lorraine",
			flag = path .. "lorraine.png",
		}
		c = c + 1
		Nations[c] = {
			value = "los_altos",
			text = "Los Altos",
			flag = path .. "los_altos.png",
		}
		c = c + 1
		Nations[c] = {
			value = "luxembourg",
			text = "Luxembourg",
			flag = path .. "luxembourg.png",
		}
		c = c + 1
		Nations[c] = {
			value = "macau",
			text = "Macau",
			flag = path .. "macau.png",
		}
		c = c + 1
		Nations[c] = {
			value = "macedonia",
			text = "Macedonia",
			flag = path .. "macedonia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "madagascar",
			text = "Madagascar",
			flag = path .. "madagascar.png",
		}
		c = c + 1
		Nations[c] = {
			value = "magallanes",
			text = "Magallanes",
			flag = path .. "magallanes.png",
		}
		c = c + 1
		Nations[c] = {
			value = "maguindanao",
			text = "Maguindanao",
			flag = path .. "maguindanao.png",
		}
		c = c + 1
		Nations[c] = {
			value = "malawi",
			text = "Malawi",
			flag = path .. "malawi.png",
		}
		c = c + 1
		Nations[c] = {
			value = "malaysia",
			text = "Malaysia",
			flag = path .. "malaysia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "maldives",
			text = "Maldives",
			flag = path .. "maldives.png",
		}
		c = c + 1
		Nations[c] = {
			value = "mali",
			text = "Mali",
			flag = path .. "mali.png",
		}
		c = c + 1
		Nations[c] = {
			value = "malta",
			text = "Malta",
			flag = path .. "malta.png",
		}
		c = c + 1
		Nations[c] = {
			value = "manchukuo",
			text = "Manchukuo",
			flag = path .. "manchukuo.png",
		}
		c = c + 1
		Nations[c] = {
			value = "mauritania",
			text = "Mauritania",
			flag = path .. "mauritania.png",
		}
		c = c + 1
		Nations[c] = {
			value = "mauritius",
			text = "Mauritius",
			flag = path .. "mauritius.png",
		}
		c = c + 1
		Nations[c] = {
			value = "mayotte",
			text = "Mayotte",
			flag = path .. "mayotte.png",
		}
		c = c + 1
		Nations[c] = {
			value = "merina_kingdom",
			text = "Merina Kingdom",
			flag = path .. "merina_kingdom.png",
		}
		c = c + 1
		Nations[c] = {
			value = "mexico",
			text = "Mexico",
			flag = path .. "mexico.png",
		}
		c = c + 1
		Nations[c] = {
			value = "minerva",
			text = "Minerva",
			flag = path .. "minerva.png",
		}
		c = c + 1
		Nations[c] = {
			value = "azawad_national_liberation_movement",
			text = "Azawad National Liberation Movement",
			flag = path .. "azawad_national_liberation_movement.png",
		}
		c = c + 1
		Nations[c] = {
			value = "moro_national_liberation_front",
			text = "Moro National Liberation Front",
			flag = path .. "moro_national_liberation_front.png",
		}
		c = c + 1
		Nations[c] = {
			value = "moheli",
			text = "Moheli",
			flag = path .. "moheli.png",
		}
		c = c + 1
		Nations[c] = {
			value = "moldova",
			text = "Moldova",
			flag = path .. "moldova.png",
		}
		c = c + 1
		Nations[c] = {
			value = "monaco",
			text = "Monaco",
			flag = path .. "monaco.png",
		}
		c = c + 1
		Nations[c] = {
			value = "mongolia",
			text = "Mongolia",
			flag = path .. "mongolia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "montenegro",
			text = "Montenegro",
			flag = path .. "montenegro.png",
		}
		c = c + 1
		Nations[c] = {
			value = "montserrat",
			text = "Montserrat",
			flag = path .. "montserrat.png",
		}
		c = c + 1
		Nations[c] = {
			value = "morning_star",
			text = "Morning Star",
			flag = path .. "morning_star.png",
		}
		c = c + 1
		Nations[c] = {
			value = "morocco",
			text = "Morocco",
			flag = path .. "morocco.png",
		}
		c = c + 1
		Nations[c] = {
			value = "most_serene_republic_of_venice",
			text = "Most Serene Republic Of Venice",
			flag = path .. "most_serene_republic_of_venice.png",
		}
		c = c + 1
		Nations[c] = {
			value = "mozambique",
			text = "Mozambique",
			flag = path .. "mozambique.png",
		}
		c = c + 1
		Nations[c] = {
			value = "murrawarri_republic",
			text = "Murrawarri Republic",
			flag = path .. "murrawarri_republic.png",
		}
		c = c + 1
		Nations[c] = {
			value = "myanmar",
			text = "Myanmar",
			flag = path .. "myanmar.png",
		}
		c = c + 1
		Nations[c] = {
			value = "namibia",
			text = "Namibia",
			flag = path .. "namibia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "natalia_republic",
			text = "Natalia Republic",
			flag = path .. "natalia_republic.png",
		}
		c = c + 1
		Nations[c] = {
			value = "nauru",
			text = "Nauru",
			flag = path .. "nauru.png",
		}
		c = c + 1
		Nations[c] = {
			value = "navassa_island",
			text = "Navassa Island",
			flag = path .. "navassa_island.png",
		}
		c = c + 1
		Nations[c] = {
			value = "nejd",
			text = "Nejd",
			flag = path .. "nejd.png",
		}
		c = c + 1
		Nations[c] = {
			value = "nepal",
			text = "Nepal",
			flag = path .. "nepal.png",
		}
		c = c + 1
		Nations[c] = {
			value = "new_mon_state_party",
			text = "New Mon State Party",
			flag = path .. "new_mon_state_party.png",
		}
		c = c + 1
		Nations[c] = {
			value = "new_zealand",
			text = "New Zealand",
			flag = path .. "new_zealand.png",
		}
		c = c + 1
		Nations[c] = {
			value = "new_zealand_south_island",
			text = "New Zealand South Island",
			flag = path .. "new_zealand_south_island.png",
		}
		c = c + 1
		Nations[c] = {
			value = "nicaragua",
			text = "Nicaragua",
			flag = path .. "nicaragua.png",
		}
		c = c + 1
		Nations[c] = {
			value = "niger",
			text = "Niger",
			flag = path .. "niger.png",
		}
		c = c + 1
		Nations[c] = {
			value = "nigeria",
			text = "Nigeria",
			flag = path .. "nigeria.png",
		}
		c = c + 1
		Nations[c] = {
			value = "niue",
			text = "Niue",
			flag = path .. "niue.png",
		}
		c = c + 1
		Nations[c] = {
			value = "norfolk_island",
			text = "Norfolk Island",
			flag = path .. "norfolk_island.png",
		}
		c = c + 1
		Nations[c] = {
			value = "north_korea",
			text = "North Korea",
			flag = path .. "north_korea.png",
		}
		c = c + 1
		Nations[c] = {
			value = "norway",
			text = "Norway",
			flag = path .. "norway.png",
		}
		c = c + 1
		Nations[c] = {
			value = "occitania",
			text = "Occitania",
			flag = path .. "occitania.png",
		}
		c = c + 1
		Nations[c] = {
			value = "ogaden_national_liberation_front",
			text = "Ogaden National Liberation Front",
			flag = path .. "ogaden_national_liberation_front.png",
		}
		c = c + 1
		Nations[c] = {
			value = "oman",
			text = "Oman",
			flag = path .. "oman.png",
		}
		c = c + 1
		Nations[c] = {
			value = "ottoman_alternative",
			text = "Ottoman Alternative",
			flag = path .. "ottoman_alternative.png",
		}
		c = c + 1
		Nations[c] = {
			value = "padania",
			text = "Padania",
			flag = path .. "padania.png",
		}
		c = c + 1
		Nations[c] = {
			value = "pakistan",
			text = "Pakistan",
			flag = path .. "pakistan.png",
		}
		c = c + 1
		Nations[c] = {
			value = "palau",
			text = "Palau",
			flag = path .. "palau.png",
		}
		c = c + 1
		Nations[c] = {
			value = "palestine",
			text = "Palestine",
			flag = path .. "palestine.png",
		}
		c = c + 1
		Nations[c] = {
			value = "palmyra_atoll",
			text = "Palmyra Atoll",
			flag = path .. "palmyra_atoll.png",
		}
		c = c + 1
		Nations[c] = {
			value = "panama",
			text = "Panama",
			flag = path .. "panama.png",
		}
		c = c + 1
		Nations[c] = {
			value = "papua_new_guinea",
			text = "Papua New Guinea",
			flag = path .. "papua_new_guinea.png",
		}
		c = c + 1
		Nations[c] = {
			value = "paraguay",
			text = "Paraguay",
			flag = path .. "paraguay.png",
		}
		c = c + 1
		Nations[c] = {
			value = "pattani",
			text = "Pattani",
			flag = path .. "pattani.png",
		}
		c = c + 1
		Nations[c] = {
			value = "pernambucan_revolt",
			text = "Pernambucan Revolt",
			flag = path .. "pernambucan_revolt.png",
		}
		c = c + 1
		Nations[c] = {
			value = "peru",
			text = "Peru",
			flag = path .. "peru.png",
		}
		c = c + 1
		Nations[c] = {
			value = "piratini_republic",
			text = "Piratini Republic",
			flag = path .. "piratini_republic.png",
		}
		c = c + 1
		Nations[c] = {
			value = "poland",
			text = "Poland",
			flag = path .. "poland.png",
		}
		c = c + 1
		Nations[c] = {
			value = "porto_claro",
			text = "Porto Claro",
			flag = path .. "porto_claro.png",
		}
		c = c + 1
		Nations[c] = {
			value = "portugal",
			text = "Portugal",
			flag = path .. "portugal.png",
		}
		c = c + 1
		Nations[c] = {
			value = "portugalicia",
			text = "Portugalicia",
			flag = path .. "portugalicia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "puerto_rico",
			text = "Puerto Rico",
			flag = path .. "puerto_rico.png",
		}
		c = c + 1
		Nations[c] = {
			value = "qatar",
			text = "Qatar",
			flag = path .. "qatar.png",
		}
		c = c + 1
		Nations[c] = {
			value = "quebec",
			text = "Quebec",
			flag = path .. "quebec.png",
		}
		c = c + 1
		Nations[c] = {
			value = "raiatea",
			text = "Raiatea",
			flag = path .. "raiatea.png",
		}
		c = c + 1
		Nations[c] = {
			value = "rainbowcreek",
			text = "Rainbowcreek",
			flag = path .. "rainbowcreek.png",
		}
		c = c + 1
		Nations[c] = {
			value = "rapa_nui, _chile",
			text = "Rapa Nui, Chile",
			flag = path .. "rapa_nui, _chile.png",
		}
		c = c + 1
		Nations[c] = {
			value = "republica_juliana",
			text = "Republica Juliana",
			flag = path .. "republica_juliana.png",
		}
		c = c + 1
		Nations[c] = {
			value = "republic_of_dubrovnik",
			text = "Republic Of Dubrovnik",
			flag = path .. "republic_of_dubrovnik.png",
		}
		c = c + 1
		Nations[c] = {
			value = "Republic_of_New_Afrika",
			text = "Republic Of New Afrika",
			flag = path .. "Republic_of_New_Afrika.png",
		}
		c = c + 1
		Nations[c] = {
			value = "republic_ryukyu_independists",
			text = "Republic Ryukyu Independists",
			flag = path .. "republic_ryukyu_independists.png",
		}
		c = c + 1
		Nations[c] = {
			value = "rhodesia",
			text = "Rhodesia",
			flag = path .. "rhodesia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "riau_independists",
			text = "Riau Independists",
			flag = path .. "riau_independists.png",
		}
		c = c + 1
		Nations[c] = {
			value = "romania",
			text = "Romania",
			flag = path .. "romania.png",
		}
		c = c + 1
		Nations[c] = {
			value = "rose_island",
			text = "Rose Island",
			flag = path .. "rose_island.png",
		}
		c = c + 1
		Nations[c] = {
			value = "rotuma",
			text = "Rotuma",
			flag = path .. "rotuma.png",
		}
		c = c + 1
		Nations[c] = {
			value = "rurutu",
			text = "Rurutu",
			flag = path .. "rurutu.png",
		}
		c = c + 1
		Nations[c] = {
			value = "rwanda",
			text = "Rwanda",
			flag = path .. "rwanda.png",
		}
		c = c + 1
		Nations[c] = {
			value = "ryukyu",
			text = "Ryukyu",
			flag = path .. "ryukyu.png",
		}
		c = c + 1
		Nations[c] = {
			value = "saba",
			text = "Saba",
			flag = path .. "saba.png",
		}
		c = c + 1
		Nations[c] = {
			value = "saint-pierre_and_miquelon",
			text = "Saint-pierre And Miquelon",
			flag = path .. "saint-pierre_and_miquelon.png",
		}
		c = c + 1
		Nations[c] = {
			value = "saint_barthelemy",
			text = "Saint Barthelemy",
			flag = path .. "saint_barthelemy.png",
		}
		c = c + 1
		Nations[c] = {
			value = "saint_helena",
			text = "Saint Helena",
			flag = path .. "saint_helena.png",
		}
		c = c + 1
		Nations[c] = {
			value = "saint_kitts_and_nevis",
			text = "Saint Kitts And Nevis",
			flag = path .. "saint_kitts_and_nevis.png",
		}
		c = c + 1
		Nations[c] = {
			value = "saint_lucia",
			text = "Saint Lucia",
			flag = path .. "saint_lucia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "saint_vincent_and_the_grenadines",
			text = "Saint Vincent And The Grenadines",
			flag = path .. "saint_vincent_and_the_grenadines.png",
		}
		c = c + 1
		Nations[c] = {
			value = "sami",
			text = "Sami",
			flag = path .. "sami.png",
		}
		c = c + 1
		Nations[c] = {
			value = "samoa",
			text = "Samoa",
			flag = path .. "samoa.png",
		}
		c = c + 1
		Nations[c] = {
			value = "san_marino",
			text = "San Marino",
			flag = path .. "san_marino.png",
		}
		c = c + 1
		Nations[c] = {
			value = "sao_tome_and_principe",
			text = "Sao Tome And Principe",
			flag = path .. "sao_tome_and_principe.png",
		}
		c = c + 1
		Nations[c] = {
			value = "sark",
			text = "Sark",
			flag = path .. "sark.png",
		}
		c = c + 1
		Nations[c] = {
			value = "saudi_arabia",
			text = "Saudi Arabia",
			flag = path .. "saudi_arabia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "saxony",
			text = "Saxony",
			flag = path .. "saxony.png",
		}
		c = c + 1
		Nations[c] = {
			value = "scotland",
			text = "Scotland",
			flag = path .. "scotland.png",
		}
		c = c + 1
		Nations[c] = {
			value = "sealand",
			text = "Sealand",
			flag = path .. "sealand.png",
		}
		c = c + 1
		Nations[c] = {
			value = "sedang",
			text = "Sedang",
			flag = path .. "sedang.png",
		}
		c = c + 1
		Nations[c] = {
			value = "senegal",
			text = "Senegal",
			flag = path .. "senegal.png",
		}
		c = c + 1
		Nations[c] = {
			value = "serbia",
			text = "Serbia",
			flag = path .. "serbia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "serbian_krajina",
			text = "Serbian Krajina",
			flag = path .. "serbian_krajina.png",
		}
		c = c + 1
		Nations[c] = {
			value = "seychelles",
			text = "Seychelles",
			flag = path .. "seychelles.png",
		}
		c = c + 1
		Nations[c] = {
			value = "sfr_yugoslavia",
			text = "Sfr Yugoslavia",
			flag = path .. "sfr_yugoslavia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "sierra_leone",
			text = "Sierra Leone",
			flag = path .. "sierra_leone.png",
		}
		c = c + 1
		Nations[c] = {
			value = "sikkim",
			text = "Sikkim",
			flag = path .. "sikkim.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_grand_duchy_of_tuscany",
			text = "The Grand Duchy Of Tuscany",
			flag = path .. "the_grand_duchy_of_tuscany.png",
		}
		c = c + 1
		Nations[c] = {
			value = "singapore",
			text = "Singapore",
			flag = path .. "singapore.png",
		}
		c = c + 1
		Nations[c] = {
			value = "sint_eustatius",
			text = "Sint Eustatius",
			flag = path .. "sint_eustatius.png",
		}
		c = c + 1
		Nations[c] = {
			value = "sint_maarten",
			text = "Sint Maarten",
			flag = path .. "sint_maarten.png",
		}
		c = c + 1
		Nations[c] = {
			value = "slovakia",
			text = "Slovakia",
			flag = path .. "slovakia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "slovenia",
			text = "Slovenia",
			flag = path .. "slovenia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "snake_of_martinique",
			text = "Snake Of Martinique",
			flag = path .. "snake_of_martinique.png",
		}
		c = c + 1
		Nations[c] = {
			value = "somalia",
			text = "Somalia",
			flag = path .. "somalia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "somaliland",
			text = "Somaliland",
			flag = path .. "somaliland.png",
		}
		c = c + 1
		Nations[c] = {
			value = "south_africa",
			text = "South Africa",
			flag = path .. "south_africa.png",
		}
		c = c + 1
		Nations[c] = {
			value = "south_georgia_and_the_south_sandwich_islands",
			text = "South Georgia And The South Sandwich Islands",
			flag = path .. "south_georgia_and_the_south_sandwich_islands.png",
		}
		c = c + 1
		Nations[c] = {
			value = "south_kasai",
			text = "South Kasai",
			flag = path .. "south_kasai.png",
		}
		c = c + 1
		Nations[c] = {
			value = "south_korea",
			text = "South Korea",
			flag = path .. "south_korea.png",
		}
		c = c + 1
		Nations[c] = {
			value = "south_moluccas",
			text = "South Moluccas",
			flag = path .. "south_moluccas.png",
		}
		c = c + 1
		Nations[c] = {
			value = "south_ossetia",
			text = "South Ossetia",
			flag = path .. "south_ossetia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "south_sudan",
			text = "South Sudan",
			flag = path .. "south_sudan.png",
		}
		c = c + 1
		Nations[c] = {
			value = "south_vietnam",
			text = "South Vietnam",
			flag = path .. "south_vietnam.png",
		}
		c = c + 1
		Nations[c] = {
			value = "south_yemen",
			text = "South Yemen",
			flag = path .. "south_yemen.png",
		}
		c = c + 1
		Nations[c] = {
			value = "spain",
			text = "Spain",
			flag = path .. "spain.png",
		}
		c = c + 1
		Nations[c] = {
			value = "sri_lanka",
			text = "Sri Lanka",
			flag = path .. "sri_lanka.png",
		}
		c = c + 1
		Nations[c] = {
			value = "sudan",
			text = "Sudan",
			flag = path .. "sudan.png",
		}
		c = c + 1
		Nations[c] = {
			value = "sulawesi",
			text = "Sulawesi",
			flag = path .. "sulawesi.png",
		}
		c = c + 1
		Nations[c] = {
			value = "sulu",
			text = "Sulu",
			flag = path .. "sulu.png",
		}
		c = c + 1
		Nations[c] = {
			value = "suriname",
			text = "Suriname",
			flag = path .. "suriname.png",
		}
		c = c + 1
		Nations[c] = {
			value = "swaziland",
			text = "Swaziland",
			flag = path .. "swaziland.png",
		}
		c = c + 1
		Nations[c] = {
			value = "switzerland",
			text = "Switzerland",
			flag = path .. "switzerland.png",
		}
		c = c + 1
		Nations[c] = {
			value = "syria",
			text = "Syria",
			flag = path .. "syria.png",
		}
		c = c + 1
		Nations[c] = {
			value = "syrian_kurdistan",
			text = "Syrian Kurdistan",
			flag = path .. "syrian_kurdistan.png",
		}
		c = c + 1
		Nations[c] = {
			value = "szekely_land",
			text = "Szekely Land",
			flag = path .. "szekely_land.png",
		}
		c = c + 1
		Nations[c] = {
			value = "taiwan_proposed_1996",
			text = "Taiwan Proposed 1996",
			flag = path .. "taiwan_proposed_1996.png",
		}
		c = c + 1
		Nations[c] = {
			value = "tajikistan",
			text = "Tajikistan",
			flag = path .. "tajikistan.png",
		}
		c = c + 1
		Nations[c] = {
			value = "tanganyika",
			text = "Tanganyika",
			flag = path .. "tanganyika.png",
		}
		c = c + 1
		Nations[c] = {
			value = "tanzania",
			text = "Tanzania",
			flag = path .. "tanzania.png",
		}
		c = c + 1
		Nations[c] = {
			value = "tavolara",
			text = "Tavolara",
			flag = path .. "tavolara.png",
		}
		c = c + 1
		Nations[c] = {
			value = "texas",
			text = "Texas",
			flag = path .. "texas.png",
		}
		c = c + 1
		Nations[c] = {
			value = "thailand",
			text = "Thailand",
			flag = path .. "thailand.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_aceh_sultanate",
			text = "The Aceh Sultanate",
			flag = path .. "the_aceh_sultanate.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_american_indian_movement",
			text = "The American Indian Movement",
			flag = path .. "the_american_indian_movement.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_bahamas",
			text = "The Bahamas",
			flag = path .. "the_bahamas.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_barisan_revolusi_nasional",
			text = "The Barisan Revolusi Nasional",
			flag = path .. "the_barisan_revolusi_nasional.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_basque_country",
			text = "The Basque Country",
			flag = path .. "the_basque_country.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_bodo_liberation_tigers_force",
			text = "The Bodo Liberation Tigers Force",
			flag = path .. "the_bodo_liberation_tigers_force.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_british_antarctic_territory",
			text = "The British Antarctic Territory",
			flag = path .. "the_british_antarctic_territory.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_british_indian_ocean_territory",
			text = "The British Indian Ocean Territory",
			flag = path .. "the_british_indian_ocean_territory.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_british_virgin_islands",
			text = "The British Virgin Islands",
			flag = path .. "the_british_virgin_islands.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_cayman_islands",
			text = "The Cayman Islands",
			flag = path .. "the_cayman_islands.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_central_african_republic",
			text = "The Central African Republic",
			flag = path .. "the_central_african_republic.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_cocos_keeling_islands",
			text = "The Cocos Keeling Islands",
			flag = path .. "the_cocos_keeling_islands.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_collectivity_of_saint_martin",
			text = "The Collectivity Of Saint Martin",
			flag = path .. "the_collectivity_of_saint_martin.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_comoros",
			text = "The Comoros",
			flag = path .. "the_comoros.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_confederate_states_of_america",
			text = "The Confederate States Of America",
			flag = path .. "the_confederate_states_of_america.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_cook_islands",
			text = "The Cook Islands",
			flag = path .. "the_cook_islands.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_creek_nation",
			text = "The Creek Nation",
			flag = path .. "the_creek_nation.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_croatian_republic_of_herzeg-bosnia",
			text = "The Croatian Republic Of Herzeg-bosnia",
			flag = path .. "the_croatian_republic_of_herzeg-bosnia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_czech_republic",
			text = "The Czech Republic",
			flag = path .. "the_czech_republic.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_democratic_republic_of_the_congo",
			text = "The Democratic Republic Of The Congo",
			flag = path .. "the_democratic_republic_of_the_congo.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_district_of_columbia",
			text = "The District Of Columbia",
			flag = path .. "the_district_of_columbia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_dominican_republic",
			text = "The Dominican Republic",
			flag = path .. "the_dominican_republic.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_falkland_islands",
			text = "The Falkland Islands",
			flag = path .. "the_falkland_islands.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_faroe_islands",
			text = "The Faroe Islands",
			flag = path .. "the_faroe_islands.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_federal_republic_of_central_america",
			text = "The Federal Republic Of Central America",
			flag = path .. "the_federal_republic_of_central_america.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_federal_republic_of_southern_cameroons",
			text = "The Federal Republic Of Southern Cameroons",
			flag = path .. "the_federal_republic_of_southern_cameroons.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_federated_states_of_micronesia",
			text = "The Federated States Of Micronesia",
			flag = path .. "the_federated_states_of_micronesia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_federation_of_rhodesia_and_nyasaland",
			text = "The Federation Of Rhodesia And Nyasaland",
			flag = path .. "the_federation_of_rhodesia_and_nyasaland.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_free_state_of_fiume",
			text = "The Free State Of Fiume",
			flag = path .. "the_free_state_of_fiume.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_french_southern_and_antarctic_lands",
			text = "The French Southern And Antarctic Lands",
			flag = path .. "the_french_southern_and_antarctic_lands.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_gagauz_people",
			text = "The Gagauz People",
			flag = path .. "the_gagauz_people.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_galician_ssr",
			text = "The Galician SSR",
			flag = path .. "the_galician_ssr.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_gambia",
			text = "The Gambia",
			flag = path .. "the_gambia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_hawar_islands",
			text = "The Hawar Islands",
			flag = path .. "the_hawar_islands.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_inner_mongolian_people's_party",
			text = "The Inner Mongolian People's Party",
			flag = path .. "the_inner_mongolian_peoples_party.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_islands_of_refreshment",
			text = "The Islands Of Refreshment",
			flag = path .. "the_islands_of_refreshment.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_isle_of_man",
			text = "The Isle Of Man",
			flag = path .. "the_isle_of_man.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_kingdom_of_araucania_and_patagonia",
			text = "The Kingdom Of Araucania And Patagonia",
			flag = path .. "the_kingdom_of_araucania_and_patagonia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_kingdom_of_lau",
			text = "The Kingdom Of Lau",
			flag = path .. "the_kingdom_of_lau.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_kingdom_of_mangareva",
			text = "The Kingdom Of Mangareva",
			flag = path .. "the_kingdom_of_mangareva.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_kingdom_of_redonda",
			text = "The Kingdom Of Redonda",
			flag = path .. "the_kingdom_of_redonda.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_kingdom_of_rimatara",
			text = "The Kingdom Of Rimatara",
			flag = path .. "the_kingdom_of_rimatara.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_kingdom_of_tahiti",
			text = "The Kingdom Of Tahiti",
			flag = path .. "the_kingdom_of_tahiti.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_kingdom_of_talossa",
			text = "The Kingdom Of Talossa",
			flag = path .. "the_kingdom_of_talossa.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_kingdom_of_the_two_sicilies",
			text = "The Kingdom Of The Two Sicilies",
			flag = path .. "the_kingdom_of_the_two_sicilies.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_kingdom_of_yugoslavia",
			text = "The Kingdom Of Yugoslavia",
			flag = path .. "the_kingdom_of_yugoslavia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_mapuches",
			text = "The Mapuches",
			flag = path .. "the_mapuches.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_maratha_empire",
			text = "The Maratha Empire",
			flag = path .. "the_maratha_empire.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_marshall_islands",
			text = "The Marshall Islands",
			flag = path .. "the_marshall_islands.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_mengjiang",
			text = "The Mengjiang",
			flag = path .. "the_mengjiang.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_midway_islands",
			text = "The Midway Islands",
			flag = path .. "the_midway_islands.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_moro_islamic_liberation_front",
			text = "The Moro Islamic Liberation Front",
			flag = path .. "the_moro_islamic_liberation_front.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_mughal_empire",
			text = "The Mughal Empire",
			flag = path .. "the_mughal_empire.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_National_Front_for_the_Liberation_of_Southern_Vietnam",
			text = "The National Front For The Liberation Of Southern Vietnam",
			flag = path .. "the_National_Front_for_the_Liberation_of_Southern_Vietnam.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_netherlands",
			text = "The Netherlands",
			flag = path .. "the_netherlands.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_northern_mariana_islands",
			text = "The Northern Mariana Islands",
			flag = path .. "the_northern_mariana_islands.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_orange_free_state",
			text = "The Orange Free State",
			flag = path .. "the_orange_free_state.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_oromo_liberation_front",
			text = "The Oromo Liberation Front",
			flag = path .. "the_oromo_liberation_front.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_pattani_united_liberation_organisation",
			text = "The Pattani United Liberation Organisation",
			flag = path .. "the_pattani_united_liberation_organisation.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_peoples_republic_of_china",
			text = "The People's Republic Of China",
			flag = path .. "flag_the_peoples_republic_of_china.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_peru-bolivian_confederation",
			text = "The Peru-bolivian Confederation",
			flag = path .. "the_peru-bolivian_confederation.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_philippines",
			text = "The Philippines",
			flag = path .. "the_philippines.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_pitcairn_islands",
			text = "The Pitcairn Islands",
			flag = path .. "the_pitcairn_islands.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_principality_of_trinidad",
			text = "The Principality Of Trinidad",
			flag = path .. "the_principality_of_trinidad.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_republic_of_alsace-lorraine",
			text = "The Republic Of Alsace-lorraine",
			flag = path .. "the_republic_of_alsace-lorraine.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_republic_of_benin",
			text = "The Republic Of Benin",
			flag = path .. "the_republic_of_benin.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_republic_of_central_highlands_and_champa",
			text = "The Republic Of Central Highlands And Champa",
			flag = path .. "the_republic_of_central_highlands_and_champa.png",
		}
		c = c + 1
		Nations[c] = {
			value = "taiwan",
			text = "Taiwan",
			flag = path .. "flag_taiwan.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_republic_of_china",
			text = "The Republic of China",
			flag = path .. "flag_the_republic_of_china.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_republic_of_lower_california",
			text = "The Republic Of Lower California",
			flag = path .. "the_republic_of_lower_california.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_republic_of_molossia",
			text = "The Republic Of Molossia",
			flag = path .. "the_republic_of_molossia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_republic_of_sonora",
			text = "The Republic Of Sonora",
			flag = path .. "the_republic_of_sonora.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_republic_of_talossa",
			text = "The Republic Of Talossa",
			flag = path .. "the_republic_of_talossa.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_republic_of_texas",
			text = "The Republic Of Texas",
			flag = path .. "the_republic_of_texas.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_republic_of_the_congo",
			text = "The Republic Of The Congo",
			flag = path .. "the_republic_of_the_congo.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_republic_of_the_rif",
			text = "The Republic Of The Rif",
			flag = path .. "the_republic_of_the_rif.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_republic_of_the_rio_grande",
			text = "The Republic Of The Rio Grande",
			flag = path .. "the_republic_of_the_rio_grande.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_republic_of_western_bosnia",
			text = "The Republic Of Western Bosnia",
			flag = path .. "the_republic_of_western_bosnia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_republic_of_yucatan",
			text = "The Republic Of Yucatan",
			flag = path .. "the_republic_of_yucatan.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_republic_of_zamboanga",
			text = "The Republic Of Zamboanga",
			flag = path .. "the_republic_of_zamboanga.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_ross_dependency",
			text = "The Ross Dependency",
			flag = path .. "the_ross_dependency.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_sahrawi_arab_democratic_republic",
			text = "The Sahrawi Arab Democratic Republic",
			flag = path .. "the_sahrawi_arab_democratic_republic.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_solomon_islands",
			text = "The Solomon Islands",
			flag = path .. "the_solomon_islands.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_soviet_union",
			text = "The Soviet Union",
			flag = path .. "the_soviet_union.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_sultanate_of_banten",
			text = "The Sultanate Of Banten",
			flag = path .. "the_sultanate_of_banten.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_sultanate_of_mataram",
			text = "The Sultanate Of Mataram",
			flag = path .. "the_sultanate_of_mataram.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_sultanate_of_zanzibar",
			text = "The Sultanate Of Zanzibar",
			flag = path .. "the_sultanate_of_zanzibar.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_tagalog_people",
			text = "The Tagalog People",
			flag = path .. "the_tagalog_people.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_transcaucasian_federation",
			text = "The Transcaucasian Federation",
			flag = path .. "the_transcaucasian_federation.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_tuamotu_kingdom",
			text = "The Tuamotu Kingdom",
			flag = path .. "the_tuamotu_kingdom.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_turkish_republic_of_northern_cyprus",
			text = "The Turkish Republic Of Northern Cyprus",
			flag = path .. "the_turkish_republic_of_northern_cyprus.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_turks_and_caicos_islands",
			text = "The Turks And Caicos Islands",
			flag = path .. "the_turks_and_caicos_islands.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_tuvan_people's_republic",
			text = "The Tuvan People's Republic",
			flag = path .. "the_tuvan_peoples_republic.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_united_arab_emirates",
			text = "The United Arab Emirates",
			flag = path .. "the_united_arab_emirates.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_united_states_virgin_islands",
			text = "The United States Virgin Islands",
			flag = path .. "the_united_states_virgin_islands.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_united_tribes_of_fiji_1865-1867",
			text = "The United Tribes Of Fiji 1865-1867",
			flag = path .. "the_united_tribes_of_fiji_1865-1867.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_united_tribes_of_fiji_1867-1869",
			text = "The United Tribes Of Fiji 1867-1869",
			flag = path .. "the_united_tribes_of_fiji_1867-1869.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_vatican_city",
			text = "The Vatican City",
			flag = path .. "the_vatican_city.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_vermont_republic",
			text = "The Vermont Republic",
			flag = path .. "the_vermont_republic.png",
		}
		c = c + 1
		Nations[c] = {
			value = "the_west_indies_federation",
			text = "The West Indies Federation",
			flag = path .. "the_west_indies_federation.png",
		}
		c = c + 1
		Nations[c] = {
			value = "tibet",
			text = "Tibet",
			flag = path .. "tibet.png",
		}
		c = c + 1
		Nations[c] = {
			value = "tknara",
			text = "Tknara",
			flag = path .. "tknara.png",
		}
		c = c + 1
		Nations[c] = {
			value = "togo",
			text = "Togo",
			flag = path .. "togo.png",
		}
		c = c + 1
		Nations[c] = {
			value = "tokelau",
			text = "Tokelau",
			flag = path .. "tokelau.png",
		}
		c = c + 1
		Nations[c] = {
			value = "tonga",
			text = "Tonga",
			flag = path .. "tonga.png",
		}
		c = c + 1
		Nations[c] = {
			value = "transkei",
			text = "Transkei",
			flag = path .. "transkei.png",
		}
		c = c + 1
		Nations[c] = {
			value = "transnistria",
			text = "Transnistria",
			flag = path .. "transnistria.png",
		}
		c = c + 1
		Nations[c] = {
			value = "transvaal",
			text = "Transvaal",
			flag = path .. "transvaal.png",
		}
		c = c + 1
		Nations[c] = {
			value = "trinidad_and_tobago",
			text = "Trinidad And Tobago",
			flag = path .. "trinidad_and_tobago.png",
		}
		c = c + 1
		Nations[c] = {
			value = "tristan_da_cunha",
			text = "Tristan Da Cunha",
			flag = path .. "tristan_da_cunha.png",
		}
		c = c + 1
		Nations[c] = {
			value = "tunisia",
			text = "Tunisia",
			flag = path .. "tunisia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "turkey",
			text = "Turkey",
			flag = path .. "turkey.png",
		}
		c = c + 1
		Nations[c] = {
			value = "turkmenistan",
			text = "Turkmenistan",
			flag = path .. "turkmenistan.png",
		}
		c = c + 1
		Nations[c] = {
			value = "tuvalu",
			text = "Tuvalu",
			flag = path .. "tuvalu.png",
		}
		c = c + 1
		Nations[c] = {
			value = "uganda",
			text = "Uganda",
			flag = path .. "uganda.png",
		}
		c = c + 1
		Nations[c] = {
			value = "ukraine",
			text = "Ukraine",
			flag = path .. "ukraine.png",
		}
		c = c + 1
		Nations[c] = {
			value = "ukrainian_ssr",
			text = "Ukrainian SSR",
			flag = path .. "ukrainian_ssr.png",
		}
		c = c + 1
		Nations[c] = {
			value = "uruguay",
			text = "Uruguay",
			flag = path .. "uruguay.png",
		}
		c = c + 1
		Nations[c] = {
			value = "uzbekistan",
			text = "Uzbekistan",
			flag = path .. "uzbekistan.png",
		}
		c = c + 1
		Nations[c] = {
			value = "vanuatu",
			text = "Vanuatu",
			flag = path .. "vanuatu.png",
		}
		c = c + 1
		Nations[c] = {
			value = "venda",
			text = "Venda",
			flag = path .. "venda.png",
		}
		c = c + 1
		Nations[c] = {
			value = "venezuela",
			text = "Venezuela",
			flag = path .. "venezuela.png",
		}
		c = c + 1
		Nations[c] = {
			value = "vietnam",
			text = "Vietnam",
			flag = path .. "vietnam.png",
		}
		c = c + 1
		Nations[c] = {
			value = "vojvodina",
			text = "Vojvodina",
			flag = path .. "vojvodina.png",
		}
		c = c + 1
		Nations[c] = {
			value = "wake_island",
			text = "Wake Island",
			flag = path .. "wake_island.png",
		}
		c = c + 1
		Nations[c] = {
			value = "wales",
			text = "Wales",
			flag = path .. "wales.png",
		}
		c = c + 1
		Nations[c] = {
			value = "wallis_and_futuna",
			text = "Wallis And Futuna",
			flag = path .. "wallis_and_futuna.png",
		}
		c = c + 1
		Nations[c] = {
			value = "yemen",
			text = "Yemen",
			flag = path .. "yemen.png",
		}
		c = c + 1
		Nations[c] = {
			value = "zambia",
			text = "Zambia",
			flag = path .. "zambia.png",
		}
		c = c + 1
		Nations[c] = {
			value = "zanzibar",
			text = "Zanzibar",
			flag = path .. "zanzibar.png",
		}
		c = c + 1
		Nations[c] = {
			value = "zimbabwe",
			text = "Zimbabwe",
			flag = path .. "zimbabwe.png",
		}
		c = c + 1
		Nations[c] = {
			value = "zomi_re-unification_organisation",
			text = "Zomi Re-unification Organisation",
			flag = path .. "zomi_re-unification_organisation.png",
		}
	end -- do


	-- skip adding full names list to existing nations
	local rand_birth = mod_DefaultNationNames

	-- add list of names from earlier for each nation
	for i = 1, #Nations do
		local id = Nations[i].value

		if rand_birth then
			if not existing_nation[id] then
				HumanNames[id] = name_table
			end
		else
			HumanNames[id] = name_table
		end
		 -- skip the countries added by the game (unless it's Mars)
--~		 -- skip the countries added by the game (unless it's Mars)
--~		 if Nations[i].value == "Mars" or type(Nations[i].text) == "string" then
--~			 HumanNames[Nations[i].value] = name_table
--~		 else
--~			 if HumanNames[Nations[i].value] then
--~				 HumanNames[Nations[i].value].Unique = name_table.Unique
--~			 end
--~		 end
	end
end
