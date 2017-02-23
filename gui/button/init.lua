local Class = require (LIB_PATH .. "hump.class")
local Vector = require (LIB_PATH .. "hump.vector")
local GUI = require (RODA_PATH .. "gui")
local TextureSlice = require (RODA_PATH .. "render.texture.slice")

local Button = Class{
	__includes = GUI,
	disabled = false
}

function Button:init(file, slice, parent)
	self.texture = TextureSlice(
		file,
		slice,
		self:getWidth(),
		self:getHeight()
	)

	GUI.init(self, parent)
end

function Button:draw()
	self.texture:draw(
		self.position,
		self.padding
	)

	GUI.draw(self)
end

function Button:append(node)
	GUI.append(self, node)

	self.texture:setWidth(self:getWidth())
	self.texture:setHeight(self:getHeight())
end

function Button:click()
end

return Button
