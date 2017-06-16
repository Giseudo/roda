local Transform = require(RODA_SRC .. 'component.transform')
local grid = {}
grid.__index = grid

function grid:new(columns, rows, layer)
	local o = {}

	o.tiles = {}
	o.transform = Transform()
	o.columns = columns
	o.rows = rows
	o.layer = layer or 0

	grid.init(o)

	return setmetatable(o, grid)
end

function grid:init()
	for i = 0, self.columns do
		self.tiles[i] = {}

		for k = 0, self.rows do
			self.tiles[i][k] = nil
		end
	end
end

function grid:add_tile(tile, x, y)
	self.tiles[x][y] = tile

	self:update_tile(x, y + 1) -- North
	self:update_tile(x, y - 1) -- South
	self:update_tile(x - 1, y) -- West
	self:update_tile(x + 1, y) -- East
	self:update_tile(x, y)
end

function grid:get_tile(x, y)
	if x - 1 >= 0 and x + 1 < self.columns then
		if y - 1 >= 0 and y + 1 < self.rows then
			return self.tiles[x][y]
		end
	end

	return false
end

function grid:get_tile_index(position)
	for i = 0, self.columns do
		for k = 0, self.rows do
			local tile_position = self:get_tile_position(i, k)
			local dx = position.x - tile_position.x
			local px = 16 / 2 - math.abs(dx)

			local dy = position.y - tile_position.y
			local py = 16 / 2 - math.abs(dy)

			if px > 0 and py > 0 then
				return i, k
			end
		end
	end

	return nil, nil
end

function grid:get_tile_position(x, y)
	local position = Vector(
		8 - self.transform.position.x - math.ceil(self.columns / 2) * Roda.graphics.unit + Roda.graphics.unit * x,
		8 + self.transform.position.y + math.ceil(self.rows / 2) * Roda.graphics.unit - Roda.graphics.unit - Roda.graphics.unit * y
	)

	return position
end

function grid:update_tile(x, y)
	local value = 0
	local tile = self:get_tile(x, y)

	if x == nil or y == nil or tile == nil then
		return
	end

	local north = self:get_tile(x, y - 1)
	local south = self:get_tile(x, y + 1)
	local west = self:get_tile(x - 1, y)
	local east = self:get_tile(x + 1, y)

	if north ~= nil then value = value + 1 * 1 end
	if south ~= nil then value = value + 1 * 8 end
	if west ~= nil then value = value + 1 * 2 end
	if east ~= nil then value = value + 1 * 4 end

	tile.sprite.frame = value
end

return setmetatable(grid, {
	__call = grid.new
})
