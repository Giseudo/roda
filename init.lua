require (GAME_LIB .. 'roda.env')
local Camera = require (RODA_SRC .. 'camera')
local Player = require (RODA_SRC .. 'player')
local Platform = require (RODA_SRC .. 'platform')

roda = {
	scale = 4,
	shader = nil,
	shaders = {},
	camera = Camera(),
	player = Player(),
	platform = Platform(0, -32)
}

function roda:run()
	love.graphics.setDefaultFilter('nearest', 'nearest', 1)
	love.window.setMode(
		self.camera.width * self.scale,
		self.camera.height * self.scale,
		{
			fullscreen = true,
			fullscreentype = 'exclusive'
		}
	)
	self:add_shader(
		'default',
		require (RODA_SRC .. 'core.shaders.fragment'),
		require (RODA_SRC .. 'core.shaders.vertex')
	)
	self:set_shader('default')
end

function roda:update(dt)
	self.player:update(dt)
	self.platform:update(dt)
end

function roda:events()
end

function roda:draw()
	love.graphics.setShader(self.shader)
	love.graphics.scale(self.scale, self.scale)
	love.graphics.clear(100, 100, 120, 255)
	self.camera:set()

	self.player:draw()
	self.platform:draw()

	self.camera:unset()
end

function roda:set_shader(name)
	self.shader = self.shaders[name]
end

function roda:add_shader(name, fragment, vertex)
	self.shaders[name] = love.graphics.newShader(fragment, vertex)
end

function roda:quit()
end
