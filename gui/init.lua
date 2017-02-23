local Class = require (LIB_PATH .. "hump.class")
local Vector = require (LIB_PATH .. "hump.vector")

local GUI = Class{
	position = Vector(0, 0),
	width = 0,
	height = 0,
	padding = 0,
	margin = 0,
	texture = {},
	transition = 0,
	opacity = 0,
	parent = nil,
	children = {}
}

function GUI:init(parent)
	self.parent = parent

	if (self.parent) then
		self.parent:append(self)
	end
end

function GUI:draw()
	local offset = self.position + Vector(self.padding, self.padding)
	
	for i, child in pairs(self.children) do
		child:draw(offset)
	end
end

function GUI:prepend(node)
end

function GUI:append(node)
	table.insert(self.children, node)
end

function GUI:remove(node)
	self.children[node] = nil
end

function GUI:getWidth()
	local width = 0

	for i, child in pairs(self.children) do
		width = width + child:getWidth()
	end

	return width
end

function GUI:getHeight()
	local height = 0

	for i, child in pairs(self.children) do
		height = height + child:getHeight()
	end

	return height
end

function GUI:setPadding(padding)
	self.padding = padding
end

function GUI:find()
end

return GUI
