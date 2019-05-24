-- See LICENSE for terms

local table_clear = table.clear

local mod_id = "ChoGGi_PassengerRocketTweaks"
local mod = Mods[mod_id]

local mod_MoreSpecInfo = mod.options and mod.options.MoreSpecInfo or false
local mod_PosPassList = mod.options and mod.options.PosPassList or false
local mod_HideRocket = mod.options and mod.options.HideRocket or false
local mod_PosX = mod.options and mod.options.PosX or 700
local mod_PosY = mod.options and mod.options.PosY or 500

local ToggleSpecInfo
local function ModOptions()
	mod_MoreSpecInfo = mod.options.MoreSpecInfo
	ToggleSpecInfo()
	mod_PosPassList = mod.options.PosPassList
	mod_HideRocket = mod.options.HideRocket
	mod_PosX = mod.options.PosX
	mod_PosY = mod.options.PosY
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end

	ModOptions()
end

-- for some reason mod options aren't retrieved before this script is loaded...
OnMsg.CityStart = ModOptions
OnMsg.LoadGame = ModOptions

--~ local Strings = ChoGGi.Strings
local Translate = ChoGGi.ComFuncs.Translate

local needed_specialist = {}
local all_specialist = {}
local function BuildSpecialistLists()
	local labels = UICity.labels

	table_clear(needed_specialist)
	table_clear(all_specialist)

	needed_specialist.none = 0
	all_specialist.none = #(labels.none or "")
	local ColonistSpecializationList = ColonistSpecializationList
	for i = 1, #ColonistSpecializationList do
		local spec = ColonistSpecializationList[i]
		all_specialist[spec] = #(labels[spec] or "")
		needed_specialist[spec] = 0
	end

	-- needed count
	local workplaces = labels.Workplace or ""
	for i = 1, #workplaces do
		local bld = workplaces[i]
		local spec = bld.specialist
		if not bld.destroyed and not bld.demolishing and not bld.bulldozed then
			needed_specialist[spec] = needed_specialist[spec] + bld:GetFreeWorkSlots()
		end
	end

end

local filter_table = {}
local function GetMatchingColonistsCount(self, spec)
	table_clear(filter_table)
	filter_table[spec] = true

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
	local ColonistSpecializationList = ColonistSpecializationList
	for i = 1, #ColonistSpecializationList do
		GetSpecInfo(self, win, ColonistSpecializationList[i])
	end
end

