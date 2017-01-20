local love = love
local Class = require (LIB_PATH .. "hump.class")
local Scheme = require (LIB_PATH .. "roda.input.scheme")

local Input = Class{
	bus = {},
	scheme = {},
	joysticks = {},
}

function Input:init(bus)
	self.bus = bus
	self.scheme = Scheme()
	self.joysticks = love.joystick.getJoysticks()

	-- Watch keyboard events
	function love.keypressed(key)
		self:keyPress(key)
	end

	function love.keyreleased(key)
		self:keyUp(key)
	end

	-- Watch joystick events
	function love.joystickreleased(joystick, button)
		--self:buttonUp(joystick, button)
	end
end

-- Keyboard key press
function Input:keyPress(key)
	if key == self.scheme.up then
		self.bus:post("input/key-press", { key = "up" })
	elseif key == self.scheme.down then
		self.bus:post("input/key-press", { key = "down" })
	elseif key == self.scheme.left then
		self.bus:post("input/key-press", { key = "left" })
	elseif key == self.scheme.right then
		self.bus:post("input/key-press", { key = "right"})
	end
end

-- Keyboard key up
function Input:keyUp(key)
	if key == self.scheme.up then
		self.bus:post("input/key-up", { key = "up" })
	elseif key == self.scheme.down then
		self.bus:post("input/key-up", { key = "down" })
	elseif key == self.scheme.left then
		self.bus:post("input/key-up", { key = "left" })
	elseif key == self.scheme.right then
		self.bus:post("input/key-up", { key = "right" })
	end
end

-- Joystick button up
function Input:buttonUp(joystick, button)
	if button == self.scheme.up then
		self.bus:post("input/button-up", { key = "up" })
	end
end

return Input
