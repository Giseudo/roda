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

local gameover_index = 0
local gameover_timer = 0
local ending_index = 0
local ending_timer = 0
local ending_timer_2 = 0
local retry_index = 0

local core = {}
core.__index = core

function core:new()
	local o = {}

	love.filesystem.setIdentity('gmtk2017', true)

	o.shader = nil
	o.debug = false
	o.retry = false
	o.state = 'intro'
	o.glitch = love.graphics.newImage('assets/textures/glitch.jpg')
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
	self.time = 0

	Roda.bus:register('input/keyboard/pressed', function(key)
		if Roda.state == 'intro' then
			if key == 'down' or key == 'up' then
				if menu_index == 0 then
					menu_index = 1
				else
					menu_index = 0
				end
			end

			if key == 'space' or key == 'return' then
				if menu_index == 0 then
					intro_index = 0
					intro_timer = 0
					Roda.state = 'game'
				elseif menu_index == 1 then
					love.event.quit()
				end
			end
		elseif Roda.retry then
			if key == 'down' or key == 'up' then
				if retry_index == 0 then
					retry_index = 1
				else
					retry_index = 0
				end
			end

			if key == 'space' or key == 'return' then
				Roda.retry = false
				if retry_index == 0 then
					Roda.bus:emit('scene/load', 'entities')
					Roda.state = 'game'
				else
					Roda.state = 'intro'
					Roda.bus:emit('scene/load', 'entities')
				end
			end
		end
	end)
end

function core:update(dt)
	self.input:update(dt)

	if self.state == 'game' then
		self.world:update(dt, Tiny.requireAll('isUpdateSystem'))
		self.scene:update(dt)
	end

	if self.debug then
		self.editor:update()
	end

	if self.retry then
		gameover_timer = gameover_timer + dt
	end

	if self.state == 'ending' then
		ending_timer = ending_timer + dt
		ending_timer_2 = ending_timer_2 + dt
	end

	self.delta = dt

	self.time = self.time + dt
end

function core:draw()
	love.graphics.setCanvas(self.canvas)
		love.graphics.clear(100, 100, 120, 255)
		self:set_shader('default')

		if self.scene.camera.background then
			love.graphics.draw(self.scene.camera.background,
				0, 0, 0,
				self.graphics.scale, self.graphics.scale
			)
		end

		-- Draw
		self.world:update(self.delta, Tiny.requireAll('isDrawingSystem'))

		-- Draw debug
		if self.debug then
			self.world:update(self.delta, Tiny.requireAll('isDebugSystem'))
			self.scene.ground:debug()
		end
	love.graphics.setCanvas()

	if self.debug then
		self.editor:draw()
	end

	if self.retry then
		Roda:set_shader('default')
		love.graphics.setColor(0, 0, 0, 140)
		love.graphics.rectangle(
			'fill',
			0, 0,
			480 * 2,
			270 * 2
		)
		love.graphics.setColor(255, 255, 255, 255)

		love.graphics.draw(
			Game.gameover.batch:getTexture(),
			Game.gameover.quads[gameover_index],
			love.graphics.getWidth() / 2,
			love.graphics.getHeight() / 3,
			0,
			2, -2,
			Game.gameover.width / 2,
			Game.gameover.height / 2
		)

		love.graphics.draw(
			Game.retry.batch:getTexture(),
			Game.retry.quads[retry_index],
			love.graphics.getWidth() / 2, love.graphics.getHeight() - 150,
			0,
			2, -2,
			Game.retry.width / 2,
			Game.retry.height / 2
		)

		if gameover_timer > 0.1 then
			gameover_index = gameover_index + 1
			gameover_timer = 0
		end

		if gameover_index > 5 then
			gameover_index = 0
		end
	end

	if Roda.state == 'ending' then
		love.graphics.clear(100, 100, 120, 255)
		Roda:set_shader('default')
		love.graphics.draw(
			Game.ending.batch:getTexture(),
			Game.ending.quads[ending_index],
			love.graphics.getWidth() / 2, love.graphics.getHeight() / 2,
			0,
			2, -2,
			Game.ending.width / 2,
			Game.ending.height / 2
		)

		if ending_timer > 0.1 then
			ending_index = ending_index + 1
			ending_timer = 0
		end

		if ending_index > 96 then
			ending_index = 96
		end

		if ending_timer_2 > 11 then
			ending_timer = 0
			ending_timer_2 = 0
			ending_index = 0
			Roda.bus:emit('scene/load', 'entities')
			Roda.scene.camera.transform.position.x = -3700
			Roda.state = 'intro'
		end
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
