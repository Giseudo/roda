local Class = require (LIB_PATH .. "hump.class")
local Vector = require (LIB_PATH .. "hump.vector")
local Camera = require (LIB_PATH .. "hump.camera")
local Tiny = require (LIB_PATH .. "tiny.tiny")

-- Systems
local UpdateSystem = require (RODA_PATH .. "systems.update")
local DrawSystem = require (RODA_PATH .. "systems.draw")
local DebugSystem = require (RODA_PATH .. "systems.debug")
local MovementSystem = require (RODA_PATH .. "systems.movement")
local GravitySystem = require (RODA_PATH .. "systems.gravity")

-- Entities
local Player = require (RODA_PATH .. "entities.player")

-- Components
local Transform = require (RODA_PATH .. "components.transform")
local Sprite = require (RODA_PATH .. "components.sprite")

local Engine = Class{}

function Engine:init()
	love.graphics.setDefaultFilter("nearest", "nearest", 0)

	local player = Player(
		Transform(Vector(0, 0)),
		Sprite("lib/roda/assets/images/2b.png", 0, 0, 32, 32)
	)

	-- Create camera
	self.camera = Camera(0, 0, 2, math.pi)

	-- Create world
	self.world = Tiny.world(
		UpdateSystem,
		DrawSystem,
		MovementSystem,
		GravitySystem,
		DebugSystem,
		player
	)
end

function Engine:update(dt)
	UpdateSystem:update(dt)
	MovementSystem:update(dt)
	GravitySystem:update(dt)
end

function Engine:draw()
	local dt = love.timer.getDelta()

	self.camera:draw(function ()
		DrawSystem:update(dt)
		DebugSystem:update(dt)
	end)
end

return Engine
