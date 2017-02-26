local Class = require (LIB_PATH .. "hump.class")
local Rigidbody = require (RODA_PATH .. "components.rigidbody")
local Sprite = require (RODA_PATH .. "components.sprite")
local Transform = require (RODA_PATH .. "components.transform")
local Velvet = Class{}

function Velvet:init(position)
	self.transform = Transform(position)
	self.sprite = Sprite("lib/roda/assets/images/Velvet.png", 32, 32, 0)
	self.rigidbody = Rigidbody()
end

return Velvet
