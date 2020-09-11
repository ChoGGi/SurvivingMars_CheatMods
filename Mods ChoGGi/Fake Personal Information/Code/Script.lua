function SteamGetBlockedUsers()
	return empty_table
end
function SteamGetFriends()
	return empty_table
end
function SteamGetPersonaName()
	return "Gabriel Dobrev"
end

-- why yes Haemimont Games, this is my personal info
local AccountDetails = {
	CreationDate = "1992-01-01 12:00:00.0",
	details = {
		AddressLine1 = "BIC IZOT, suite 423",
		AddressLine2 = "7th km, Tzarigradsko chaussee Blvd.",
		City = "Sofia",
		Country = "Bulgaria",
		DateOfBirth = "1992-01-01",
		FirstName = "Gabriel",
		Language = "BG",
		LastName = "Dobrev",
		Phone = "359-2-9650625",
		State = "",
		ZipCode = "",
	},
	Email = "Gabriel_Dobrev@haemimontgames.com",
	IsEmailVerified = true,
	Referer = "",
	Source = "",
}

-- they get set between now and OnMsg.ClassesGenerate(), so
g_ParadoxAccountDetails = AccountDetails
g_ParadoxAccountLinked = false
g_ParadoxUserId = false
g_ParadoxHashedUserId = false

-- close enough...
local user_id = table.concat{AsyncRand(), AsyncRand(), AsyncRand(), AsyncRand()}
g_ParadoxUserId = user_id

-- If it's good enough for HG
local user_id_hashed = tostring(Encode16(SHA256(table.concat{g_ParadoxUserId, "GVF235LWMID64DC4DC6508FSQE4823179D7034D99DEE"})))

-- this is probably for uploading saved games to the cloud (thanks SkiRich)
g_ParadoxHashedUserId = user_id_hashed

function WaitGetParadoxAccountData()
	ClearParadoxParams()
	g_ParadoxAccountLinked = true
	MarkParadoxSponsorActive()
	g_ParadoxAccountDetails = AccountDetails
	g_ParadoxUserId = user_id
	g_ParadoxHashedUserId = user_id_hashed
	Msg("PopsAccountDetailsRetrieved")
end

function OnMsg.ClassesBuilt()
	g_ParadoxAccountDetails = AccountDetails
	g_ParadoxUserId = user_id
	g_ParadoxHashedUserId = user_id_hashed
end
