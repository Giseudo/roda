local Class = require (LIB_PATH .. "hump.class")
local Vector = require (LIB_PATH .. "hump.vector")
local Tiny = require (LIB_PATH .. "tiny.tiny")

-- Systems
local UpdateSystem = require (RODA_PATH .. "systems.update")
local DrawSystem = require (RODA_PATH .. "systems.draw")
local DebugSystem = require (RODA_PATH .. "systems.debug")
local PlayerSystem = require (RODA_PATH .. "systems.player")
local GravitySystem = require (RODA_PATH .. "systems.gravity")
local JumpSystem = require (RODA_PATH .. "systems.jump")
local AnimationSystem = require (RODA_PATH .. "systems.animation")

-- Entities
local Player = require (RODA_PATH .. "entities.2b")

-- Components
local Sprite = require (RODA_PATH .. "components.sprite")

local Engine = Class{}

function Engine:init(camera)
	love.graphics.setDefaultFilter("nearest", "nearest", 0)

	-- Create camera
	self.camera = camera 

	-- Create world
	self.world = Tiny.world(
		UpdateSystem,
		DrawSystem,
		PlayerSystem,
		GravitySystem,
		JumpSystem,
		AnimationSystem,
		DebugSystem
	)

	local player = Player(Vector(0, 0))

	-- Add entities
	self.world:add(player)
	self.world:refresh()
end

function Engine:update(dt)
	UpdateSystem:update(dt)
	PlayerSystem:update(dt)
	GravitySystem:update(dt)
	JumpSystem:update(dt)
	AnimationSystem:update(dt)
end

function Engine:draw()
	local dt = love.timer.getDelta()

	self.camera:draw(function ()
		DrawSystem:update(dt)
		--DebugSystem:update(dt)
	end)
end

return Engine
