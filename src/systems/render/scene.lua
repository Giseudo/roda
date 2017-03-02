local Tiny = require (LIB_PATH .. "tiny.tiny")
local Vector = require (LIB_PATH .. "hump.vector")
local SceneSystem = Tiny.system()

function SceneSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("camera", "transform", "name")

	return self
end

function SceneSystem:onAdd(e)
	self.bus:register("render/draw", function(dt)
		self:draw(e, dt)
	end)
end

function SceneSystem:draw(e, dt)
	e.camera:draw(function()
		self.bus:emit("scene/draw", dt)
		self.bus:emit("scene/debug/draw", dt)
	end)
end

return SceneSystem
