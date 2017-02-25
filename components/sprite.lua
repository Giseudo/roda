local Class = require (LIB_PATH .. "hump.class")
local Sprite = Class{}

function Sprite:init(image, x, y, w, h)
	self.image = love.graphics.newImage(image)
	self.width = w
	self.height = h
	self.quad = love.graphics.newQuad(x, y, w, h, self.image:getDimensions())
end

function Sprite:draw(dt, position)
	love.graphics.draw(
		self.image,
		self.quad,
		position.x - self.width / 2,
		position.y - self.height / 2
	)
end

return Sprite
