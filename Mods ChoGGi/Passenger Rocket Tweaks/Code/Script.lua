-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 62
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error","Passenger Rocket Tweaks requires ChoGGi's Library (at least v" .. min_version .. [[).
Press OK to download it or check the Mod Manager to make sure it's enabled.]]) == "ok" then
				if p.steam then
					OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
				elseif p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/505/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/89?tab=files")
				end
			end
		end)
	end
end

local table_clear = table.clear

local Strings
local Translate
-- generate is late enough that my library is loaded, but early enough to replace anything I need to
function OnMsg.ClassesGenerate()
	Strings = ChoGGi.Strings
	Translate = ChoGGi.ComFuncs.Translate
end

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
--~ 		if spec ~= "none" and not bld.destroyed and not bld.demolishing and not bld.bulldozed then
		if not bld.destroyed and not bld.demolishing and not bld.bulldozed then
			needed_specialist[spec] = needed_specialist[spec] + bld:GetFreeWorkSlots()
		end
	end

end

local filter_table = {}
local function GetMatchingColonistsCount(self,spec)
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

local function GetSpecInfo(self,win,label)
	local matching_win = win:ResolveId("idChoGGiPassInfo_" .. label)
	if matching_win then
		local count = GetMatchingColonistsCount(self,label)
		local all = all_specialist[label]
		local needed = needed_specialist[label]
		matching_win:SetText(T{0,"<c>/<n>/<a>",c = count,n = needed,a = all})
	end
end
function SetUIResupplyParams(self,win)
	GetSpecInfo(self,win,"none")
	local ColonistSpecializationList = ColonistSpecializationList
	for i = 1, #ColonistSpecializationList do
		GetSpecInfo(self,win,ColonistSpecializationList[i])
	end
end

-- add extra info to select colonists
function OnMsg.ClassesBuilt()
	-- I'm lazy, sue me
	pcall(function()

		local pass = XTemplates.ResupplyPassengers[1]
		local template = pass[table.find(pass,"Id","idContent")]
		template = template[table.find(template,"Id","idTop")]
		ChoGGi.ComFuncs.RemoveXTemplateSections(template,"Id","idPassInfo_ChoGGi")

		table.insert(template,3,PlaceObj("XTemplateWindow", {
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
					SetUIResupplyParams(context,self)
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
						PlaceObj("XTemplateWindow", {
							"__condition", function(parent, context)
								return not UICity or UICity.launch_mode ~= "passenger_pod"
							end,
							"__class", "XText",
							"Padding", box(0, 0, 0, 0),
							"TextStyle", "PGLandingPosDetails",
							"Translate", true,
							"Text", T(3848, "No specialization"),
						}),
						PlaceObj("XTemplateWindow", {
							"__condition", function(parent, context)
								return not UICity or UICity.launch_mode ~= "passenger_pod"
							end,
							"__class", "XText",
							"Padding", box(0, 0, 0, 0),
							"TextStyle", "PGLandingPosDetails",
							"Translate", true,
							"Text", T(3850, "Scientist"),
						}),
						PlaceObj("XTemplateWindow", {
							"__condition", function(parent, context)
								return not UICity or UICity.launch_mode ~= "passenger_pod"
							end,
							"__class", "XText",
							"Padding", box(0, 0, 0, 0),
							"TextStyle", "PGLandingPosDetails",
							"Translate", true,
							"Text", T(3853, "Engineer"),
						}),
						PlaceObj("XTemplateWindow", {
							"__condition", function(parent, context)
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
							"Id", "idChoGGiPassInfo_none",
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
							"Id", "idChoGGiPassInfo_engineer",
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
							"__condition", function(parent, context)
								return not UICity or UICity.launch_mode ~= "passenger_pod"
							end,
							"__class", "XText",
							"Padding", box(0, 0, 0, 0),
							"TextStyle", "PGLandingPosDetails",
							"Translate", true,
							"Text", T(3859, "Geologist"),
						}),
						PlaceObj("XTemplateWindow", {
							"__condition", function(parent, context)
								return not UICity or UICity.launch_mode ~= "passenger_pod"
							end,
							"__class", "XText",
							"Padding", box(0, 0, 0, 0),
							"TextStyle", "PGLandingPosDetails",
							"Translate", true,
							"Text", T(3865, "Botanist"),
						}),
						PlaceObj("XTemplateWindow", {
							"__condition", function(parent, context)
								return not UICity or UICity.launch_mode ~= "passenger_pod"
							end,
							"__class", "XText",
							"Padding", box(0, 0, 0, 0),
							"TextStyle", "PGLandingPosDetails",
							"Translate", true,
							"Text", T(3862, "Medic"),
						}),
					}),

					PlaceObj("XTemplateWindow", {
						"LayoutMethod", "VList",
					}, {
						PlaceObj("XTemplateWindow", {
							"__class", "XText",
							"Id", "idChoGGiPassInfo_geologist",
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
							"Id", "idChoGGiPassInfo_medic",
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

local orig_OpenDialog = OpenDialog
function OpenDialog(dlg_str,...)
	local dlg = orig_OpenDialog(dlg_str,...)
	if dlg_str == "Resupply" then
		-- build list once per open (total count and needed count)
		BuildSpecialistLists()

		-- replace old func with our piggyback
		local orig_SetMode = dlg.SetMode
		function dlg:SetMode(mode,...)
			orig_SetMode(self,mode,...)
			if mode == "passengers" then
				local content = self.idTemplate.idPassengers

				-- first time pass list opens
				if IsValidThread(pass_thread) then
					DeleteThread(pass_thread)
				end
				pass_thread = CreateRealTimeThread(AddUIStuff,content)

				-- when we switch back from filter mode
				local orig_SetMode2 = content.SetMode
				function content:SetMode(mode,...)
					orig_SetMode2(self,mode,...)
					if mode == "review" then
						if IsValidThread(pass_thread) then
							DeleteThread(pass_thread)
						end
						pass_thread = CreateRealTimeThread(AddUIStuff,content)
					end
				end

			end
		end
	end

	return dlg
end
