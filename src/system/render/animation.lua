local Class = require 'middleclass'
local Tiny = require 'tiny'
local System = require (RODA_SRC .. 'system')

local animation_system = Class('AnimationSystem', System)

function animation_system:initialize()
	System.initialize(self)

	self.filter = Tiny.requireAll('animator', 'sprite')
end

function animation_system:on_add(e)
	Roda.bus:register('update', function (dt)
		self:update(e, dt)
	end)
end

function animation_system:update(e, dt)
	if e.animator.current == nil then
		return
	end

	if e.animator.timer > e.animator.current.framerate then
		e.sprite:set_frame(e.animator:next())
		e.animator.timer = 0
	else
		e.animator.timer = e.animator.timer + dt
	end
end

return animation_system
