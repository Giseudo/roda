local Class = require 'middleclass'

local controller = Class('Controller')

function controller:initialize()
	self.up = "up"
	self.left = "left"
	self.right = "right"
	self.down = "down"
	self.jump = "space"
end

return controller
