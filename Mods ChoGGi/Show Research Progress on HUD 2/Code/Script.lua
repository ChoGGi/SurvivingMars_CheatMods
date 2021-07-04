-- See LICENSE for terms

local mod_QueueCount
local mod_HideWhenEmpty

-- declared here, so we can use the func declared after ModOptions is declared
local UpdateResearchProgressBar

-- fired when settings are changed/init
local function ModOptions()
	mod_QueueCount = CurrentModOptions:GetProperty("QueueCount")
	mod_HideWhenEmpty = CurrentModOptions:GetProperty("HideWhenEmpty")

	if not UICity then
		return
	end
	UpdateResearchProgressBar()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

-- local some globals
local T = T
local box = box
local MulDivRound = MulDivRound
local FormatDuration = FormatDuration
local GetDialog = GetDialog
local XUpdateRolloverWindow = XUpdateRolloverWindow
local table = table

local const_HoursPerDay = const.HoursPerDay

-- Randomly generated number to start counting from, to generate IDs for translatable strings
-- local StringIdBase = 76827246

-- ref to
local dlg_frame

local function AddResearchProgressBar2(queue_count, dlg)
	if not dlg then
		dlg = GetDialog("HUD")
	end
	if not dlg then
		return
	end

--~ 	local sol_frame = dlg.idSolDisplay
	local sol_frame = dlg.idPause.parent.parent

	if sol_frame.idResearchProgressContainer then
		-- The progress bar is already there, so this must have been called more than once. This
		-- might be a request to rebuild it, so remove the existing one and start again
		sol_frame.idResearchProgressContainer:delete()
	end

	sol_frame.idResearchProgressContainer = XWindow:new({
		Id = "idResearchProgressContainer",
		Margins = box(0, 0, 0, 0),
		Dock = "top",
		Background = 0,
		LayoutMethod = "HList",
		FoldWhenHidden = true,
	}, sol_frame)

	dlg_frame = sol_frame.idResearchProgressContainer

	local UICity = UICity
	local TechDef = TechDef
	local queue_table = {}
	local research_queue = UICity.research_queue

	dlg_frame.idResearchProgress = XFrameProgress:new({
		Id = "idResearchProgress",
		Image = "UI/HUD/day_pad.tga",
		FrameBox = box(5, 0, 5, 0),
		HAlign = "center",
		VAlign = "center",
		HandleMouse = true,
		RolloverTemplate = "Rollover",
		ProgressImage = CurrentModPath .. "UI/progress_bar.png",
		MinWidth = 146,
		MaxWidth = 146,
		MinHeight = 20,
		MaxProgress = 100,
		SeparatorImage = "UI/HUD/day_shine.tga",
		SeparatorOffset = 4,

		RolloverTitle = T(311, "Research"),
		RolloverHint = T(4005, "<em><ShortcutName('actionResearchScreen')></em> - open Research Screen"),
		RolloverText = T{1301376827256, [[Current Research: <em><name></em>
Research Progress: <em><percent(progress)> (<done> / <ResearchPoints(total)>)</em>
Approximate Time Remaining: <em><eta></em>

Queue: <em><queue></em>]],
			name = function()
				-- GetCheapestTech is what gets researched when nothing in queue
				local current_research = UICity:GetResearchInfo() or UICity:GetCheapestTech()
				if not current_research then
					return T(6761, "None")
				end
				return TechDef[current_research].display_name
			end,
			progress = function()
				return UICity:GetResearchProgress(research_queue[1] or UICity:GetCheapestTech())
			end,
			done = function()
				local tech_id, points, _ = UICity:GetResearchInfo(research_queue[1] or UICity:GetCheapestTech())
				return tech_id and points or 0
			end,
			total = function()
				local tech_id, _, max_points = UICity:GetResearchInfo(research_queue[1] or UICity:GetCheapestTech())
				return tech_id and max_points or 0
			end,
			eta = function()
				local tech_id, points, max_points = UICity:GetResearchInfo(research_queue[1] or UICity:GetCheapestTech())
				local rate = UICity:GetEstimatedRP()
				if tech_id and rate > 0 then
					local eta = MulDivRound(const_HoursPerDay, (max_points - points), rate)
					return FormatDuration(eta)
				else
					return T(130, "N/A")
				end
			end,
			queue = function()
				local queue_c = #research_queue
				if queue_c < 1 then
					return T(6761, "None")
				end

				table.iclear(queue_table)
				local c = 0
				for i = 2, queue_c do
					c = c + 1
					queue_table[c] = TechDef[research_queue[i]].display_name
				end
				return table.concat(queue_table, ", ")
			end,
		}, -- RolloverText
	}, dlg_frame)

	dlg_frame.idResearchProgress.idProgress:SetTileFrame(true)

	dlg_frame.idQueueCount = XText:new({
		Id = "idQueueCount",
		Dock = "left",
		TextStyle = "HUDStat",
		FoldWhenHidden = true,
	}, dlg_frame)

	dlg_frame.idQueueCount:SetVisible(queue_count)

end

UpdateResearchProgressBar = function()
	if not dlg_frame then
		return
	end

	-- When you mouse over an element, its tooltip ('rollover') is updated
	-- automatically, but to have it update while it's open, it needs to be
	-- triggered
	local UICity = UICity
	XUpdateRolloverWindow(dlg_frame.idResearchProgress)
	local current_research = UICity:GetResearchInfo()

	dlg_frame.idResearchProgress:SetProgress(UICity:GetResearchProgress(
		-- GetCheapestTech is what gets researched when queue is empty
		current_research or UICity:GetCheapestTech()
	))

	dlg_frame.idQueueCount:SetVisible(mod_QueueCount)
	if mod_QueueCount then
		dlg_frame.idQueueCount:SetText(T{12612, "<ResearchPoints(cost)>",
			cost = #UICity.research_queue,
		})
	end

	dlg_frame:SetVisible(current_research or not mod_HideWhenEmpty)
end

OnMsg.NewHour = UpdateResearchProgressBar
OnMsg.TechResearched = UpdateResearchProgressBar
OnMsg.ResearchQueueChange = UpdateResearchProgressBar
-- To update immediately if you get RP but don't complete a tech
OnMsg.AnomalyAnalyzed = UpdateResearchProgressBar

-- add ui elements when the HUD is opened
local orig_OpenDialog = OpenDialog
function OpenDialog(dlg_str, ...)
	local dlg = orig_OpenDialog(dlg_str, ...)
	if dlg_str == "HUD" then
		AddResearchProgressBar2(mod_QueueCount, dlg)
		ModOptions()
	end
	return dlg
end
