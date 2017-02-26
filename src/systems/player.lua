local Tiny = require (LIB_PATH .. "tiny.tiny")
local Vector = require (LIB_PATH .. "hump.vector")
local PlayerSystem = Tiny.system()

function PlayerSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("input", "transform", "rigidbody")

	return self
end

function PlayerSystem:onAdd(e)
	self.bus:register("update", function (dt)
		self:update(e, dt)
	end)
end

-- Should subscribe to input system
function PlayerSystem:update(e, dt)
	if love.keyboard.isDown("left") then
		e.transform:translate(Vector(-200, 0), dt)
	end

	if love.keyboard.isDown("right") then
		e.transform:translate(Vector(200, 0), dt)
	end
end


return PlayerSystem
