local Class = require (LIB_PATH .. "hump.class")
local Vector = require (LIB_PATH .. "hump.vector")
local Sprite = require (RODA_PATH .. "components.sprite")
local Player = Class{}

function Player:init(x, y)
	self.position = Vector(x, y)
	self.sprite = Sprite("lib/roda/assets/images/velvet.png", 0, 0, 32, 32)
end

function Player:update(dt)
end

return Player
