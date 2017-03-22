local Class = require 'middleclass'
local Tiny = require 'tiny'
local Camera = require (RODA_LIB .. 'hump.camera')
local Space = require (RODA_SRC .. 'core.scene.space')
local MainCamera = require (RODA_SRC .. 'entity.main_camera')

local scene = Class('Scene')

function scene:initialize(bus)
	self.bus = bus
	self.space = Space(bus)
	self.world = Tiny.world()
	self:bind()
	self:bootstrap()
end

function scene:bind()
	self.bus:register('draw', function(dt)
		self:draw(dt)
	end)

	self.bus:register('world/add', function(e)
		self.world:add(e)
		self.world:refresh()
	end)
end

function scene:bootstrap()
	self.view = MainCamera()
	self.view.camera.smoother = Camera.smooth.damped(10)
	self.bus:emit('world/add', self.view)
	self.bus:register('player/moved', function (e, dt) 
		self.view.camera:lockX(e.transform.position.x)
		self.view.camera:lockY(e.transform.position.y - 50)
	end)
end

function scene:draw(dt)
	self.bus:emit('scene/draw')
	self.view.camera:draw(function ()
		self.bus:emit('scene/camera/draw', dt)
		self.bus:emit('scene/debug/draw', dt)
	end)
end

return scene
