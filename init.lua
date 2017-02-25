local Class = require (LIB_PATH .. "hump.class")
local Tiny = require (LIB_PATH .. "tiny.tiny")
local MessageBus = require (RODA_PATH .. "message-bus")
local UpdateSystem = require (RODA_PATH .. "systems.update")
local DrawSystem = require (RODA_PATH .. "systems.draw")
local Player = require (RODA_PATH .. "entities.player")

local Engine = Class{}

function Engine:init()
	local player = Player()

	-- Create message bus
	self.bus = MessageBus()

	-- Create world
	self.world = Tiny.world(
		UpdateSystem,
		DrawSystem,
		player
	)
end

function Engine:update(dt)
	UpdateSystem:update(dt)
	--self.bus:post("update", { dt = dt })
end

function Engine:draw()
	DrawSystem:update(love.timer.getDelta())
	--self.bus:post("draw")
end

return Engine
