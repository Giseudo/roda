local love = love
local Class = require (LIB_PATH .. "hump.class")
local Scheme = require (LIB_PATH .. "roda.input.scheme")

local Input = Class{
	bus = nil,
	scheme = nil
}

function Input:init(bus)
	self.bus = bus
	self.scheme = Scheme()

	-- Watch love's input key press events
	function love.keyreleased(key)
		self:onKeyUp(key)
	end
end

function Input:onKeyUp(key)
	if (key == self.scheme.up) then
		self.bus:post("input/key-up", "up")
	end
end

return Input
