local collider = {}

function collider:new(shape, solid)
	return setmetatable(
		{
			shape = shape,
			solid = solid
		},
		{ __index = collider }
	)
end

function collider:collides(other)
	local delta = Vector(
		self.shape.position.x - other.shape.position.x,
		self.shape.position.y - other.shape.position.y
	)
	local intersect = Vector(
		math.abs(delta.x) - (self.shape.size.x / 2 + other.shape.size.x / 2),
		math.abs(delta.y) - (self.shape.size.y / 2 + other.shape.size.y / 2)
	)

	if intersect.x < 0.0 and intersect.y < 0.0 then
		return intersect, delta
	end

	return false
end

return setmetatable(collider, { __call = collider.new })
