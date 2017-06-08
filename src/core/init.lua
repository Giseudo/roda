require (RODA_SRC .. 'core.shared')

local Tiny = require 'tiny'

local Camera = require (RODA_SRC .. 'entity.camera')
local Tilemap = require (RODA_SRC .. 'entity.tilemap')

local Logger = require (RODA_SRC .. 'core.logger')
local Resources = require (RODA_SRC .. 'core.resources')
local Graphics = require (RODA_SRC .. 'core.graphics')
local World = require (RODA_SRC .. 'core.world')
local Physics = require (RODA_SRC .. 'core.physics')

local core = {}
core.__index = core

function core:new()
	local o = {}

	o.shader = nil
	o.debug = true
	o.timer = 0
	o.background = love.graphics.newImage('assets/images/sky_night_01.png')
	o.glitch = love.graphics.newImage('assets/images/glitch.jpeg')
	o.bus = Signal()
	o.world = World()
	o.logger = Logger()
	o.graphics = Graphics()
	o.resources = Resources()
	o.physics = Physics()

	return setmetatable(o, core)
end

function core:run()
	self.graphics:init()
	self.physics:init()

	self.camera = Camera(Vector(0, 100), Vector(self.graphics.scale, self.graphics.scale))
	self.tilemap = Tilemap(0, 0, 128, 128)
	self.tilemap:init()
	self.canvas = love.graphics.newCanvas()
	self.editor = love.graphics.newCanvas()
end

function core:update(dt)
	self.camera:follow(Game.player)
	self.world:update(dt, Tiny.requireAll('isUpdateSystem'))
	self.timer = self.timer + dt

	print(love.timer.getFPS())
end

function core:draw()
	-- Reset graphics
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.clear(100, 100, 120, 255)

	-- Camera
	self.camera:set()
		-- Game canvas
		love.graphics.setCanvas(self.canvas)
			love.graphics.clear()
			Roda:set_shader('default')

			-- Background
			love.graphics.draw(
				self.background,
				self.camera.transform.position.x - self.camera.viewport.size.x / 2,
				self.camera.transform.position.y - self.camera.viewport.size.y / 2,
				0,
				self.graphics.scale / self.camera.transform.scale.x,
				self.graphics.scale / self.camera.transform.scale.y
			)

			-- Draw
			self.world:update(love.timer.getDelta(), Tiny.requireAll('isDrawingSystem'))
		love.graphics.setCanvas()
	self.camera:unset()

	-- Draw game
	Roda:set_shader('glitch')
	Roda.shader:send('iChannel1', self.glitch)
	Roda.shader:send('iGlobalTime', self.timer)
	love.graphics.draw(self.canvas)

	if self.debug then
		self.camera:set()
			love.graphics.setShader()
			self.tilemap:draw()
			self.world:update(dt, Tiny.requireAll('isDebugSystem'))
		self.camera:unset()
	end
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
