-- See LICENSE for terms

local next = next
local table = table
local T = T
local _InternalTranslate = _InternalTranslate
local CmpLower = CmpLower

local function SortName(a, b)
	return CmpLower(_InternalTranslate(a[1]), _InternalTranslate(b[1]))
end

-- no sense in creating a table each time
local approve = {}
local disapprove = {}
local ac = 0
local dc = 0
local a = T("<image UI/Icons/traits_approve.tga>")
local d = T("\n\n<image UI/Icons/traits_disapprove.tga>")

function Dome:ChoGGi_GetDomeTraitsRollover()
	if not next(self.traits_filter) then
		return ""
	end

	table.iclear(approve)
	table.iclear(disapprove)
	ac = 1
	dc = 1
	approve[1] = a
	disapprove[1] = d

	local TraitPresets = TraitPresets
	for id, filter in pairs(self.traits_filter) do
		if filter then
			ac = ac + 1
			approve[ac] = T(TraitPresets[id].display_name)
		else
			dc = dc + 1
			disapprove[dc] = T(TraitPresets[id].display_name)
		end
	end

	table.sort(approve, SortName)
	table.sort(disapprove, SortName)

	return table.concat{
		T("\n\n"),
		table.concat(approve, ", "),
		table.concat(disapprove, ", "),
	}
end

function OnMsg.ClassesPostprocess()
	local xtemplate = XTemplates.sectionDome[1]
	if xtemplate.ChoGGi_GetDomeTraitsRollover then
		return
	end
	xtemplate.ChoGGi_GetDomeTraitsRollover = true

	local idx = table.find(xtemplate, "Icon", "UI/Icons/IPButtons/colonists_accept.tga")
	if not idx then
		return
	end

	xtemplate[idx].RolloverText = xtemplate[idx].RolloverText
		.. T("<ChoGGi_GetDomeTraitsRollover>")
end
