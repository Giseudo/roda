local Class = require (LIB_PATH .. "hump.class")
local HumpCamera = require (LIB_PATH .. "hump.camera")

local Camera = Class{
	bus = {},
	main = {},
	gui = {}
}

function Camera:init(bus)
	self.bus = bus
	self.main = HumpCamera(0, 0, 2)
	self.gui = HumpCamera(0, 0, 1)

	self.bus:subscribe("update", function(message) self:update(message) end)
	self.bus:subscribe("render/draw", function(message) self:draw(message) end)
end

function Camera:update(message)
	--self.main:rotate(message.dt)
end

function Camera:draw()
	self.main:draw(function ()
		self.bus:post("camera/draw")
	end)

	self.gui:draw(function ()
		self.bus:post("camera/gui/draw")
	end)
end

return Camera
