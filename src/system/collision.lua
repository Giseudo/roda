local collision_system = {}

function collision_system:new()
	return setmetatable({
		entities = {}
	}, { __index = self })
end

function collision_system:add(e)
	self.entities[#self.entities + 1] = e
end

function collision_system:update(dt)
	for _, entity in pairs(self.entities) do
		-- Update shape position
		entity.collider.shape.position = entity.transform.position

		-- Check for collisions with entities on quadtree
		for _, entity2 in pairs(Roda.quadtree) do
			if entity ~= entity2 then
				self:resolve(entity, entity2)
			end
		end
	end
end

function collision_system:resolve(first, second)
	-- Return if shape is not solid
	if second.collider.solid ~= true then
		return
	end

	-- Get collision data
	local intersect, delta = first.collider:collides(second.collider)

	-- If collision happened
	if intersect then
		if intersect.x > intersect.y then
			first.body.velocity.x = 0
			first.body.acceleration.x = 0

			if delta.x > 0.0 then
				first.transform.position.x = first.transform.position.x - intersect.x
			else
				first.transform.position.x = first.transform.position.x + intersect.y
			end
		else
			first.body.velocity.y = 0
			first.body.acceleration.y = 0

			if delta.y > 0.0 then
				first.transform.position.y = first.transform.position.y - intersect.y
			else
				first.transform.position.y = first.transform.position.y + intersect.y
			end
		end
	end
end


return setmetatable(collision_system, { __call = collision_system.new })
