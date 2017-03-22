local Class = require 'middleclass'
local Bump = require 'bump'

local space = Class('Space')

function space:initialize(bus)
	self.bus = bus
	setmetatable(self, { __index = Bump.newWorld(32) })

	self.bus:register('scene/space/add', function(e, x, y, w, h)
		self:add(e, x, y, w, h)
	end)
end

return space
