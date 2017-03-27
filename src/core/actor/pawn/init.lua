local Class = require 'middleclass'
local Actor = require (RODA_SRC .. 'core.actor')

local pawn = Class('Pawn', Actor)

function pawn:initialize(camera)
	Actor.initialize(self)

	self.camera = camera
end

return pawn
