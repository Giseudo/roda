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

	self.camera = Camera(Vector(0, 100), Vector(2, 2))
	self.tilemap = Tilemap(0, 0, 128, 128)
	self.tilemap:init()
	self.canvas = love.graphics.newCanvas()
end

function core:update(dt)
	self.camera:follow(Game.player)
	self.world:update(dt, Tiny.requireAll('isUpdateSystem'))
	self.timer = self.timer + dt
end

function core:draw()
	Roda:set_shader('glitch')
	local image1 = love.graphics.newImage('assets/images/glitch.jpeg')
	Roda.shader:send('iChannel1', image1)
	Roda.shader:send('iGlobalTime', self.timer)
	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.draw(self.canvas)

	-- Set view matrix
	self.camera:set()
		love.graphics.setCanvas(self.canvas)
			love.graphics.clear(100, 100, 120, 255)
			self:set_shader('default')

			-- Draw
			self.world:update(love.timer.getDelta(), Tiny.requireAll('isDrawingSystem'))
		love.graphics.setCanvas()

		-- Debug
		if self.debug then
			self.tilemap:draw()
			self.world:update(dt, Tiny.requireAll('isDebugSystem'))
		end

	-- Unset
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
