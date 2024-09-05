-- See LICENSE for terms

local Translate = ChoGGi_Funcs.Common.Translate

local table = table
local T = T
local procall = procall

local options
local mod_MoreSpecInfo
local mod_PosPassList
local mod_HideRocket
local mod_PosX
local mod_PosY

local ToggleSpecInfo
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	options = CurrentModOptions
	mod_MoreSpecInfo = options:GetProperty("MoreSpecInfo")
	mod_PosPassList = options:GetProperty("PosPassList")
	mod_HideRocket = options:GetProperty("HideRocket")
	mod_PosX = options:GetProperty("PosX")
	mod_PosY = options:GetProperty("PosY")

	-- I'm lazy, sue me
	procall(ToggleSpecInfo)
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local needed_specialist = {}
local all_specialist = {}

local function BuildSpecialistLists()
	needed_specialist.none = 0
	all_specialist.none = #UIColony:GetCityLabels("none")

	local ColonistClasses = ColonistClasses
	for id in pairs(ColonistClasses) do
		all_specialist[id] = #UIColony:GetCityLabels(id)
		needed_specialist[id] = 0
	end
--~ 	ex(needed_specialist)

	-- needed count
	local workplaces = UIColony:GetCityLabels("Workplace")
	for i = 1, #workplaces do
		local bld = workplaces[i]
		local spec = bld.specialist
		local count = needed_specialist[spec]
--~ 		if count and not bld.destroyed and not bld.demolishing and not bld.bulldozed then
		if count and bld.working then
			needed_specialist[spec] = count + (bld:GetFreeWorkSlots() or 0)
		end
	end

end

local filter_table = {}
local function GetMatchingColonistsCount(self, spec)
	table.clear(filter_table)
	-- picard uses numbers instead of bool for for traits and TraitFilterColonist was updated for that
	filter_table[spec] = 1

	local colonists = self.approved_applicants
	local count = 0
	-- what dome?
	local label = not not self.dome
	for i = 1, #colonists do
		local colonist = label and colonists[i] or colonists[i][1]

		if TraitFilterColonist(filter_table, colonist.traits) > 0 then
			count = count + 1
		end
	end
	return count
end

local function GetSpecInfo(self, win, label)
	local matching_win = win:ResolveId("idChoGGiPassInfo_" .. label)
	if matching_win then
		local count = GetMatchingColonistsCount(self, label)
		local all = all_specialist[label]
		local needed = needed_specialist[label]
		matching_win:SetText(T{0, "<c>/<n>/<a>", c = count, n = needed, a = all})
	end
end
function SetUIResupplyParams(self, win)
	GetSpecInfo(self, win, "none")
	local ColonistClasses = ColonistClasses
	for id in pairs(ColonistClasses) do
		GetSpecInfo(self, win, id)
	end
end

