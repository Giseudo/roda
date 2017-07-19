local body = {}

function body:new(velocity, acceleration, friction, jump_velocity)
	return setmetatable({
		velocity = velocity or Vector(0, 0),
		acceleration = acceleration or Vector(0, 0),
		friction = friction or Vector(0, 0),
		jump_velocity = jump_velocity or 10,
		kinematic = false,
		grounded = false
	}, { __index = self })
end

return setmetatable(body, { __call = body.new })
