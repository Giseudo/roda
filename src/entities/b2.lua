local Class = require (LIB_PATH .. "hump.class")
local Rigidbody = require (RODA_PATH .. "components.rigidbody")
local Sprite = require (RODA_PATH .. "components.sprite")
local Transform = require (RODA_PATH .. "components.transform")
local Input = require (RODA_PATH .. "components.input")
local Animator = require (RODA_PATH .. "components.animator")
local B2 = Class{}

function B2:init(position)
	self.transform = Transform(position)
	self.sprite = Sprite("lib/roda/assets/images/B2.png", 32, 32, 0)
	self.rigidbody = Rigidbody()
	self.input = Input()
	self.animator = Animator("idle", 0, 3, 0.3)
end

function B2:update(dt)
end

return B2
