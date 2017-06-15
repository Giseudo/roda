require (RODA_SRC .. 'core.shared')

local Tiny = require 'tiny'

local Camera = require (RODA_SRC .. 'entity.camera')

local Logger = require (RODA_SRC .. 'core.logger')
local Resources = require (RODA_SRC .. 'core.resources')
local Graphics = require (RODA_SRC .. 'core.graphics')
local World = require (RODA_SRC .. 'core.world')
local Physics = require (RODA_SRC .. 'core.physics')
local Input = require (RODA_SRC .. 'core.input')
local Editor = require (RODA_SRC .. 'core.editor')

local core = {}
core.__index = core

function core:new()
	local o = {}

	o.shader = nil
	o.debug = true
	o.glitch = love.graphics.newImage('assets/images/glitch.jpeg')
	o.bus = Signal()
	o.world = World()
	o.logger = Logger()
	o.graphics = Graphics()
	o.resources = Resources()
	o.physics = Physics()
	o.input = Input()
	o.editor = Editor()

	return setmetatable(o, core)
end

function core:run()
	self.graphics:init()
	self.physics:init()
	self.input:init()
	self.editor:init()

	self.camera = Camera(Vector(0, 100), Vector(self.graphics.scale, self.graphics.scale))
	self.canvas = love.graphics.newCanvas()
	self.timer = 0
end

function core:update(dt)
	self.input:update(dt)
	self.camera:follow(Game.dummy)
	self.world:update(dt, Tiny.requireAll('isUpdateSystem'))
	self.timer = self.timer + dt
end

function core:draw()
	-- Reset graphics
	love.graphics.setColor(255, 255, 255, 255)

	-- Draw game
	self:set_shader('default')
	love.graphics.draw(self.canvas)

	-- Camera
	self.camera:set()
		love.graphics.setCanvas(self.canvas)
			love.graphics.clear(100, 100, 120, 255)

			-- Background
			love.graphics.draw(
				self.camera.background,
				self.camera.transform.position.x - (self.camera.background:getWidth() / 2) / self.camera.transform.scale.x,
				self.camera.transform.position.y - (self.camera.background:getHeight() / 2) / self.camera.transform.scale.y,
				0,
				self.graphics.scale / self.camera.transform.scale.x,
				self.graphics.scale / self.camera.transform.scale.y
			)

			-- Draw
			self.world:update(love.timer.getDelta(), Tiny.requireAll('isDrawingSystem'))

			-- Draw sprite batches
			for _, batch in pairs(self.graphics.batches) do
				love.graphics.draw(batch)
			end

			-- Draw debug
			if self.debug then
				love.graphics.setShader()
				self.world:update(dt, Tiny.requireAll('isDebugSystem'))
			end
		love.graphics.setCanvas()
	self.camera:unset()
end

function core:set_shader(name)
	self.shader = Roda.resources.shaders[name]
	love.graphics.setShader(self.shader)
end

function core:quit()
end

return setmetatable(core, {
	__call = core.new
})
