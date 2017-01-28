local Class = require(LIB_PATH .. "hump.class")

local Console = Class{
	bus = nil
}

function Console:init(bus)
	self.bus = bus

	-- Subscribe to message bus
	self.bus:subscribe("update", function (message) self:update(message) end)
	self.bus:subscribe("camera/draw", function (message) self:draw(message) end)
end

function Console:update()
end

function Console:draw()
	love.graphics.print("Hello World!", 0, 0)
end

return Console
