local Class = require (LIB_PATH .. "hump.class")
local Sprite = Class{}

function Sprite:init(image)
	self.image = love.graphics.newImage(image)
	self.quad = love.graphics.newQuad(0, 0, 32, 32, self.image:getDimensions())
end

function Sprite:draw(dt, position)
	love.graphics.draw(
		self.image,
		self.quad,
		position.x,
		position.y
	)
end

return Sprite
