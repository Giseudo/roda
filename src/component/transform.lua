local Class = require 'middleclass'
local Vector = require (RODA_LIB .. 'hump.vector')

local transform = Class('Transform')

function transform:initialize(position, scale, rotation, depth)
	self.position = position or Vector(0, 0)
	self.scale = scale or Vector(1, 1)
	self.rotation = rotation or 0
	self.depth = depth or 1 -- Order of drawing
end

return transform
