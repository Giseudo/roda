local Class = require (LIB_PATH .. "hump.class")
local Velocity = require (RODA_PATH .. "components.velocity")
local Rigidbody = require (RODA_PATH .. "components.rigidbody")
local Player = Class{}

function Player:init(transform, sprite)
	self.transform = transform
	self.sprite = sprite
	self.velocity = Velocity()
	self.rigidbody = Rigidbody()
end

function Player:update(dt)
end

return Player
