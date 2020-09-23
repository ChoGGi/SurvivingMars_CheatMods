-- See LICENSE for terms

-- build list of traits/mod options
local mod_options = {}
local traits_list = {}
local c = 0
local Random = ChoGGi.ComFuncs.Random
local RetName = ChoGGi.ComFuncs.RetName
local Sleep = Sleep

local function AddColonists(list)
	for i = 1, #list do
		c = c + 1
		local id = list[i]
		traits_list[c] = id
		mod_options[id] = false
	end
end
local t = ChoGGi.Tables
AddColonists(t.ColonistAges)
AddColonists(t.NegativeTraits)
AddColonists(t.PositiveTraits)
AddColonists(t.OtherTraits)

-- call down the wrath of Zeus for miscreants
local IsValid = IsValid
local function UpdateMurderPods()
	local objs = UICity.labels.Colonist or ""
	for i = 1, c do
		local obj = objs[i]
		-- If colonist already has a pod after it then skip
		if obj and not IsValid(obj.ChoGGi_MurderPod) then
			-- quicker to check age instead of looping all traits, so ageism rules
			if mod_options[obj.age_trait] then
				obj:ChoGGi_MP_LaunchPod()
			else
				-- loop through colonist traits for bad ones
				for id in pairs(obj.traits) do
					-- we found it, so stop checking rest of traits and on to next victim
					if mod_options[id] then
						obj:ChoGGi_MP_LaunchPod()
						break
					end
				end
			end
		end
	end
end

local options

-- fired when settings are changed/init
local function ModOptions()
	options = CurrentModOptions

	for i = 1, c do
		local id = traits_list[i]
		mod_options[id] = options:GetProperty("Trait_" .. id)
	end

	-- make sure we're ingame
	if not UICity then
		return
	end

	UpdateMurderPods()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions


-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

OnMsg.NewHour = UpdateMurderPods

function Colonist:ChoGGi_MP_RemovePod()
	if IsValid(self.ChoGGi_MurderPod) then
		self.ChoGGi_MurderPod:SetCommand("Leave")
		self.ChoGGi_MurderPod = nil
	end
end

function Colonist:ChoGGi_MP_WaitForIt()
	while self.command == "Goto" do
		Sleep(500)
	end
	Sleep(10000)
	if IsValid(self) and IsValid(self.ChoGGi_MurderPod) then
		self:SetCommand("Goto", g_IdiotMonument:GetPos())
		self:ChoGGi_MP_WaitForIt()
	end
end

function Colonist:ChoGGi_MP_LaunchPod()
	-- launch a pod and set to stalk hunt colonist
	local pod = MurderPod:new()
	pod.target = self
	pod.panel_icon = "<image " .. self.infopanel_icon .. " 2500>"
	pod:SetCommand("Spawn")
	-- used to update selection panel and to remove pod if needed
	self.ChoGGi_MurderPod = pod

	-- get outta here
	if IsValid(g_IdiotMonument) then
		CreateGameTimeThread(function()
			Sleep(Random(1000, 15000))
			self:SetCommand("Goto", g_IdiotMonument:GetPos())
			self:ChoGGi_MP_WaitForIt()
		end)
	else
		CreateGameTimeThread(function()
			while IsValid(self) and IsValid(self.ChoGGi_MurderPod) do
				Sleep(1000)
				if IsValid(g_IdiotMonument) then
					self:ChoGGi_MP_WaitForIt()
				end
			end
		end)

	end
end

GlobalVar("g_IdiotMonument", false)

DefineClass.IdiotMonument = {
	__parents = {
		"Building",
	},
	entity = "IceSet_05",
}

function IdiotMonument:GameInit()
	-- If there's already one replace with new one
	if IsValid(g_IdiotMonument) then
		g_IdiotMonument:OnDemolish()
	end
	g_IdiotMonument = self

	self:SetScale(250)
	self:SetPos(self:GetPos():AddZ(5000), 10000)
end

function IdiotMonument:OnDemolish()
	g_IdiotMonument = false

	CreateGameTimeThread(function()
		PlayFX("ElectrostaticStormArea", "start", self)
		self.fx_actor_class = "Crystal"
		PlayFX("CrystalCompose", "attach1", self)
		Sleep(2500)
		for i = 100, 1, -1 do
			self:SetOpacity(i)
			Sleep(25)
		end
		DoneObject(self)
	end)
end

