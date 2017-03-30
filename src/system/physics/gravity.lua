local Class = require 'middleclass'
local Tiny = require 'tiny'
local Vector = require (RODA_LIB .. 'hump.vector')
local System = require (RODA_SRC .. 'system')

local gravity_system = Class('GravitySystem', System)

function gravity_system:initialize()
	System.initialize(self)

	self.filter = Tiny.requireAll('transform', 'rigidbody')
	self:set_acceleration(Vector(0, 0))
end

function gravity_system:bind()
	roda.bus:register('physics/gravity/set', function (acceleration)
		self:set_acceleration(acceleration)
	end)
end

function gravity_system:on_add(e)
	roda.bus:register('update', function (dt)
		if e.rigidbody.kinematic == false then
			roda.bus:emit('physics/translate', e, self.acceleration)
		end
	end)
end

function gravity_system:set_acceleration(acceleration)
	self.acceleration = acceleration
	roda.bus:emit('physics/gravity/changed', acceleration)
end

return gravity_system
