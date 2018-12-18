### Export/Import CSV data

##### Export
```lua
-- data to export
local example_data = {
	{
		name = "example1",
		amount = 1,
	},
	{
		name = "example2",
		amount = 2,
	},
}

local fields = {
	"name",
	"amount",
}
local captions = {
	"Example Name",
	"Amount",
}
local filename = "AppData/Example Data.csv"
SaveCSV(filename, example_data, fields, captions)
```

##### Import
```lua
local csv_load_fields = {
	[1] = "name",
	[2] = "amount",
}
local filename = "AppData/Example Data.csv"

-- returns a table structured the same as example_data above (true means skip captions)
LoadCSV(filename,{},csv_load_fields,true)
```
