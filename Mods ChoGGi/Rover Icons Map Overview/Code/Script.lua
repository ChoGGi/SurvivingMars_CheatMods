-- See LICENSE for terms

local MulDivRound = MulDivRound
local Sleep = Sleep

local step = 33

local function UpdateIcons(time, direction, rovers)
	SuspendPassEdits("ChoGGi_RoverIconsMapOverview_Update")
	local scale = const.SignsOverviewCameraScaleUp

	g_CurrentDepositScale = direction == "up" and scale or 100

	local i = 0
	local signs_scale = 0
	repeat
		Sleep(step)
		if time == 0 then
			signs_scale = direction == "up" and scale or 100
		else
			signs_scale = 100 + MulDivRound(direction == "up" and i or time-i, scale - 100, time)
		end

		for i = 1, #rovers do
			rovers[i]:SetScale(signs_scale)
		end
		i = i + step
	until i > time or not CameraTransitionThread
	ResumePassEdits("ChoGGi_RoverIconsMapOverview_Update")
end

local orig_OverviewModeDialog_ScaleSmallObjects = OverviewModeDialog.ScaleSmallObjects
function OverviewModeDialog:ScaleSmallObjects(time, direction, ...)
	local ret = orig_OverviewModeDialog_ScaleSmallObjects(self, time, direction, ...)
	CreateRealTimeThread(UpdateIcons, time, direction, MapGet(true, "BaseRover"))
	return ret
end

