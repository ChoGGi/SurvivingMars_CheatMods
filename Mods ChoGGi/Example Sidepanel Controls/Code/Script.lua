-- See LICENSE for terms

-- remove (maybe) existing xtemplate entry (xtemplates are only built on New Game, and when new dlc is added?)
local function RemoveXTemplateSections(list, name)
	local idx = table.find(list, name, true)
	if idx then
		list[idx]:delete()
		table.remove(list, idx)
	end
end

function OnMsg.ClassesPostprocess()

	local template = XTemplates.sectionWorkplace
	RemoveXTemplateSections(template, "SOMETHINGUNIQUE1")

	-- this adds a button to all workplaces that changes depending on Object.working (a building that works...)
	template[#template+1] = PlaceObj("XTemplateTemplate", {
		-- we use this to check for our added template crap
		"SOMETHINGUNIQUE1", true,

		-- use OpenExamine(XTemplates) to see the complete list (and check that yours was added).
		-- and https://github.com/HaemimontGames/SurvivingMars/tree/master/Lua/XTemplates

		-- added to the workplace panel, for more see OpenExamine(somebuilding) > click the class at the top till you get to metatable Building > then either __ancestors or __parents
		"__context_of_kind", "Workplace", --change this to say SecurityStation to only show up for them, but you can just use OnContextUpdate to hide it
		-- see Source\Lua\XTemplates\Infopanel*.lua for more examples
		"__template", "InfopanelActiveSection",

		-- you can set these here or in OnContextUpdate below
--~ 		"Icon", "",
--~ 		"Title", "",
--~ 		"RolloverText", "",

		-- certain things don't have a rollover template, so use this if the rollover isn't showing up
--~ 		"RolloverTemplate", "Rollover",

		"RolloverTitle", "Hello, this needs to have something here for the hint to showup",
		"RolloverHint", "",
		-- defaults to false, have it fire OnContextUpdate when selection panel appears instead of after 1 sec
--~ 		"ContextUpdateOnOpen", true,
		"OnContextUpdate", function(self, context)
			-- context is the object selected
			if context.working then
				self:SetRolloverText("This building is working.")
				self:SetTitle("Working")
				self:SetIcon("UI/Icons/Upgrades/factory_ai_01.tga")
			else
				self:SetRolloverText("This building isn't working.")
				self:SetTitle("Not Working")
				self:SetIcon("UI/Icons/Upgrades/factory_ai_03.tga")
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
				if context.working then
					-- do something on a working building
				else
					-- and a not working building
				end

				-- If you modified a value then use this, if not remove
				ObjModified(context)
				RebuildInfopanel(context)
				---
			end
		}),
	})

	RemoveXTemplateSections(template, "SOMETHINGUNIQUE2")
	-- slider added to all workplaces to adjust number of workers allowed
	template[#template+1] = PlaceObj("XTemplateTemplate", {
		"SOMETHINGUNIQUE2", true,

		"__context_of_kind", "Workplace",
		"__template", "InfopanelSection",

		-- only show up for buildings that need maintenance
		"__condition", function (_, context)
			return context:IsKindOf("RequiresMaintenance") and context:DoesRequireMaintenance()
		end,

		"RolloverText", "Look ma it slides!",
		"RolloverHint", "",
		"RolloverHintGamepad", "",
		"RolloverTitle", " ",
		-- updated below, can't be blank
		"Title", " ",
		"Icon", "UI/Icons/Sections/facility.tga",
	}, {
		PlaceObj("XTemplateTemplate", {
			"__template", "InfopanelSlider",
			"BindTo", "max_workers",
			-- If it's a resource unit then add 1000, so 25000
			"Max", 25,
			"Min", 5,
			"StepSize", 5,
--~ PageSize: 1
--~ StepSize: 1
--~ FullPageAtEnd: false
--~ SnapToItems: false
--~ AutoHide: false
--~ Horizontal: false
			"OnContextUpdate", function(self, context)
				-- make the slider scroll to current amount
				self.Scroll = context.max_workers
				self.parent.parent:SetTitle([[Change "max_workers" limit: ]] .. context.max_workers)
			end,
		}),
	})

	template = XTemplates.ipBuilding[1]

	RemoveXTemplateSections(template, "SOMETHINGUNIQUE")
	-- two sliders, one header, or just remove Title to not have one at all
	template[#template+1] = PlaceObj("XTemplateTemplate", {
		"SOMETHINGUNIQUE", true,

		"__context_of_kind", "Workplace",
		"__template", "InfopanelActiveSection",

		-- only show up for buildings that require main
		"__condition", function (_, context)
			return context:IsKindOf("RequiresMaintenance") and context:DoesRequireMaintenance()
		end,

		"RolloverText", "Look ma it slides!",
		"RolloverHintGamepad", "",
		"RolloverTitle", " ",
		-- updated below, can't be blank as it isn't updated auto
		"Title", " ",
		"Icon", "UI/Icons/Sections/facility.tga",
	}, {
		PlaceObj("XTemplateTemplate", {
			"__template", "InfopanelSlider",
			"BindTo", "max_workers",
			"Max", 25,
			"min", 5,
			-- change 5 per movement
			"StepSize", 5,
--~ 			"OnContextUpdate", function(self, context)
--~ 			self.parent.parent:SetTitle([[Change "max_workers" limit: ]] .. context.max_workers)
--~ 			end
		}),
		PlaceObj("XTemplateTemplate", {
			"__template", "InfopanelSlider",
			"BindTo", "max_workers",
			-- change 5 per movement
			"StepSize", 5,
			"OnContextUpdate", function(self, context)
				self.parent.parent:SetTitle([[Change "max_workers" limit: ]] .. context.max_workers)
			end
		}),
	})

	template = XTemplates.sectionWorkplace[1]

	RemoveXTemplateSections(XTemplates, "SOMETHINGUNIQUE3")
	-- this adds a button to the resource overview that only shows when hour is over 10
	-- It needs the [1] or it takes over the whole screen (it's usually only needed for ipResourceOverview not the section ones)
	XTemplates[#XTemplates+1] = PlaceObj("XTemplateTemplate", {
		"SOMETHINGUNIQUE3", true,

		-- added to the resource overview panel
		"__context_of_kind", "ResourceOverview",
		"__template", "InfopanelActiveSection",

		-- you can set these here or in OnContextUpdate below
		"Icon", "UI/Icons/Upgrades/factory_ai_03.tga",
		"Title", "hour over 10",
		"RolloverText", "only shows when hour is 10 or over",
		"RolloverTitle", " ",
		"RolloverHint",	"",
--~ 	(self, context)
		"OnContextUpdate", function(self)
			if UIColony.hour >= 10 then
				self:SetVisible(true)
				self:SetMaxHeight()
			else
				self:SetVisible(false)
				self:SetMaxHeight(0)
			end
		end,
	})

	RemoveXTemplateSections(template, "SOMETHINGUNIQUE4")
	-- add an actual button (at the top of the panel)
	template[#template+1] = PlaceObj("XTemplateTemplate", {
		"SOMETHINGUNIQUE4", true,

		"__template", "InfopanelButton",
		"Icon", "UI/Icons/Sections/Metals_2.tga",
		"Title", "5 Times the amount",
		"RolloverText", "Clicking this once will add 5 times the amount of stored resources.",
		"RolloverTitle", "",
		"RolloverHint",	"",
--~ 		(self, context)
		"OnPress", function()
			---
			local objs = UIColony:GetCityLabels("SubsurfaceDeposit")
			for i = 1, #objs do
				objs[i].max_amount = objs[i].max_amount * 5
				objs[i]:CheatRefill()
			end
			---
		end,
		-- add a right-click or button y action
		"AltPress", true,
		"OnAltPress", function (self, gamepad)
			if gamepad then
				self.context:Rotate(gamepad)
			else
				self.context:Rotate(not IsMassUIModifierPressed())
			end
			ObjModified(self.context)
		end,
	})

end
