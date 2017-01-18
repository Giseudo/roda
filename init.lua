local Class = require (LIB_PATH .. "hump.class")
local MessageBus = require (LIB_PATH .. "roda.message-bus")

local Engine = Class{
	bus = MessageBus()
}

function Engine:init()
	print("Init: Engine")
end

return Engine
