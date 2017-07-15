local Transform = require(RODA_SRC .. 'component.transform')
local layer = {}
layer.__index = layer

function layer:new(columns, rows)
	local o = {}

	o.tiles = {}
	o.transform = Transform()
	o.columns = columns
	o.rows = rows

	layer.init(o)

	return setmetatable(o, layer)
end

function layer:init()
	for i = 0, self.columns do
		self.tiles[i] = {}

		for k = 0, self.rows do
			self.tiles[i][k] = nil
		end
	end
end

function layer:add_tile(tile, x, y)
	self.tiles[x][y] = tile

	self:update_tile(x, y + 1) -- North
	self:update_tile(x, y - 1) -- South
	self:update_tile(x - 1, y) -- West
	self:update_tile(x + 1, y) -- East
	self:update_tile(x, y)
end

function layer:get_tile(x, y)
	if x > 0 and x < self.columns + 1 then
		if y >= 0 and y <= self.rows + 1 then
			return self.tiles[x][y]
		end
	end

	return false
end

function layer:get_tile_index(position)
	local x, y = 0, 0

	for i = 0, self.columns do
		for k = 0, self.rows do
			local tile_position = self:get_tile_position(i, k)
			local dx = position.x - tile_position.x
			local px = 16 / 2 - math.abs(dx)

			local dy = position.y - tile_position.y
			local py = 16 / 2 - math.abs(dy)

			if px > 0 and py > 0 then
				x = i
				y = k
			end
		end
	end

	return x, y
end

function layer:get_tile_position(x, y)
	local position = Vector(
		8 - self.transform.position.x - math.ceil(self.columns / 2) * Roda.graphics.unit + Roda.graphics.unit * x,
		8 + self.transform.position.y + math.ceil(self.rows / 2) * Roda.graphics.unit - Roda.graphics.unit - Roda.graphics.unit * y
	)

	return position
end

function layer:update_tile(x, y)
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

function layer:debug()
	Roda.bus:emit('camera/set')

	-- Set grid color
	love.graphics.setColor(255, 255, 255, 30)

	-- Draw columns
	for i = 0, self.columns do
		love.graphics.line(
			self.transform.position.x - math.ceil(self.columns / 2) * Roda.graphics.unit + Roda.graphics.unit * i,
			self.transform.position.y - math.floor(self.rows / 2) * Roda.graphics.unit,
			self.transform.position.x - math.ceil(self.columns / 2) * Roda.graphics.unit + Roda.graphics.unit * i,
			self.transform.position.y + math.ceil(self.rows / 2) * Roda.graphics.unit
		)
	end

	-- Draw rows
	for k = 0, self.rows do
		love.graphics.line(
			self.transform.position.x - math.ceil(self.columns / 2) * Roda.graphics.unit,
			self.transform.position.y - math.floor(self.rows / 2) * Roda.graphics.unit + Roda.graphics.unit * k,
			self.transform.position.x + math.floor(self.columns / 2) * Roda.graphics.unit,
			self.transform.position.y - math.floor(self.rows / 2) * Roda.graphics.unit + Roda.graphics.unit * k
		)
	end

	-- Draw X axis line
	love.graphics.setColor(255, 0, 0, 150)
	love.graphics.line(
		self.transform.position.x - math.ceil(self.columns / 2) * Roda.graphics.unit,
		self.transform.position.y,
		self.transform.position.x + math.floor(self.columns / 2) * Roda.graphics.unit,
		self.transform.position.y
	)

	-- Draw Y axis line
	love.graphics.setColor(0, 0, 255, 150)
	love.graphics.line(
		self.transform.position.x,
		self.transform.position.y + math.ceil(self.rows / 2) * Roda.graphics.unit,
		self.transform.position.x,
		self.transform.position.y - math.floor(self.rows / 2) * Roda.graphics.unit
	)

	love.graphics.setColor(255, 255, 255, 255)

	Roda.bus:emit('camera/unset')
end

return setmetatable(layer, {
	__call = layer.new
})
