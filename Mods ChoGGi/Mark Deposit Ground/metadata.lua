return PlaceObj("ModDef", {
	"title", "Mark Deposit Ground v0.5",
	"version_major", 0,
	"version_minor", 5,
	"saved", 1552564800,
	"image", "Preview.png",
	"id", "ChoGGi_MarkDepositGround",
	"steam_id", "1555446081",
	"pops_any_uuid", "8a57f30a-6bae-46c0-99b9-ca497bf74bd3",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 243725,
	"code", {
		"Code/Script.lua",
		"Code/ModConfig.lua",
		"Code/ShowConstruct.lua",
	},
	"description", [[Marks the ground around deposits so you can turn off the ugly signs and still see where they are.
Marks are sized depending on max amount.

Includes a Mod Config Reborn option to always hide the signs (you can still select the invisible sign and see the amount).
An option to change all anomalies to the greenman model (suggestions for a different model?).
And one more to show signs during construction mode.]],
})
