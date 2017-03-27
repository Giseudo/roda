local Class = require 'middleclass'
local Tiny = require 'tiny'
local Vector = require (RODA_LIB .. 'hump.vector')
local System = require (RODA_SRC .. 'system')
local JumpSystem = require (RODA_SRC .. 'system.physics.jump')
local GravitySystem = require (RODA_SRC .. 'system.physics.gravity')

local physics_system = Class('PhysicsSystem', System)

function physics_system:initialize()
	System.initialize(self)

	self.filter = Tiny.requireAll('transform', 'rigidbody')

	-- Initialize Subsystems
	self:add_subsystem(JumpSystem())
	self:add_subsystem(GravitySystem())
end

function physics_system:bind()
	Roda.bus:register('physics/debug', function (value)
		self.debug = value
	end)

	Roda.bus:register('physics/translate', function (e, velocity)
		self:translate(e, velocity)
	end)
end

function physics_system:on_add(e)
	Roda.bus:emit('scene/space/add', e,
		e.transform.position.x - e.rigidbody.width / 2,
		e.transform.position.y - e.rigidbody.height / 2,
		e.rigidbody.width,
		e.rigidbody.height
	)

	Roda.bus:register('scene/debug/draw', function (dt)
		if (self.debug) then
			self:draw_debug(e, dt)
		end
	end)
end

function physics_system:translate(e, velocity)
	local actualX, actualY = Roda.space:move(
		e,
		(e.transform.position.x - e.rigidbody.width / 2) + velocity.x * love.timer.getDelta(),
		(e.transform.position.y - e.rigidbody.height / 2) + velocity.y * love.timer.getDelta()
	)

	e.transform.position.x = actualX + e.rigidbody.width / 2
	e.transform.position.y = actualY + e.rigidbody.height / 2
end

function physics_system:translateTo(e, position)
	
end

function physics_system:draw_debug(e, dt)
	love.graphics.setColor(0, 255, 0, 150)
	love.graphics.rectangle(
		'line',
		Roda.space:getRect(e)
	)
	love.graphics.setColor(255, 255, 255, 255)
end

return physics_system
