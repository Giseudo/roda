local Class = require (LIB_PATH .. "hump.class")
local Rigidbody = require (RODA_PATH .. "components.rigidbody")
local Transform = require (RODA_PATH .. "components.transform")
local Floor = Class{}

function Floor:init(position, width, height)
	self.transform = Transform(position)
	self.rigidbody = Rigidbody(width, height)
	self.rigidbody.kinematic = true
end

return Floor
