-- See LICENSE for terms

function OnMsg.ClassesPostprocess()
	local building = XTemplates.customRocketExpedition[1]

	-- check for and remove existing template
	ChoGGi_Funcs.Common.RemoveXTemplateSections(building, "ChoGGi_Template_ChoGGi_ForceLaunch", true)

	table.insert(building, 1, PlaceObj("XTemplateTemplate", {
		"ChoGGi_Template_ChoGGi_ForceLaunch", true,
		"Id", "idLaunch",
		"comment", "force launch",
		"__template", "InfopanelButton",
		"RolloverText", T(625375195830, "Initiates launch sequence for the return trip to Earth. Note that the rocket has to be refueled and any remaining resources on board will be lost.<newline><newline>Status: <em><UILaunchStatus></em>"),
		"RolloverTitle", T(526598507877, "Return to Earth"),
		"OnPressParam", "UILaunch",
		"Icon", "UI/Icons/IPButtons/force_launch.tga",
	}))

end

function RocketBase:UILaunch()
	if self:IsDemolishing() then
		self:ToggleDemolish()
	end

	if self:GetLaunchIssue() == "cargo" then

		-- no issues so show the msg
		CreateRealTimeThread(function()
			local result = WaitPopupNotification("LaunchIssue_Cargo", {
					choice1 = T(8013, "Launch anyway (resources will be lost)."),
					choice2 = T(8014, "Abort the launch sequence."),
				}, false, GetInGameInterface())

			if result == 1 then
					self:SetCommand("Takeoff")
			end
		end)
	end
end
