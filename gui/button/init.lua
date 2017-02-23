local Class = require (LIB_PATH .. "hump.class")
local Vector = require (LIB_PATH .. "hump.vector")
local GUI = require (RODA_PATH .. "gui")

local Button = Class{
	__includes = GUI,
	disabled = false
}

function Button:init(texture, padding, parent)
	self.texture = texture
	self.padding = padding

	GUI.init(self, parent)
end

function Button:draw(offset)
	-- FIXME: Not every texture has slice size
	local offset = Vector(self.texture.slice, self.texture.slice)

	self.texture:draw(self.position)

	GUI.draw(self)
end

function Button:append(node)
	GUI.append(self, node)

	self.texture:setWidth(self:getWidth())
	self.texture:setHeight(self:getHeight())
end

function Button:setPadding(padding)
	GUI.setPadding(self, padding)

	self.texture:setWidth(self:getWidth())
	self.texture:setHeight(self:getHeight())
end

function Button:click()
end

return Button
