local Tiny = require (LIB_PATH .. "tiny.tiny")
local Vector = require (LIB_PATH .. "hump.vector")
local JumpSystem = Tiny.system()

function JumpSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("input", "transform", "rigidbody")

	return self
end

function JumpSystem:onAdd(e)
	self.bus:register("update", function (dt)
		self:update(e, dt)
	end)
end

-- Should subscribe to input system
function JumpSystem:update(e, dt)
	if e.rigidbody:isGrounded() and e.input:isJumping() then
		e.transform:translate(Vector(0, -1000), dt)
	end
end


return JumpSystem
