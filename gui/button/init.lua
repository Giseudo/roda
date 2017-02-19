local Class = require (LIB_PATH .. "hump.class")
local GUI = require (RODA_PATH .. "gui")
local TextureSlice = require (RODA_PATH .. "render.texture.slice")

local Button = Class{
	__includes = GUI,
	disabled = false
}

function Button:init(position, width, height)
	GUI.init(self)

	self.position = position
	self.width = width
	self.height = height
	self.texture = TextureSlice("lib/roda/assets/images/button.png", 8, width, height)
end

function Button:draw()
	self.texture:draw(self.position)
end

function Button:click()
end

return Button
