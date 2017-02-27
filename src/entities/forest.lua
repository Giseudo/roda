local Class = require (LIB_PATH .. "hump.class")
local Camera = require (LIB_PATH .. "hump.camera")
local Transform = require (RODA_PATH .. "components.transform")
local Forest = Class{}

function Forest:init(position)
	self.camera = Camera(position.x, position.y, 2)
	self.transform = Transform(position)
	self.name = "forest"
end

return Forest
