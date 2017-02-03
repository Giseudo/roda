local Class = require (LIB_PATH .. "hump.class")
local GUI = require (RODA_PATH .. "gui")

local Fieldset = Class{
	__includes = GUI,
	title = "Fieldset title",
	fields = {}
}

function Fieldset:init(title)
	GUI.init(self)

	self.title = title
end

function Fieldset:update()
end

function Fieldset:draw()
end

function Fieldset:setTitle(title)
	self.title = title
end

function Fieldset:addField(field)
	self:append(field)
end
