local Class = require 'middleclass'

local sprite = Class('Sprite')

function sprite:initialize(image, width, height, frame)
	self.image = love.graphics.newImage(image)
	self.width = width
	self.height = height
	self:set_frame(frame)
end

function sprite:set_frame(frame)
	self.frame = frame

	self.quad = love.graphics.newQuad(
		frame * self.width,
		0,
		self.width,
		self.height,
		self.image:getDimensions()
	)
end

return sprite
