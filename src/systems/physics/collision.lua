local Tiny = require (LIB_PATH .. "tiny.tiny")
local CollisionSystem = Tiny.system()

function CollisionSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("transform", "rigidbody")

	return self
end

return CollisionSystem
