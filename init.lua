local Class = require (LIB_PATH .. "hump.class")
local Vector = require (LIB_PATH .. "hump.vector")
local Tiny = require (LIB_PATH .. "tiny.tiny")
local Camera = require (LIB_PATH .. "hump.camera")

-- Systems
local UpdateSystem = require (RODA_PATH .. "systems.update")
local DrawSystem = require (RODA_PATH .. "systems.draw")
local DebugSystem = require (RODA_PATH .. "systems.debug")
local PlayerSystem = require (RODA_PATH .. "systems.player")
local GravitySystem = require (RODA_PATH .. "systems.gravity")
local JumpSystem = require (RODA_PATH .. "systems.jump")
local AnimationSystem = require (RODA_PATH .. "systems.animation")

local Engine = Class{}

function Engine:init()
	-- Create camera
	self.camera = Camera(0, 0, 2)

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
