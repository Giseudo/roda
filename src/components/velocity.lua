local Class = require (LIB_PATH .. "hump.class")
local Vector = require (LIB_PATH .. "hump.vector")
local Velocity = Class{
	direction = Vector(0, 0),
	speed = 0
}

function Velocity:init(direction, speed)
	self.direction = direction
	self.speed = speed
end

return Velocity
