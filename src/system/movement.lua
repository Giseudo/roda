local Tiny = require 'tiny'
local movement = {}
movement.__index = movement

function movement:new()
	local o = setmetatable({
		dash_timer = 0,
		filter = Tiny.requireAll('controller', 'body', 'transform'),
		isUpdateSystem = true
	}, movement)

	return Tiny.processingSystem(o)
end

function movement:process(e, dt)
	if Vector.distance(e.transform.position, Roda.scene.camera.transform.position) > 320 then
		return
	end

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

	-- Reset flying state
	if e.body.grounded then
		e.controller.flying = false
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

	if e.controller.forward or e.controller.backward then
		if e.transform.facing == 'forward' and e.controller.backward then
			e.transform.facing = 'backward'
			e.transform.scale.x = e.transform.scale.x * - 1
		end

		if e.transform.facing == 'backward' and e.controller.forward then
			e.transform.facing = 'forward'
			e.transform.scale.x = e.transform.scale.x * -1
		end
	end

	-- Apply friction
	e.body.acceleration.x = e.body.acceleration.x + e.body.velocity.x * e.body.friction.x
	e.body.acceleration.y = e.body.acceleration.y + e.body.velocity.y * e.body.friction.y

	-- Equations of motion
	e.body.velocity = e.body.velocity + e.body.acceleration * dt
	e.transform.position = e.transform.position + e.body.velocity + 0.5 * e.body.acceleration

	if e.transform.position.y > 120 then
		e.transform.position.y = 120
	elseif e.transform.position.y < -120 then
		Roda.bus:emit('entity/dropped', e)
	end

	if e.transform.position.x < -4000 then
		e.transform.position.x = -4000
	elseif e.transform.position.x > 4000 then
		e.transform.position.x = 4000
	end

	-- Reset controller direction
	e.controller:reset()
end

return setmetatable(movement, {
	__call = movement.new
})
