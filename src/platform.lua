local platform = {}

function platform:new(x, y, width, height)
	return setmetatable({
		x = x or 0,
		y = y or 0,
		width = width or 200,
		height = height or 32
	},
	{ __index = self })
end

function platform:update()
end

function platform:draw()
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.rectangle(
		"fill",
		self.x - self.width / 2,
		self.y - self.height / 2,
		self.width,
		self.height
	)
end

return setmetatable(platform, { __call = platform.new })


