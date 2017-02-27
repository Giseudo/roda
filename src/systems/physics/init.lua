local Tiny = require (LIB_PATH .. "tiny.tiny")
local Bump = require (LIB_PATH .. "bump.bump")
local Vector = require (LIB_PATH .. "hump.vector")
local JumpSystem = require (RODA_PATH .. "systems.physics.jump")
local GravitySystem = require (RODA_PATH .. "systems.physics.gravity")
local PhysicsSystem = Tiny.system()

function PhysicsSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("transform", "rigidbody")
	self.bump = Bump.newWorld(32)

	-- Initialize Subsystems
	self.bus:emit("system/add", "jump", JumpSystem:new(self.bus))
	self.bus:emit("system/add", "gravity", GravitySystem:new(self.bus))

	return self
end

function PhysicsSystem:onAdd(e)
	self.bump:add(
		e,
		e.transform.position.x - e.rigidbody.width / 2,
		e.transform.position.y - e.rigidbody.height / 2,
		e.rigidbody.width,
		e.rigidbody.height
	)

	self.bus:register("physics/translate", function (entity, velocity)
		if entity ~= e then
			return
		end

		self:translate(entity, velocity)
	end)

	self.bus:register("scene/draw", function (dt)
		love.graphics.setColor(0, 255, 0, 150)
		love.graphics.rectangle(
			"line",
			self.bump:getRect(e)
		)
		love.graphics.setColor(255, 255, 255, 255)
	end)
end

function PhysicsSystem:translate(e, velocity)
	local actualX, actualY = self.bump:move(
		e,
		e.transform.position.x + velocity.x * love.timer.getDelta(),
		e.transform.position.y + velocity.y * love.timer.getDelta()
	)

	e.transform.position.x = actualX
	e.transform.position.y = actualY
end

function PhysicsSystem:translateTo(e, position)
	
end

return PhysicsSystem
