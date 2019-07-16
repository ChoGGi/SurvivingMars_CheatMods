local objs = UICity.labels.Colonist or ""
for i = 1, #objs do
	objs[i]:RemoveTrait("Renegade")
end
