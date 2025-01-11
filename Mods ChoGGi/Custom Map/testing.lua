local orig = RandomMapGenerator.OnGenerateLogic
function RandomMapGenerator:OnGenerateLogic(env)
	if self["StyleFamily"] == "Underground" then
		ex(env)
	end
	return orig(self, env)
end



g_ProfileStats = rawget(_G, "g_ProfileStats") or {}
g_Sections = rawget(_G, "g_Sections") or 1
local statsInterval = 3000
function __SectionStart(s)
  if s then
  end
	PerformanceMarker(g_Sections)
	g_Sections = g_Sections + 1
end
function __SectionEnd(s)
	g_Sections = g_Sections - 1
	local time = GetPerformanceMarkerElapsedTime(g_Sections)
	local t = g_ProfileStats[s] or {}
	local now = GameTime()
	for gt in pairs(t) do
		if now - gt > statsInterval then
			t[gt] = nil
		end
	end
	t[now] = (t[now] or 0) + time
	g_ProfileStats[s] = t
end

function __SectionStats(s)
	local total = 0
	local t = g_ProfileStats[s] or {}
	local now = GameTime()
	local samples = 0
	for gt, time in pairs(t) do
		if now - gt > statsInterval then
			t[gt] = nil
		end
		total = total + time
		samples = samples + 1
	end
	return total, samples
end

local thread
function __PrintStats(s)
	if not s then
		DeleteThread(thread)
		return
	end

	if thread then
		DeleteThread(thread)
	end
	thread = CreateRealTimeThread(function()
		while true do
			local total, samples = __SectionStats(s)
			printf("time: %d / %d", total, samples)
			Sleep(500)
		end
	end)
end



do return end
table.clear(g_ProfileStats)


CreateRealTimeThread(function()
	__SectionStart("temp1")
	Sleep(1000)
	__SectionEnd("temp1")
end)

CreateRealTimeThread(function()
	__SectionStart("temp2")
	Sleep(1000)
	__SectionEnd("temp2")
end)

CreateRealTimeThread(function()
	__SectionStart("temp3")
	Sleep(1000)
	__SectionEnd("temp3")
end)
