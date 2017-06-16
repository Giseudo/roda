local Tiny = require 'tiny'
local Tile = require(RODA_SRC .. 'entity.tile')

local tilemap = {}
tilemap.__index = tilemap

function tilemap:new()
	local o = setmetatable({
		filter = Tiny.requireAll('transform', 'tiles'),
		isDrawingSystem = true
	}, tilemap)

	return Tiny.processingSystem(o)
end

function tilemap:onAdd(e)
	Roda.bus:register('tilemap/add', function(tile, x, y)
		e:add_tile(tile, x, y)
		Roda.world:add(tile)
		Roda.world:refresh()
	end)

	Roda.bus:register('input/mouse/pressed', function(event)
		local x, y = e:get_tile_index(event.position)

		if x ~= nil and y ~= nil then
			if e.tiles[x][y] == nil then
				Roda.bus:emit('tilemap/add', Tile(e:get_tile_position(x, y), 'assets/images/terrain_01.png'), x, y)
			end
		end
	end)
end

function tilemap:process(e, dt)
	for i = 0, e.columns do
		for k = 0, e.rows do
			local tile = e.tiles[i][k]

			if tile ~= nil then
				-- Update tile position
				tile.transform.position = e:get_tile_position(i, k)
			end
		end
	end
end

return setmetatable(tilemap, {
	__call = tilemap.new
})
