local Class = require 'middleclass'
local Vector = require (RODA_LIB .. 'hump.vector')

local rigidbody = Class('Rigidbody')

function rigidbody:initialize(width, height)
	self.width = width
	self.height = height
	self.shape = {}
	self.mass = 0
	self.kinematic = false
	self.gravity = true
	self.velocity = Vector(0, 0)
end

function rigidbody:is_grounded()
	return true
end

function rigidbody:set_kinematic(kinematic)
	self.kinematic = kinematic
end

function rigidbody:use_gravity(gravity)
	self.gravity = gravity
end

return rigidbody
