local tilemap = {}

function tilemap:new(x, y, columns, rows)
	return setmetatable({
		x = x,
		y = y,
		columns = columns,
		rows = rows
	}, { __index = self })
end

function tilemap:tile_at(x, y)
end

function tilemap:draw()
	love.graphics.setColor(255, 255, 255, 50)
	for i = 0, self.columns do
		love.graphics.line(
			self.x - math.ceil(self.columns / 2) * roda.unit + roda.unit * i,
			self.y - math.floor(self.rows / 2) * roda.unit,
			self.x - math.ceil(self.columns / 2) * roda.unit + roda.unit * i,
			self.y + math.ceil(self.rows / 2) * roda.unit
		)
	end

	for k = 0, self.rows do
		love.graphics.line(
			self.x - math.ceil(self.columns / 2) * roda.unit,
			self.y - math.floor(self.rows / 2) * roda.unit + roda.unit * k,
			self.x + math.floor(self.columns / 2) * roda.unit,
			self.y - math.floor(self.rows / 2) * roda.unit + roda.unit * k
		)
	end
end

return setmetatable(tilemap, { __call = tilemap.new })
