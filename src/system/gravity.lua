local gravity = {}

function gravity:new()
	return setmetatable({
		entities = {}
	}, { __index = self })
end

function gravity:add(e)
	self.entities[#self.entities + 1] = e
end

function gravity:update(dt)
	for _, entity in pairs(self.entities) do
		-- Apply gravity force
		entity.body.acceleration.y = Roda.gravity

		-- Max gravity velocity
		if entity.body.velocity.y <= -10.0 then
			entity.body.velocity.y = -10.0
		end
	end
end

return setmetatable(gravity, { __call = gravity.new })
