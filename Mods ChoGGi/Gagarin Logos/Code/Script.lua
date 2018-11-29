function OnMsg.ClassesPostprocess()
	local logos = Presets.MissionLogoPreset.Default

	if not logos.USA then
		PlaceObj("MissionLogoPreset", {
			SortKey = 20000,
			display_name = T({435363139815, "USA"}),
			entity_name = "DecLogoGagarin_01",
			group = "Default",
			id = "USA",
			image = "UI/Icons/Logos/logo_gagarin_01.tga",
		})
	end
	if not logos.China then
		PlaceObj("MissionLogoPreset", {
			SortKey = 21000,
			display_name = T({313417356933, "China"}),
			entity_name = "DecLogoGagarin_02",
			group = "Default",
			id = "China",
			image = "UI/Icons/Logos/logo_gagarin_02.tga",
		})
	end
	if not logos.India then
		PlaceObj("MissionLogoPreset", {
			SortKey = 22000,
			display_name = T({972998234385, "India"}),
			entity_name = "DecLogoGagarin_03",
			group = "Default",
			id = "India",
			image = "UI/Icons/Logos/logo_gagarin_03.tga",
		})
	end
	if not logos.Russia then
		PlaceObj("MissionLogoPreset", {
			SortKey = 23000,
			display_name = T({148015385814, "Russia"}),
			entity_name = "DecLogoGagarin_04",
			group = "Default",
			id = "Russia",
			image = "UI/Icons/Logos/logo_gagarin_04.tga",
		})
	end
	if not logos.Europe then
		PlaceObj("MissionLogoPreset", {
			SortKey = 24000,
			display_name = T({11545, "Europe"}),
			entity_name = "DecLogoGagarin_05",
			group = "Default",
			id = "Europe",
			image = "UI/Icons/Logos/logo_gagarin_05.tga",
		})
	end
	if not logos.IMM then
		PlaceObj("MissionLogoPreset", {
			SortKey = 25000,
			display_name = T({524835759283, "IMM"}),
			entity_name = "DecLogoGagarin_06",
			group = "Default",
			id = "IMM",
			image = "UI/Icons/Logos/logo_gagarin_06.tga",
		})
	end
	if not logos.SpaceY then
		PlaceObj("MissionLogoPreset", {
			SortKey = 26000,
			display_name = T({248041410082, "SpaceY"}),
			entity_name = "DecLogoGagarin_07",
			group = "Default",
			id = "SpaceY",
			image = "UI/Icons/Logos/logo_gagarin_07.tga",
		})
	end
	if not logos.BlueSun then
		PlaceObj("MissionLogoPreset", {
			SortKey = 27000,
			display_name = T({
				900140529348,
				"Blue Sun Corporation"
			}),
			entity_name = "DecLogoGagarin_08",
			group = "Default",
			id = "BlueSun",
			image = "UI/Icons/Logos/logo_gagarin_08.tga",
		})
	end
	if not logos.NewArk then
		PlaceObj("MissionLogoPreset", {
			SortKey = 27000,
			display_name = T({
				171811838507,
				"Church of the New Ark"
			}),
			entity_name = "DecLogoGagarin_09",
			group = "Default",
			id = "NewArk",
			image = "UI/Icons/Logos/logo_gagarin_09.tga",
		})
	end
	if not logos.Japan then
		PlaceObj("MissionLogoPreset", {
			SortKey = 28000,
			display_name = T({239529920043, "Japan"}),
			entity_name = "DecLogoGagarin_10",
			group = "Default",
			id = "Japan",
			image = "UI/Icons/Logos/logo_gagarin_10.tga",
		})
	end
	if not logos.Brazil then
		PlaceObj("MissionLogoPreset", {
			SortKey = 29000,
			display_name = T({256458010861, "Brazil"}),
			entity_name = "DecLogoGagarin_11",
			group = "Default",
			id = "Brazil",
			image = "UI/Icons/Logos/logo_gagarin_11.tga",
		})
	end

end
