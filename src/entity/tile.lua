local Transform = require (RODA_SRC .. 'component.transform')
local Sprite = require (RODA_SRC .. 'component.sprite')
local Collider = require (RODA_SRC .. 'component.collider')

local tile = {}
tile.__index = tile

function tile:new(file, column, row, layer)
	local o = {}

	o.transform = Transform()
	o.collider = Collider(Rect(o.transform.position, Vector(16, 16)), true)
	o.sprite = Sprite(file, 16, 16, 0, 4)
	o.column = column
	o.row = row
	o.layer = layer

	return setmetatable(o, tile)
end

return setmetatable(tile, { __call = tile.new })
