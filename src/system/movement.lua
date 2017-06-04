local Tiny = require 'tiny'
local movement = {}
movement.__index = movement

function movement:new()
	local o = setmetatable({
		filter = Tiny.requireAll('controller', 'body', 'transform'),
		isUpdateSystem = true
	}, movement)

	return Tiny.processingSystem(o)
end

function movement:process(e, dt)
	-- Reset acceleration every frame
	e.body.acceleration.x = Roda.physics.gravity.x

	-- Check movement direction
	if e.controller.forward then
		e.body.acceleration.x = e.controller.speed + Roda.physics.gravity.x
	end

	if e.controller.backward then
		e.body.acceleration.x = -e.controller.speed + Roda.physics.gravity.x
	end

	if e.controller.downward then
		e.body.acceleration.y = -e.controller.speed
	end

	if e.controller.upward then
		e.body.acceleration.y = e.controller.speed
	end

	-- Apply friction
	e.body.acceleration.x = e.body.acceleration.x + e.body.velocity.x * e.body.friction.x
	e.body.acceleration.y = e.body.acceleration.y + e.body.velocity.y * e.body.friction.y

	-- Equations of motion
	e.body.velocity = e.body.velocity + e.body.acceleration
	e.transform.position = e.transform.position + e.body.velocity + 0.5 * e.body.acceleration

	-- Reset controller direction
	e.controller:reset()
end

return setmetatable(movement, {
	__call = movement.new
})
