Rect = {}
Rect.__index = Rect

function Rect.new(position, size)
	return setmetatable({
		position = position or Vector(0, 0),
		size = size or Vector(0, 0)
	}, Rect)
end

function Rect:get_half()
	return Vector(self.size.x / 2, self.size.y / 2)
end

function Rect:get_left()
	return self.position.x - self.size.x / 2
end

function Rect:get_right()
	return self.position.x + self.size.x / 2
end

function Rect:get_top()
	return self.position.y + self.size.y / 2
end

function Rect:get_bottom()
	return self.position.y - self.size.y / 2
end

function Rect:draw(mode)
	love.graphics.rectangle(
		mode or "line",
		self:get_left(),
		self:get_bottom(),
		self.size.x,
		self.size.y
	)
end

setmetatable(Rect, { __call = function(_, ...) return Rect.new(...) end })
