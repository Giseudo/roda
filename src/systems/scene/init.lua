local Tiny = require "tiny"
local Vector = require (LIB_PATH .. "hump.vector")
local ParentingSystem = require (RODA_PATH .. "systems.scene.parenting")
local SceneSystem = Tiny.system()

function SceneSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("camera", "transform")

	-- Init subsystems
	self.bus:emit("system/add", "parenting", ParentingSystem:new(self.bus))

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
