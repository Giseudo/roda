local Class = require (LIB_PATH .. "hump.class")
local Vector = require (LIB_PATH .. "hump.vector")
local Transform = Class{}

function Transform:init(position, scale, rotation, depth)
	self.position = position or Vector(0, 0)
	self.scale = scale or Vector(1, 1)
	self.rotation = rotation or 0
	self.depth = depth -- Order of drawing
end

return Transform