-- add extra info to select colonists
ToggleSpecInfo = function()
	local pass = XTemplates.ResupplyPassengers[1]
	local template = pass[table.find(pass, "Id", "idContent")]
	template = template[table.find(template, "Id", "idTop")]
	ChoGGi_Funcs.Common.RemoveXTemplateSections(template, "Id", "idPassInfo_ChoGGi")
	if not mod_MoreSpecInfo then
		return
	end

	local oooo = box(0, 0, 0, 0)
	local T = T

	table.insert(template, 3, PlaceObj("XTemplateWindow", {
		"Id", "idPassInfo_ChoGGi",
		"HAlign", "left",
		"Dock", "top",
		"Margins", box(55, 0, 0, 0),
		"RolloverTemplate", "Rollover",
		"RolloverTitle", T(11531, "Specialists"),
		"RolloverText", T(302535920011132, "Selected Applicants / Needed Specialists / Colony Amount"),
	}, {
		PlaceObj("XTemplateWindow", {
			"__class", "XText",
			"Dock", "top",
			"TextStyle", "LandingPosName",
			"Translate", true,
			"Text", T(11531, "Specialists"),
			-- stop it from going black on mouse over
			"HandleMouse", false,
			-- remove the margin added above
			"Margins", box(-35, 0, 0, 0),
		}),

		PlaceObj("XTemplateWindow", {
			"__class", "XContextWindow",
			"Dock", "top",
			"LayoutMethod", "HList",
			"ContextUpdateOnOpen", true,
			"OnContextUpdate", function (self, context, ...)
				SetUIResupplyParams(context, self)
			end,
		}, {

			PlaceObj("XTemplateWindow", {
				"Dock", "left",
				"LayoutMethod", "HList",
				"LayoutHSpacing", 50,
			}, {
				PlaceObj("XTemplateWindow", {
					"LayoutMethod", "VList",
				}, {
					PlaceObj("XTemplateWindow", {-- none
						"__condition", function()
							return not MainCity or MainCity.launch_mode ~= "passenger_pod"
						end,
						"__class", "XText",
						"Padding", oooo,
						"TextStyle", "PGLandingPosDetails",
						"Translate", true,
						"Text", T(3848, "No specialization"),
					}),
					PlaceObj("XTemplateWindow", {-- Botanist
						"__condition", function()
							return not MainCity or MainCity.launch_mode ~= "passenger_pod"
						end,
						"__class", "XText",
						"Padding", oooo,
						"TextStyle", "PGLandingPosDetails",
						"Translate", true,
						"Text", T(3865, "Botanist"),
					}),
					PlaceObj("XTemplateWindow", {-- Engineer
						"__condition", function()
							return not MainCity or MainCity.launch_mode ~= "passenger_pod"
						end,
						"__class", "XText",
						"Padding", oooo,
						"TextStyle", "PGLandingPosDetails",
						"Translate", true,
						"Text", T(3853, "Engineer"),
					}),
					PlaceObj("XTemplateWindow", {-- Geologist
						"__condition", function()
							return not MainCity or MainCity.launch_mode ~= "passenger_pod"
						end,
						"__class", "XText",
						"Padding", oooo,
						"TextStyle", "PGLandingPosDetails",
						"Translate", true,
						"Text", T(3859, "Geologist"),
					}),

				}),

				PlaceObj("XTemplateWindow", {
					"LayoutMethod", "VList",
				}, {
					PlaceObj("XTemplateWindow", {
						"__class", "XText",
						"Id", "idChoGGiPassInfo_none",
						"Padding", oooo,
						"TextStyle", "PGChallengeDescription",
						"Translate", true,
					}),
					PlaceObj("XTemplateWindow", {
						"__class", "XText",
						"Id", "idChoGGiPassInfo_botanist",
						"Padding", oooo,
						"TextStyle", "PGChallengeDescription",
						"Translate", true,
					}),
					PlaceObj("XTemplateWindow", {
						"__class", "XText",
						"Id", "idChoGGiPassInfo_engineer",
						"Padding", oooo,
						"TextStyle", "PGChallengeDescription",
						"Translate", true,
					}),
					PlaceObj("XTemplateWindow", {
						"__class", "XText",
						"Id", "idChoGGiPassInfo_geologist",
						"Padding", oooo,
						"TextStyle", "PGChallengeDescription",
						"Translate", true,
					}),

				}),
			}),

			PlaceObj("XTemplateWindow", {
				"Dock", "right",
				"Margins", box(20, 0, 0, 0),
				"LayoutMethod", "HList",
				"LayoutHSpacing", 50,
			}, {
				PlaceObj("XTemplateWindow", {
					"LayoutMethod", "VList",
				}, {
					PlaceObj("XTemplateWindow", {
						"__condition", function()
							return not MainCity or MainCity.launch_mode ~= "passenger_pod"
						end,
						"__class", "XText",
						"Padding", oooo,
						"TextStyle", "PGLandingPosDetails",
						"Translate", true,
						"Text", T(3862, "Medic"),
					}),
					PlaceObj("XTemplateWindow", {
						"__condition", function()
							return not MainCity or MainCity.launch_mode ~= "passenger_pod"
						end,
						"__class", "XText",
						"Padding", oooo,
						"TextStyle", "PGLandingPosDetails",
						"Translate", true,
						"Text", T(3850, "Scientist"),
					}),
					PlaceObj("XTemplateWindow", {
						"__condition", function()
							return not MainCity or MainCity.launch_mode ~= "passenger_pod"
						end,
						"__class", "XText",
						"Padding", oooo,
						"TextStyle", "PGLandingPosDetails",
						"Translate", true,
						"Text", T(6682, "Officer"),
					}),

				}),

				PlaceObj("XTemplateWindow", {
					"LayoutMethod", "VList",
				}, {
					PlaceObj("XTemplateWindow", {
						"__class", "XText",
						"Id", "idChoGGiPassInfo_medic",
						"Padding", oooo,
						"TextStyle", "PGChallengeDescription",
						"Translate", true,
					}),
					PlaceObj("XTemplateWindow", {
						"__class", "XText",
						"Id", "idChoGGiPassInfo_scientist",
						"Padding", oooo,
						"TextStyle", "PGChallengeDescription",
						"Translate", true,
					}),
					PlaceObj("XTemplateWindow", {
						"__class", "XText",
						"Id", "idChoGGiPassInfo_security",
						"Padding", oooo,
						"TextStyle", "PGChallengeDescription",
						"Translate", true,
					}),

				}),
			}),
		}),
	}))
