-- See LICENSE for terms

DefineClass.BottomlessWasteRock = {
	__parents = {
		"WasteRockDumpSite",
	},
}

function BottomlessWasteRock:GameInit()
	-- make sure it isn't mistaken for a regular depot
	self:SetColorModifier(-11252937)

	-- turn off shuttles
	StorageDepot.SetLRTService(self, false)
end

--om nom nom nom nom
function BottomlessWasteRock:DroneUnloadResource(...)
	WasteRockDumpSite.DroneUnloadResource(self, ...)
	if self.working then
		self:CheatEmpty()
		RebuildInfopanel(self)
	end
end

--add building to building template list
function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.BottomlessWasteRock then
		PlaceObj("BuildingTemplate", {
			"Id", "BottomlessWasteRock",
			"template_class", "BottomlessWasteRock",
			"instant_build", true,
			"dome_forbidden", true,
			"display_name", T(302535920011050, [[Bottomless Waste Rock]]),
			"display_name_pl", T(302535920011051, [[Bottomless Waste Rocks]]),
			"description", T(302535920011051, [[Warning: Any waste rocks dumped at this depot will disappear.]]),
			"build_category", "ChoGGi",
			"Group", "ChoGGi",
			"display_icon", CurrentModPath .. "UI/res_waste_rock.png",
			"entity", "ResourcePlatform",
			"on_off_button", true,
			"prio_button", false,
			"count_as_building", false,
			"desire_slider_max", 57,
			"max_amount_WasteRock", 10000,
		})
	end

	-- since we use a diff name from customWasteRockDumpBig
	PlaceObj('XTemplate', {
		group = "Infopanel Sections",
		id = "customBottomlessWasteRock",
		PlaceObj('XTemplateTemplate', {
			'__template', "InfopanelSection",
			'RolloverText', T(10461, --[[XTemplate customWasteRockDumpSite RolloverText]] "Drones and Shuttles will attempt to stockpile at least <DesiredAmountUI> of each resources stored here."),
			'RolloverHint', T(116367034467, --[[XTemplate customWasteRockDumpSite RolloverHint]] "<left_click> Set Desired Amount <newline><em>Ctrl + <left_click></em> Set Desired Amount in all <display_name_pl>"),
			'RolloverHintGamepad', T(10462, --[[XTemplate customWasteRockDumpSite RolloverHintGamepad]] "<LB> / <RB>    change desired amount"),
			'Title', T(10463, --[[XTemplate customWasteRockDumpSite Title]] "Desired Amount <DesiredAmountUI>"),
			'Icon', "UI/Icons/Sections/facility.tga",
		}, {
			PlaceObj('XTemplateTemplate', {
				'__template', "InfopanelSlider",
				'BindTo', "DesiredAmountSlider",
			}),
			}),
		PlaceObj('XTemplateTemplate', {
			'__context_of_kind', "BottomlessWasteRock",
			'__template', "InfopanelSection",
			'RolloverText', T(490, --[[XTemplate customWasteRockDumpSite RolloverText]] "Amount Waste Rock stored."),
			'Title', T(489, --[[XTemplate customWasteRockDumpSite Title]] "Available resources"),
			'Icon', "UI/Icons/Sections/WasteRock_4.tga",
		}, {
			PlaceObj('XTemplateTemplate', {
				'__template', "InfopanelText",
				'Text', T(491, --[[XTemplate customWasteRockDumpSite Text]] "<resource('WasteRock')><right><wasterock(Stored_WasteRock, MaxAmount_WasteRock)>"),
			}),
			}),
	})


end --ClassesPostprocess
