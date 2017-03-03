local Tiny = require (LIB_PATH .. "tiny.tiny")
local AnimationSystem = require (RODA_PATH .. "systems.render.animation")
local SceneSystem = require (RODA_PATH .. "systems.render.scene")
local RenderSystem = Tiny.system()

function RenderSystem:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("sprite", "transform")

	self.bus:emit("system/add", "animation", AnimationSystem:new(self.bus))
	self.bus:emit("system/add", "scene", SceneSystem:new(self.bus))

	self.bus:register("render/debug", function (value)
		self.debug = value
	end)

	return self
end

function RenderSystem:onAdd(e)
	self.bus:register("scene/draw", function (dt)
		self:draw(e, dt)
	end)
	self.bus:register("scene/debug/draw", function (dt)
		if self.debug then
			self:drawDebug(e, dt)
		end
	end)
end

function RenderSystem:draw(e, dt)
	love.graphics.draw(
		e.sprite.image,
		e.sprite.quad,
		e.transform.position.x - (e.transform.scale.x * e.sprite.width) / 2,
		e.transform.position.y - (e.transform.scale.y * e.sprite.height) / 2,
		e.transform.rotation,
		e.transform.scale.x,
		e.transform.scale.y
	)
end

function RenderSystem:drawDebug(e, dt)
	love.graphics.setColor(255, 0, 255, 150)
	love.graphics.rectangle(
		"line",
		e.transform.position.x - (e.transform.scale.x * e.sprite.width) / 2,
		e.transform.position.y - (e.transform.scale.y * e.sprite.height) / 2,
		e.sprite.width * e.transform.scale.x,
		e.sprite.height * e.transform.scale.y,
		e.transform.rotation
	)
	love.graphics.setColor(255, 255, 255, 255)
end


return RenderSystem
