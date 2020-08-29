-- See LICENSE for terms

--[[

-- some sound funcs to use with the sounds defined below:
handle = PlaySound(sound, _type, volume, fade_time, looping, point_or_object, loud_distance)
StopSound(handle)
IsSoundPlaying(handle)
SetSoundVolume(handle, volume, time)
GetSoundVolume(handle)

PlaySound("Object LandingPad Fail")
PlaySound("Object MOXIE Loop", "ObjectLoopLimited-A", nil, 0, true, SelectedObj, 1000)

-- if you're making a looping sound test with:
local snd_playing = false
local function TestSound(snd)
	StopSound(snd_playing)
	snd_playing = PlaySound(snd)
end
TestSound("Object MOXIE Loop")
]]

function OnMsg.ClassesPostprocess()
	-- if you have ecm use OpenExamine(SoundPreset), to see the object properties
	-- or grab the decompiled lua files from my discord channel and open CommonLua\Classes\Sounds\Sounds.lua
	-- Data\SoundPreset.lua, and Lua\Config\__SoundTypes.lua

	-- that's right no .ext
	local Example_Sound_File = CurrentModPath .. "Sounds/OhHaiMark"

	-- as basic a sound as you can
	-- PlaySound("OhHaiMark")
	PlaceObj("SoundPreset", {
		id = "OhHaiMark",
		type = "UI",
		PlaceObj("Sample", {
			"file", Example_Sound_File,
		}),
	})

	-- a loop for use with an object
	-- like the thumper on the rare metals extractor
	-- PlaySound("Object OhHaiMark Loop")
	PlaceObj("SoundPreset", {
		group = "Object",
		id = "Object OhHaiMark Loop",
		looping = true,
		mindistance = 2200,
		volume = 110,
		type = "ObjectLoopLimited-A",
		PlaceObj("Sample", {
			"file", Example_Sound_File,
			"frequency", 50,
		}),
--~ 		PlaceObj("Sample", {
--~ 			"file", "Sounds/Objects/GeneratorMoxie/generatorMoxie_work3",
--~ 			"frequency", 50,
--~ 		}),
--~ 		PlaceObj("Sample", {
--~ 			"file", "Sounds/Objects/GeneratorMoxie/generatorMoxie_work2",
--~ 			"frequency", 50,
--~ 		}),
	})
--~ 	PlaySound("Object OhHaiMark Loop", "ObjectLoopLimited-A", nil, 0, true, SelectedObj, 1000)

	-- a oneshot for use with an object
	-- PlaySound("Object OhHaiMark Oneshot")
	PlaceObj("SoundPreset", {
		group = "Object",
		id = "Object OhHaiMark Oneshot",
		mindistance = 3000,
		volume = 40,
		type = "ObjectOneshotLimited-B",
		PlaceObj("Sample", {
			"file", Example_Sound_File,
			"frequency", 10,
		}),
	})
--~ PlaySound("Object OhHaiMark Oneshot", "ObjectOneshotLimited-B", nil, 0, true, SelectedObj, 1000)

	-- needed to rebuild sound lists
	ReloadSoundBanks()

--~ PlaceObj('ActionFXSound', {
--~ 	'Action', "SelectObj",
--~ 	'Moment', "start",
--~ 	'Actor', "RCTransport",
--~ 	'Sound', "Object OhHaiMark Oneshot",
--~ })

end
