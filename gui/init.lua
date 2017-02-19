local Class = require (LIB_PATH .. "hump.class")

local GUI = Class{
	position = {},
	width = "auto",
	height = "auto",
	padding = {0, 0, 0, 0},
	margin = {0, 0, 0, 0},
	texture = {},
	transition = 0,
	opacity = 0,
	parent = {},
	children = {}
}

function GUI:init()
end

function GUI:draw()
	for child in pairs(self.children) do
		child:draw()
	end
end

function GUI:append()
end

function GUI:prepend()
end

function GUI:find()
end

return GUI
