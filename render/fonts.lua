local Class = require (LIB_PATH .. "hump.class")

local Fonts = Class{
	bus = {},
	fonts = {}
}

function Fonts:init(bus)
	self.bus = bus

	self.bus:subscribe("render/fonts/set", function(message) self:set(message) end)
	self.bus:subscribe("render/fonts/add-image", function(message) self:addImage(message) end)
end

function Fonts:set(message)
	love.graphics.setFont(self.fonts[message.name])
end

function Fonts:addImage(message)
	self.fonts[message.name] = love.graphics.newImageFont(message.file, message.chars)
end

return Fonts
