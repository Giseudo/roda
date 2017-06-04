local Tile = require (RODA_SRC .. 'entity.tile')
local tilemap = {}

function tilemap:new(x, y, columns, rows)
	return setmetatable({
		x = x,
		y = y,
		columns = columns,
		rows = rows,
		tiles = {}
	}, { __index = self })
end

function tilemap:init()
	for i = 0, self.columns do
		self.tiles[i] = {}

		for k = 0, self.rows do
			local position = Vector(self.x, self.y)

			position.x = position.x + Roda.graphics.unit / 2 - math.ceil(self.columns / 2) * Roda.graphics.unit + Roda.graphics.unit * i
			position.y = position.y + Roda.graphics.unit / 2 - math.ceil(self.columns / 2) * Roda.graphics.unit + Roda.graphics.unit * k

			self.tiles[i][k] = nil
			--self.tiles[i][k] = Tile(position)
		end
	end
end

function tilemap:add(position)
	local column = 0
	local row = 0

	-- Resolve tile column and row position
	-- Check if tile exist
	-- Add new tile with fixed position
end

function tilemap:tile_at(x, y)
end

function tilemap:draw()
	-- Set grid color
	love.graphics.setColor(255, 255, 255, 30)

	-- Draw columns
	for i = 0, self.columns do
		love.graphics.line(
			self.x - math.ceil(self.columns / 2) * Roda.graphics.unit + Roda.graphics.unit * i,
			self.y - math.floor(self.rows / 2) * Roda.graphics.unit,
			self.x - math.ceil(self.columns / 2) * Roda.graphics.unit + Roda.graphics.unit * i,
			self.y + math.ceil(self.rows / 2) * Roda.graphics.unit
		)
	end

	-- Draw rows
	for k = 0, self.rows do
		love.graphics.line(
			self.x - math.ceil(self.columns / 2) * Roda.graphics.unit,
			self.y - math.floor(self.rows / 2) * Roda.graphics.unit + Roda.graphics.unit * k,
			self.x + math.floor(self.columns / 2) * Roda.graphics.unit,
			self.y - math.floor(self.rows / 2) * Roda.graphics.unit + Roda.graphics.unit * k
		)
	end

	for i = 0, self.columns do
		for k = 0, self.rows do
			if self.tiles[i][k] ~= nil then
				self.tiles[i][k]:draw()
			end
		end
	end

	-- Draw X axis line
	love.graphics.setColor(255, 0, 0, 50)
	love.graphics.line(
		self.x - math.ceil(self.columns / 2) * Roda.graphics.unit,
		self.y,
		self.x + math.floor(self.columns / 2) * Roda.graphics.unit,
		self.y
	)

	-- Draw Y axis line
	love.graphics.setColor(0, 255, 0, 50)
	love.graphics.line(
		self.x,
		self.y + math.ceil(self.rows / 2) * Roda.graphics.unit,
		self.x,
		self.y - math.floor(self.rows / 2) * Roda.graphics.unit
	)
end

return setmetatable(tilemap, { __call = tilemap.new })
