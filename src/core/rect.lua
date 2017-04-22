Rect = {}
Rect.__index = Rect

function Rect.new(x, y, w, h)
	return setmetatable({
		position = Vector(x or 0, y or 0),
		width = w or 0,
		height = h or 0
	}, Rect)
end

function Rect:get_half()
	return Vector(self.width / 2, self.height / 2)
end

function Rect:get_left()
	return self.position.x - self.width / 2
end

function Rect:get_right()
	return self.position.x + self.width / 2
end

function Rect:get_top()
	return self.position.y + self.height / 2
end

function Rect:get_bottom()
	return self.position.y - self.height / 2
end

function Rect:overlaps_y(o)
	return self:get_bottom() < o:get_top() and self:get_top() > o:get_bottom()
end

function Rect:overlaps_x(o)
	return self:get_left() < o:get_right() and self:get_right() > o:get_left()
end

function Rect:overlaps(o)
	return self:overlaps_x(o) and self:overlaps_y(o)
end

setmetatable(Rect, { __call = function(_, ...) return Rect.new(...) end })
