require (GAME_LIB .. 'roda.env')
require (RODA_SRC .. 'core')
local Camera = require (RODA_SRC .. 'camera')
local Player = require (RODA_SRC .. 'player')
local Platform = require (RODA_SRC .. 'platform')
local Tilemap = require (RODA_SRC .. 'tilemap')

roda = {
	scale = 2,
	unit = 16,
	shader = nil,
	shaders = {},
	camera = Camera(0, 100),
	player = Player(0, 0),
	platform1 = Platform(0, -8, 512, 16),
	platform2 = Platform(256, 56, 512, 16),
	tilemap = Tilemap(0, 0, 128, 128)
}

function roda:run()
	love.graphics.setDefaultFilter('nearest', 'nearest', 1)
	love.graphics.setPointSize(4)
	love.window.setMode(
		self.camera.width * self.scale,
		self.camera.height * self.scale
	)
	self:add_shader(
		'default',
		require (RODA_SRC .. 'core.shaders.fragment'),
		require (RODA_SRC .. 'core.shaders.vertex')
	)
	self:set_shader('default')
end

function roda:collides(other)
	local deltaX = self.player.position.x - other.position.x
	local deltaY = self.player.position.y - other.position.y
	local intersectX = math.abs(deltaX) - (self.player.rect.width / 2 + other.rect.width / 2)
	local intersectY = math.abs(deltaY) - (self.player.rect.height / 2 + other.rect.height / 2)

	-- If collide
	if intersectX < 0.0 and intersectY < 0.0 then
		if intersectX > intersectY then
			self.player.velocity.x = 0

			if deltaX > 0.0 then
				self.player.position.x = self.player.position.x - intersectX
			else
				self.player.position.x = self.player.position.x + intersectX
			end
		else
			self.player.velocity.y = 0

			if deltaY > 0.0 then
				self.player.position.y = self.player.position.y - intersectY
			else
				self.player.position.y = self.player.position.y + intersectY
			end
		end

		return true
	end

	return false
end

function roda:update(dt)
	self:events()
	self.player:update(dt)
	self.camera:follow(self.player)

	-- Resolve collision for player
	self:collides(self.platform1)
	self:collides(self.platform2)
end

function roda:events()
	if love.keyboard.isDown("z") then
		self.camera:zoom(2)
	end
	if love.keyboard.isDown("x") then
		self.camera:zoom(-2)
	end
end

function roda:draw()
	love.graphics.setShader(self.shader)
	love.graphics.scale(self.scale, self.scale)
	love.graphics.clear(100, 100, 120, 255)
	self.camera:set()

	self.tilemap:draw()
	self.player:draw()
	self.platform1:draw()
	self.platform2:draw()


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
