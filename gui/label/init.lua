local Class = require (LIB_PATH .. "hump.class")
local Vector = require (LIB_PATH .. "hump.vector")
local GUI = require (RODA_PATH .. "gui")

local Label = Class{
	__includes = GUI,
	text = ""
}

function Label:init(text, x, y)
	GUI.init(self)

	self.text = text
	self.position = Vector(x, y)
end

function Label:draw()
	love.graphics.print(self.text, self.position.x, self.position.y)
end

return Label
