
local Msg,pairs = Msg,pairs
local empty_table = empty_table
local TableRemove = table.remove

function OnMsg.LoadGame()
	local missles = g_IncomingMissiles or empty_table
	for missle,_ in pairs(missles) do
		missle:ExplodeInAir()
	end

	if g_DustStorm then
		StopDustStorm()
		-- stop doesn't always seem to work, so adding this as well
		g_DustStormType = false
	end

	if g_ColdWave then
		StopColdWave()
		g_ColdWave = false
	end

	local objs = g_DustDevils or ""
	for i = #objs, 1, -1 do
		objs[i]:delete()
	end

	objs = g_MeteorsPredicted or ""
	for i = #objs, 1, -1 do
		Msg("MeteorIntercepted", objs[i])
		objs[i]:ExplodeInAir()
	end

	objs = g_IonStorms or ""
	for i = #objs, 1, -1 do
		objs[i]:delete()
		TableRemove(g_IonStorms,i)
	end
end
