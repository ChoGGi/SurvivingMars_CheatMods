function OnMsg.ClassesPostprocess()
	PlaceObj('AmbientLife', {
		group = "Work",
		id = "WorkSolaria",
		param1 = "unit",
		param2 = "bld",
		PlaceObj('XPrgDefineSlot', {
			'groups', "A",
			'spot_type', "Workvr",
			'goto_spot', "Pathfind",
			'flags_missing', 4,
			'usable_by_child', false,
		}),
		PlaceObj('XPrgDefineSlot', {
			'groups', "B",
			'spot_type', "Floor",
			'goto_spot', "LeadToSpot",
			'usable_by_child', false,
		}),
		PlaceObj('XPrgSelectSlot', {
			'unit', "unit",
			'bld', "bld",
			'group', "A",
			'var_spot', "spot",
			'var_slot_desc', "slotdata",
			'var_slot', "slot",
			'var_slotname', "slotname",
		}),
		PlaceObj('XPrgCheckExpression', {
			'expression', "spot",
		}, {
			PlaceObj('XPrgChangeSlotFlags', {
				'bld', "bld",
				'obj', "bld",
				'spot', "spot",
				'slotname', "slotname",
				'slot', "slot",
				'flags_add', 4,
				'dtor_flags_clear', 4,
			}),
			PlaceObj('XPrgVisitSlot', {
				'unit', "unit",
				'bld', "bld",
				'group', "Holder",
				'time', "0",
			}),
			PlaceObj('XPrgPlaceObject', {
				'obj', "unit",
				'spot_type', "Head",
				'attach', true,
				'orient_axis', "1",
				'classname', "VRHeadset",
			}),
			PlaceObj('XPrgSetMoveAnim', {
				'unit', "unit",
				'move_anim', "moveVR",
			}),
			PlaceObj('XPrgSelectSlot', {
				'unit', "unit",
				'bld', "bld",
				'group', "B",
				'var_spot', "fspot",
				'var_slot_desc', "fslotdata",
				'var_slot', "fslot",
				'var_slotname', "fslotname",
			}),
			PlaceObj('XPrgLeadTo', {
				'unit', "unit",
				'spot_obj', "bld",
				'spot', "fspot",
			}),
			PlaceObj('XPrgVisitSelectedSlot', {
				'unit', "unit",
				'bld', "bld",
				'obj', "bld",
				'spot', "spot",
				'slot_desc', "slotdata",
				'slot', "slot",
				'slotname', "slotname",
			}),
			PlaceObj('XPrgChangeSlotFlags', {
				'bld', "bld",
				'obj', "bld",
				'spot', "spot",
				'slotname', "slotname",
				'slot', "slot",
				'flags_clear', 4,
			}),
			PlaceObj('XPrgCheckExpression', {
				'comment', "disable flags destructor",
				'form', "A=",
				'var', "slotname",
				'expression', '""',
			}),
			PlaceObj('XPrgSelectSlot', {
				'unit', "unit",
				'bld', "bld",
				'group', "B",
				'var_spot', "fspot",
				'var_slot_desc', "fslotdata",
				'var_slot', "fslot",
				'var_slotname', "fslotname",
				'var_pos', "fpos",
			}),
			PlaceObj('XPrgGoto', {
				'unit', "unit",
				'pos', "fpos",
			}),
			}),
		PlaceObj('XPrgLeadTo', {
			'loc', "Exit",
			'unit', "unit",
			'spot_obj', "bld",
		}),
	})
end


local _slots = {
	{
		flags_missing = 4,
		goto_spot = "Pathfind",
		groups = {
			["A"] = true,
		},
		spots = {
			"Workvr",
		},
		usable_by_child = false,
	},
	{
		goto_spot = "LeadToSpot",
		groups = {
			["B"] = true,
		},
		spots = {
			"Floor",
		},
		usable_by_child = false,
	},
}
PrgAmbientLife["WorkSolaria"] = function(unit, bld)
	local spot, _obj, slotdata, slot, slotname, __placed, _unit_move, fspot, fslotdata, fslot, fslotname, fpos

	unit:PushDestructor(function(unit)
		PrgChangeSpotFlags(bld, bld, spot, 0, 4, slotname, slot)
		if IsValid(__placed) then
			DoneObject(__placed)
		end
		if _unit_move then
			unit:SetMoveAnim(_unit_move)
		end
	end)

	spot, _obj, slotdata, slot, slotname = PrgGetObjRandomSpotFromGroup(bld, nil, "A", _slots, unit)
	if spot then
		PrgChangeSpotFlags(bld, bld, spot, 4, 0, slotname, slot)
		PrgVisitHolder(unit, bld, bld, 0)
		if unit.visit_restart then unit:PopAndCallDestructor() return end
		__placed = PlaceObject("VRHeadset", nil, const.cfComponentEx + const.cfComponentAttach)
		NetTempObject(__placed)
		unit:Attach(__placed, unit:GetRandomSpot("Head"))
		_unit_move = _unit_move or unit:GetMoveAnim()
		unit:SetMoveAnim("moveVR")
		fspot, _obj, fslotdata, fslot, fslotname = PrgGetObjRandomSpotFromGroup(bld, nil, "B", _slots, unit)
		PrgLeadToSpot(unit, PrgResolvePathObj(bld), bld, fspot, false)
		if unit.visit_restart then unit:PopAndCallDestructor() return end
		PrgVisitSlot(unit, bld, bld, spot, slotdata, slot, slotname)
		if unit.visit_restart then unit:PopAndCallDestructor() return end
		PrgChangeSpotFlags(bld, bld, spot, 0, 4, slotname, slot)
		-- disable flags destructor
		slotname = ""
		fspot, _obj, fslotdata, fslot, fslotname = PrgGetObjRandomSpotFromGroup(bld, nil, "B", _slots, unit)
		fpos = fspot and _obj:GetSpotLocPos(fspot)
		unit:Goto(fpos)
	end
	PrgLeadToExit(unit, bld)
	if unit.visit_restart then unit:PopAndCallDestructor() return end

	unit:PopAndCallDestructor()
end

