local Class = require (LIB_PATH .. "hump.class")
local Vector = require (LIB_PATH .. "hump.vector")
local Transform = Class{
	position = Vector(0, 0),
	scale = Vector(1, 1),
	rotation = 0,
	parent = nil
}

function Transform:init(position, scale, rotation, node)
	self.position = position
	self.scale = scale
	self.rotation = rotation
	self.parent = node
end

function Transform:translate(velocity, dt)
	self.position = self.position + (velocity * dt)
end

function Transform:translateTo(position, speed, dt)
	
end

return Transform
