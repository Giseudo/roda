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
	o.background = love.graphics.newImage('assets/images/sky_night_01.png')
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
	self.editor = love.graphics.newCanvas()
end

function core:update(dt)
	self.input:update(dt)
	self.camera:follow(Game.dummy)
	self.world:update(dt, Tiny.requireAll('isUpdateSystem'))
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

			-- Draw sprite batches
			for _, batch in pairs(self.graphics.batches) do
				love.graphics.draw(batch)
			end
		love.graphics.setCanvas()
	self.camera:unset()

	-- Draw game
	love.graphics.setShader()
	love.graphics.draw(self.canvas)

	if self.debug then
		self.camera:set()
			love.graphics.setShader()
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
