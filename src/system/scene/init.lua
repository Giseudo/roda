local Class = require 'middleclass'
local Tiny = require 'tiny'
local Vector = require (RODA_LIB .. 'hump.vector')
local System = require (RODA_SRC .. 'system')
local ParentingSystem = require (RODA_SRC .. 'system.scene.parenting')

local scene_system = Class('SceneSystem', System)

function scene_system:initialize(bus)
	System.initialize(self, bus)

	self.filter = Tiny.requireAll('camera', 'transform')

	-- Init subsystems
	self.bus:emit('system/add', 'parenting', ParentingSystem(self.bus))
end

function scene_system:onAdd(e)
	self.bus:register('render/draw', function(dt)
		self:draw(e, dt)
	end)
end

function scene_system:draw(e, dt)
	e.camera:draw(function()
		self.bus:emit('scene/draw', dt)
		self.bus:emit('scene/debug/draw', dt)
	end)
end

return scene_system
