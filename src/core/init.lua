require (RODA_SRC .. 'core.shared')

local Tiny = require 'tiny'

local Logger = require (RODA_SRC .. 'core.logger')
local Resources = require (RODA_SRC .. 'core.resources')
local Graphics = require (RODA_SRC .. 'core.graphics')
local World = require (RODA_SRC .. 'core.world')
local Physics = require (RODA_SRC .. 'core.physics')
local Input = require (RODA_SRC .. 'core.input')
local Editor = require (RODA_SRC .. 'core.editor')
local Scene = require (RODA_SRC .. 'core.scene')

local core = {}
core.__index = core

function core:new()
	local o = {}

	o.shader = nil
	o.debug = true
	o.state = 'editor'
	o.glitch = love.graphics.newImage('assets/images/glitch.jpeg')
	o.bus = Signal()
	o.world = World()
	o.logger = Logger()
	o.graphics = Graphics()
	o.resources = Resources()
	o.physics = Physics()
	o.input = Input()
	o.editor = Editor()
	o.scene = Scene()

	return setmetatable(o, core)
end

function core:run()
	self.graphics:init()
	self.world:init()
	self.physics:init()
	self.input:init()
	self.editor:init()
	self.scene:init()

	self.canvas = love.graphics.newCanvas()
	self.timer = 0
end

function core:update(dt)
	self.input:update(dt)
	if self.state == 'game' then
		self.world:update(dt, Tiny.requireAll('isUpdateSystem'))
	end
	self.timer = self.timer + dt
end

function core:draw()
	-- Reset graphics
	love.graphics.setColor(255, 255, 255, 255)

	-- Draw game
	self:set_shader('default')
	love.graphics.draw(self.canvas)

	love.graphics.setCanvas(self.canvas)
		love.graphics.clear(100, 100, 120, 255)

		-- Draw
		self.world:update(love.timer.getDelta(), Tiny.requireAll('isDrawingSystem'))

		-- Draw debug
		if self.debug then
			self.world:update(dt, Tiny.requireAll('isDebugSystem'))
		end
	love.graphics.setCanvas()
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
