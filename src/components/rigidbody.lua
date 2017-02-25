local Class = require (LIB_PATH .. "hump.class")
local Rigidbody = Class{}

function Rigidbody:init()
	self.shape = {}
end

return Rigidbody
