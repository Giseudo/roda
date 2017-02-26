local Tiny = require (LIB_PATH .. "tiny.tiny")
local Vector = require (LIB_PATH .. "hump.vector")
local GravitySystem = Tiny.system()

function GravitySystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("transform", "rigidbody")

	return self
end

function GravitySystem:onAdd(e)
	self.bus:register("update", function (dt)
		self:update(e, dt)
	end)
end

function GravitySystem:update(e, dt)
	if e.rigidbody.kinematic == false and e.rigidbody.gravity then
		e.transform:translate(Vector(0, 9.81), dt)
	end
end


return GravitySystem
