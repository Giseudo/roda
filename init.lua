require (GAME_LIB .. 'Roda.env')
require (RODA_SRC .. 'core')

local tiny = require 'tiny'

-- Core
local Resources = require (RODA_SRC .. 'core.resources')
local Logger = require (RODA_SRC .. 'core.logger')

-- Entities
local Camera = require (RODA_SRC .. 'entity.camera')
local Player = require (RODA_SRC .. 'entity.player')
local Platform = require (RODA_SRC .. 'entity.platform')
local Tilemap = require (RODA_SRC .. 'entity.tilemap')

-- Systems
local CollisionSystem = require (RODA_SRC .. 'system.collision')
local MovementSystem = require (RODA_SRC .. 'system.movement')
local GravitySystem = require (RODA_SRC .. 'system.gravity')
local RenderSystem = require (RODA_SRC .. 'system.render')
local AnimationSystem = require (RODA_SRC .. 'system.animation')

Roda = {
	resources = Resources(),
	logger = Logger(),
	width = 320,
	height = 200,
	scale = 3,
	unit = 16,
	shader = nil,
	gravity = -.6,
	quadtree = {},
	world = tiny.world(),
}

function Roda:run()
	-- Graphics defaults
	love.graphics.setPointSize(8)

	-- Window defaults
	love.window.setMode(
		self.width * self.scale,
		self.height * self.scale
	)

	self.camera = Camera(Vector(0, 100), Vector(self.scale, self.scale))
	self.player = Player(Vector(0, 0), Vector(16, 32))
	self.platform1 = Platform(Vector(0, -8), Vector(512, 16))
	self.platform2 = Platform(Vector(256, 56), Vector(512, 16))
	self.tilemap = Tilemap(0, 0, 128, 128)

	-- Add systems
	self.world:addSystem(GravitySystem())
	self.world:addSystem(MovementSystem())
	self.world:addSystem(CollisionSystem())
	self.world:addSystem(RenderSystem())
	self.world:addSystem(AnimationSystem())

	-- Add entities
	self.world:addEntity(self.player)

	-- Add entities to quadtree for collision check
	self.quadtree[#self.quadtree + 1] = self.platform1
	self.quadtree[#self.quadtree + 1] = self.platform2

	self.tilemap:init()
end

function Roda:update(dt)
	self:events()
	self.camera:follow(self.player)

	self.world:update(dt, tiny.requireAll('isUpdateSystem'))
end

mouse_position = Vector(0, 0)

function Roda:events()
	function love.keypressed(key)
		-- Player inputs
		if key == "space" then
			self.player:jump()
		end
		-- Camera inputs
		if love.keyboard.isDown("z") then
			self.camera:zoom(1)
		end
		if love.keyboard.isDown("x") then
			self.camera:zoom(-1)
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
end

function Roda:draw()
	love.graphics.clear(100, 100, 120, 255)

	-- Set view matrix
	self.camera:set()

	love.graphics.setColor(0, 0, 255, 50)
	self.camera.viewport:draw("fill")
	self:set_shader('default')

	-- Draw entities
	self.tilemap:draw()
	self.platform1:draw()
	self.platform2:draw()

	self.world:update(dt, tiny.requireAll('isDrawingSystem'))
	self.world:update(dt, tiny.requireAll('isDebugSystem'))

	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.points(self.camera:mousePosition().x, self.camera:mousePosition().y)
	love.graphics.points(0, 0)

	self.camera:unset()
end

function Roda:set_shader(name)
	local shader = self.resources.shaders[name]
	self.shader = shader
	love.graphics.setShader(shader)
end

function Roda:quit()
end
