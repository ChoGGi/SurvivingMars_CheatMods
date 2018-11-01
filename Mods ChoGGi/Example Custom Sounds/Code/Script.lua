function OnMsg.ClassesBuilt()
	-- if you have ecm use OpenExamine(SoundPreset), to see the object properties
	-- or grab the decompiled lua files from my discord channel and open CommonLua\Classes\Sounds\Sounds.lua (line: 69)
	-- Data\SoundPreset.lua, and Lua\Config\__SoundTypes.lua

	-- as basic a sound as you can
	-- PlaySound("OhHaiMark")
	PlaceObj("SoundPreset", {
		id = "OhHaiMark",
		type = "UI",
		PlaceObj("Sample", {
			"file", CurrentModPath .. "Sounds/OhHaiMark_stereo",
		}),
	})

	-- a loop for use with an object
	-- PlaySound("Object OhHaiMark Loop")
	PlaceObj("SoundPreset", {
		group = "Object",
		id = "Object OhHaiMark Loop",
		looping = true,
		mindistance = 2200,
		volume = 110,
		type = "ObjectLoopLimited-A",
		PlaceObj("Sample", {
			"file", CurrentModPath .. "Sounds/OhHaiMark_mono",
			"frequency", 50,
		}),
--~ 		PlaceObj('Sample', {
--~ 			'file', "Sounds/Objects/GeneratorMoxie/generatorMoxie_work3",
--~ 			'frequency', 50,
--~ 		}),
--~ 		PlaceObj('Sample', {
--~ 			'file', "Sounds/Objects/GeneratorMoxie/generatorMoxie_work2",
--~ 			'frequency', 50,
--~ 		}),
	})

	-- a oneshot for use with an object
	-- PlaySound("Object OhHaiMark Oneshot")
	PlaceObj("SoundPreset", {
		group = "Object",
		id = "Object OhHaiMark Oneshot",
		mindistance = 3000,
		volume = 40,
		type = "ObjectOneshotLimited-B",
		PlaceObj("Sample", {
			"file", CurrentModPath .. "Sounds/OhHaiMark_mono",
			"frequency", 10,
		}),
	})

	-- needed to rebuild lists
	ReloadSoundBanks()

	--[[
	-- PlaySound(sound, _type, volume, fade_time, looping, point_or_object, loud_distance)

	PlaySound("Object OhHaiMark Loop", "ObjectLoopLimited-A", nil, 0, true, SelectedObj, 1000)
	PlaySound("Object MOXIE Loop", "ObjectLoopLimited-A", nil, 0, true, SelectedObj, 1000)
	PlaySound("Object OhHaiMark Oneshot", "ObjectOneshotLimited-B", nil, 0, true, SelectedObj, 1000)
	--]]

	-- if you're making a looping sound test with:
	--[[
	GlobalVar("snd_playing", false)
	local function TestSound(snd)
		StopSound(snd_playing)
		snd_playing = PlaySound(snd)
	end
	TestSound("Object MOXIE Loop")
	--]]

end
