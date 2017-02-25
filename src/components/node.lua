local Class = require (LIB_PATH .. "hump.class")
local Node = Class{}

function Node:init(parent, children)
	self.parent = parent
	self.children = children
end

return Node
