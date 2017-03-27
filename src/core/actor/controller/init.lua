local Class = require 'middleclass'
local controller = Class('Controller')

function controller:initialize(pawn)
	self.pawn = pawn
end

return controller
