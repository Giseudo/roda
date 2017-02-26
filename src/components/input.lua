local Class = require (LIB_PATH .. "hump.class")
local Input = Class{}

function Input:init()
end

function Input:isJumping()
	return love.keyboard.isDown("space")
end

return Input
