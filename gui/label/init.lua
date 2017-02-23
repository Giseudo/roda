local Class = require (LIB_PATH .. "hump.class")
local Vector = require (LIB_PATH .. "hump.vector")
local GUI = require (RODA_PATH .. "gui")

local Label = Class{
	__includes = GUI,
	text = "",
	font = {}
}

function Label:init(text, parent)
	self.text = text
	self.font = love.graphics.newImageFont("lib/roda/assets/fonts/glyph.png",
		" abcdefghijklmnopqrstuvwxyz" ..
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
		"123456789.,!?-+/():;%&`'*#=[]\""
	)

	GUI.init(self, parent)
end

function Label:draw(offset)
	offset = offset + self.padding 

	love.graphics.setFont(self.font)

	love.graphics.print(
		self.text,
		self.position.x + offset.x,
		self.position.y + offset.y
	)
end

function Label:getWidth()
	return GUI.getWidth(self) + self.font:getWidth(self.text)
end

function Label:getHeight()
	return GUI.getHeight(self) + self.font:getHeight()
end

return Label
