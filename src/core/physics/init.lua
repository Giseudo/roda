local physics = {}
physics.__index = physics

function physics:new(gravity)
	local o = {}

	o.gravity = gravity or Vector(0, 0)
	o.quadtree = {}

	return setmetatable(o, physics)
end

function physics:init()
	Roda.bus:register('physics/quadtree/add', function(e)
		self.quadtree[#self.quadtree + 1] = e
	end)

	Roda.bus:register('physics/quadtree/remove', function(e)
		for i = 1, #self.quadtree do
			if self.quadtree[i] == e then
				self.quadtree[i] = nil
			end
		end
	end)
end

return setmetatable(physics, {
	__call = physics.new
})
