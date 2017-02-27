local Tiny = require (LIB_PATH .. "tiny.tiny")
local JumpSystem = require (RODA_PATH .. "systems.physics.jump")
local GravitySystem = require (RODA_PATH .. "systems.physics.gravity")
local PhysicsSystem = Tiny.system()

function PhysicsSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("transform", "rigidbody")

	-- Initialize Subsystems
	self.bus:emit("system/add", "jump", JumpSystem:new(self.bus))
	self.bus:emit("system/add", "gravity", GravitySystem:new(self.bus))

	return self
end

function PhysicsSystem:onAdd(e)
	self.bus:register("physics/translate", function (entity, velocity)
		self:translate(entity, velocity * love.timer.getDelta())
	end)
end

function PhysicsSystem:translate(e, velocity)
	e.transform.position = e.transform.position + velocity
end

function PhysicsSystem:translateTo(e, position)
	
end

return PhysicsSystem
