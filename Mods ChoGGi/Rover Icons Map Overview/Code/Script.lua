-- See LICENSE for terms

local MulDivRound = MulDivRound
local IsValid = IsValid
local Sleep = Sleep
local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits

local function UpdateIcons(time, direction, signs)
	SuspendPassEdits("ChoGGi_UpdateOverviewIcons")
	local SignsOverviewCameraScaleUp = const.SignsOverviewCameraScaleUp

	g_CurrentDepositScale = direction == "up" and SignsOverviewCameraScaleUp or 100

	local i = 0
	local step = 33
	repeat
		Sleep(step)
		local signs_scale
		if time == 0 then
			signs_scale = direction == "up" and SignsOverviewCameraScaleUp or 100
		else
			signs_scale = 100 + MulDivRound(direction == "up" and i or time-i, SignsOverviewCameraScaleUp - 100, time)
		end

		for i = 1, #signs do
			local sign = signs[i]
			if IsValid(sign) then
				sign:SetScale(signs_scale)
			end
		end
		i = i + step
	until i > time or not CameraTransitionThread
	ResumePassEdits("ChoGGi_UpdateOverviewIcons")
end

local orig_OverviewModeDialog_ScaleSmallObjects = OverviewModeDialog.ScaleSmallObjects
function OverviewModeDialog:ScaleSmallObjects(time, direction, ...)
	orig_OverviewModeDialog_ScaleSmallObjects(self, time, direction, ...)

	CreateRealTimeThread(UpdateIcons, time, direction, MapGet(true, "BaseRover"))
end

