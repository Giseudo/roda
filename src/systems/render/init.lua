local Tiny = require (LIB_PATH .. "tiny.tiny")
local AnimationSystem = require (RODA_PATH .. "systems.render.animation")
local SceneSystem = require (RODA_PATH .. "systems.render.scene")
local RenderSystem = Tiny.system()

function RenderSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("sprite", "transform")

	self.bus:emit("system/add", "animation", AnimationSystem:new(self.bus))
	self.bus:emit("system/add", "scene", SceneSystem:new(self.bus))

	return self
end

function RenderSystem:onAdd(e)
	self.bus:register("scene/draw", function (dt)
		self:draw(e, dt)
	end)
end

function RenderSystem:draw(e, dt)
	love.graphics.draw(
		e.sprite.image,
		e.sprite.quad,
		e.transform.position.x - e.sprite.width / 2,
		e.transform.position.y - e.sprite.height / 2
	)
end


return RenderSystem
