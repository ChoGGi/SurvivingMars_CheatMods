-- See LICENSE for terms

function OnMsg.ClassesPostprocess()
PlaceObj('AmbientLife', {
	group = "Visit",
	id = "VisitApartments",
	param1 = "unit",
	param2 = "bld",
	PlaceObj('XPrgDefineSlot', {
		'groups', "A",
		'spot_type', "Visitbed",
		'attach', "BaseBlinds",
		'goto_spot', "LeadToSpot",
		'flags_missing', 1,
	}),
	PlaceObj('XPrgDefineSlot', {
		'groups', "A",
		'spot_type', "Visitbed",
		'goto_spot', "LeadToSpot",
		'flags_missing', 1,
	}),
	PlaceObj('XPrgDefineSlot', {
		'groups', "A",
		'spot_type', "Visitlounge,Standidle",
		'goto_spot', "LeadToSpot",
		'flags_missing', 1,
		'usable_night', false,
	}),
	PlaceObj('XPrgDefineSlot', {
		'groups', "A",
		'spot_type', "Visitbench",
		'attach', "DecorInt_04",
		'goto_spot', "LeadToSpot",
		'flags_missing', 1,
		'usable_night', false,
	}),
	PlaceObj('XPrgDefineSlot', {
		'groups', "A",
		'spot_type', "Visittable",
		'attach', "BaseBlinds",
		'goto_spot', "LeadToSpot",
		'flags_missing', 1,
	}),
	PlaceObj('XPrgDefineSlot', {
		'groups', "A",
		'spot_type', "Petlay",
		'goto_spot', "Teleport",
		'move_end', "TeleportToExit",
		'flags_missing', 1,
		'usable_by_child', false,
		'pet_only', true,
	}),
	PlaceObj('XPrgDefineSlot', {
		'groups', "A",
		'spot_type', "Visittable",
		'goto_spot', "LeadToSpot",
		'flags_missing', 1,
	}),
	PlaceObj('XPrgDefineSlot', {
		'groups', "A",
		'spot_type', "Visitdesk",
		'attach', "BaseBlinds",
		'goto_spot', "LeadToSpot",
		'flags_missing', 1,
	}),
	PlaceObj('XPrgDefineSlot', {
		'groups', "A",
		'spot_type', "Visitdesk",
		'goto_spot', "LeadToSpot",
		'flags_missing', 1,
	}),
	PlaceObj('XPrgSelectSlot', {
		'unit', "unit",
		'bld', "bld",
		'group', "A",
		'var_obj', "obj",
		'var_spot', "spot",
		'var_slot_desc', "slot_desc",
		'var_slot', "slot",
		'var_slotname', "slotname",
	}),
	PlaceObj('XPrgCheckExpression', {
		'expression', "not spot",
	}, {
		PlaceObj('XPrgVisitSlot', {
			'unit', "unit",
			'bld', "bld",
			'group', "Holder",
		}),
		}),
	PlaceObj('XPrgCheckExpression', {
		'form', "else-if",
		'expression', 'IsKindOf(obj, "BaseBlinds")',
	}, {
		PlaceObj('XPrgCheckExpression', {
			'form', "A=",
			'var', "apartment",
			'expression', "obj",
		}),
		PlaceObj('XPrgCheckExpression', {
			'form', "A=",
			'var', "open_state",
			'expression', "apartment:GetOpenState()",
		}),
		PlaceObj('XPrgCheckExpression', {
			'expression', 'open_state == "Idle"',
		}, {
			PlaceObj('XPrgCheckExpression', {
				'expression', "bld:Random(100) < 50",
			}, {
				PlaceObj('XPrgCheckExpression', {
					'form', "A=",
					'var', "open_state",
					'expression', '"Open"',
				}),
				}),
			PlaceObj('XPrgCheckExpression', {
				'form', "else-if",
				'expression', "",
			}, {
				PlaceObj('XPrgCheckExpression', {
					'form', "A=",
					'var', "open_state",
					'expression', '"Open2"',
				}),
				}),
			}),
		PlaceObj('XPrgUseObject', {
			'obj', "apartment",
			'action', "",
			'action_var', "open_state",
			'dtor_action', "Close",
		}),
		PlaceObj('XPrgCheckExpression', {
			'expression', 'open_state == "Open"',
		}, {
			PlaceObj('XPrgVisitSelectedSlot', {
				'unit', "unit",
				'bld', "bld",
				'obj', "apartment",
				'spot', "spot",
				'slot_desc', "slot_desc",
				'slot', "slot",
				'slotname', "slotname",
			}),
			PlaceObj('XPrgLeadTo', {
				'loc', "Exit",
				'unit', "unit",
				'spot_obj', "apartment",
			}),
			}),
		PlaceObj('XPrgCheckExpression', {
			'form', "else-if",
			'expression', "",
		}, {
			PlaceObj('XPrgVisitSlot', {
				'unit', "unit",
				'bld', "bld",
				'group', "Holder",
			}),
			}),
		}),
	PlaceObj('XPrgCheckExpression', {
		'form', "else-if",
		'expression', "",
	}, {
		PlaceObj('XPrgVisitSelectedSlot', {
			'unit', "unit",
			'bld', "bld",
			'obj', "obj",
			'spot', "spot",
			'slot_desc', "slot_desc",
			'slot', "slot",
			'slotname', "slotname",
		}),
		PlaceObj('XPrgLeadTo', {
			'loc', "Exit",
			'unit', "unit",
			'spot_obj', "bld",
		}),
		}),
})
end

