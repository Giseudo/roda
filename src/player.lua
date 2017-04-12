local player = {}

function player:new(x, y, width, height)
	return setmetatable({
		x = x or 0,
		y = y or 0,
		width = width or 16,
		height = height or 32
	},
	{ __index = self })
end

function player:update()
end

function player:draw()
	love.graphics.setColor(255, 255, 0, 255)
	love.graphics.rectangle(
		"fill",
		self.x - self.width / 2,
		self.y - self.height / 2,
		self.width,
		self.height
	)
end

return setmetatable(player, { __call = player.new })
