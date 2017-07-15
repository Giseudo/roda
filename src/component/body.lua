local body = {}

function body:new(velocity, acceleration, friction)
	return setmetatable({
		velocity = velocity or Vector(0, 0),
		acceleration = acceleration or Vector(0, 0),
		friction = friction or Vector(0, 0),
		grounded = false
	}, { __index = self })
end

return setmetatable(body, { __call = body.new })
