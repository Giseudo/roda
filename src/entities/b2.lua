local Class = require (LIB_PATH .. "hump.class")
local Rigidbody = require (RODA_PATH .. "components.rigidbody")
local Sprite = require (RODA_PATH .. "components.sprite")
local Transform = require (RODA_PATH .. "components.transform")
local Device = require (RODA_PATH .. "components.device")
local Animator = require (RODA_PATH .. "components.animator")
local B2 = Class{}

function B2:init(position)
	self.transform = Transform(position)
	self.sprite = Sprite("lib/roda/assets/images/B2.png", 32, 32, 0)
	self.rigidbody = Rigidbody(32, 32)
	self.device = Device()
	self.animator = Animator("idle", 0, 3, 0.3)
	--self.rigidbody.kinematic = true
end

return B2
