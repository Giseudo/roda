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
	self.tiles[tile.column][tile.row] = tile
end

return setmetatable(grid, {
	__call = grid.new
})
