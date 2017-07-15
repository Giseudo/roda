local Transform = require (RODA_SRC .. 'component.transform')
local Sprite = require (RODA_SRC .. 'component.sprite')
local Collider = require (RODA_SRC .. 'component.collider')

local tile = {}
tile.__index = tile

function tile:new(position, file, layer)
	local o = {}

	o.transform = Transform(position)
	o.sprite = Sprite('terrain_01', file, 16, 16, 0, 4)
	o.layer = layer or 0

	return setmetatable(o, tile)
end

return setmetatable(tile, { __call = tile.new })
