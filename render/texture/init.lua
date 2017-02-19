local Class = require (LIB_PATH .. "hump.class")

local Texture = Class{
	color = "",
	width = 0,
	height = 0,
	image = {}
}

function Texture:init(file, width, height)
	self.image = love.graphics.newImage(file)
	self.width = width
	self.height = height
end

function Texture:draw()
end

return Texture