function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.IdiotMonument then
		PlaceObj("BuildingTemplate", {
			"Id", "IdiotMonument",
			"template_class", "IdiotMonument",
			"construction_cost_Concrete", 1000,
			"display_name", T(302535920011239, "Idiot Monument"),
			"display_name_pl", T(302535920011240, "Idiot Monuments"),
			"description", T(302535920011241, "Here kitty kitty kitty"),
			"display_icon", CurrentModPath .. "UI/IdiotMonument.png",
			"build_category", "ChoGGi",
			"Group", "ChoGGi",
			"dome_forbidden", true,
			"encyclopedia_exclude", true,
			"on_off_button", false,
		})
	end

	local xt = XTemplates
	local template = xt.ipColonist[1]

	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(template, "ChoGGi_Template_ColonistSucker", true)

	-- we want to insert above warning
	local warning = table.find(template, "__template", "sectionWarning")
	if warning then
		warning = warning
	else
		-- screw it stick it at the end
		warning = #template
	end

	table.insert(
		template,
		warning,
		PlaceObj('XTemplateTemplate', {
			"ChoGGi_Template_ColonistSucker", true,
			"Id", "ChoGGi_ColonistSucker",
			"__template", "InfopanelActiveSection",
			"Icon", "UI/Icons/traits_disapprove.tga",
			"Title", T(302535920011244, "Remove Colonist"),
			"RolloverTitle", T(302535920011244, "Remove Colonist"),
			"RolloverText", T(302535920011245, "Thumbs down means colonist will get sucked up and deported to Earth."),
			"RolloverHint", T(302535920011246, "<left_click> Toggle"),
			"OnContextUpdate", function(self, context)
				---
				if context.ChoGGi_MurderPod then
					self:SetIcon("UI/Icons/traits_disapprove.tga")
					self:SetTitle(T(302535920011596, "Removing Colonist!"))
					self:SetRolloverTitle(T(302535920011596, "Removing Colonist!"))
				else
					self:SetIcon("UI/Icons/traits_approve.tga")
					self:SetTitle(T(302535920011244, "Remove Colonist"))
					self:SetRolloverTitle(T(302535920011244, "Remove Colonist"))
				end
				---
			end,
		}, {
			PlaceObj("XTemplateFunc", {
				"name", "OnActivate(self, context)",
				"parent", function(self)
					return self.parent
				end,
				"func", function(self, context)
					---
					if context.ChoGGi_MurderPod then
						-- tell pod to piss off
						context:ChoGGi_MP_RemovePod()
					else
						-- send down a pod
						context:ChoGGi_MP_LaunchPod()
					end
					ObjModified(context)
					---
				end,
			}),
		})
	)

	template = xt.ipShuttle[1]
	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(template, "ChoGGi_Template_ColonistSucker", true)

	-- we want to insert above warning
	warning = table.find(template, "__template", "sectionCheats")
	if warning then
		warning = warning - 1
	else
		-- screw it stick it at the end
		warning = #template
	end

	table.insert(
		template,
		warning,
		PlaceObj('XTemplateTemplate', {
			"ChoGGi_Template_ColonistSucker", true,
			"__template", "InfopanelActiveSection",
			"__context_of_kind", "MurderPod",
			"__condition", function(_, context)
				return IsValid(context.target)
			end,
			"Icon", "UI/Icons/Sections/colonist.tga",
			"Title", T(302535920011247, "Select Colonist"),
			"RolloverTitle", T(302535920011247, "Select Colonist"),
			"RolloverText", T{302535920011248, "Select <name>.",
				name = function(self)
					return RetName(self[1].target)
			end},
			"RolloverHint", T(302535920011249, "<left_click> Select"),
		}, {
			PlaceObj("XTemplateFunc", {
				"name", "OnActivate(self, context)",
				"parent", function(self)
					return self.parent
				end,
				"func", function(_, context)
					---
					ViewAndSelectObject(context.target)
					---
				end,
			}),
		})
	)

end

--~ GlobalVar("g_ChoGGi_RemoveUnwantedColonists_StuckPassageFix", false)
--~ GlobalVar("g_ChoGGi_RemoveUnwantedColonists_StuckAirColonist", false)

--~ -- remove any invalid colonists from passages (fix for mod < v0.5)
--~ function OnMsg.LoadGame()
--~ 	-- so it only loops once per game
--~ 	if not g_ChoGGi_RemoveUnwantedColonists_StuckPassageFix then
--~ 		local remove = table.remove

--~ 		local objs = UICity.labels.Passage or ""
--~ 		for i = 1, #objs do
--~ 			local traversing = objs[i].traversing_colonists or ""
--~ 			for j = #traversing, 1, -1 do
--~ 				if not IsValid(traversing[j]) then
--~ 					remove(traversing, j)
--~ 				end
--~ 			end
--~ 		end

--~ 		g_ChoGGi_RemoveUnwantedColonists_StuckPassageFix = true

--~ 	end

--~ 	if not g_ChoGGi_RemoveUnwantedColonists_StuckAirColonist then
--~ 		local objs = UICity.labels.Colonist or ""
--~ 		for i = 1, #objs do
--~ 			local obj = objs[i]
--~ 			if obj.ChoGGi_MurderPod and not IsValid(obj.ChoGGi_MurderPod) then
--~ 				obj:Erase()
--~ 			end
--~ 		end
--~ 		g_ChoGGi_RemoveUnwantedColonists_StuckAirColonist = true
--~ 	end

--~ end
