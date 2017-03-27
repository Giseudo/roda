local Class = require 'middleclass'
local Vector = require (RODA_LIB .. 'hump.vector')
local Actor = require (RODA_SRC .. 'core.actor')
local TransformComponent = require (RODA_SRC .. 'component.transform')
local CameraComponent = require (RODA_LIB .. 'hump.camera')

local camera_actor = Class('CameraActor', Actor)

function camera_actor:initialize()
	Actor.initialize(self, 'Main Camera')

	self.transform = TransformComponent(Vector(0, 0))
	self.camera = CameraComponent(0, 0, 2)
end

return camera_actor
