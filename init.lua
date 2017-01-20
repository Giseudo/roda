local Class = require (LIB_PATH .. "hump.class")
local MessageBus = require (LIB_PATH .. "roda.message-bus")
local Input = require (LIB_PATH .. "roda.input")

local Engine = Class{
	bus = nil,
	input = nil
}

function Engine:init()
	self.bus = MessageBus()
	self.input = Input(self.bus)
end

function Engine:update(dt)
end

return Engine
