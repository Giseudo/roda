local Tiny = require (LIB_PATH .. "tiny.tiny")
local Vector = require (LIB_PATH .. "hump.vector")
local GravitySystem = Tiny.processingSystem()

GravitySystem.filter = Tiny.requireAll("transform", "rigidbody")

function GravitySystem:process(e, dt)
	if e.rigidbody.kinematic == false and e.rigidbody.gravity then
		e.transform:translate(Vector(0, -9.81), dt)
	end
end


return GravitySystem
