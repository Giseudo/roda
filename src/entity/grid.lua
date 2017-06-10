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

function grid:add_tile(tile)
	local north = self:get_north(tile)
	local south = self:get_south(tile)
	local west = self:get_west(tile)
	local east = self:get_east(tile)

	self.tiles[tile.column][tile.row] = tile

	self:update_tile(north)
	self:update_tile(south)
	self:update_tile(west)
	self:update_tile(east)
	self:update_tile(tile)
end

function grid:update_tile(tile)
	if tile == nil then
		return
	end

	local north = self:get_north(tile)
	local south = self:get_south(tile)
	local west = self:get_west(tile)
	local east = self:get_east(tile)

	local value = 0

	if north ~= nil then
		value = value + 1 * 1
	end

	if south ~= nil then
		value = value + 1 * 8
	end

	if west ~= nil then
		value = value + 1 * 2
	end

	if east ~= nil then
		value = value + 1 * 4
	end

	tile.sprite.frame = value
end

function grid:get_north(tile)
	local north = nil

	if tile.row - 1 >= 0 then
		north = self.tiles[tile.column][tile.row - 1]
	end

	return north
end

function grid:get_south(tile)
	local south = nil

	if tile.row + 1 < self.rows then
		south = self.tiles[tile.column][tile.row + 1]
	end

	return south
end

function grid:get_west(tile)
	local west = nil

	if tile.column - 1 >= 0 then
		west = self.tiles[tile.column - 1][tile.row]
	end

	return west
end

function grid:get_east(tile)
	local east = nil

	if tile.column + 1 < self.columns then
		east = self.tiles[tile.column + 1][tile.row]
	end

	return east
end

return setmetatable(grid, {
	__call = grid.new
})
