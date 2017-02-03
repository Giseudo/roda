local Class = require (LIB_PATH .. "hump.class")

local GUI = Class{
	position = {},
	width = "auto",
	height = "auto",
	padding = 0,
	margin = 0,
	color = { 255, 255, 255 },
	background = "",
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
