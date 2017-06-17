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

	Roda.bus:register('input/mouse/pressing', function(event)
		self:add_tile(event, e)
	end)
end

function tilemap:add_tile(event, grid)
	local x, y = grid:get_tile_index(event.position)

	if x ~= nil and y ~= nil then
		if grid.tiles[x][y] == nil then
			Roda.bus:emit('tilemap/add', Tile(grid:get_tile_position(x, y), 'assets/images/terrain_01.png'), x, y)
		end
	end
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
