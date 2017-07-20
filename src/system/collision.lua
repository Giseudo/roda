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

function collision:onRemove(e)
	Roda.bus:emit('physics/quadtree/remove', e)
end

function collision:process(e, dt)
	-- Update shape position
	e.collider.shape.position = e.transform.position

	if math.abs(e.transform.position.x - Game.sparkle.transform.position.x) > 300 then
		return
	end

	-- Check for collisions with entities on quadtree
	for _, other in pairs(Roda.physics.quadtree) do
		if e ~= other and e.body ~= nil then
			self:resolve(e, other)

			if e.body.velocity.y > 0 then
				e.body.grounded = false
			end
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
				first.transform.position.x = first.transform.position.x + intersect.x
			end
		else
			if delta.y > 0.0 then
				first.transform.position.y = first.transform.position.y - intersect.y
			else
				first.transform.position.y = first.transform.position.y + intersect.y
			end

			first.body.velocity.y = 0
			first.body.acceleration.y = 0
		end

		if first.kinematic then
			return
		end

		-- Check if body is grounded
		local half = second.collider.shape:get_half()
		local dx = first.transform.position.x - second.transform.position.x
		local px = half.x - math.abs(dx)
		local dy = first.collider.shape:get_bottom() - second.collider.shape.position.y - 1
		local py = half.y - math.abs(dy)

		if px > 0 and py > 0 then
			first.body.grounded = true
		else
			first.body.grounded = false
		end

		if second.name == 'hand' and first.body.grounded then
			-- TODO
		end
	end
end

return setmetatable(collision, {
	__call = collision.new
})