-- add extra info to select colonists
ToggleSpecInfo = function()
	-- I'm lazy, sue me
	pcall(function()

		local pass = XTemplates.ResupplyPassengers[1]
		local template = pass[table.find(pass, "Id", "idContent")]
		template = template[table.find(template, "Id", "idTop")]
		ChoGGi.ComFuncs.RemoveXTemplateSections(template, "Id", "idPassInfo_ChoGGi")
		if not mod_MoreSpecInfo then
			return
		end

		table.insert(template, 3, PlaceObj("XTemplateWindow", {
			"Id", "idPassInfo_ChoGGi",
			"HAlign", "left",
			"Dock", "top",
			"Margins", box(55, 0, 0, 0),
			"RolloverTemplate", "Rollover",
			"RolloverTitle", T(11531, "Specialists"),
			"RolloverText", [[Selected Applicants / Needed Specialists / Colony Amount]],
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
								return not UICity or UICity.launch_mode ~= "passenger_pod"
							end,
							"__class", "XText",
							"Padding", box(0, 0, 0, 0),
							"TextStyle", "PGLandingPosDetails",
							"Translate", true,
							"Text", T(3848, "No specialization"),
						}),
						PlaceObj("XTemplateWindow", {-- Botanist
							"__condition", function()
								return not UICity or UICity.launch_mode ~= "passenger_pod"
							end,
							"__class", "XText",
							"Padding", box(0, 0, 0, 0),
							"TextStyle", "PGLandingPosDetails",
							"Translate", true,
							"Text", T(3865, "Botanist"),
						}),
						PlaceObj("XTemplateWindow", {-- Engineer
							"__condition", function()
								return not UICity or UICity.launch_mode ~= "passenger_pod"
							end,
							"__class", "XText",
							"Padding", box(0, 0, 0, 0),
							"TextStyle", "PGLandingPosDetails",
							"Translate", true,
							"Text", T(3853, "Engineer"),
						}),
						PlaceObj("XTemplateWindow", {-- Geologist
							"__condition", function()
								return not UICity or UICity.launch_mode ~= "passenger_pod"
							end,
							"__class", "XText",
							"Padding", box(0, 0, 0, 0),
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
							"Padding", box(0, 0, 0, 0),
							"TextStyle", "PGChallengeDescription",
							"Translate", true,
						}),
						PlaceObj("XTemplateWindow", {
							"__class", "XText",
							"Id", "idChoGGiPassInfo_botanist",
							"Padding", box(0, 0, 0, 0),
							"TextStyle", "PGChallengeDescription",
							"Translate", true,
						}),
						PlaceObj("XTemplateWindow", {
							"__class", "XText",
							"Id", "idChoGGiPassInfo_engineer",
							"Padding", box(0, 0, 0, 0),
							"TextStyle", "PGChallengeDescription",
							"Translate", true,
						}),
						PlaceObj("XTemplateWindow", {
							"__class", "XText",
							"Id", "idChoGGiPassInfo_geologist",
							"Padding", box(0, 0, 0, 0),
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
								return not UICity or UICity.launch_mode ~= "passenger_pod"
							end,
							"__class", "XText",
							"Padding", box(0, 0, 0, 0),
							"TextStyle", "PGLandingPosDetails",
							"Translate", true,
							"Text", T(3862, "Medic"),
						}),
						PlaceObj("XTemplateWindow", {
							"__condition", function()
								return not UICity or UICity.launch_mode ~= "passenger_pod"
							end,
							"__class", "XText",
							"Padding", box(0, 0, 0, 0),
							"TextStyle", "PGLandingPosDetails",
							"Translate", true,
							"Text", T(3850, "Scientist"),
						}),
						PlaceObj("XTemplateWindow", {
							"__condition", function()
								return not UICity or UICity.launch_mode ~= "passenger_pod"
							end,
							"__class", "XText",
							"Padding", box(0, 0, 0, 0),
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
							"Padding", box(0, 0, 0, 0),
							"TextStyle", "PGChallengeDescription",
							"Translate", true,
						}),
						PlaceObj("XTemplateWindow", {
							"__class", "XText",
							"Id", "idChoGGiPassInfo_scientist",
							"Padding", box(0, 0, 0, 0),
							"TextStyle", "PGChallengeDescription",
							"Translate", true,
						}),
						PlaceObj("XTemplateWindow", {
							"__class", "XText",
							"Id", "idChoGGiPassInfo_security",
							"Padding", box(0, 0, 0, 0),
							"TextStyle", "PGChallengeDescription",
							"Translate", true,
						}),

					}),
				}),
			}),
		}))
	end)
end

local function AddUIStuff(content)
	-- wait for it (thanks SkiRich)
	WaitMsg("OnRender")

	mod_PosPassList = mod.options.PosPassList
	mod_PosX = mod.options.PosX
	mod_PosY = mod.options.PosY
	if mod_PosPassList then
		content.idListsWrapper:SetMargins(box(
			mod_PosX,
			mod_PosY * -1,
			0, 0
		))
	end

	-- fatty boy
	content.idLeftScroll:SetMaxWidth(24)
	content.idLeftScroll:SetMinWidth(24)

	-- back button
	local orig_back = content.idToolBar.idback.OnPress
	content.idToolBar.idback.OnPress = function(...)
		local varargs = ...
		local function CallBackFunc(answer)
			if answer then
				orig_back(varargs)
			end
		end
		ChoGGi.ComFuncs.QuestionBox(
			Translate(5761--[[Are you sure you want to cancel the Rocket's launch order?--]]),
			CallBackFunc,
			Translate(3687--[[Cancel--]]) .. " " .. Translate(1116--[[Passenger Rocket--]])
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
	local orig_SetMode = dlg.SetMode
	function dlg:SetMode(mode, ...)
		orig_SetMode(self, mode, ...)
		if mode == "passengers" then
			local content = self.idTemplate.idPassengers

			-- first time pass list opens
			if IsValidThread(pass_thread) then
				DeleteThread(pass_thread)
			end
			pass_thread = CreateRealTimeThread(AddUIStuff, content)

			-- when we switch back from filter mode
			local orig_SetMode2 = content.SetMode
			function content:SetMode(mode, ...)
				orig_SetMode2(self, mode, ...)
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

local orig_OpenDialog = OpenDialog
function OpenDialog(dlg_str, ...)
	local dlg = orig_OpenDialog(dlg_str, ...)
	if dlg_str == "Resupply" then
		ResDlg(dlg)
	end
	return dlg
end
