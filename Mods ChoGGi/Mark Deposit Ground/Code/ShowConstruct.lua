
local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding:GameInit()
	local mdg = MarkDepositGround

	if mdg.ShowConstruct and mdg.HideSigns then
		mdg.UpdateOpacity("SubsurfaceDeposit",false)
		mdg.UpdateOpacity("EffectDeposit",false)
		mdg.UpdateOpacity("TerrainDeposit",false)
	end

	return orig_CursorBuilding_GameInit(self)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding:Done()
	local mdg = MarkDepositGround

	if mdg.ShowConstruct and mdg.HideSigns then
		mdg.UpdateOpacity("SubsurfaceDeposit",true)
		mdg.UpdateOpacity("EffectDeposit",true)
		mdg.UpdateOpacity("TerrainDeposit",true)
	end

	return orig_CursorBuilding_Done(self)
end
