local Tiny = require (LIB_PATH .. "tiny.tiny")
local Vector = require (LIB_PATH .. "hump.vector")
local JumpSystem = Tiny.system()

function JumpSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("transform", "rigidbody")

	return self
end

function JumpSystem:onAdd(e)
	self.bus:register("physics/jump", function (entity, velocity)
		if e.rigidbody:isGrounded() and e == entity then
			self.bus:emit("physics/translate", entity, velocity)
		end
	end)
end

return JumpSystem
