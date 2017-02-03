local Class = require(LIB_PATH .. "hump.class")

local Console = Class{
	bus = nil
}

function Console:init(bus)
	self.bus = bus

	-- Subscribe to message bus
	self.bus:subscribe("update", function(message) self:update(message) end)
	self.bus:subscribe("camera/gui/draw", function(message) self:draw(message) end)
	self.bus:subscribe("console/log", function(message) self:log(message) end)
end

function Console:update()
end

function Console:draw()

end

function Console:log(message)

end

function Console:print(message)

end

function Console:warn(message)

end

function Console:error(message)

end

function Console:fatal(message)

end

return Console
