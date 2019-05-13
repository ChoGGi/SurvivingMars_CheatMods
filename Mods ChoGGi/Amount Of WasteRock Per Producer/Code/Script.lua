-- See LICENSE for terms

local orig_CalcWasteRockAmount = CalcWasteRockAmount
function CalcWasteRockAmount(...)
	return orig_CalcWasteRockAmount(...) / 2
end
