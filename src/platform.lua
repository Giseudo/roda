local platform = {}

function platform:new(x, y, width, height)
	return setmetatable({
		position = Vector(x or 0, y or 0),
		rect = Rect(x or 0, y or 0, width or 100, height or 10)
	},
	{ __index = self })
end

function platform:update()
	self.rect.position = position
end

function platform:draw()
	love.graphics.setColor(0, 255, 0, 150)
	love.graphics.rectangle(
		"fill",
		self.rect:get_left(),
		self.rect:get_bottom(),
		self.rect.width,
		self.rect.height
	)
end

return setmetatable(platform, { __call = platform.new })


