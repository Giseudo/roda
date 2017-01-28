local Class = require (LIB_PATH .. "hump.class")
local HumpCamera = require (LIB_PATH .. "hump.camera")

local Camera = Class{
	bus = {},
	humpCamera = {}
}

function Camera:init(bus)
	self.bus = bus
	self.humpCamera = HumpCamera(0, 0)

	self.bus:subscribe("update", function(message) self:update(message) end)
	self.bus:subscribe("render/draw", function(message) self:draw(message) end)
end

function Camera:update(message)
	self.humpCamera:rotate(message.dt)
end

function Camera:draw()
	self.humpCamera:draw(function ()
		self.bus:post("camera/draw")
	end)
end

return Camera
