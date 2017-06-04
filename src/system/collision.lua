local Tiny = require 'tiny'

local collision = {}
collision.__index = collision

function collision:new()
	local o = setmetatable({
		filter = Tiny.requireAll('collider', 'transform'),
		isUpdateSystem = true
	}, collision)

	return Tiny.processingSystem(o)
end

function collision:onAdd(e)
	Roda.bus:emit('physics/quadtree/add', e)
end

function collision:process(e, dt)
	-- Update shape position
	e.collider.shape.position = e.transform.position

	-- Check for collisions with entities on quadtree
	for _, other in pairs(Roda.physics.quadtree) do
		if e ~= other then
			self:resolve(e, other)
		end
	end
end

function collision:resolve(first, second)
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

return setmetatable(collision, {
	__call = collision.new
})
