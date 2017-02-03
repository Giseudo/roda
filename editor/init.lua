local Class = require (LIB_PATH .. "hump.class")
local Label = require (RODA_PATH .. "gui.label")

local Editor = Class{
	bus = {},
	label = {}
}

function Editor:init(bus)
	self.bus = bus
	self.label = Label("Lorem ipsum sit amet")

	self.bus:subscribe("camera/gui/draw", function(message) self:draw(message) end)
end

function Editor:draw()
	self.label:draw()
end

return Editor
