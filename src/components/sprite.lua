local Class = require (LIB_PATH .. "hump.class")
local Sprite = Class{
	frame = 0
}

function Sprite:init(image, width, height, frame)
	self.image = love.graphics.newImage(image)
	self.width = width
	self.height = height
	self:setFrame(frame)
end

function Sprite:setFrame(frame)
	self.frame = frame

	self.quad = love.graphics.newQuad(
		frame * self.width,
		0,
		self.width,
		self.height,
		self.image:getDimensions()
	)
end

return Sprite
