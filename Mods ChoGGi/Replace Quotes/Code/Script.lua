-- See LICENSE for terms

local mod_ElonMusk
local mod_VladimirPutin

local quotes_list = {
	English = {
		-- Elon Musk
		[7933] = [[<em>Colonists</em> gain <param1> bonus work performance when all their stats are in the green.

<grey>"I plan to live forever, of course, but barring that I'd settle for a couple thousand years. Even five hundred would be pretty nice."
<right>Nwabudike Morgan</grey><left>]],
		[6356] = [[New Wonder: <em>Geoscape Dome</em> (<buildinginfo('GeoscapeDome')>)  - A slice of Earth on Mars, this Dome has high Comfort and increases the Sanity of its inhabitants on every Sol.

<grey>"Some civilian workers got in among the research patients today and became so hysterical I felt compelled to have them nerve stapled. The consequence, of course, will be another public relations nightmare, but I was severely shaken by the extent of their revulsion towards a project so vital to our survival."
<right>Nwabudike Morgan</grey><left>]],
		[6497] = [[License Martian technology for use back on Earth. Earn <em><funding(param1)></em> funding.

This tech is <em>repeatable</em> and can be researched multiple times.

<grey>"Planet's Primary, Alpha Centauri A, blasts unimaginable quantities of energy into space each instant, and virtually every joule of it is wasted entirely. Incomprehensible riches can be ours if we can but stretch our arms wide enough to dip from this eternal river of wealth."
<right>Nwabudike Morgan</grey><left>]],
		[825589330974] = [[
New Building: <em>GHG Factory</em> (<buildinginfo('GHGFactory')>) - burns Fuel to increase the Temperature<icon_TemperatureTP_alt> of Mars, using greenhouse gases.

<grey>"Resources exist to be consumed. And consumed they will be, if not by this generation then by some future. By what right does this forgotten future seek to deny us our birthright? None I say! Let us take what is ours, chew and eat our fill."
<right>Nwabudike Morgan</grey><left>]],
		[11782] = [[Nwabudike]],
		-- Vladimir Putin
		[10515] = [[Extractors Upgrade (<em>Fueled Extractor</em>) - Production increased by <param1>% as long as the building is supplied with Fuel.

<grey>"Once is quite enough. What good does it do to annihilate a country twice? We're not a bloodthirsty people."
<right>Nikita Khrushchev<left></grey>]],
	},

	Brazilian = {
		[7933] = [[<em>Colonos</em> ganham <param1> bônus na performance de trabalho quando todos os seus status estão verdes.

<grey>"I plan to live forever, of course, but barring that I'd settle for a couple thousand years. Even five hundred would be pretty nice."
<right>Nwabudike Morgan</grey><left>]],
		[6356] = [[Nova Maravilha: <em>Domo de Geosfera</em> (<buildinginfo('GeoscapeDome')>) - um pedaço da Terra em Marte, este Domo tem um alto Conforto e aumenta a Sanidade de seus habitantes diariamente.

<grey>"Some civilian workers got in among the research patients today and became so hysterical I felt compelled to have them nerve stapled. The consequence, of course, will be another public relations nightmare, but I was severely shaken by the extent of their revulsion towards a project so vital to our survival."
<right>Nwabudike Morgan</grey><left>]],
		[6497] = [[Licencie tecnologias Marcianas para o uso na Terra. Receba <em><funding(param1)></em> de Financiamento.

Essa tecnologia pode ser <em>reaplicada</em> e pesquisada várias vezes.

<grey>"Planet's Primary, Alpha Centauri A, blasts unimaginable quantities of energy into space each instant, and virtually every joule of it is wasted entirely. Incomprehensible riches can be ours if we can but stretch our arms wide enough to dip from this eternal river of wealth."
<right>Nwabudike Morgan</grey><left>]],
		[825589330974] = [[Nova construção: <em>Fábrica de GEE</em> (<buildinginfo('GHGFactory')>) - queima combustível para aumentar a Temperatura<icon_TemperatureTP_alt> de Marte usando gases de efeito estufa.

<grey>"Resources exist to be consumed. And consumed they will be, if not by this generation then by some future. By what right does this forgotten future seek to deny us our birthright? None I say! Let us take what is ours, chew and eat our fill."
<right>Nwabudike Morgan</grey><left>]],
		[11782] = [[Nwabudike]],
		[10515] = [[Aprimoramento dos Extratores (<em>Extrator movido a Combustível</em>) - Produção aumentada em <param1>% desde que a construção esteja abastecida de Combustível.

<grey>"Once is quite enough. What good does it do to annihilate a country twice? We're not a bloodthirsty people."
<right>Nikita Khrushchev<left></grey>]],
	},

	French = {
		[7933] = [[Les <em>colons</em> gagnent <param1> de Productivité au travail en plus lorsque toutes leurs statistiques sont dans le vert.

<grey>"I plan to live forever, of course, but barring that I'd settle for a couple thousand years. Even five hundred would be pretty nice."
<right>Nwabudike Morgan</grey><left>]],
		[6356] = [[Nouvelle Merveille : <em>Dôme Terravision</em> (<buildinginfo('GeoscapeDome')>) - Un petit bout de Terre sur Mars. Ce Dôme a un Confort élevé et augmente quotidiennement la Santé Mentale de ses habitants.

<grey>"Some civilian workers got in among the research patients today and became so hysterical I felt compelled to have them nerve stapled. The consequence, of course, will be another public relations nightmare, but I was severely shaken by the extent of their revulsion towards a project so vital to our survival."
<right>Nwabudike Morgan</grey><left>]],
		[6497] = [[Déposez un brevet sur les technologies martiennes pour les utiliser sur Terre. Gagnez <em><funding(param1)></em> de Financement.

Cette technologie est <em>reproductible</em> et peut être développée plusieurs fois.

<grey>"Planet's Primary, Alpha Centauri A, blasts unimaginable quantities of energy into space each instant, and virtually every joule of it is wasted entirely. Incomprehensible riches can be ours if we can but stretch our arms wide enough to dip from this eternal river of wealth."
<right>Nwabudike Morgan</grey><left>]],
		[825589330974] = [[Nouveau bâtiment : <em>Usine GES</em> (<buildinginfo('GHGFactory')>) - brûle du carburant pour augmenter la température<icon_TemperatureTP_alt> de Mars grâce aux gaz à effet de serre.

<grey>"Resources exist to be consumed. And consumed they will be, if not by this generation then by some future. By what right does this forgotten future seek to deny us our birthright? None I say! Let us take what is ours, chew and eat our fill."
<right>Nwabudike Morgan</grey><left>]],
		[11782] = [[Nwabudike]],
		[10515] = [[Amélioration d'Extracteur (<em>Extracteur approvisionné</em>) - Production accrue de <param1> % tant que le bâtiment est approvisionné en carburant.

<grey>"Once is quite enough. What good does it do to annihilate a country twice? We're not a bloodthirsty people."
<right>Nikita Khrushchev<left></grey>]],
	},

	German = {
		[7933] = [[Die <em>Kolonisten</em> erhalten einen Bonus von <param1> auf ihre Arbeitsleistung, wenn all ihre Werte im grünen Bereich liegen.

<grey>"I plan to live forever, of course, but barring that I'd settle for a couple thousand years. Even five hundred would be pretty nice."
<right>Nwabudike Morgan</grey><left>]],
		[6356] = [[Neues Wunder: <em>Geoscape-Kuppel</em> (<buildinginfo('GeoscapeDome')>) – Ein Stück Erde auf dem Mars. Diese Kuppel verfügt über hohen Komfort und regeneriert täglich die Besonnenheit ihrer Bewohner.

<grey>"Some civilian workers got in among the research patients today and became so hysterical I felt compelled to have them nerve stapled. The consequence, of course, will be another public relations nightmare, but I was severely shaken by the extent of their revulsion towards a project so vital to our survival."
<right>Nwabudike Morgan</grey><left>]],
		[6497] = [[Lizensiere marsianische Technologien für die Benutzung auf der Erde. Erhalte Geldmittel in Höhe von <em><funding(param1)></em>.

Diese Technologie lässt sich <em>wiederholen</em> und kann mehrere Male erforscht werden.

<grey>"Planet's Primary, Alpha Centauri A, blasts unimaginable quantities of energy into space each instant, and virtually every joule of it is wasted entirely. Incomprehensible riches can be ours if we can but stretch our arms wide enough to dip from this eternal river of wealth."
<right>Nwabudike Morgan</grey><left>]],
		[825589330974] = [[Neues Gebäude: <em>Treibhausgas-Fabrik</em> (<buildinginfo('GHGFactory')>) – verbrennt Treibstoff, um die Temperatur <icon_TemperatureTP_alt> des Mars zu erhöhen.

<grey>"Resources exist to be consumed. And consumed they will be, if not by this generation then by some future. By what right does this forgotten future seek to deny us our birthright? None I say! Let us take what is ours, chew and eat our fill."
<right>Nwabudike Morgan</grey><left>]],
		[11782] = [[Nwabudike]],
		[10515] = [[Extraktoren-Upgrade (<em>Betankter Extraktor</em>) – +<param1> % Produktion, solange das Gebäude mit Treibstoff versorgt ist.

<grey>"Once is quite enough. What good does it do to annihilate a country twice? We're not a bloodthirsty people."
<right>Nikita Khrushchev<left></grey>]],
	},

	Polish = {
		[7933] = [[<em>Koloniści</em> uzyskują <param1> premii do wydajności pracy, gdy wszystkie parametry są zielone.

<grey>"I plan to live forever, of course, but barring that I'd settle for a couple thousand years. Even five hundred would be pretty nice."
<right>Nwabudike Morgan</grey><left>]],
		[6356] = [[Nowy cud: <em>kopuła krajobrazowa</em> (<buildinginfo('GeoscapeDome')>) - kawałek Ziemi na Marsie, zapewniający dużą wygodę i codziennie zwiększający zdrowie psychiczne mieszkańców.

<grey>"Some civilian workers got in among the research patients today and became so hysterical I felt compelled to have them nerve stapled. The consequence, of course, will be another public relations nightmare, but I was severely shaken by the extent of their revulsion towards a project so vital to our survival."
<right>Nwabudike Morgan</grey><left>]],
		[6497] = [[Udzielenie Ziemianom licencji na korzystanie z marsjańskiej technologii, za co otrzymasz <em><funding(param1)></em>.

Ta technologia jest <em>powtarzalna</em> i można ją opracowywać wielokrotnie.

<grey>"Planet's Primary, Alpha Centauri A, blasts unimaginable quantities of energy into space each instant, and virtually every joule of it is wasted entirely. Incomprehensible riches can be ours if we can but stretch our arms wide enough to dip from this eternal river of wealth."
<right>Nwabudike Morgan</grey><left>]],
		[825589330974] = [[Nowy budynek – <em>Wytwórnia GC</em> (<buildinginfo('GHGFactory')>) – spala paliwo, aby zwiększyć temperaturę <icon_TemperatureTP_alt> Marsa za pomocą gazów cieplarnianych.

<grey>"Resources exist to be consumed. And consumed they will be, if not by this generation then by some future. By what right does this forgotten future seek to deny us our birthright? None I say! Let us take what is ours, chew and eat our fill."
<right>Nwabudike Morgan</grey><left>]],
		[11782] = [[Nwabudike]],
		[10515] = [[Ulepszenie ekstraktora (<em>napęd ekstraktora</em>) – +<param1>% do produkcji, jak długo budynek jest zaopatrywany w paliwo.

<grey>"Once is quite enough. What good does it do to annihilate a country twice? We're not a bloodthirsty people."
<right>Nikita Khrushchev<left></grey>]],
	},

	Russian = {
		[7933] = [[<em>Колонисты</em> получают бонус к эффективности труда (<param1>), когда их показатели отмечены зеленым.

<grey>"I plan to live forever, of course, but barring that I'd settle for a couple thousand years. Even five hundred would be pretty nice."
<right>Nwabudike Morgan</grey><left>]],
		[6356] = [[Новое чудо марсианской науки: <em>купол «Природа Земли»</em> (<buildinginfo('GeoscapeDome')>) — уголок Земли на Марсе, в нем поддерживается высокий уровень комфорта, и он ежедневно улучшает душевное равновесие обитателей.

<grey>"Some civilian workers got in among the research patients today and became so hysterical I felt compelled to have them nerve stapled. The consequence, of course, will be another public relations nightmare, but I was severely shaken by the extent of their revulsion towards a project so vital to our survival."
<right>Nwabudike Morgan</grey><left>]],
		[6497] = [[Марсианские технологии можно лицензировать для использования на Земле, это принесет вам дополнительные средства (<em><funding(param1)></em>).

Данное исследование можно проводить <em>многократно</em>.

<grey>"Planet's Primary, Alpha Centauri A, blasts unimaginable quantities of energy into space each instant, and virtually every joule of it is wasted entirely. Incomprehensible riches can be ours if we can but stretch our arms wide enough to dip from this eternal river of wealth."
<right>Nwabudike Morgan</grey><left>]],
		[825589330974] = [[Новая постройка: <em>завод парниковых газов</em> (<buildinginfo('GHGFactory')>) — сжигает топливо, чтобы повысить температуру<icon_TemperatureTP_alt> Марса парниковыми газами.

<grey>"Resources exist to be consumed. And consumed they will be, if not by this generation then by some future. By what right does this forgotten future seek to deny us our birthright? None I say! Let us take what is ours, chew and eat our fill."
<right>Nwabudike Morgan</grey><left>]],
		[11782] = [[Nwabudike]],
		[10515] = [[Улучшение экстракторов (<em>экстрактор на топливе</em>) — производительность увеличивается на <param1>%, пока постройка снабжается топливом.

<grey>"Once is quite enough. What good does it do to annihilate a country twice? We're not a bloodthirsty people."
<right>Nikita Khrushchev<left></grey>]],
	},

	Schinese = {
		[7933] = [[当<em>殖民地居民</em>所有属性都为绿色时，会额外获得<param1>工作效率。

<grey>"I plan to live forever, of course, but barring that I'd settle for a couple thousand years. Even five hundred would be pretty nice."
<right>Nwabudike Morgan</grey><left>]],
		[6356] = [[新奇观：<em>地景穹顶</em>（<buildinginfo('GeoscapeDome')>） - 火星上的地球一隅。这种穹顶可以增加所有内部居民的舒适度，而且每个太阳日都能提高居民的理智度。

<grey>"Some civilian workers got in among the research patients today and became so hysterical I felt compelled to have them nerve stapled. The consequence, of course, will be another public relations nightmare, but I was severely shaken by the extent of their revulsion towards a project so vital to our survival."
<right>Nwabudike Morgan</grey><left>]],
		[6497] = [[将火星上的技术专利出口至地球，获得<em><funding(param1)></em>资金。

这项技术是<em>重复性</em>技术，可以多次研发。

<grey>"Planet's Primary, Alpha Centauri A, blasts unimaginable quantities of energy into space each instant, and virtually every joule of it is wasted entirely. Incomprehensible riches can be ours if we can but stretch our arms wide enough to dip from this eternal river of wealth."
<right>Nwabudike Morgan</grey><left>]],
		[825589330974] = [[新建筑：<em>温室气体工厂</em>（<buildinginfo('GHGFactory')>） - 燃烧燃料，利用温室气体提高火星<icon_TemperatureTP_alt>温度。

<grey>"Resources exist to be consumed. And consumed they will be, if not by this generation then by some future. By what right does this forgotten future seek to deny us our birthright? None I say! Let us take what is ours, chew and eat our fill."
<right>Nwabudike Morgan</grey><left>]],
		[11782] = [[Nwabudike]],
		[10515] = [[挖掘站升级（<em>燃料式挖掘站</em>），在挖掘站配备燃料的情况下，产量提高<param1>%。

<grey>"Once is quite enough. What good does it do to annihilate a country twice? We're not a bloodthirsty people."
<right>Nikita Khrushchev<left></grey>]],
	},

	Spanish = {
		[7933] = [[Los <em>colonos</em> consiguen <param1> bonus de rendimiento de trabajo cuando todas sus estadísticas están en verde.

<grey>"I plan to live forever, of course, but barring that I'd settle for a couple thousand years. Even five hundred would be pretty nice."
<right>Nwabudike Morgan</grey><left>]],
		[6356] = [[Nueva maravilla: <em>Cúpula terraria</em> (<buildinginfo('GeoscapeDome')>) - un cachito de la Tierra en Marte. Esta cúpula tiene una comodidad de cúpula alta y aumenta la cordura de sus habitantes cada Sol.

<grey>"Some civilian workers got in among the research patients today and became so hysterical I felt compelled to have them nerve stapled. The consequence, of course, will be another public relations nightmare, but I was severely shaken by the extent of their revulsion towards a project so vital to our survival."
<right>Nwabudike Morgan</grey><left>]],
		[6497] = [[Registra la tecnología marciana para que la usen en la Tierra. Gana <em><funding(param1)></em> de fondos.

Esta tecnología es <em>repetible</em> y puede ser investigada varias veces.

<grey>"Planet's Primary, Alpha Centauri A, blasts unimaginable quantities of energy into space each instant, and virtually every joule of it is wasted entirely. Incomprehensible riches can be ours if we can but stretch our arms wide enough to dip from this eternal river of wealth."
<right>Nwabudike Morgan</grey><left>]],
		[825589330974] = [[Nueva construcción: <em>Fábrica de gases invernadero</em> (<buildinginfo('GHGFactory')>), quema combustible para aumentar la temperatura <icon_TemperatureTP_alt> de Marte usando gases de efecto invernadero.

<grey>"Resources exist to be consumed. And consumed they will be, if not by this generation then by some future. By what right does this forgotten future seek to deny us our birthright? None I say! Let us take what is ours, chew and eat our fill."
<right>Nwabudike Morgan</grey><left>]],
		[11782] = [[Nwabudike]],
		[10515] = [[Mejora de extractores (<em>extractores propulsados</em>): aumenta la producción en un <param1> % si la construcción tiene combustible.

<grey>"Once is quite enough. What good does it do to annihilate a country twice? We're not a bloodthirsty people."
<right>Nikita Khrushchev<left></grey>]],
	},

	Turkish = {
		[7933] = [[<em>Kolonistler</em> tüm istatistikleri yeşil renkte olduğunda <param1> iş performansı bonusu kazanır.

<grey>"I plan to live forever, of course, but barring that I'd settle for a couple thousand years. Even five hundred would be pretty nice."
<right>Nwabudike Morgan</grey><left>]],
		[6356] = [[Yeni Mars Harikası: <em>Dünyamsı Kubbe</em> (<buildinginfo('GeoscapeDome')>) - Mars'ta, Dünya'dan bir parça. Bu kubbe yüksek konfora sahiptir ve her Sol sakinlerinin akıl sağlığını artırır.

<grey>"Some civilian workers got in among the research patients today and became so hysterical I felt compelled to have them nerve stapled. The consequence, of course, will be another public relations nightmare, but I was severely shaken by the extent of their revulsion towards a project so vital to our survival."
<right>Nwabudike Morgan</grey><left>]],
		[6497] = [[Mars teknolojisini Dünya'da kullanılması için lisansla. <em><funding(param1)></em> fon kazanılır.

Bu teknoloji <em>tekrarlanabilir</em> ve birçok kez araştırılabilir.

<grey>"Planet's Primary, Alpha Centauri A, blasts unimaginable quantities of energy into space each instant, and virtually every joule of it is wasted entirely. Incomprehensible riches can be ours if we can but stretch our arms wide enough to dip from this eternal river of wealth."
<right>Nwabudike Morgan</grey><left>]],
		[825589330974] = [[Yeni Bina: <em>Sera Gazı Fabrikası</em> (<buildinginfo('GHGFactory')>) - Yakıt tüketerek, sera gazlarını kullanarak Mars'ın sıcaklığını<icon_TemperatureTP_alt> yükseltir.

<grey>"Resources exist to be consumed. And consumed they will be, if not by this generation then by some future. By what right does this forgotten future seek to deny us our birthright? None I say! Let us take what is ours, chew and eat our fill."
<right>Nwabudike Morgan</grey><left>]],
		[11782] = [[Nwabudike]],
		[10515] = [[Sondaj Yükseltmesi (<em>Yakıtlı Sondaj</em>) - Binaya yakıt ikmali yapıldığı sürece, üretim %<param1> oranında artar.

<grey>"Once is quite enough. What good does it do to annihilate a country twice? We're not a bloodthirsty people."
<right>Nikita Khrushchev<left></grey>]],
	},
}

local function ChangeStrings()
	local TranslationTable = TranslationTable
	local lang = GetLanguage()

	if mod_ElonMusk then
		TranslationTable[7933] = quotes_list[lang][7933]
		TranslationTable[6356] = quotes_list[lang][6356]
		TranslationTable[6497] = quotes_list[lang][6497]
		TranslationTable[825589330974] = quotes_list[lang][825589330974]
		TranslationTable[11782] = quotes_list[lang][11782]
	end

	if mod_VladimirPutin then
		TranslationTable[10515] = quotes_list[lang][10515]
	end

	-- Probably don't need this
	Msg("TranslationChanged", "skip")
end

-- Override strings whenever TranslationChanged fires
function OnMsg.TranslationChanged(skip)
	if skip == "skip" then
		return
	end

	ChangeStrings()
end

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_ElonMusk = CurrentModOptions:GetProperty("ElonMusk")
	mod_VladimirPutin = CurrentModOptions:GetProperty("VladimirPutin")

	ChangeStrings()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
