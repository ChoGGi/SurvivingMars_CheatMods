-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "ApplicantAmount",
		"DisplayName", T(302535920011701, "Applicant Amount"),
		"Help", T(302535920011702, "How many more tourist applicants to add per each successful tourist."),
		"DefaultValue", 6,
		"MinValue", 2,
		"MaxValue", 10000,
	}),
}
