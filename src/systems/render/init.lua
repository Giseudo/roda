local Tiny = require "tiny"
local AnimationSystem = require (RODA_PATH .. "systems.render.animation")
local render_system = Tiny.system()

function render_system:new(bus)
	self.bus = bus
	self.filter = Tiny.requireAll("sprite", "transform")

	-- Init subsystems
	self.bus:emit("system/add", "animation", AnimationSystem(self.bus))

	self.bus:register("render/debug", function (value)
		self.debug = value
	end)

	return self
end

function render_system:onAdd(e)
	self.bus:register("scene/draw", function (dt)
		self:draw(e, dt)
	end)

	self.bus:register("scene/debug/draw", function (dt)
		if self.debug then
			self:draw_debug(e, dt)
		end
	end)
end

function render_system:draw(e, dt)
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

function render_system:draw_debug(e, dt)
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

return setmetatable(render_system, { __call = render_system.new })
