local Tiny = require "tiny"
local InputSystem = Tiny.system()

function InputSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("device")

	return self
end

function InputSystem:onAdd(e)
	self.bus:register("update", function (dt)
		self:update(e, dt)
	end)
end

function InputSystem:update(e, dt)
	for key, value in pairs(e.device) do
		if love.keyboard.isDown(value) then
			self.bus:emit("input/key-down", key)
		end
	end

	function love.keyreleased(released)
		for key, value in pairs(e.device) do
			if released == value then
				self.bus:emit("input/key-released", key)
			end
		end
	end
end


return InputSystem
