local Transform = require (RODA_SRC .. 'component.transform')
local tile = {}

function tile:new(position)
	return setmetatable({
		transform = Transform(position)
	},
	{ __index = self })
end

function tile:draw()
	love.graphics.setColor(255, 0, 255, 150)
	love.graphics.rectangle(
		"fill",
		self.transform.position.x - Roda.unit / 2,
		self.transform.position.y - Roda.unit / 2,
		Roda.unit,
		Roda.unit
	)
end

return setmetatable(tile, { __call = tile.new })
