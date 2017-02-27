local Class = require (LIB_PATH .. "hump.class")
local Vector = require (LIB_PATH .. "hump.vector")
local Rigidbody = Class{
	shape = {},
	mass = 0,
	kinematic = false,
	gravity = true,
	width = 0,
	height = 0,
	velocity = Vector(0, 0)
}

function Rigidbody:init(width, height)
	self.width = width
	self.height = height
end

function Rigidbody:isGrounded()
	return true
end

function Rigidbody:setKinematic(kinematic)
	self.kinematic = kinematic
end

function Rigidbody:useGravity(gravity)
	self.gravity = gravity
end

return Rigidbody
