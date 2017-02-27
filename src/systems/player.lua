local Tiny = require (LIB_PATH .. "tiny.tiny")
local Vector = require (LIB_PATH .. "hump.vector")
local PlayerSystem = Tiny.system()

function PlayerSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("device", "transform", "rigidbody")

	return self
end

function PlayerSystem:onAdd(e)
	self.bus:register("input/key-down/left", function ()
		self.bus:emit("physics/translate", e, Vector(-300, 0))
	end)

	self.bus:register("input/key-down/right", function ()
		self.bus:emit("physics/translate", e, Vector(300, 0))
	end)

	self.bus:register("input/key-down/jump", function ()
		self.bus:emit("physics/jump", e, Vector(0, -1200))
	end)
end

return PlayerSystem