local _slots = {
	{
		attach = "BaseBlinds",
		flags_missing = 1,
		goto_spot = "LeadToSpot",
		groups = {
			["A"] = true,
		},
		spots = {
			"Visitbed",
		},
	},
	{
		flags_missing = 1,
		goto_spot = "LeadToSpot",
		groups = {
			["A"] = true,
		},
		spots = {
			"Visitbed",
		},
	},
	{
		flags_missing = 1,
		goto_spot = "LeadToSpot",
		groups = {
			["A"] = true,
		},
		spots = {
			"Visitlounge",
			"Standidle",
		},
		usable_night = false,
	},
	{
		attach = "DecorInt_04",
		flags_missing = 1,
		goto_spot = "LeadToSpot",
		groups = {
			["A"] = true,
		},
		spots = {
			"Visitbench",
		},
		usable_night = false,
	},
	{
		attach = "BaseBlinds",
		flags_missing = 1,
		goto_spot = "LeadToSpot",
		groups = {
			["A"] = true,
		},
		spots = {
			"Visittable",
		},
	},
	{
		flags_missing = 1,
		goto_spot = "Teleport",
		groups = {
			["A"] = true,
		},
		move_end = "TeleportToExit",
		pet_only = true,
		spots = {
			"Petlay",
		},
		usable_by_child = false,
	},
	{
		flags_missing = 1,
		goto_spot = "LeadToSpot",
		groups = {
			["A"] = true,
		},
		spots = {
			"Visittable",
		},
	},
	{
		attach = "BaseBlinds",
		flags_missing = 1,
		goto_spot = "LeadToSpot",
		groups = {
			["A"] = true,
		},
		spots = {
			"Visitdesk",
		},
	},
	{
		flags_missing = 1,
		goto_spot = "LeadToSpot",
		groups = {
			["A"] = true,
		},
		spots = {
			"Visitdesk",
		},
	},
}
PrgAmbientLife["VisitTubularHouse"] = function(unit, bld)
	local spot, obj, slot_desc, slot, slotname, apartment, open_state

	unit:PushDestructor(function()
		if IsValid(apartment) then
			apartment:Close()
		end
	end)

	spot, obj, slot_desc, slot, slotname = PrgGetObjRandomSpotFromGroup(bld, nil, "A", _slots, unit)
	if not spot then
		PrgVisitHolder(unit, bld)
		if unit.visit_restart then unit:PopAndCallDestructor() return end
	elseif IsKindOf(obj, "BaseBlinds") then
		apartment = obj
		open_state = apartment:GetOpenState()
		if open_state == "Idle" then
			if bld:Random(100) < 50 then
				open_state = "Open"
			else
				open_state = "Open2"
			end
		end
		apartment[open_state](apartment)
		if unit.visit_restart then unit:PopAndCallDestructor() return end
		if open_state == "Open" then
			PrgVisitSlot(unit, bld, apartment, spot, slot_desc, slot, slotname)
			if unit.visit_restart then unit:PopAndCallDestructor() return end
			PrgLeadToExit(unit, apartment)
			if unit.visit_restart then unit:PopAndCallDestructor() return end
		else
			PrgVisitHolder(unit, bld)
			if unit.visit_restart then unit:PopAndCallDestructor() return end
		end
	else
		PrgVisitSlot(unit, bld, obj, spot, slot_desc, slot, slotname)
		if unit.visit_restart then unit:PopAndCallDestructor() return end
		PrgLeadToExit(unit, bld)
		if unit.visit_restart then unit:PopAndCallDestructor() return end
	end

	unit:PopAndCallDestructor()
end
