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

	-- Jump velocity
	if e.controller.jumping and e.body.grounded then
		e.body.velocity.y = e.body.jump_velocity
	end

	-- Jump limit
	Roda.bus:register('input/released', function(button)
		if e.body.velocity.y > 0 then
			if button == 'jump' then
				e.body.velocity.y = math.min(e.body.velocity.y, 2)
			end
		end
	end)

	-- Apply friction
	e.body.acceleration.x = e.body.acceleration.x + e.body.velocity.x * e.body.friction.x
	e.body.acceleration.y = e.body.acceleration.y + e.body.velocity.y * e.body.friction.y

	-- Equations of motion
	e.body.velocity = e.body.velocity + e.body.acceleration
	e.transform.position = e.transform.position + e.body.velocity + 0.5 * e.body.acceleration
end

return setmetatable(movement, {
	__call = movement.new
})
