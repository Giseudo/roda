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
		e.animator:set("run")
		if (e.transform.scale.x > 0) then
			e.transform.scale.x = -1 * e.transform.scale.x
		end
		self.bus:emit("physics/translate", e, Vector(-200, 0))
	end)

	self.bus:register("input/key-down/right", function ()
		e.animator:set("run")
		if (e.transform.scale.x < 0) then
			e.transform.scale.x = -1 * e.transform.scale.x
		end
		self.bus:emit("physics/translate", e, Vector(200, 0))
	end)

	self.bus:register("input/key-released/left", function ()
		e.animator:set("idle")
	end)

	self.bus:register("input/key-released/right", function ()
		e.animator:set("idle")
	end)

	self.bus:register("input/key-down/jump", function ()
		self.bus:emit("physics/translate", e, Vector(0, -1) * 450)
	end)
end

return PlayerSystem
