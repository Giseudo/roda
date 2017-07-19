local Transform = require (RODA_SRC .. 'component.transform')
local Sprite = require (RODA_SRC .. 'component.sprite')
local Collider = require (RODA_SRC .. 'component.collider')

local block = {}
block.__index = block

function block:new(position, tiles, size)
	local o = {
		name = 'block',
		size = size,
		tiles = tiles
	}

	o.transform = Transform(position)
	o.collider = Collider(Rect(o.transform.position, Vector(16 * size.x, 16 * size.y)), true)

	return setmetatable(o, block)
end

return setmetatable(block, { __call = block.new })
