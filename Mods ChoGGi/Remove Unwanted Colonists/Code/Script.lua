-- See LICENSE for terms

local IsValid = IsValid

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

	-- get the fuck outta here
	if IsValid(g_IdiotMonument) then
		self:SetCommand("Goto", g_IdiotMonument:GetPos())
		CreateGameTimeThread(Colonist.ChoGGi_MP_WaitForIt, self)
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

function OnMsg.ClassesPostprocess()
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
			"__template", "InfopanelActiveSection",
			"Icon", "UI/Icons/traits_disapprove.tga",
			"Title", [[Remove Colonist]],
			"RolloverTitle", [[Remove Colonist]],
			"RolloverText", [[Thumbs down means colonist will get sucked up and deported to Earth.]],
			"RolloverHint", T(0, [[<left_click> Toggle]]),
			"OnContextUpdate", function(self, context)
				---
				if context.ChoGGi_MurderPod then
					self:SetIcon("UI/Icons/traits_approve.tga")
				else
					self:SetIcon("UI/Icons/traits_disapprove.tga")
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
			"__condition", function (_, context)
				return IsValid(context.target)
			end,
			"Icon", "UI/Icons/Sections/colonist.tga",
			"Title", [[Select Colonist]],
			"RolloverTitle", [[Select Colonist]],
			"RolloverText", [[Selects the colonist.]],
			"RolloverHint", T(0, [[<left_click> Select]]),
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

	-- add a button to select victim to selection panel of murder pod

end