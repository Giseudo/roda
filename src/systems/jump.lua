local Tiny = require (LIB_PATH .. "tiny.tiny")
local Vector = require (LIB_PATH .. "hump.vector")
local JumpSystem = Tiny.processingSystem()

JumpSystem.filter = Tiny.requireAll("input", "transform", "rigidbody")

-- Should subscribe to input system

function JumpSystem:process(e, dt)
	if e.rigidbody:isGrounded() and e.input:isJumping() then
		e.transform:translate(Vector(0, 1000), dt)
	end
end


return JumpSystem
