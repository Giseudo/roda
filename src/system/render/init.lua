local Class = require 'middleclass'
local Tiny = require 'tiny'
local System = require (RODA_SRC .. 'system')
local AnimationSystem = require (RODA_SRC .. 'system.render.animation')

local render_system = Class('RenderSystem', System)

function render_system:initialize(bus)
	System.initialize(self, bus)

	self.filter = Tiny.requireAll('sprite', 'transform')

	-- Create subsystems
	self:add_subsystem(AnimationSystem(self.bus))
end

function render_system:bind()
	self.bus:register('render/debug', function (value)
		self.debug = value
	end)
end

function render_system:on_add(e)
	self.bus:register('scene/camera/draw', function (dt)
		self:draw(e, dt)
	end)

	self.bus:register('scene/debug/draw', function (dt)
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
		'line',
		e.transform.position.x - (e.transform.scale.x * e.sprite.width) / 2,
		e.transform.position.y - (e.transform.scale.y * e.sprite.height) / 2,
		e.sprite.width * e.transform.scale.x,
		e.sprite.height * e.transform.scale.y,
		e.transform.rotation
	)
	love.graphics.setColor(255, 255, 255, 255)
end

return render_system
