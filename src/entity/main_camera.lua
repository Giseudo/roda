local Class = require 'middleclass'
local Camera = require (RODA_LIB .. 'hump.camera')
local Vector = require (RODA_LIB .. 'hump.vector')
local GameObject = require (RODA_SRC .. 'core.game_object')
local Transform = require (RODA_SRC .. 'component.transform')

local main_camera = Class('MainCamera', GameObject)

function main_camera:initialize(bus)
	GameObject.initialize(self, bus, 'MainCamera')

	self.transform = Transform(Vector(0, 0))
	self.camera = Camera(0, 0, 2)
end

return main_camera
