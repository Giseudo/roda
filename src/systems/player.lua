local Tiny = require "tiny"
local Vector = require (LIB_PATH .. "hump.vector")
local PlayerSystem = Tiny.system()

function PlayerSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("device", "transform", "rigidbody")

	return self
end

function PlayerSystem:onAdd(e)
	self:subscribe(e)
end

function PlayerSystem:subscribe(e)
	self.bus:register("input/key-down", function (key)
		if key == "left" then
			e.animator:set("run")
			if (e.transform.scale.x > 0) then
				e.transform.scale.x = -1 * e.transform.scale.x
			end
			self.bus:emit("physics/translate", e, Vector(-200, 0))
		end

		if key == "right" then
			e.animator:set("run")
			if (e.transform.scale.x < 0) then
				e.transform.scale.x = -1 * e.transform.scale.x
			end
			self.bus:emit("physics/translate", e, Vector(200, 0))
		end
	end)

	self.bus:register("input/key-released", function (key)
		if key == "left" or key == "right" then
			e.animator:set("idle")
		end
	end)

	self.bus:register("input/key-down", function (key)
		if key == "jump" then
			self.bus:emit("physics/translate", e, Vector(0, -1) * 450)
		end
	end)
end

return PlayerSystem
