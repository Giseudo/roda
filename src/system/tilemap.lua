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
	Roda.bus:register('tilemap/add', function(tile)
		e:add_tile(tile)
		Roda.world:add(tile)
		Roda.world:refresh()
	end)

	Roda.bus:register('input/mouse/pressed', function(event)
		local x, y = e:get_tile_index(event.position)

		if e.tiles[x][y] == nil then
			local tile = Tile('assets/images/terrain_01.png', x, y, 0)
			e:add_tile(tile)
			Roda.world:add(tile)
			Roda.world:refresh()
		end
	end)
end

function tilemap:process(e, dt)
	for i = 0, e.columns do
		for k = 0, e.rows do
			local tile = e.tiles[i][k]

			if tile ~= nil then
				-- Update tile position
				tile.transform.position.x = 8 - e.transform.position.x - math.ceil(e.columns / 2) * Roda.graphics.unit + Roda.graphics.unit * i
				tile.transform.position.y = 8 + e.transform.position.y + math.ceil(e.rows / 2) * Roda.graphics.unit - tile.sprite.height - Roda.graphics.unit * k
			end
		end
	end
end

return setmetatable(tilemap, {
	__call = tilemap.new
})
