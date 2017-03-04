local Class = require (LIB_PATH .. "hump.class")
local GameObject = Class{
	active = true,
	parent = nil,
	children = {},
	layer = 1
}

function GameObject:init(name)
	self.name = name
end

return GameObject
