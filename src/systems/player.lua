local Tiny = require (LIB_PATH .. "tiny.tiny")
local Vector = require (LIB_PATH .. "hump.vector")
local PlayerSystem = Tiny.processingSystem()

PlayerSystem.filter = Tiny.requireAll("input", "transform", "rigidbody")

-- Should subscribe to input system

function PlayerSystem:process(e, dt)
	if love.keyboard.isDown("left") then
		e.transform:translate(Vector(200, 0), dt)
	end

	if love.keyboard.isDown("right") then
		e.transform:translate(Vector(-200, 0), dt)
	end
end


return PlayerSystem
