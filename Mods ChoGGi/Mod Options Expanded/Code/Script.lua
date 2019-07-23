-- See LICENSE for terms

local function UpdateProp(xtemplate)
	local idx = table.find(xtemplate, "MaxWidth", 400)
	if idx then
		xtemplate[idx].MaxWidth = 1000000
	end

--~ 	if not table.find(xtemplate, "name", "OnSetRollover(self, rollover)") then
--~ 		xtemplate[#xtemplate+1] = PlaceObj('XTemplateFunc', {
--~ 			'name', "OnSetRollover(self, rollover)",
--~ 			'func', function (self, rollover, ...)
--~ 				local desc = self.context.prop_meta.desc
--~ 				if desc and desc ~= "" then
--~ 						if RolloverWin then
--~ 							XDestroyRolloverWindow()
--~ 						end
--~ 						XCreateRolloverWindow(self.idName, RolloverGamepad, true, {
--~ 							RolloverTitle = T(1000162, "Menu"),
--~ 							RolloverText = desc,
--~ 							RolloverHint = T(1000162, "Menu"),
--~ 						})
--~ 				end
--~ 				XPropControl.OnSetRollover(self, rollover, ...)
--~ 			end,
--~ 		})
--~ 	end

end

function OnMsg.ClassesPostprocess()
	local xtemplate = XTemplates.PropBool[1]
	if xtemplate.ChoGGi_ModOptionsExpanded then
		return
	end
	xtemplate.ChoGGi_ModOptionsExpanded = true


	UpdateProp(xtemplate)
	UpdateProp(XTemplates.PropChoiceOptions[1])
	UpdateProp(XTemplates.PropNumber[1])
--~ 	-- hmm
--~ 	UpdateProp(XTemplates.PropKeybinding[1])

end
