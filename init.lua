local Class = require (LIB_PATH .. "hump.class")
local Tiny = require (LIB_PATH .. "tiny.tiny")
local MessageBus = require (RODA_PATH .. "message-bus")
local UpdateSystem = require (RODA_PATH .. "systems.update")
local DrawSystem = require (RODA_PATH .. "systems.draw")
local DebugSystem = require (RODA_PATH .. "systems.debug")
local Player = require (RODA_PATH .. "entities.player")
local Camera = require (LIB_PATH .. "hump.camera")

local Engine = Class{}

function Engine:init()
	love.graphics.setDefaultFilter("nearest", "nearest", 0)

	local player = Player(0, 0)

	-- Create message bus
	self.bus = MessageBus()

	-- Create camera
	self.camera = Camera(0, 0, 2)

	-- Create world
	self.world = Tiny.world(
		UpdateSystem,
		DrawSystem,
		--DebugSystem,
		player
	)
end

function Engine:update(dt)
	UpdateSystem:update(dt)
end

function Engine:draw()
	local dt = love.timer.getDelta()

	self.camera:draw(function ()
		DrawSystem:update(dt)
		--DebugSystem:update(dt)
	end)
end

return Engine
