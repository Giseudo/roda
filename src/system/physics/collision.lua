local Class = require 'middleclass'
local Tiny = require 'tiny'

local collision_system = Class('CollisionSystem', System)

function collision_system:initialize(bus)
	System.initialize(bus)

	self.filter = Tiny.requireAll('transform', 'rigidbody')
end

return collision_system
