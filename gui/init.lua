local Class = require (LIB_PATH .. "hump.class")
local Vector = require (LIB_PATH .. "hump.vector")

local GUI = Class{
	position = nil,
	padding = nil,
	margin = nil,
	texture = {},
	transition = 0,
	opacity = 0,
	parent = nil,
	children = {}
}

function GUI:init(parent)
	self.parent = parent
	self.position = Vector(0, 0)
	self.padding = Vector(0, 0)
	self.margin = Vector(0, 0)

	if (self.parent) then
		self.parent:append(self)
	end
end

function GUI:draw()
	for i, child in pairs(self.children) do
		child:draw(self.position + self.padding)
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
	local width = self.padding.x * 2

	for i, child in pairs(self.children) do
		width = width + child:getWidth()
	end

	return width
end

function GUI:getHeight()
	local height = self.padding.y * 2

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