end

local function AddUIStuff(content)
	-- wait for it (thanks SkiRich)
	WaitMsg("OnRender")

	mod_PosPassList = options:GetProperty("PosPassList")
	mod_PosX = options:GetProperty("PosX")
	mod_PosY = options:GetProperty("PosY")
	if mod_PosPassList then
		content.idListsWrapper:SetMargins(box(
			mod_PosX,
			-mod_PosY,
			0, 0
		))
	end

	-- fatty boy
	content.idLeftScroll:SetMaxWidth(24)
	content.idLeftScroll:SetMinWidth(24)
	-- *cough cough* rare/precious
	content.idScrollRight:SetMaxWidth(24)
	content.idScrollRight:SetMinWidth(24)

	-- back button
	local ChoOrig_back = content.idToolBar.idback.OnPress
	content.idToolBar.idback.OnPress = function(...)
		local varargs = {...}
		local function CallBackFunc(answer)
			if answer then
				ChoOrig_back(table.unpack(varargs))
			end
		end
		ChoGGi_Funcs.Common.QuestionBox(
			T(5761, "Are you sure you want to cancel the Rocket's launch order?"),
			CallBackFunc,
			T(3687, "Cancel") .. " " .. T(1116, "Passenger Rocket")
		)
	end

end

local pass_thread

local function ResDlg(dlg)
	-- goodbye planet
	if mod_HideRocket then
		dlg:SetBackground(black)
	end

	-- build list once per open (total count and needed count)
	BuildSpecialistLists()

	-- replace old func with our piggyback
	local ChoOrig_SetMode = dlg.SetMode
	function dlg:SetMode(mode, ...)
		ChoOrig_SetMode(self, mode, ...)
		if mode == "passengers" then
			local content = self.idTemplate.idPassengers

			-- first time pass list opens
			if IsValidThread(pass_thread) then
				DeleteThread(pass_thread)
			end
			pass_thread = CreateRealTimeThread(AddUIStuff, content)

			-- when we switch back from filter mode
			local ChoOrig_SetMode2 = content.SetMode
			function content:SetMode(mode, ...)
				ChoOrig_SetMode2(self, mode, ...)
				if mode == "review" then
					if IsValidThread(pass_thread) then
						DeleteThread(pass_thread)
					end
					pass_thread = CreateRealTimeThread(AddUIStuff, content)
				end
			end

		end
	end
end

local ChoOrig_OpenDialog = OpenDialog
function OpenDialog(dlg_str, ...)
	local dlg = ChoOrig_OpenDialog(dlg_str, ...)
	if dlg_str == "Resupply" then
		ResDlg(dlg)
	end
	return dlg
end

local function SafeChangeAge(self)
	local descr = self.prop_meta.rollover.descr[1]
	if type(descr.Age) == "userdata" and TGetID(descr.Age) > 0 then
		descr.Age = Translate(descr.Age .. ": " .. self.prop_meta.applicant[1].age)
	end
end

local function AddExtraInfo(xtemplate)
	if xtemplate.ChoGGi_AddedExtraPassInfo then
		return
	end
	xtemplate.ChoGGi_AddedExtraPassInfo = true

	local idx = table.find(xtemplate, "name", "Open")
	if not idx then
		return
	end
	xtemplate = xtemplate[idx]

	local orig = xtemplate.func
	xtemplate.func = function(self, ...)
		-- by safe I mean log spam instead of failing on a bad apple
		procall(SafeChangeAge, self)
		return orig(self, ...)
	end
end

function OnMsg.ClassesPostprocess()
	AddExtraInfo(XTemplates.PropApplicantSelected[1])
	AddExtraInfo(XTemplates.PropApplicant[1])
end
