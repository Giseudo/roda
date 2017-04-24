require (GAME_LIB .. 'Roda.env')
require (RODA_SRC .. 'core')

-- Entities
local Camera = require (RODA_SRC .. 'entity.camera')
local Player = require (RODA_SRC .. 'entity.player')
local Platform = require (RODA_SRC .. 'entity.platform')
local Tilemap = require (RODA_SRC .. 'entity.tilemap')

-- Systems
local Collision = require (RODA_SRC .. 'system.collision')
local Movement = require (RODA_SRC .. 'system.movement')
local Gravity = require (RODA_SRC .. 'system.gravity')

Roda = {
	scale = 3,
	unit = 16,
	shader = nil,
	gravity = -.8,
	shaders = {},
	quadtree = {},
	systems = {
		collision = Collision(),
		movement = Movement(),
		gravity = Gravity()
	},
	camera = Camera(Vector(0, 100)),
	player = Player(Vector(0, 0), Vector(16, 32)),
	platform1 = Platform(Vector(0, -16), Vector(512, 32)),
	platform2 = Platform(Vector(256, 64), Vector(512, 32)),
	tilemap = Tilemap(0, 0, 128, 128)
}

function Roda:run()
	-- Graphics defaults
	love.graphics.setDefaultFilter('nearest', 'nearest', 1)
	love.graphics.setPointSize(4)

	-- Window defaults
	love.window.setMode(
		self.camera.width * self.scale,
		self.camera.height * self.scale
	)

	-- Shader defaults
	self:add_shader(
		'default',
		require (RODA_SRC .. 'core.shaders.fragment'),
		require (RODA_SRC .. 'core.shaders.vertex')
	)
	self:set_shader('default')

	-- Add entities to system
	self.systems.collision:add(self.player)
	self.systems.movement:add(self.player)
	self.systems.gravity:add(self.player)

	-- Add entities to quadtree for collision check
	self.quadtree[#self.quadtree + 1] = self.platform1
	self.quadtree[#self.quadtree + 1] = self.platform2
end

function Roda:update(dt)
	self:events()
	self.camera:follow(self.player)
	self.player:update(dt)

	-- Update systems
	self.systems.movement:update(dt)
	self.systems.gravity:update(dt)
	self.systems.collision:update(dt)
end


function Roda:events()
	-- Player inputs
	function love.keypressed(key)
		if key == "space" then
			self.player:jump()
		end
	end

	if love.keyboard.isDown("left") then
		self.player.controller:move_left()
	end
	if love.keyboard.isDown("right") then
		self.player.controller:move_right()
	end
	if love.keyboard.isDown("down") then
		self.player.controller:move_down()
	end
	if love.keyboard.isDown("up") then
		self.player.controller:move_up()
	end

	-- Camera inputs
	if love.keyboard.isDown("z") then
		self.camera:zoom(2)
	end
	if love.keyboard.isDown("x") then
		self.camera:zoom(-2)
	end
end

function Roda:draw()
	love.graphics.setShader(self.shader)
	love.graphics.scale(self.scale, self.scale)
	love.graphics.clear(100, 100, 120, 255)

	-- Set view matrix
	self.camera:set()

	-- Draw entities
	self.tilemap:draw()
	self.platform1:draw()
	self.platform2:draw()
	self.player:draw()

	self.camera:unset()
end

function Roda:set_shader(name)
	self.shader = self.shaders[name]
end

function Roda:add_shader(name, fragment, vertex)
	self.shaders[name] = love.graphics.newShader(fragment, vertex)
end

function Roda:quit()
end
