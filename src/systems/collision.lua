local Tiny = require (LIB_PATH .. "tiny.tiny")
local CollisionSystem = Tiny.processingSystem()

function CollisionSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("transform", "rigidbody")

	-- Subscribes to world/created event
	self.bus:register("world/created", function (world)
		world:add(self)
	end)

	return self
end

function CollisionSystem:process(e, dt)
end


return CollisionSystem
