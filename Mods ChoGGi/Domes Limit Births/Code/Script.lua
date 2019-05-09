-- See LICENSE for terms

local orig_CalcBirth = Dome.CalcBirth
function Dome:CalcBirth(...)
	local amount = #(self.labels.Child or "")
	local limit = self.ChoGGi_DomeLimitBirths

	-- make sure it exists, isn't zero, and amount isn't at limit
	if limit and limit > 0 and amount >= limit then
		return
	end
	return orig_CalcBirth(self,...)
end

local apply_to_all = false
local labels,current
function OnMsg.ClassesBuilt()
	-- add some prod info to selection panel
	local dome = XTemplates.sectionDome[1]
	-- check for and remove existing templates
	ChoGGi.ComFuncs.RemoveXTemplateSections(dome,"ChoGGi_Template_DomeLimitBirths")

	-- status updates/radius slider
	table.insert(
		dome,
		#dome,
		PlaceObj('XTemplateTemplate', {
			"ChoGGi_Template_DomeLimitBirths", true,
			"__template", "InfopanelSection",
			"Title", " ",
			"Icon", "UI/Icons/Sections/dome.tga",
			"RolloverTemplate", "Rollover",
			"RolloverTitle", [[Apply To All?]],
			"RolloverText", [[Apply value to this dome only.]],
		}, {
			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelSlider",
				"RolloverTemplate", "Rollover",
				"RolloverTitle", [[Limit Dome Births]],
				"RolloverText", [[Set birth limit.]],
				"BindTo", "ChoGGi_DomeLimitBirths",
				-- about the size of mega dome
				"Max", 500,
				"Min", 0,
				"StepSize", 1,
				"Scroll", 0,
				"OnContextUpdate", function(self, context)
					---
					-- slider won't do anything if this isn't a number
					context.ChoGGi_DomeLimitBirths = context.ChoGGi_DomeLimitBirths or 0

					-- make the slider scroll to current amount
					self.Scroll = context.ChoGGi_DomeLimitBirths

					-- turn off apply to all when the dome changes
					if current ~= context then
						apply_to_all = false
						current = context
					end

					local pp = self.parent.parent
					-- update title
					pp.idSectionTitle:SetText([[Limit Dome Births: ]] .. context.ChoGGi_DomeLimitBirths)

					-- update all domes
					if apply_to_all then
						local domes = labels.Dome or ""
						for i = 1, #domes do
							domes[i].ChoGGi_DomeLimitBirths = context.ChoGGi_DomeLimitBirths
						end
						pp:SetIcon("UI/Icons/Sections/Overpopulated.tga")
						pp:SetRolloverText([[Apply value to all domes!]])
					else
						pp:SetIcon("UI/Icons/Sections/dome.tga")
						pp:SetRolloverText([[Apply value to this dome only.]])
					end
					---
				end,
			}),
			PlaceObj("XTemplateFunc", {
				"name", "OnActivate(self, context)",
				"parent", function(self)
					return self.parent
				end,
				"func", function(self, context)
					---
					apply_to_all = not apply_to_all
					ObjModified(context)
					---
				end
			}),
		})
	)
end

local function StartupCode()
	labels = UICity.labels
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
