return PlaceObj("ModDef", {
	"title", "Mark Deposit Ground v0.4",
	"version", 4,
	"saved", 1543060800,
	"image", "Preview.png",
	"id", "ChoGGi_MarkDepositGround",
	"steam_id", "1555446081",
	"author", "ChoGGi",
	"lua_revision", LuaRevision,
	"code", {
		"Code/Script.lua",
		"Code/ModConfig.lua",
		"Code/ShowConstruct.lua",
	},
	"description", [[Marks the ground around deposits so you can turn off the ugly signs and still see where they are.
Marks are sized depending on max amount.

Includes a ModConfig option to always hide the signs (you can still select the invisible sign and see the amount).
An option to change all anomalies to the greenman model (suggestions for a different model?).
And one more to show signs during construction mode.]],
})
