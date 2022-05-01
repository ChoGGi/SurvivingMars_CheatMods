-- See LICENSE for terms

local d_before = Platform.developer
Platform.developer = true

editor.ObjClassList = ""
const.SelectionFilters = {
	{"Unit", name = "Units"}
}

editor.Camera = {
	MinHeight = "0.5",
	MaxHeight = 1000,
	HeightInertia = 7,
	MoveSpeedNormal = 2,
	MoveSpeedFast = 32,
	PanSpeed = 25,
	RotateSpeed = 5,
	LookatDist = 3,
	LowRotationRadius = 1,
	HighRotationRadius = 20,
	CameraYawRestore = 0,
	UpDownSpeed = 230,
	MinZoom = 1 * guim,
	MaxZoom = 3 * guim
}
function OnMsg.GameEnterEditor()
	cameraRTS.SetProperties(1, editor.Camera)
	ShowMouseCursor("Editor")
end
function OnMsg.GameExitEditor()
	HideMouseCursor("Editor")
	cameraRTS.SetProperties(1, const.DefaultCameraRTS)
end

-- fixes UpdateInterface nil value in editor mode
--~ 	editor.LoadPlaceObjConfig()
PlaceObjectConfig = editor.PlaceObjectConfigToUIFormat({
	Decals = {},
	Gameplay = {
		"MinimumElevationMarker"
	},
	Lights = {"PointLight"},
	Units = {}
})
ObjectPaletteFilters = {
	{id = "all", item = nil},
	{
		id = "decals",
		item = function(x)
			return g_Classes[x] and g_Classes[x]:IsKindOf("Decal")
		end
	}
}

-- needed for HashLogToTable(), SM was planning to have multiple cities (or from a past game from this engine)?
if not rawget(_G, "g_Cities") then
	g_Cities = {}
end
-- editor wants a table
g_revision_map = {}
-- stops some log spam in editor (function doesn't exist in SM)
UpdateMapRevision = rawget(_G, "UpdateMapRevision") or empty_func
AsyncGetSourceInfo = rawget(_G, "AsyncGetSourceInfo") or empty_func

Platform.developer = d_before
