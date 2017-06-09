local Tiny = require 'tiny'

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
end

function tilemap:process(e, dt)
	for i = 0, e.columns do
		for k = 0, e.rows do
			local tile = e.tiles[i][k]
			if tile ~= nil then
				tile.transform.position.x = 8 - e.transform.position.x - math.ceil(e.columns / 2) * Roda.graphics.unit + Roda.graphics.unit * i
				tile.transform.position.y = 8 + e.transform.position.y + math.ceil(e.rows / 2) * Roda.graphics.unit - tile.sprite.height - Roda.graphics.unit * k

				--[[love.graphics.draw(
					tile.sprite.texture,
					tile.sprite.quad,
					tile.transform.position.x,
					tile.transform.position.y
				)]]
			end
		end
	end

end

return setmetatable(tilemap, {
	__call = tilemap.new
})
