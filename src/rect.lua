local rect = {}

function rect:new(x, y, width, height)
	return setmetatable({
		x = x or 0,
		y = y or 0,
		width = width or 16,
		height = height or 16
	}, { __index = self })
end

function rect:get_left()
	return self.x - self.width / 2
end

function rect:get_right()
	return self.x + self.width / 2
end

function rect:get_top()
	return self.y - self.height / 2
end

function rect:get_bottom()
	return self.y + self.height / 2
end

return setmetatable(rect, { __call = rect.new })
