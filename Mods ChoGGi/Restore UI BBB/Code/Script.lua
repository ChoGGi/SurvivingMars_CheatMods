-- See LICENSE for terms

local langs = {
	Brazilian = T(0000, "Drones<right><drone(DronesCount,MaxDronesCount)>"),
	English = T(0000, "Drones<right><drone(DronesCount,MaxDronesCount)>"),
	French = T(0000, "Drones<right><drone(DronesCount,MaxDronesCount)>"),
	German = T(0000, "Drohnen<right><drone(DronesCount,MaxDronesCount)>"),
	Polish = T(0000, "Drony<right><drone(DronesCount,MaxDronesCount)>"),
	Russian = T(0000, "Дроны<right><drone(DronesCount,MaxDronesCount)>"),
	Schinese = T(0000, "无人机<right><drone(DronesCount,MaxDronesCount)>"),
	Spanish = T(0000, "Drones<right><drone(DronesCount,MaxDronesCount)>"),
	Turkish = T(0000, "Drone'lar<right><drone(DronesCount,MaxDronesCount)>"),
}

local function UpdateLang()
	local template = XTemplates.customDroneHub
	local idx = table.find(template, "Icon", "UI/Icons/Sections/drone.tga")
	if idx then
		template[idx].Title = langs[GetLanguage()]
	end
end

OnMsg.TranslationChanged = UpdateLang

function OnMsg.ClassesPostprocess()
	UpdateLang()

	-- this wasn't added before BB, but it's as good as any place to put it...
	if not XTemplates.customSecurityPost then
		XTemplates.customSecurityPost = PlaceObj('XTemplate', {
			group = "Infopanel Sections",
			id = "customSecurityPost",
			PlaceObj('XTemplateTemplate', {
				'__context_of_kind', "SecurityStation",
				'__template', "InfopanelSection",
				'RolloverText', T(525, --[[XTemplate customSecurityStation RolloverText]] "Unhappy Colonists may become Renegades. Renegades will often cause trouble in the Dome"),
				'RolloverTitle', T(524, --[[XTemplate customSecurityStation RolloverTitle]] "Renegades in the Dome"),
				'Title', T(277702433938, --[[XTemplate customSecurityStation Title]] "Renegades in the Dome <right><RenegadesCount>"),
				'Icon', "UI/Icons/Sections/colonist.tga",
				'TitleHAlign', "stretch",
			}),
		})
	end
end

-- got removed by AG, it's not as if anyone needs to see how many drones a drone hub can support
function DroneControl:GetMaxDronesCount()
	return g_Consts.CommandCenterMaxDrones
end

