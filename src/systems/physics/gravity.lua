local Tiny = require (LIB_PATH .. "tiny.tiny")
local Vector = require (LIB_PATH .. "hump.vector")
local GravitySystem = Tiny.system()

function GravitySystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("transform", "rigidbody")
	self:setAcceleration(Vector(0, 0))

	self.bus:register("physics/gravity/set", function (acceleration)
		self:setAcceleration(acceleration)
	end)

	return self
end

function GravitySystem:onAdd(e)
	self.bus:register("update", function (dt)
		if e.rigidbody.kinematic == false then
			self.bus:emit("physics/translate", e, self.acceleration)
		end
	end)
end

function GravitySystem:setAcceleration(acceleration)
	self.acceleration = acceleration
	self.bus:emit("physics/gravity/changed", acceleration)
end

return GravitySystem
