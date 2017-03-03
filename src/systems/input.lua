local Tiny = require (LIB_PATH .. "tiny.tiny")
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
	if love.keyboard.isDown(e.device.left) then
		self.bus:emit("input/key-down/left")
	end
	if love.keyboard.isDown(e.device.right) then
		self.bus:emit("input/key-down/right")
	end
	if love.keyboard.isDown(e.device.up) then
		self.bus:emit("input/key-down/up")
	end
	if love.keyboard.isDown(e.device.down) then
		self.bus:emit("input/key-down/down")
	end
	if love.keyboard.isDown(e.device.jump) then
		self.bus:emit("input/key-down/jump")
	end

	function love.keyreleased(key)
		if e.device.left == key then
			self.bus:emit("input/key-released/left")
		end
		if e.device.right == key then
			self.bus:emit("input/key-released/right")
		end
	end
end


return InputSystem
