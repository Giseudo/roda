local Class = require (LIB_PATH .. "hump.class")
local Signal = require (LIB_PATH .. "hump.signal")

local MessageBus = Class{
	signal = nil
}

function MessageBus:init()
	self.signal = Signal.new()
end

function MessageBus:subscribe(name, callback)
	self.signal:register(name, callback);
end

function MessageBus:unsubscribe(name, callback)
	self.signal:remove(name, callback)
end

function MessageBus:post(name, payload)
	self.signal:emit(name, payload)
end

return MessageBus
