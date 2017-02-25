local Tiny = require (LIB_PATH .. "tiny.tiny")
local Vector = require (LIB_PATH .. "hump.vector")
local GravitySystem = Tiny.processingSystem()

GravitySystem.filter = Tiny.requireAll("transform", "velocity", "rigidbody")

function GravitySystem:process(e, dt)
	local acceleration = Vector(0, -9.81)

	e.transform.position = e.transform.position + (acceleration * dt)
end


return GravitySystem
