require (GAME_LIB .. 'roda.env')
require (RODA_SRC .. 'core')
local Camera = require (RODA_SRC .. 'camera')
local Player = require (RODA_SRC .. 'player')
local Platform = require (RODA_SRC .. 'platform')
local Tilemap = require (RODA_SRC .. 'tilemap')

roda = {
	scale = 3,
	unit = 16,
	shader = nil,
	shaders = {},
	camera = Camera(0, 100),
	player = Player(0, 0),
	platform = Platform(0, -66, 100, 100),
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

function roda:update(dt)
	self:events()
	self.player:update(dt)
	self.camera:follow(self.player)

	-- Check for player / platform collision

	if self.player.velocity.y ~= 0 or self.player.velocity.x ~= 0 then
		local collision = self.player.rect:overlaps(self.platform.rect)
		if collision then
			-- If player is falling
			if self.player.velocity.y < 0 and self.player.rect:get_top() > self.platform.rect:get_top() then
				self.player.position.y = self.platform.rect:get_top() + self.player.rect.height / 2
				self.player.velocity.y = 0
			end
			-- If player is jumping
			if self.player.velocity.y > 0 and self.player.rect:get_bottom() < self.platform.rect:get_bottom() then
				self.player.position.y = self.platform.rect:get_bottom() - self.player.rect.height / 2
				self.player.velocity.y = 0
			end
			-- If player is moving forward
			if self.player.velocity.x > 0 and self.player.rect:get_left() < self.platform.rect:get_left() then
				self.player.position.x = self.platform.rect:get_left() - self.player.rect.width / 2
				self.player.velocity.x = 0
			end
			-- If player if moving backward
			if self.player.velocity.x < 0 and self.player.rect:get_right() > self.platform.rect:get_right() then
				self.player.position.x = self.platform.rect:get_right() + self.player.rect.width / 2
				self.player.velocity.x = 0
			end
		end
	end
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
