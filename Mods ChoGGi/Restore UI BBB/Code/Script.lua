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
OnMsg.ClassesPostprocess = UpdateLang

-- got removed by AG, it's not as if anyone needs to see how many drones a drone hub can support
function DroneControl:GetMaxDronesCount()
	return g_Consts.CommandCenterMaxDrones
end
