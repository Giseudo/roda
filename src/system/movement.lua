local movement = {}

function movement:new()
	return setmetatable({
		entities = {}
	}, { __index = self })
end

function movement:add(e)
	self.entities[#self.entities + 1] = e
end

function movement:update(dt)
	for _, entity in pairs(self.entities) do
		-- Reset acceleration every frame
		entity.body.acceleration.x = 0

		-- Check movement direction
		if entity.controller.forward then
			entity.body.acceleration.x = entity.controller.speed
		end

		if entity.controller.backward then
			entity.body.acceleration.x = -entity.controller.speed
		end

		if entity.controller.downward then
			entity.body.acceleration.y = -entity.controller.speed
		end

		if entity.controller.upward then
			entity.body.acceleration.y = entity.controller.speed
		end

		-- Apply friction
		entity.body.acceleration.x = entity.body.acceleration.x + entity.body.velocity.x * entity.body.friction.x
		entity.body.acceleration.y = entity.body.acceleration.y + entity.body.velocity.y * entity.body.friction.y

		-- Equations of motion
		entity.body.velocity = entity.body.velocity + entity.body.acceleration
		entity.transform.position = entity.transform.position + entity.body.velocity + 0.5 * entity.body.acceleration

		-- Reset controller direction
		entity.controller:reset()
	end
end

return setmetatable(movement, { __call = movement.new })
