local Class = require (LIB_PATH .. "hump.class")

local Texture = Class{
	color = "",
	image = {}
}

function Texture:init(image)
	self.image = love.graphics.newImage(image)
end

function Texture:draw()
end

return Texture
