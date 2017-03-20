local Class = require 'middleclass'

local collider = Class('Collider')

function collider:initialize()
	self.trigger = false
end

return collider
